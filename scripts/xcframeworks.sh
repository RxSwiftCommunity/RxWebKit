set -euo pipefail
rm -rf RxWebKit-SPM.xcodeproj
rm -rf xcarchives/*
rm -rf RxWebKit.xcframework.zip
rm -rf RxWebKit.xcframework

xcodegen --spec project-spm.yml

xcodebuild archive -quiet -project RxWebKit-SPM.xcodeproj -configuration Release -scheme "RxWebKit iOS" -destination "generic/platform=iOS" -archivePath "xcarchives/RxWebKit-iOS" SKIP_INSTALL=NO SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES OTHER_CFLAGS="-fembed-bitcode" BITCODE_GENERATION_MODE="bitcode" ENABLE_BITCODE=YES | xcpretty --color --simple
xcodebuild archive -quiet -project RxWebKit-SPM.xcodeproj -configuration Release -scheme "RxWebKit iOS" -destination "generic/platform=iOS Simulator" -archivePath "xcarchives/RxWebKit-iOS-Simulator" SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES OTHER_CFLAGS="-fembed-bitcode" BITCODE_GENERATION_MODE="bitcode" ENABLE_BITCODE=YES | xcpretty --color --simple
xcodebuild archive -quiet -project RxWebKit-SPM.xcodeproj -configuration Release -scheme "RxWebKit macOS" -destination "generic/platform=macOS" -archivePath "xcarchives/RxWebKit-macOS" SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES OTHER_CFLAGS="-fembed-bitcode" BITCODE_GENERATION_MODE="bitcode" ENABLE_BITCODE=YES | xcpretty --color --simple

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
rm -rf RxWebKit-SPM.xcodeproj