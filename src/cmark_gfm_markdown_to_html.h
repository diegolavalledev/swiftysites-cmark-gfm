#ifndef cmark_gfm_markdown_to_html_h
#define cmark_gfm_markdown_to_html_h

#include <stdio.h>

/// GFM version of the standard Commonmark function  `cmark_markdown_to_html()`.
char *cmark_gfm_markdown_to_html(const char *text, size_t len, int options);

#endif /* cmark_gfm_markdown_to_html_h */