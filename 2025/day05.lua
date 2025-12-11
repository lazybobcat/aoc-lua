local utils = require("lib.utils")
local inspect = require("lib.inspect")

local Day = {}

local function parse_input(lines)
  local ranges = {}
  local ingredients = {}

  local parsing_range = true
  for _, line in ipairs(lines) do
    if line == "" then
      parsing_range = false
    else
      if parsing_range then
        local range = utils.split(line, "-")
        table.insert(ranges, { tonumber(range[1]), tonumber(range[2]) })
      else
        table.insert(ingredients, tonumber(line))
      end
    end
  end

  return ranges, ingredients
end

local function get_fresh_ingredients(ranges, ingredients)
  local marked = {}

  for _, ingredient in ipairs(ingredients) do
    for _, range in ipairs(ranges) do
      if ingredient >= range[1] and ingredient <= range[2] then
        table.insert(marked, ingredient)
        break
      end
    end
  end

  return marked
end

-- Part 1 solution
function Day.part1(data)
  local ranges, ingredients = parse_input(data)
  local fresh = get_fresh_ingredients(ranges, ingredients)

  return #fresh
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
