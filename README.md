# Document Publish

A GitHub Action for publishing a set of one or more Markdown files as a single
PDF document.

```yaml
- name: Publish PDF Document
  uses: shrink/actions-document-publish@v1
  id: publish-document
  with:
    sources: 'documents/front.md documents/*.md documents/back.md'
```

Jump to [complete examples &rarr;][examples]

## Inputs

### Sources

A string of space separated [glob patterns][glob] of paths to Markdown files
in order of their appearance in the final document.

```yaml
sources: 'front.md docs/*.md examples/**/*.md back.md'
```

## Examples

Examples assume a repository containing a `documents` directory.

### Upload as Artifact

```yaml
name: Upload Document as Artifact

on: [push]

env:
  GITHUB_TOKEN: ${{ github.token }}

jobs:
  publish:
    runs-on: ubuntu-latest
    name: Publish Document
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Publish PDF Document
        uses: shrink/actions-document-publish@v1
        id: publish-document
        with:
          sources: 'documents/front.md documents/examples/**/*.md documents/back.md'
      - name: Upload Document
        uses: actions/upload-artifact@v2
        id: upload-document
        with:
          name: 'document.pdf'
          path: ${{ steps.publish-document.outputs.pdf }}
```

### Publish to Release

A conditional check before publishing to a release is used to demonstrate a
single workflow that can publish a document on push and on release.

```yaml
name: Publish Document to Release

on:
  push:
  release:
    types: [published]

env:
  GITHUB_TOKEN: ${{ github.token }}

jobs:
  publish-and-release:
    runs-on: ubuntu-latest
    name: Publish Document to Release
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Publish PDF Document
        uses: shrink/actions-document-publish@v1
        id: publish-document
        with:
          sources: 'documents/front.md documents/examples/**/*.md documents/back.md'
      - if: github.event_name == 'release' && github.event.action == 'published'
        name: Get Release
        id: release
        uses: bruceadams/get-release@v1.2.0
      - if: github.event_name == 'release' && github.event.action == 'published'
        name: Attach PDF to Release
        uses: actions/upload-release-asset@v1
        with:
          upload_url: ${{ steps.release.outputs.upload_url }}
          asset_path: ${{ steps.publish-document.outputs.pdf }}
          asset_name: 'document.pdf'
          asset_content_type: application/pdf
```

### Sign and Publish

actions-document-publish is designed for use alongside
[actions-document-sign][actions-document-sign] which allows generation of an
Electronic Signature to be included within the published document.

```yaml
name: Publish Signed Document to Release

on:
  push:
  release:
    types: [published]

env:
  GITHUB_TOKEN: ${{ github.token }}

jobs:
  publish-and-release:
    runs-on: ubuntu-latest
    name: Publish Document to Release
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Create Electronic Signature
        uses: shrink/actions-document-sign@v1
        id: create-signature
      - name: Publish PDF Document
        uses: shrink/actions-document-publish@v1
        id: publish-document
        with:
          sources: '${{ steps.create-signature.outputs.signature }} documents/front.md documents/examples/**/*.md documents/back.md'
      - if: github.event_name == 'release' && github.event.action == 'published'
        name: Get Release
        id: release
        uses: bruceadams/get-release@v1.2.0
      - if: github.event_name == 'release' && github.event.action == 'published'
        name: Attach PDF to Release
        uses: actions/upload-release-asset@v1
        with:
          upload_url: ${{ steps.release.outputs.upload_url }}
          asset_path: ${{ steps.publish-document.outputs.pdf }}
          asset_name: 'signed-document-${{ steps.create-signature.outputs.label }}.pdf'
          asset_content_type: application/pdf
```

## Notes

Publish is designed specifically for combining multiple Markdown files into a
single document for publishing, the process of creating the PDF is handled by
[Markdown to PDF][markdown-to-pdf] which should be used for any use-case more
complex than what is described here.

[glob]: https://en.wikipedia.org/wiki/Glob_(programming)
[markdown-to-pdf]: https://github.com/BaileyJM02/markdown-to-pdf
[actions-document-sign]: https://github.com/shrink/actions-document-sign
[examples]: #examples
