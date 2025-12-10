local utils = require("lib.utils")
local inspect = require("lib.inspect")

local Day = {}

local function parse_input(lines)
  local parsed = {}
  -- TODO: transform lines into useful data

  return parsed
end

-- Part 1 solution
function Day.part1(data)
  -- Implement part 1 here
  print(inspect(data))
  local parsed = parse_input(data)
  return 0
end

-- Part 2 solution
function Day.part2(data)
  -- Implement part 2 here
  print(inspect(data))
  local parsed = parse_input(data)
  return 0
end

-- Main execution
function Day.run(input_file, part)
  local data = utils.read_lines(input_file)
  -- NOTE: use read_file to read a file with a single line
  -- local data = utils.read_file(input_file)

  if part == 1 or part == nil then
    local result = Day.part1(data)
    print(string.format("Part 1: %s", result))
  end

  if part == 2 or part == nil then
    local result = Day.part2(data)
    print(string.format("Part 2: %s", result))
  end
end

-- Allow running as standalone script
if arg and arg[0]:match("day%d+%.lua$") then
  local input_file = arg[1]
  local part = arg[2] and tonumber(arg[2]) or nil

  if not input_file then
    local day_num = arg[0]:match("day(%d+)%.lua$")
    input_file = string.format("inputs/day%s.txt", day_num)
  end

  Day.run(input_file, part)
end

return Day
