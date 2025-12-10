local utils = require("lib.utils")
local inspect = require("lib.inspect")

local Day = {}

local function parse_input(lines)
  local parsed = {}
  for _, line in ipairs(lines) do
    local direction, steps = line:match("([LR])(%d+)")
    table.insert(parsed, {
      direction = direction,
      steps = tonumber(steps),
    })
  end

  return parsed
end

local function dialRight(start, steps)
  local passedZero = 0
  for _ = 1, steps do
    start = (start + 1) % 100
    if start == 0 then
      passedZero = passedZero + 1
    end
  end
  return start, passedZero
end

local function dialLeft(start, steps)
  local passedZero = 0
  for _ = 1, steps do
    start = (start - 1) % 100
    if start == 0 then
      passedZero = passedZero + 1
    end
  end

  return start, passedZero
end

-- Part 1 solution
function Day.part1(data)
  local parsed = parse_input(data)
  local start = 50
  local zeroCount = 0
  for _, step in ipairs(parsed) do
    if step.direction == "L" then
      start = dialLeft(start, step.steps)
    elseif step.direction == "R" then
      start = dialRight(start, step.steps)
    end

    if start == 0 then
      zeroCount = zeroCount + 1
    end
  end

  return zeroCount
end

-- Part 2 solution
function Day.part2(data)
  local parsed = parse_input(data)
  local start = 50
  local zeroCount = 0
  for _, step in ipairs(parsed) do
    local passedZero = 0
    if step.direction == "L" then
      start, passedZero = dialLeft(start, step.steps)
    elseif step.direction == "R" then
      start, passedZero = dialRight(start, step.steps)
    end
    zeroCount = zeroCount + passedZero
  end

  return zeroCount
end

-- Main execution
function Day.run(input_file, part)
  local data = utils.read_lines(input_file)

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
