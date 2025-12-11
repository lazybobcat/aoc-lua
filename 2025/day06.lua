local utils = require("lib.utils")
local inspect = require("lib.inspect")

local Day = {}

local function parse_input(lines)
  local parsed = {}
  for _, line in ipairs(lines) do
    local symbols = utils.split(utils.trim(line))
    table.insert(parsed, symbols)
  end

  return utils.map2d_rotate(parsed)
end

local function compute_addition(acc, operand)
  return acc + operand
end

local function compute_multiplication(acc, operand)
  return acc * operand
end

local function compute(line)
  local operation = table.remove(line)
  local operands = utils.map(line, tonumber)

  local compute_operation = operation == "+" and compute_addition or compute_multiplication
  local start = operation == "+" and 0 or 1

  return utils.reduce(operands, compute_operation, start)
end

-- Part 1 solution
function Day.part1(data)
  local parsed = parse_input(data)
  local total = 0
  for _, line in ipairs(parsed) do
    total = total + compute(line)
  end

  return total
end

-- Part 2 solution
function Day.part2(data)
  -- Implement part 2 here
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
