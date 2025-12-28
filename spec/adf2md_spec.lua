local adf2md = require("adf2md")

describe("adf2md", function()

  describe("empty document", function()
    it("returns empty string", function()
      local result = adf2md({})
      assert.are.equal("", result)
    end)
  end)

  describe("paragraph", function()
    it("converts simple text", function()
      local doc = {
        type = "paragraph",
        content = {
          { type = "text", text = "Hello" }
        }
      }
      local result = adf2md(doc)
      assert.are.equal("Hello", result)
    end)

    it("converts multiple text nodes", function()
      local doc = {
        type = "paragraph",
        content = {
          { type = "text", text = "Hello " },
          { type = "text", text = "World" }
        }
      }
      local result = adf2md(doc)
      assert.are.equal("Hello World", result)
    end)

    it("converts multiple paragraphs", function()
      local doc = {
        {
          type = "paragraph",
          content = {{ type = "text", text = "First" }}
        },
        {
          type = "paragraph",
          content = {{ type = "text", text = "Second" }}
        }
      }
      local result = adf2md(doc)
      assert.are.equal("First\n\nSecond", result)
    end)
  end)

  describe("text marks", function()
    it("converts bold text", function()
      local doc = {
        type = "paragraph",
        content = {
          { type = "text", text = "Hello", marks = {{ type = "strong" }} }
        }
      }
      local result = adf2md(doc)
      assert.are.equal("**Hello**", result)
    end)

    it("converts italic text", function()
      local doc = {
        type = "paragraph",
        content = {
          { type = "text", text = "Hello", marks = {{ type = "em" }} }
        }
      }
      local result = adf2md(doc)
      assert.are.equal("*Hello*", result)
    end)

    it("converts bold and italic text", function()
      local doc = {
        type = "paragraph",
        content = {
          { type = "text", text = "Hello", marks = {{ type = "strong" }, { type = "em" }} }
        }
      }
      local result = adf2md(doc)
      assert.are.equal("***Hello***", result)
    end)

    it("converts links", function()
      local doc = {
        type = "paragraph",
        content = {
          { type = "text", text = "Click here", marks = {{ type = "link", attrs = { href = "https://example.com" } }} }
        }
      }
      local result = adf2md(doc)
      assert.are.equal("[Click here](https://example.com)", result)
    end)

    it("converts inline code", function()
      local doc = {
        type = "paragraph",
        content = {
          { type = "text", text = "const x", marks = {{ type = "code" }} }
        }
      }
      local result = adf2md(doc)
      assert.are.equal("`const x`", result)
    end)

    it("converts strikethrough", function()
      local doc = {
        type = "paragraph",
        content = {
          { type = "text", text = "deleted", marks = {{ type = "strike" }} }
        }
      }
      local result = adf2md(doc)
      assert.are.equal("~~deleted~~", result)
    end)
  end)

  describe("hardBreak", function()
    it("converts to line break", function()
      local doc = {
        type = "paragraph",
        content = {
          { type = "text", text = "Hello" },
          { type = "hardBreak" },
          { type = "text", text = "World" }
        }
      }
      local result = adf2md(doc)
      assert.are.equal("Hello  \nWorld", result)
    end)
  end)

  describe("bulletList", function()
    it("converts list items", function()
      local doc = {
        type = "bulletList",
        content = {
          {
            type = "listItem",
            content = {
              { type = "paragraph", content = {{ type = "text", text = "Item 1" }} }
            }
          },
          {
            type = "listItem",
            content = {
              { type = "paragraph", content = {{ type = "text", text = "Item 2" }} }
            }
          }
        }
      }
      local result = adf2md(doc)
      assert.are.equal("+ Item 1\n+ Item 2", result)
    end)
  end)

  describe("orderedList", function()
    it("converts numbered list items", function()
      local doc = {
        type = "orderedList",
        content = {
          {
            type = "listItem",
            content = {
              { type = "paragraph", content = {{ type = "text", text = "First" }} }
            }
          },
          {
            type = "listItem",
            content = {
              { type = "paragraph", content = {{ type = "text", text = "Second" }} }
            }
          }
        }
      }
      local result = adf2md(doc)
      assert.are.equal("1. First\n2. Second", result)
    end)
  end)

  describe("taskList", function()
    it("converts task items with state", function()
      local doc = {
        type = "taskList",
        content = {
          {
            type = "taskItem",
            attrs = { state = "TODO" },
            content = {{ type = "text", text = "Pending task" }}
          },
          {
            type = "taskItem",
            attrs = { state = "DONE" },
            content = {{ type = "text", text = "Done task" }}
          }
        }
      }
      local result = adf2md(doc)
      assert.are.equal("- [ ] Pending task\n- [x] Done task", result)
    end)
  end)

  describe("panel", function()
    it("converts to blockquote", function()
      local doc = {
        type = "panel",
        content = {
          { type = "paragraph", content = {{ type = "text", text = "Quote text" }} }
        }
      }
      local result = adf2md(doc)
      assert.are.equal("> Quote text", result)
    end)
  end)

  describe("table", function()
    it("converts with headers and cells", function()
      local doc = {
        type = "table",
        content = {
          {
            type = "tableRow",
            content = {
              { type = "tableHeader", content = {{ type = "paragraph", content = {{ type = "text", text = "H1" }} }} },
              { type = "tableHeader", content = {{ type = "paragraph", content = {{ type = "text", text = "H2" }} }} }
            }
          },
          {
            type = "tableRow",
            content = {
              { type = "tableCell", content = {{ type = "paragraph", content = {{ type = "text", text = "A" }} }} },
              { type = "tableCell", content = {{ type = "paragraph", content = {{ type = "text", text = "B" }} }} }
            }
          }
        }
      }
      local result = adf2md(doc)
      assert.are.equal("| H1 | H2 |\n| --- | --- |\n| A | B |", result)
    end)
  end)

  describe("heading", function()
    it("converts level 1", function()
      local doc = {
        type = "heading",
        attrs = { level = 1 },
        content = {{ type = "text", text = "Title" }}
      }
      local result = adf2md(doc)
      assert.are.equal("# Title", result)
    end)

    it("converts level 2", function()
      local doc = {
        type = "heading",
        attrs = { level = 2 },
        content = {{ type = "text", text = "Title" }}
      }
      local result = adf2md(doc)
      assert.are.equal("## Title", result)
    end)

    it("converts level 3", function()
      local doc = {
        type = "heading",
        attrs = { level = 3 },
        content = {{ type = "text", text = "Title" }}
      }
      local result = adf2md(doc)
      assert.are.equal("### Title", result)
    end)

    it("converts level 4", function()
      local doc = {
        type = "heading",
        attrs = { level = 4 },
        content = {{ type = "text", text = "Title" }}
      }
      local result = adf2md(doc)
      assert.are.equal("#### Title", result)
    end)

    it("converts level 5", function()
      local doc = {
        type = "heading",
        attrs = { level = 5 },
        content = {{ type = "text", text = "Title" }}
      }
      local result = adf2md(doc)
      assert.are.equal("##### Title", result)
    end)

    it("converts level 6", function()
      local doc = {
        type = "heading",
        attrs = { level = 6 },
        content = {{ type = "text", text = "Title" }}
      }
      local result = adf2md(doc)
      assert.are.equal("###### Title", result)
    end)
  end)

  describe("codeBlock", function()
    it("converts with language", function()
      local doc = {
        type = "codeBlock",
        attrs = { language = "javascript" },
        content = {{ type = "text", text = "console.log('hello')" }}
      }
      local result = adf2md(doc)
      assert.are.equal("```javascript\nconsole.log('hello')\n```", result)
    end)
  end)

  describe("rule", function()
    it("converts to horizontal line", function()
      local doc = { type = "rule" }
      local result = adf2md(doc)
      assert.are.equal("---", result)
    end)
  end)

end)
