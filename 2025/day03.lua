local utils = require("lib.utils")
local inspect = require("lib.inspect")

local Day = {}

-- each line is a battery bank, each digit is a battery "joltage"
local function parse_input(lines)
  local parsed = lines

  return parsed
end

local function find_biggest_digit(bank)
  local biggest_digit, biggest_digit_pos = 0, nil
  for i = 1, #bank do
    local digit = tonumber(bank:sub(i, i))
    if digit and digit > biggest_digit then
      biggest_digit = digit
      biggest_digit_pos = i
    end
  end

  return biggest_digit, biggest_digit_pos
end

local function find_largest_joltage(bank, nb_batteries)
  nb_batteries = nb_batteries or 2
  local total = 0
  local current_pos = 1

  for j = 1, nb_batteries do
    local sub_bank = bank:sub(current_pos, #bank - nb_batteries + j)
    local biggest_digit, biggest_digit_pos = find_biggest_digit(sub_bank)
    total = total + biggest_digit * 10 ^ (nb_batteries - j)
    current_pos = biggest_digit_pos + 1
  end

  return total
end

-- Part 1 solution
function Day.part1(data)
  -- Implement part 1 here
  local parsed = parse_input(data)
  local joltages = {}
  for _, bank in ipairs(parsed) do
    local largest = find_largest_joltage(bank)
    table.insert(joltages, largest)
  end

  return utils.sum(joltages)
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
