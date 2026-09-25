#!/usr/bin/env python3
"""Bump casks to the latest EAP using the JetBrains releases API.

The API also publishes the SHA-256 of each download, so no DMG has to be fetched,
unlike `brew bump`, which downloads every DMG for every arch to compute its checksum.

Casks are read from, and PR branches are created on top of, the latest `origin/main`,
regardless of which branch this runs on.

Set DRY_RUN=1 to only print the diffs without committing or opening PRs.
"""

import difflib
import json
import os
import re
import subprocess
import sys
import time
import urllib.request
from pathlib import Path

DRY_RUN = bool(os.environ.get("DRY_RUN"))
BASE_BRANCH = "main"

API_URL_RE = re.compile(r'https://data\.services\.jetbrains\.com/products/releases\?[^"]+')
CODE_RE = re.compile(r'json\["([A-Z]+)"\]')
VERSION_RE = re.compile(r'^  version "([^"]+)"$', re.MULTILINE)
SHA256_RE = re.compile(r'^  sha256 arm: +"([0-9a-f]{64})",\n +intel: +"([0-9a-f]{64})"$', re.MULTILINE)
CHECKSUM_RE = re.compile(r"^[0-9a-f]{64}$")


class SkipError(Exception):
    pass


def fetch(url: str) -> str:
    req = urllib.request.Request(url, headers={"User-Agent": "homebrew-jetbrains-eap"})
    for attempt in range(3):
        try:
            with urllib.request.urlopen(req, timeout=30) as response:
                return response.read().decode()
        except OSError:
            if attempt == 2:
                raise
            time.sleep(attempt + 1)
    raise AssertionError("unreachable")


def fetch_sha256(checksum_link: str) -> str:
    sha256 = fetch(checksum_link).split()[0]
    if not CHECKSUM_RE.match(sha256):
        raise ValueError(f"Invalid checksum from {checksum_link}: {sha256}")
    return sha256


def build_number(version: str) -> tuple[int, ...]:
    return tuple(int(part) for part in version.split(",")[1].split("."))


def run(*args: str, strip: bool = True) -> str:
    stdout = subprocess.run(args, check=True, capture_output=True, text=True).stdout
    return stdout.strip() if strip else stdout


def git(*args: str, strip: bool = True) -> str:
    return run("git", *args, strip=strip)


def gh(*args: str) -> str:
    return run("gh", *args)


def bump_cask(cask_file: str, base_ref: str) -> None:
    token = Path(cask_file).stem
    old_contents = contents = git("show", f"{base_ref}:{cask_file}", strip=False)

    api_url = API_URL_RE.search(contents)
    code = CODE_RE.search(contents)
    current_version = VERSION_RE.search(contents)
    checksums = SHA256_RE.search(contents)
    if not (api_url and code and current_version and checksums):
        raise SkipError("unable to parse the cask")
    current_version = current_version[1]

    releases = json.loads(fetch(api_url[0])).get(code[1]) or []
    release = releases[0] if releases else {}
    if not (release.get("version") and release.get("build")):
        raise SkipError(f"no release found at {api_url[0]}")
    new_version = f"{release['version']},{release['build']}"

    if build_number(new_version) <= build_number(current_version):
        print(f"{token} is up to date ({current_version})")
        return

    branch = f"action/{token}"
    title = f"{token} {new_version}"
    print(f"==> {token} {current_version} -> {new_version}")

    # An unmerged PR from a previous run is updated in place by force-pushing the branch.
    remote_sha = "" if DRY_RUN else git("ls-remote", "--heads", "origin", branch).partition("\t")[0]
    if remote_sha:
        remote_version = VERSION_RE.search(gh("api", f"repos/{{owner}}/{{repo}}/contents/{cask_file}?ref={branch}",
                                              "--header", "Accept: application/vnd.github.raw"))
        if remote_version and remote_version[1] == new_version:
            print(f"Branch {branch} is already at {new_version}, skipping")
            return

    downloads = release["downloads"]
    new_arm = fetch_sha256(downloads["macM1"]["checksumLink"])
    new_intel = fetch_sha256(downloads["mac"]["checksumLink"])

    contents = VERSION_RE.sub(f'  version "{new_version}"', contents, count=1)
    contents = contents.replace(checksums[1], new_arm).replace(checksums[2], new_intel)

    if DRY_RUN:
        diff = difflib.unified_diff(
            old_contents.splitlines(keepends=True), contents.splitlines(keepends=True), f"a/{cask_file}", f"b/{cask_file}"
        )
        print("".join(diff), end="")
        return

    # `--force` also discards anything left behind by a previous failed cask.
    git("checkout", "--quiet", "--force", "-B", branch, base_ref)
    Path(cask_file).write_text(contents)
    git("commit", "--quiet", "--message", title, "--", cask_file)
    git("push", "--quiet", f"--force-with-lease={branch}:{remote_sha}", "origin", branch)

    open_pr = gh("pr", "list", "--head", branch, "--state", "open", "--json", "number", "--jq", ".[0].number")
    if open_pr:
        subprocess.run(["gh", "pr", "edit", open_pr, "--title", title], check=True)
    else:
        subprocess.run(
            [
                "gh", "pr", "create",
                "--base", BASE_BRANCH,
                "--head", branch,
                "--title", title,
                "--body", "Created by `.github/scripts/bump.py`.",
            ],
            check=True,
        )


def main() -> int:
    # Keep our output ordered with that of `gh` when stdout is not a TTY, as in CI.
    sys.stdout.reconfigure(line_buffering=True)
    os.chdir(git("rev-parse", "--show-toplevel"))
    original_ref = git("rev-parse", "--abbrev-ref", "HEAD")
    if original_ref == "HEAD":
        original_ref = git("rev-parse", "HEAD")

    # Fetch only the tip in a shallow clone (as in CI); `--depth` would make a full clone shallow.
    depth = ["--depth=1"] if git("rev-parse", "--is-shallow-repository") == "true" else []
    git("fetch", "--quiet", *depth, "origin", BASE_BRANCH)
    base_ref = git("rev-parse", "FETCH_HEAD")

    failed = False
    try:
        for cask_file in git("ls-tree", "--name-only", base_ref, "Casks/").splitlines():
            if not cask_file.endswith(".rb"):
                continue
            token = Path(cask_file).stem
            try:
                bump_cask(cask_file, base_ref)
            except SkipError as e:
                print(f"::warning::Skipping {token}: {e}")
            except Exception as e:
                detail = f"{e}\n{e.stderr}" if isinstance(e, subprocess.CalledProcessError) and e.stderr else e
                print(f"::error::Failed to bump {token}: {detail}")
                failed = True
    finally:
        if not DRY_RUN:
            git("checkout", "--quiet", "--force", original_ref)
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
