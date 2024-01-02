#!/bin/zsh

# https://developer.apple.com/documentation/xcode/writing-custom-build-scripts
# https://forums.swift.org/t/telling-xcode-14-beta-4-to-trust-build-tool-plugins-programatically/59305/7
# defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES

# https://forums.swift.org/t/is-there-a-way-to-programmatically-allow-trust-the-compiler-plugin-to-run-from-the-command-line/65690
defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES
