export XCODE_PROJECT=~/Developer/Projects/CMarkGFM
export CLIENT_XCODE_PROJECT=/path/to/some/client/project

cat $XCODE_PROJECT/conf/CMarkGFM.xconfig << EOF
MODULEMAP_FILE=conf/module.modulemap
BUILD_LIBRARY_FOR_DISTRIBUTION=YES
SKIP_INSTALL=NO
CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER=NO
CLANG_WARN_STRICT_PROTOTYPES=NO
MACOSX_DEPLOYMENT_TARGET=11.5
EXCLUDED_ARCHS[config=Release]=arm64
EOF

cat $XCODE_PROJECT/conf/module.modulemap << EOF
framework module CMarkGFM {
    umbrella header "CMarkGFM.h"
    header "cmark_gfm_markdown_to_html.h"
    header "cmark-gfm.h"
    export *

    explicit module CMarkGFM_Private {
        header "cmark-gfm_export.h"
        header "cmark-gfm_version.h"
    }
}
EOF

cd $XCODE_PROJECT

# Archive

xcodebuild archive -project CMarkGFM.xcodeproj -scheme CMarkGFM -destination "platform=macOS" -configuration Release -archivePath ./CMarkGFM

# Currently only the x86_64 (Intel) architecture is supported

# Create XCFramework

xcodebuild -create-xcframework -framework CMarkGFM.xcarchive/Products/Library/Frameworks/CMarkGFM.framework -output CMarkGFM.xcframework

zip -Xr CMarkGFM.xcframework CMarkGFM.xcframework.zip
swift package compute-checksum CMarkGFM.xcframework.zip

# Multiple frameworks can be combined for multiple arthitectures.

# Optional copy locally to a client project
# Clean up previous framework from the client project
rm -rf $CLIENT_XCODE_PROJECT/CMarkGFM.xcframework
cp -Rp CMarkGFM.xcframework $CLIENT_XCODE_PROJECT


# Clean up
rm -rf CMarkGFM.xcarchive CMarkGFM.xcframework  CMarkGFM.xcframework.zip

# To only bundle the cmark-gfm static libraries in an Xcode Framework use the following command form:
#
# xcodebuild -create-xcframework -library <path> [-headers <path>] [-library <path> [-headers <path>]...] -output <path>
