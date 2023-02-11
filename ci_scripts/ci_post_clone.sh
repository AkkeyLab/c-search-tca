#!/bin/zsh

# https://developer.apple.com/documentation/xcode/writing-custom-build-scripts
# https://forums.swift.org/t/telling-xcode-14-beta-4-to-trust-build-tool-plugins-programatically/59305/7
defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES

security add-generic-password -a NATIONAL-TAX-AGENCY -w ${NTA_API_KEY} -s NTA-API-KEY

