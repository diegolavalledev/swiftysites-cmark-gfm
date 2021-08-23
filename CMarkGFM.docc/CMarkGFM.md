# ``CMarkGFM``

Easily convert Swift strings to Github Flavored Mardown (CMark-GFM).

## Overview

Use the _String_ method `markdownToHTML()` to apply the conversion.

```swift
public extension String {
    func markdownToHTML(options: [CMarkOption] = .default, extensions: [GFMExtension] = .default) -> String {
        …
    }
}
```

### Basic usage

```swift
let HTML = "# Hello".markdownToHTML()
print(HTML) // "<h1>Hello</h1>"
```

## Topics

### Specifying options and extensions

- ``CMarkOption``
- ``GFMExtension``
