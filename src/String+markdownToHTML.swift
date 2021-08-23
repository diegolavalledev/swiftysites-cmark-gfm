/// Github-Flavored Markdown (GFM) extensions for strings.
public extension String {

    /// Converts a GFM (Github-Flavored Markdown) string into its corresponding rendered HTML code.
    ///
    /// Basic usage:
    ///
    /// `let HTML = "# Hello".markdownToHTML()`
    /// `print(HTML) // "<h1>Hello</h1>"`
    ///
    /// For a list of default CMark options see `[CMarkOption].default`.
    /// For a list of default GFM extensions see `[GFMExtension].default`.
    ///
    func markdownToHTML(options: [CMarkOption] = .default, extensions: [GFMExtension] = .default) -> String {

        // Create [UnsafeMutablePointer<Int8>]:
        var extensions = extensions.map { strdup($0.rawValue) }

        let outString = cmark_gfm_markdown_to_html(self, utf8.count, options.code, &extensions, Int32(extensions.count))!

        // Free the duplicated strings:
        for ptr in extensions { free(ptr) }

        defer { free(outString) }
        return String(cString: outString)
    }
}
