JetBrains EAP Casks for Homebrew Cask
=====================================

[![GitHub Actions][GitHub Actions badge]][GitHub Actions]

Since [homebrew-cask and homebrew-cask-versions decided to do not accept all
JetBrains EAP versions][1], instead, here we maintain a separated tap for them.

    brew tap dahlia/jetbrains-eap
    brew install intellij-idea-ce-eap

[GitHub Actions]: https://github.com/dahlia/homebrew-jetbrains-eap/actions/workflows/check.yaml
[GitHub Actions badge]: https://github.com/dahlia/homebrew-jetbrains-eap/actions/workflows/check.yaml/badge.svg
[1]: https://github.com/Homebrew/homebrew-cask/issues/32521


Casks
-----

Every cask in this tap ends with `-eap`.

 -  `clion-eap`
 -  `goland-eap`
 -  `intellij-idea-ce-eap`
 -  `intellij-idea-eap`
 -  `phpstorm-eap`
 -  `pycharm-ce-eap`
 -  `pycharm-eap`
 -  `rider-eap`
 -  `rubymine-eap`
 -  `webstorm-eap`

Note that here's no cask for AppCode EAP, because [homebrew/cask-versions] tap
still maintains it (but don't know why they treat only it special):

 -  `homebrew/cask-versions/appcode-eap`

FYI, Android Studio has beta and canary channel instead of EAP, and casks for
them are included in [homebrew/cask-versions] tap:

 -  `homebrew/cask-versions/android-studio-preview-beta`
 -  `homebrew/cask-versions/android-studio-preview-canary`

[homebrew/cask-versions]: https://github.com/Homebrew/homebrew-cask-versions
