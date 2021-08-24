# Archive

xcodebuild archive -project CMarkGFM.xcodeproj -scheme CMarkGFM -destination "platform=macOS" -configuration Release -archivePath ./CMarkGFM


# Create XCFramework

xcodebuild -create-xcframework -framework CMarkGFM.xcarchive/Products/Library/Frameworks/CMarkGFM.framework -output CMarkGFM.xcframework

zip -Xr CMarkGFM.xcframework.zip CMarkGFM.xcframework
# Zip gets attached to GitHub release.


# Generate checksum

touch Package.swift

swift package compute-checksum CMarkGFM.xcframework.zip
# Result goes into README.md.


# Clean up

rm -rf CMarkGFM.xcarchive CMarkGFM.xcframework CMarkGFM.xcframework.zip Package.swift
