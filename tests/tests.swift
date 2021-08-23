import XCTest
import CMarkGFM

class tests: XCTestCase {

    func testDefaultMarkdown() throws {
        let result = "# Hello".markdownToHTML()
        XCTAssertEqual(result, "<h1>Hello</h1>\n")
    }

    func testDefaultExtension() throws {
        // Default extensions include strikethrough
        var result = "~Hello~".markdownToHTML()
        XCTAssertEqual(result, "<p><del>Hello</del></p>\n")
        // Exclude strikethrough from extensions
        result = "~Hello~".markdownToHTML(extensions: [])
        XCTAssertEqual(result, "<p>~Hello~</p>\n")
    }

    func testTableExtension() throws {
        var result = "www.google.com".markdownToHTML(extensions: [.autolink])
        XCTAssertEqual(result, "<p><a href=\"http://www.google.com\">www.google.com</a></p>\n")
        result = """
        | foo | bar |
        | --- | --- |
        | baz | bim |
        """.markdownToHTML(extensions: [.table])
        XCTAssertEqual(result, """
        <table>
        <thead>
        <tr>
        <th>foo</th>
        <th>bar</th>
        </tr>
        </thead>
        <tbody>
        <tr>
        <td>baz</td>
        <td>bim</td>
        </tr>
        </tbody>
        </table>

        """)
    }

    func testAutolinkExtension() throws {
        var result = "www.google.com".markdownToHTML(extensions: [])
        XCTAssertEqual(result, "<p>www.google.com</p>\n")
        result = "www.google.com".markdownToHTML(extensions: [.autolink])
        XCTAssertEqual(result, "<p><a href=\"http://www.google.com\">www.google.com</a></p>\n")
    }

    func testTasklistExtension() throws {
        let result = """
        - [ ] foo
        - [x] bar
        """.markdownToHTML(extensions: [.tasklist])
        XCTAssertEqual(result, """
        <ul>
        <li><input type="checkbox" disabled="" /> foo</li>
        <li><input type="checkbox" checked="" disabled="" /> bar</li>
        </ul>

        """)
    }

    func testGithubPreLangOption() throws {
        var result = """
        ```swift
        print("Hello, World!")
        ```
        """.markdownToHTML(options: [])
        XCTAssertEqual(result, """
        <pre><code class="language-swift">print(&quot;Hello, World!&quot;)
        </code></pre>

        """)
        result = """
        ```swift
        print("Hello, World!")
        ```
        """.markdownToHTML(options: [.githubPreLang])
        XCTAssertEqual(result, """
        <pre lang="swift"><code>print(&quot;Hello, World!&quot;)
        </code></pre>

        """)
    }

    func testSmartOption() throws {
        var result = """
        "quotes"
        """.markdownToHTML(options: [])
        XCTAssertEqual(result, """
        <p>&quot;quotes&quot;</p>

        """)
        result = """
        "quotes"
        """.markdownToHTML(options: [.smart])
        XCTAssertEqual(result, """
        <p>“quotes”</p>

        """)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            let _ = """
            # Hello

            www.google.com

            """.markdownToHTML()
        }
    }
}
