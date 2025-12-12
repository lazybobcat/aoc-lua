local utils = require("lib.utils")
local inspect = require("lib.inspect")

local Day = {}

-- Expected results for example input
Day.expected = {
  part1 = 357,
  part2 = 3121910778619,
}

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
    local sub_bank = bank:sub(current_pos, #bank - (nb_batteries - j))
    local biggest_digit, biggest_digit_pos = find_biggest_digit(sub_bank)
    total = total + biggest_digit * 10 ^ (nb_batteries - j)
    current_pos = current_pos + biggest_digit_pos
  end

  return total
end

-- Part 1 solution
function Day.part1(data)
  local parsed = parse_input(data)
  local joltages = {}
  for _, bank in ipairs(parsed) do
    local largest = find_largest_joltage(bank)
    table.insert(joltages, largest)
  end

  return tonumber(string.format("%.f", utils.sum(joltages)))
end

-- Part 2 solution
function Day.part2(data)
  local parsed = parse_input(data)
  local joltages = {}
  for _, bank in ipairs(parsed) do
    local largest = find_largest_joltage(bank, 12)
    table.insert(joltages, largest)
  end

  return tonumber(string.format("%.f", utils.sum(joltages)))
end

-- Main execution
function Day.run(input_file, part, is_test)
  local data = utils.read_lines(input_file)
  -- NOTE: use read_file to read a file with a single line
  -- local data = utils.read_file(input_file)

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
