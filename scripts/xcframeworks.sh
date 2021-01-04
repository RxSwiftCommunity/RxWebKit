#!/usr/bin/env bash

set -euo pipefail
rm -rf xcarchives/*
rm -rf RxWebKit.xcframework.zip

xcodebuild archive -quiet -project RxWebKit-SPM.xcodeproj -scheme "RxWebKit iOS" -sdk iphoneos -archivePath "xcarchives/RxWebKit-iOS"
xcodebuild archive -quiet -project RxWebKit-SPM.xcodeproj -scheme "RxWebKit iOS" -sdk iphonesimulator  -archivePath "xcarchives/RxWebKit-iOS-Simulator"
xcodebuild archive -quiet -project RxWebKit-SPM.xcodeproj -scheme "RxWebKit macOS" -sdk macosx -archivePath "xcarchives/RxWebKit-macOS"

xcodebuild -create-xcframework \
-framework "xcarchives/RxWebKit-iOS-Simulator.xcarchive/Products/Library/Frameworks/RxWebKit.framework" \
-debug-symbols ""$(pwd)"/xcarchives/RxWebKit-iOS-Simulator.xcarchive/dSYMs/RxWebKit.framework.dSYM" \
-framework "xcarchives/RxWebKit-iOS.xcarchive/Products/Library/Frameworks/RxWebKit.framework" \
-debug-symbols ""$(pwd)"/xcarchives/RxWebKit-iOS.xcarchive/dSYMs/RxWebKit.framework.dSYM" \
-framework "xcarchives/RxWebKit-macOS.xcarchive/Products/Library/Frameworks/RxWebKit.framework" \
-debug-symbols ""$(pwd)"/xcarchives/RxWebKit-macOS.xcarchive/dSYMs/RxWebKit.framework.dSYM" \
-output "RxWebKit.xcframework" 

zip -r RxWebKit.xcframework.zip RxWebKit.xcframework
rm -rf xcarchives/*
rm -rf RxWebKit.xcframework