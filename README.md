# CMarkGFM

Easily render HTML from standard Markdown content.

## Overview

Use this library to generate HTML from a string containing [GitHub Flavored Markdown (GFM)](https://github.github.com/gfm/) / [CommonMark](https://commonmark.org) content.

For example this code:

```markdown
# Hello
Hello, _World_!
```

Will be translated into this code:

```html
<h1>Hello</h1>
<p>Hello, <em>World<em>!</p>
```

## Acknowledgements

This implementation is built entirely on top of the amazing [cmark-gfm](https://github.com/github/cmark-gfm) which itself is a fork of the excellent [cmark](https://github.com/commonmark/cmark).

## Basic usage

Simply wrap your Markdown string with ``GFMarkdown`` and call ``GFMarkdown/toHTML(options:extensions:)`` with no parameters.

```swift
let html = GFMarkdown("# Hello").toHTML()
print(html) // "<h1>Hello</h1>"
```

## Full documentation

Complete documentation ins DocC format can be found attached to each corresponding release. For instance [here](https://github.com/swiftysites/cmark-gfm/releases/download/1.0.0/CMarkGFM.docc.zip).

## Configuring your project

Look for the corresponding _XCFramework_ attached to each release and add it as a binary target to your _Package.swift_. The example below contains the correct URL and checksum for the current branch/release.

```swift
…
let package = Package(
    …
    targets: [
        .binaryTarget(
            name: "CMarkGFM",
            url: "https://github.com/swiftysites/cmark-gfm/releases/download/1.0.0/CMarkGFM.xcframework.zip",
            checksum: "a2638dfb0d52990788143e7bbe9fdc4de1eb0153a9830a208d951720d3a4b75f"),
        .target(
            name: "MyApp",
            dependencies: ["CMarkGFM"])
    ]
    …
)
```

# Building

If you would like to compile CMarkGFM from scratch you will first need to download and build `cmark-gfm` as a static library. For more information about how to do this take a look inside [build-cmark-gfm](scripts/build-cmark-gfm.sh).

Copy the `.a` files to the [lib folder](lib) and archive the project following the steps in [generate-xcframework](scripts/generate-xcframework.sh).

The bundle that is ultimatelly generated gets attached to the GitHub release.
