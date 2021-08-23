/// GFM extensions.
public enum GFMExtension: String {

    /// https://github.github.com/gfm/#tables-extension-
    case table

    /// https://github.github.com/gfm/#tables-extension-
    case tasklist

    /// https://github.github.com/gfm/#strikethrough-extension-
    case strikethrough

    /// https://github.github.com/gfm/#autolinks-extension-
    case autolink

    /// https://github.github.com/gfm/#disallowed-raw-html-extension-
    case tagfilter
}

public extension Array where Element == GFMExtension {

    /// Default GFM extensions.
    static var `default`: Self {[
        .strikethrough, .autolink, .tagfilter
    ]}
}
