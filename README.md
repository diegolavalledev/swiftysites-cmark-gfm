#  CMarkGFM

**CMarkGFM** is a small Swift wrapper for the [cmark-gfm](https://github.com/github/cmark-gfm) library written in C.

## Public interface

This library extends _String_ with a single public function.

```swift
String.markdownToHTML() -> String
```

## Usage
 
```swift
import CMarkGFM

let HTML = "# Hello".markdownToHTML()
print(HTML) // "<h1>Hello</h1>"
```

## Documentation

Find full documentation ins DocC format attached to each release.

## Configuring

Look for the corresponding _XCFramework_ attached to each release.

Download the XCFramework to your project's root and add it to your _Package.swift_ as a binary dependency:

```swift
…
let package = Package(
    …
    targets: [
        .binaryTarget(
            name: "CMarkGFM",
            url: "https://github.com/swiftysites/cmark-gfm/releases/download/1.0.0-beta.1/CMarkGFM.xcframework.zip",
            checksum: "c7656b0b0c2bed7f12fe9d60044617c0d20310d8c306a8b1e22a8159c750f1de"),
        .target(
            name: "YourProject",
            dependencies: ["CMarkGFM"])
    ]
    …
)
```

# Building

If you want to build CMarkGFM from scratch, you will need to first download and build `cmark-gfm` as a static library. For more information about how to do this, take a look inside the _scripts_ folder.

Copy the `.a` files to the _lib_ folder and archive the project:

```bash
xcodebuild archive -project CMarkGFM.xcodeproj -scheme CMarkGFM -destination "platform=macOS,arch=x86_64" -configuration Release -archivePath ./CMarkGFM
```

To create the Xcode Framework use the following command:

```bash
xcodebuild -create-xcframework -framework CMarkGFM.xcarchive/Products/Library/Frameworks/CMarkGFM.framework -output ./CMarkGFM.xcframework
```

This is the bundle that ultimatelly gets attached to the Github release.
