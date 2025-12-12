local utils = require("lib.utils")
local inspect = require("lib.inspect")

local Day = {}

-- Expected results for example input
Day.expected = {
  part1 = 1227775554,
  part2 = 4174379265,
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
function Day.part1(data)
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
function Day.part2(data)
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

-- Main execution
function Day.run(input_file, part, is_test)
  local data = utils.read_file(input_file)

  if part == 1 or part == nil then
    local result = Day.part1(data)
    print(string.format("Part 1: %s", result))

    if is_test and Day.expected and Day.expected.part1 then
      assert(result == Day.expected.part1,
        string.format("Part 1 assertion failed: expected %s, got %s",
          Day.expected.part1, result))
      print("✓ Part 1 test passed")
    end
  end

  if part == 2 or part == nil then
    local result = Day.part2(data)
    print(string.format("Part 2: %s", result))

    if is_test and Day.expected and Day.expected.part2 then
      assert(result == Day.expected.part2,
        string.format("Part 2 assertion failed: expected %s, got %s",
          Day.expected.part2, result))
      print("✓ Part 2 test passed")
    end
  end
end

-- Allow running as standalone script
if arg and arg[0]:match("day%d+%.lua$") then
  local input_file = arg[1]
  local part = arg[2] and tonumber(arg[2]) or nil
  local is_test = false

  -- Check for --test flag in remaining args
  for i = 1, #arg do
    if arg[i] == "--test" then
      is_test = true
      break
    end
  end

  if not input_file then
    local day_num = arg[0]:match("day(%d+)%.lua$")
    input_file = string.format("inputs/day%s.txt", day_num)
  end

  Day.run(input_file, part, is_test)
end

return Day
