JetBrains EAP Casks for Homebrew Cask
=====================================

[![Check](https://github.com/dahlia/homebrew-jetbrains-eap/actions/workflows/check.yml/badge.svg?branch=main&event=push)](https://github.com/dahlia/homebrew-jetbrains-eap/actions/workflows/check.yml?query=event:push+branch:main)

Since [homebrew-cask and homebrew-cask-versions decided to do not accept all
JetBrains EAP versions][1], instead, here we maintain a separated tap for them.

    brew tap dahlia/jetbrains-eap
    brew install intellij-idea-eap

[1]: https://github.com/Homebrew/homebrew-cask/issues/32521


Casks
-----

Every cask in this tap ends with `-eap`. These can coexist with the non-EAP
casks.

- `clion-eap`
- `datagrip-eap`
- `dataspell-eap`
- `goland-eap`
- `intellij-idea-eap`
- `phpstorm-eap`
- `pycharm-eap`
- `rider-eap`
- `rubymine-eap`
- `webstorm-eap`

FYI, Android Studio has beta and canary channel instead of EAP, and casks for
them are included in [homebrew-cask] tap:

- `android-studio-preview@beta`
- `android-studio-preview@canary`

[homebrew-cask]: https://github.com/Homebrew/homebrew-cask
