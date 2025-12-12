local utils = require("lib.utils")

local Day = {}

---@type DayConfig
Day.config = {
  name = "Lobby",
  expected = {
    part1 = 357,
    part2 = 3121910778619,
  },
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
function Day.part1(data, is_test)
  local parsed = parse_input(data)
  local joltages = {}
  for _, bank in ipairs(parsed) do
    local largest = find_largest_joltage(bank)
    table.insert(joltages, largest)
  end

  return tonumber(string.format("%.f", utils.sum(joltages)))
end

-- Part 2 solution
function Day.part2(data, is_test)
  local parsed = parse_input(data)
  local joltages = {}
  for _, bank in ipairs(parsed) do
    local largest = find_largest_joltage(bank, 12)
    table.insert(joltages, largest)
  end

  return tonumber(string.format("%.f", utils.sum(joltages)))
end

return require("lib.runner").run(Day)
