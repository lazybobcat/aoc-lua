local utils = require("lib.utils")

local Day = {}

---@type DayConfig
Day.config = {
  name = "Gift Shop",
  reader = utils.read_file,
  expected = {
    part1 = 1227775554,
    part2 = 4174379265,
  },
}

-- We get a line with ranges separated by commas, e.g. "11-22,95-115"
local function parse_input(lines)
  local parsed = {}
  local ranges = utils.split(lines, ",")
  parsed = utils.map(ranges, function(range)
    local parts = utils.split(range, "-")
    local s = tonumber(parts[1])
    local e = tonumber(parts[2])
    return { s, e }
  end)

  return parsed
end

-- Find ids with repeating digits, e.g. in {998-1012} there is one invalid id: 1010 (because 10 and 10)
local find_invalid_ids_part1 = function(startId, endId)
  local invalidIds = {}
  for i = startId, endId do
    local digits = tostring(i)
    -- if odd number of digits, ignore
    if #digits % 2 == 0 then
      -- split in the middle
      local firstHalf = digits:sub(1, #digits / 2)
      local secondHalf = digits:sub(#digits / 2 + 1, #digits)
      if firstHalf == secondHalf then
        table.insert(invalidIds, i)
      end
    end
  end

  return invalidIds
end

-- Find ids with repeating digits patterns, e.g. in {998-1012} there is two invalid ids: 999 and 1010
local find_invalid_ids_part2 = function(startId, endId)
  local invalidIds = {}
  for i = startId, endId do
    local digits = tostring(i)
    -- from first to last digit check if there is a repeating pattern
    for j = 1, math.floor(#digits / 2) do
      local sequence = digits:sub(0, j)
      local pattern = string.rep(sequence, math.floor(#digits / #sequence))
      if digits == pattern then
        table.insert(invalidIds, i)
        break
      end
    end
  end

  return invalidIds
end

-- Part 1 solution
function Day.part1(data, is_test)
  local parsed = parse_input(data)
  local invalidIds = {}
  for _, range in ipairs(parsed) do
    local startId = range[1]
    local endId = range[2]
    local invalid = find_invalid_ids_part1(startId, endId)
    if #invalid > 0 then
      invalidIds = utils.concat(invalidIds, invalid)
    end
  end

  return utils.sum(invalidIds)
end

-- Part 2 solution
function Day.part2(data, is_test)
  local parsed = parse_input(data)
  local invalidIds = {}
  for _, range in ipairs(parsed) do
    local startId = range[1]
    local endId = range[2]
    local invalid = find_invalid_ids_part2(startId, endId)
    if #invalid > 0 then
      invalidIds = utils.concat(invalidIds, invalid)
    end
  end

  return utils.sum(invalidIds)
end

return require("lib.runner").run(Day)
