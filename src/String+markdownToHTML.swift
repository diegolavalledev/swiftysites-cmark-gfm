/// Github-Flavored Markdown (GFM) extensions for strings.
public extension String {

    /// Converts a GFM (Github-Flavored Markdown) string into its corresponding rendered HTML code.
    ///
    /// Example of usage:
    ///
    /// `let HTML = "# Hello".markdownToHTML`
    /// `print(HTML) // "<h1>Hello</h1>"`
    ///
    /// Footnotes, table and strike-through extensions are enabled by default.
    ///
    var markdownToHTML: String {
        let outString = cmark_gfm_markdown_to_html(self, utf8.count, CMARK_OPT_DEFAULT|CMARK_OPT_UNSAFE|CMARK_OPT_FOOTNOTES)!
        defer { free(outString) }
        return String(cString: outString)
    }
}
