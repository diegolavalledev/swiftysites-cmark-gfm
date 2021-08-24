import XCTest
import CMarkGFM

class tests: XCTestCase {

    func testDefaultMarkdown() throws {
        let result = GFMarkdown("# Hello").toHTML()
        XCTAssertEqual(result, "<h1>Hello</h1>\n")
    }

    func testDefaultExtension() throws {
        // Default extensions include strikethrough
        var result = GFMarkdown("~Hello~").toHTML()
        XCTAssertEqual(result, "<p><del>Hello</del></p>\n")
        // Exclude strikethrough from extensions
        result = GFMarkdown("~Hello~").toHTML(extensions: [])
        XCTAssertEqual(result, "<p>~Hello~</p>\n")
    }

    func testTableExtension() throws {
        var result =  GFMarkdown("www.google.com").toHTML(extensions: [.autolink])
        XCTAssertEqual(result, "<p><a href=\"http://www.google.com\">www.google.com</a></p>\n")
        result = GFMarkdown("""
        | foo | bar |
        | --- | --- |
        | baz | bim |
        """).toHTML(extensions: [.table])
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
        var result = GFMarkdown("www.google.com").toHTML(extensions: [])
        XCTAssertEqual(result, "<p>www.google.com</p>\n")
        result = GFMarkdown("www.google.com").toHTML(extensions: [.autolink])
        XCTAssertEqual(result, "<p><a href=\"http://www.google.com\">www.google.com</a></p>\n")
    }

    func testTasklistExtension() throws {
        let result = GFMarkdown("""
        - [ ] foo
        - [x] bar
        """).toHTML(extensions: [.tasklist])
        XCTAssertEqual(result, """
        <ul>
        <li><input type="checkbox" disabled="" /> foo</li>
        <li><input type="checkbox" checked="" disabled="" /> bar</li>
        </ul>

        """)
    }

    func testGithubPreLangOption() throws {
        var result = GFMarkdown("""
        ```swift
        print("Hello, World!")
        ```
        """).toHTML(options: [])
        XCTAssertEqual(result, """
        <pre><code class="language-swift">print(&quot;Hello, World!&quot;)
        </code></pre>

        """)
        result = GFMarkdown("""
        ```swift
        print("Hello, World!")
        ```
        """).toHTML(options: [.githubPreLang])
        XCTAssertEqual(result, """
        <pre lang="swift"><code>print(&quot;Hello, World!&quot;)
        </code></pre>

        """)
    }

    func testSmartOption() throws {
        var result = GFMarkdown("""
        "quotes"
        """).toHTML(options: [])
        XCTAssertEqual(result, """
        <p>&quot;quotes&quot;</p>

        """)
        result = GFMarkdown("""
        "quotes"
        """).toHTML(options: [.smart])
        XCTAssertEqual(result, """
        <p>“quotes”</p>

        """)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            let _ = GFMarkdown("""
            # Hello

            www.google.com

            """).toHTML()
        }
    }
}
