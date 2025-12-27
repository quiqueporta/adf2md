local function apply_marks(text, marks)
  if not marks then
    return text
  end

  local result = text
  for _, mark in ipairs(marks) do
    if mark.type == "strong" then
      result = "**" .. result .. "**"
    elseif mark.type == "em" then
      result = "*" .. result .. "*"
    elseif mark.type == "link" then
      result = "[" .. result .. "](" .. mark.attrs.href .. ")"
    elseif mark.type == "code" then
      result = "`" .. result .. "`"
    end
  end
  return result
end

local node_handlers = {}

node_handlers.paragraph = function(node, convert_node)
  local result = ""
  for _, child in ipairs(node.content or {}) do
    if child.type == "text" then
      result = result .. apply_marks(child.text, child.marks)
    elseif child.type == "hardBreak" then
      result = result .. "  \n"
    end
  end
  return result
end

local function get_list_item_content(item, convert_node)
  local content = ""
  for _, child in ipairs(item.content or {}) do
    content = content .. convert_node(child)
  end
  return content
end

node_handlers.bulletList = function(node, convert_node)
  local items = {}
  for _, item in ipairs(node.content or {}) do
    table.insert(items, "+ " .. get_list_item_content(item, convert_node))
  end
  return table.concat(items, "\n")
end

node_handlers.orderedList = function(node, convert_node)
  local items = {}
  for i, item in ipairs(node.content or {}) do
    table.insert(items, i .. ". " .. get_list_item_content(item, convert_node))
  end
  return table.concat(items, "\n")
end

node_handlers.taskList = function(node, convert_node)
  local items = {}
  for _, item in ipairs(node.content or {}) do
    local checkbox = "[ ]"
    if item.attrs and item.attrs.state == "DONE" then
      checkbox = "[x]"
    end
    local content = ""
    for _, child in ipairs(item.content or {}) do
      if child.type == "text" then
        content = content .. apply_marks(child.text, child.marks)
      else
        content = content .. convert_node(child)
      end
    end
    table.insert(items, "- " .. checkbox .. " " .. content)
  end
  return table.concat(items, "\n")
end

node_handlers.taskItem = function(node, convert_node)
  local content = ""
  for _, child in ipairs(node.content or {}) do
    if child.type == "text" then
      content = content .. apply_marks(child.text, child.marks)
    else
      content = content .. convert_node(child)
    end
  end
  return content
end

node_handlers.listItem = function(node, convert_node)
  return get_list_item_content(node, convert_node)
end

node_handlers.panel = function(node, convert_node)
  local content = ""
  for _, child in ipairs(node.content or {}) do
    content = content .. convert_node(child)
  end
  return "> " .. content
end

node_handlers.tableCell = function(node, convert_node)
  local content = ""
  for _, child in ipairs(node.content or {}) do
    content = content .. convert_node(child)
  end
  return content
end

node_handlers.tableHeader = function(node, convert_node)
  local content = ""
  for _, child in ipairs(node.content or {}) do
    content = content .. convert_node(child)
  end
  return content
end

node_handlers.tableRow = function(node, convert_node)
  local cells = {}
  for _, cell in ipairs(node.content or {}) do
    table.insert(cells, convert_node(cell))
  end
  return "| " .. table.concat(cells, " | ") .. " |"
end

node_handlers.table = function(node, convert_node)
  local rows = {}
  for i, row in ipairs(node.content or {}) do
    table.insert(rows, convert_node(row))
    if i == 1 then
      local num_cols = #(row.content or {})
      local separator = {}
      for _ = 1, num_cols do
        table.insert(separator, "---")
      end
      table.insert(rows, "| " .. table.concat(separator, " | ") .. " |")
    end
  end
  return table.concat(rows, "\n")
end

node_handlers.heading = function(node, convert_node)
  local level = node.attrs and node.attrs.level or 1
  local prefix = string.rep("#", level)
  local content = ""
  for _, child in ipairs(node.content or {}) do
    if child.type == "text" then
      content = content .. apply_marks(child.text, child.marks)
    end
  end
  return prefix .. " " .. content
end

node_handlers.codeBlock = function(node, convert_node)
  local language = node.attrs and node.attrs.language or ""
  local content = ""
  for _, child in ipairs(node.content or {}) do
    if child.type == "text" then
      content = content .. child.text
    end
  end
  return "```" .. language .. "\n" .. content .. "\n```"
end

node_handlers.rule = function(node, convert_node)
  return "---"
end

local function convert_node(node)
  local handler = node_handlers[node.type]
  if handler then
    return handler(node, convert_node)
  end
  return ""
end

local function adf2md(document)
  if not document.type then
    if #document == 0 then
      return ""
    end

    local results = {}
    for _, node in ipairs(document) do
      table.insert(results, convert_node(node))
    end
    return table.concat(results, "\n\n")
  end

  return convert_node(document)
end

return adf2md
