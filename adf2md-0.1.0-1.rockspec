package = "adf2md"
version = "0.1.0-1"

source = {
  url = "git://github.com/quiqueporta/adf2md.git",
  tag = "v0.1.0"
}

description = {
  summary = "Convert Atlassian Document Format (ADF) to Markdown",
  detailed = [[
    A Lua library to convert Atlassian Document Format (ADF) JSON
    documents to Markdown. Supports paragraphs, headings, lists,
    tables, code blocks, and inline formatting.
  ]],
  homepage = "https://github.com/quiqueporta/adf2md",
  license = "MIT"
}

dependencies = {
  "lua >= 5.1"
}

build = {
  type = "builtin",
  modules = {
    adf2md = "src/adf2md.lua"
  }
}
