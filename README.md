# Document Publish

A GitHub Action for publishing a set of one or more Markdown files as a single
PDF document.

```yaml
shrink/actions-document-publish@v1
```

Publish is designed specifically for combining multiple Markdown files into a
single document for publishing, the process of creating the PDF is handled by
[Markdown to PDF][markdown-to-pdf] which should be used for any use-case more
complex than what is described here.

## Inputs

### Sources

A string of space separated [glob patterns][glob] of paths to Markdown files
in order of their appearance in the final document.

```yaml
sources: 'front.md docs/*.md examples/**/*.md back.md'
```

[glob]: https://en.wikipedia.org/wiki/Glob_(programming)
[markdown-to-pdf]: https://github.com/BaileyJM02/markdown-to-pdf
