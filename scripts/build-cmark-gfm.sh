# Building the CMark-GFM (Github Flavored Markdown) static library

# You will need cmake and autotools (Make)
brew install cmake autotools

export $XCODE_PROJECT_DIR=/some/path/to/your/project

git clone https://github.com/github/cmark-gfm
cd cmark-gfm
mkdir build
cd build

cmake -DCMAKE_OSX_ARCHITECTURES=arm64 -DCMAKE_OSX_DEPLOYMENT_TARGET=11.0 -DCMARK_TESTS=OFF -DCMARK_SHARED=OFF ..

# Optional. Verify the right settings were applied.
cmake -L -N ..
# …
# CMAKE_OSX_ARCHITECTURES:STRING=arm64
# CMAKE_OSX_DEPLOYMENT_TARGET:STRING=11.0
# CMAKE_OSX_SYSROOT:PATH=/Applications/Xcode-beta.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX12.0.sdk
# CMARK_SHARED:BOOL=OFF
# CMARK_STATIC:BOOL=ON
# CMARK_TESTS:BOOL=OFF
# …

# Build products (static library)
make
mv src/libcmark-gfm.a src/libcmark-gfm.arm64.a
mv extensions/libcmark-gfm-extensions.a extensions/libcmark-gfm-extensions.arm64.a
make clean

# Repeat but for x86_64

cmake -DCMAKE_OSX_ARCHITECTURES=x86_64 -DCMAKE_OSX_DEPLOYMENT_TARGET=11.0 -DCMARK_TESTS=OFF -DCMARK_SHARED=OFF ..
cmake -L -N ..
make

lipo -create src/libcmark-gfm.arm64.a src/libcmark-gfm.x86_64.a -output src/libcmark-gfm.a
lipo -create extensions/libcmark-gfm-extensions.arm64.a extensions/libcmark-gfm-extensions.x86_64.a -output extensions/libcmark-gfm-extensions.a

cp src/libcmark-gfm.a $XCODE_PROJECT_DIR/lib
cp extensions/libcmark-gfm-extensions.a $XCODE_PROJECT_DIR/lib

# Copy headers, generated headers and static library to your Xcode project
cp ../src/cmark-gfm.h src/cmark-gfm_export.h src/cmark-gfm_version.h src/libcmark-gfm.a $XCODE_PROJECT_DIR

# Optional GFM extensions (table, strikethrough)
cp ../src/cmark-gfm-extension_api.h ../extensions/cmark-gfm-core-extensions.h config.h extensions/cmark-gfm-extensions_export.h extensions/libcmark-gfm-extensions.a $XCODE_PROJECT_DIR

# Optional. Clean up products.
make clean

# Optional. Clean up build.
cd ..
rm -rf build

# Optional. Clean up sources.
cd ..
rm -rf

cd $XCODE_PROJECT_DIR

# Add headers to project (not part of target)
# Add library to project as required

# Add a bridging header
cat >> bridging.h << EOF
#include "cmark-gfm.h"
EOF

# Test on main
cat >> main.swift << EOF
let outString = cmark_markdown_to_html("# Hello", string.utf8.count, 0)!
print(String(cString: outString))
free(outString)
EOF

# Execute
xcoderun

# <h1>Hello.</h1>
#
# Program ended with exit code: 0


# Optional helper for GFM extensions

cat >> cmark_gfm_markdown_to_html.h << EOF
#ifndef cmark_gfm_markdown_to_html_h
#define cmark_gfm_markdown_to_html_h

#include <stdio.h>
char *cmark_gfm_markdown_to_html(const char *text, size_t len, int options);

#endif /* cmark_gfm_markdown_to_html_h */
EOF


cat >> bridging.h << EOF
#include "cmark_gfm_markdown_to_html.h"
EOF


cat >> cmark_gfm_markdown_to_html.c << EOF
#include "cmark_gfm_markdown_to_html.h"

#include "cmark-gfm.h"
#include "cmark-gfm-core-extensions.h"

// This is a function that will make enabling extensions easier later on.
void addMarkdownExtension(cmark_parser *parser, char *extName) {
    cmark_syntax_extension *ext = cmark_find_syntax_extension(extName);
    if (ext) {
        cmark_parser_attach_syntax_extension(parser, ext);
    }
}

// A function to convert HTML to markdown
char *cmark_gfm_markdown_to_html(const char *text, size_t len, int options) {
    cmark_gfm_core_extensions_ensure_registered();

    // Modified version of cmark_parse_document in blocks.c
    cmark_parser *parser = cmark_parser_new(options);

    // Add extensions here
    addMarkdownExtension(parser, "strikethrough");
    addMarkdownExtension(parser, "table");

    cmark_node *doc;
    cmark_parser_feed(parser, text, len);
    doc = cmark_parser_finish(parser);
    cmark_parser_free(parser);

    // Render
    char *html = cmark_render_html(doc, options, NULL);
    cmark_node_free(doc);

    return html;
}
EOF
