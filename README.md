# adf2md

A Lua library to convert [Atlassian Document Format (ADF)](https://developer.atlassian.com/cloud/jira/platform/apis/document/structure/) to Markdown.

## Installation

Copy `src/adf2md.lua` to your project or add the `src` directory to your Lua path.

## Usage

```lua
local adf2md = require("adf2md")

local adf_document = {
  type = "paragraph",
  content = {
    { type = "text", text = "Hello ", marks = {{ type = "strong" }} },
    { type = "text", text = "World" }
  }
}

local markdown = adf2md(adf_document)
print(markdown)  -- Output: **Hello **World
```

## Supported Node Types

| ADF Node      | Markdown Output                          |
|---------------|------------------------------------------|
| paragraph     | Plain text                               |
| heading       | `#` to `######` (levels 1-6)             |
| bulletList    | `+ item`                                 |
| orderedList   | `1. item`                                |
| taskList      | `- [ ] task` / `- [x] task`              |
| codeBlock     | ` ```language\ncode\n``` `               |
| blockquote    | `> text`                                 |
| panel         | `> [!NOTE]`, `> [!WARNING]`, etc. (GFM)  |
| table         | GFM table with `\|` and `---`            |
| rule          | `---`                                    |
| mediaSingle   | `![](url)`                               |
| mention       | `@username`                              |
| emoji         | `:shortName:`                            |
| status        | Colored emoji + text (e.g., `🟢 DONE`)   |
| hardBreak     | Two spaces + newline                     |

## Supported Marks

| Mark   | Markdown Output       |
|--------|-----------------------|
| strong | `**text**`            |
| em     | `*text*`              |
| link   | `[text](url)`         |
| code   | `` `text` ``          |
| strike | `~~text~~`            |

## Unsupported Types

When the library encounters an unsupported node type, it outputs a marker:

```
[unsupported: nodeType]
```

This makes it easy to identify which ADF features are not yet converted.

## License

MIT License - see [LICENSE](LICENSE) file.
