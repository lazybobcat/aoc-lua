local utils = {}

-- String utilities
function utils.split(str, delimiter)
  local result = {}
  for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
    table.insert(result, match)
  end
  return result
end

function utils.trim(str)
  return str:match("^%s*(.-)%s*$")
end

-- Table utilities
function utils.map(tbl, func)
  local result = {}
  for i, v in ipairs(tbl) do
    result[i] = func(v)
  end
  return result
end

function utils.filter(tbl, predicate)
  local result = {}
  for _, v in ipairs(tbl) do
    if predicate(v) then
      table.insert(result, v)
    end
  end
  return result
end

function utils.sum(tbl)
  local total = 0
  for _, v in ipairs(tbl) do
    total = total + v
  end
  return total
end

-- File utilities
function utils.read_file(filename)
  local file = io.open(filename, "r")
  if not file then
    error("Could not open file: " .. filename)
  end

  local data = {}
  for line in file:lines() do
    -- Parse your input here
    table.insert(data, line)
  end
  file:close()

  return data
end

function utils.read_lines(filename)
  local lines = {}
  for line in io.lines(filename) do
    table.insert(lines, line)
  end
  return lines
end

return utils
