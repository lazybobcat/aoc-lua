--- Utility functions for Advent of Code solutions
---@class utils
local utils = {}

-- String utilities

--- Splits a string by a delimiter
---@param str string The string to split
---@param delimiter ?string The delimiter pattern to split by
---@return table Array of string parts
function utils.split(str, delimiter)
  delimiter = delimiter or "%s"
  local result = {}
  for match in str:gmatch("[^" .. delimiter .. "]+") do
    table.insert(result, match)
  end
  -- for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
  --   table.insert(result, match)
  -- end
  return result
end

--- Trims whitespace from both ends of a string
---@param str string The string to trim
---@return string The trimmed string
function utils.trim(str)
  return str:match("^%s*(.-)%s*$")
end

--- Converts an integer to a string without decimal notation
---@param n number The number to convert
---@return string The formatted string representation
function utils.int_to_string(n)
  return string.format("%.f", n)
end

--- Converts a table to a string by putting each element on a new line
---@param tbl table The table to convert
---@return string The formatted string representation
function utils.map2d_to_string(tbl, separator)
  separator = separator or ""
  local result = ""
  for i = 1, #tbl do
    local row = tbl[i]
    for j = 1, #row do
      local char = row[j]
      result = result .. tostring(char) .. separator
    end
    result = result:sub(1, #result - #separator)
    result = result .. "\n"
  end
  return result
end

-- Table utilities

--- Maps a function over a table
---@param tbl table The input array
---@param func function Function to apply to each element
---@return table New array with transformed elements
function utils.map(tbl, func)
  local result = {}
  for i, v in ipairs(tbl) do
    result[i] = func(v)
  end
  return result
end

--- Reduces a table to a single value
---@param tbl table The input array
---@param func function Function to apply to each element
---@param initial any Initial value
---@return any Reduced value
function utils.reduce(tbl, func, initial)
  local result = initial
  for _, v in ipairs(tbl) do
    result = func(result, v)
  end
  return result
end

--- Filters a table based on a predicate function
---@param tbl table The input array
---@param predicate function Function that returns true for elements to keep
---@return table New array with filtered elements
function utils.filter(tbl, predicate)
  local result = {}
  for _, v in ipairs(tbl) do
    if predicate(v) then
      table.insert(result, v)
    end
  end
  return result
end

--- Concatenates two tables into a new table
---@param tbl1 table First array
---@param tbl2 table Second array
---@return table New array containing all elements from both tables
function utils.concat(tbl1, tbl2)
  local result = {}
  for _, v in ipairs(tbl1) do
    table.insert(result, v)
  end
  for _, v in ipairs(tbl2) do
    table.insert(result, v)
  end
  return result
end

--- Clones a table
---@param tbl table The table to clone
---@return table The cloned table
function utils.clone(tbl)
  local result = {}
  for k, v in pairs(tbl) do
    result[k] = v
  end
  return result
end

--- Sums all numeric elements in a table
---@param tbl table Array of numbers
---@return number
function utils.sum(tbl)
  local total = 0
  for _, v in ipairs(tbl) do
    total = total + v
  end
  return total
end

--- Transpose a 2D array so that columns become rows and rows become columns
---@param tbl table Array of arrays
---@return table Transposed array
function utils.map2d_rotate(tbl)
  local result = {}
  local columns = #tbl[1]
  local rows = #tbl
  for i = 1, rows do
    for j = 1, columns do
      result[j] = result[j] or {}
      result[j][i] = tbl[i][j]
    end
  end
  return result
end

-- File utilities

--- Reads entire file content as a single trimmed string
---@param filename string Path to the file
---@return string The file content with trimmed whitespace
function utils.read_file(filename)
  local file = io.open(filename, "r")
  if not file then
    error("Could not open file: " .. filename)
  end

  local data = file:read("*all")
  file:close()

  return utils.trim(data)
end

--- Reads file content line by line into a table
---@param filename string Path to the file
---@return table Array of lines from the file
function utils.read_lines(filename)
  local lines = {}
  for line in io.lines(filename) do
    table.insert(lines, utils.trim(line))
  end
  return lines
end

return utils
