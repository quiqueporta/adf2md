# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2025-12-28

### Added

- `inlineCard` node support (extracts Jira issue key from URL)

### Changed

- Refactored `collect_children` helper to reduce code duplication
- Refactored marks to use `mark_handlers` table (Open/Closed principle)
- Added `text` and `hardBreak` as proper node handlers for consistency

## [0.1.0] - 2025-12-28

### Added

- Initial release
- Core ADF to Markdown conversion
- Node types: paragraph, heading (1-6), bulletList, orderedList, taskList, codeBlock, blockquote, panel, table, rule, mediaSingle, mention, emoji, status, hardBreak
- Mark types: strong, em, link, code, strike
- Panel types with GFM alerts: info, note, warning, error, success
- Status colors with emoji: blue, green, yellow, red, neutral
- Unsupported node type marker: `[unsupported: nodeType]`
- GitHub Actions CI for Lua 5.1, 5.2, 5.3, 5.4
