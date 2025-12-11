local utils = require("lib.utils")
local inspect = require("lib.inspect")

local Day = {}

local function advance_beams(data, step)
  local split_count = 0

  if step == 1 then
    local S_index = utils.find_index(data[step], "S")
    data[step + 1][S_index] = 1

    return 0
  end

  -- find numeric values then check the bottom square
  for i = 1, #data[step] do
    local char = data[step][i]
    if type(char) == "number" then
      local bottom_square = data[step + 1][i]
      if "." == bottom_square then
        data[step + 1][i] = char
      elseif "^" == bottom_square then
        data[step + 1][i - 1] = char + 1
        data[step + 1][i + 1] = char + 1
        split_count = split_count + 1
      elseif type(bottom_square) == "number" then
        data[step + 1][i] = math.max(char, bottom_square)
      end
    end
  end

  return split_count
end

-- Part 1 solution
function Day.part1(data)
  local step, max_steps, split_count = 1, #data - 1, 0

  -- print("--- BEGIN SIMULATION (" .. max_steps .. " steps) ---")
  while step <= max_steps do
    -- print("-- STEP " .. step .. " --")
    split_count = split_count + advance_beams(data, step)
    step = step + 1
    -- print(utils.map2d_to_string(data))
  end
  -- print("--- END SIMULATION ---")

  return split_count
end

-- Part 2 solution
function Day.part2(data)
  -- Implement part 2 here
  return 0
end

-- Main execution
function Day.run(input_file, part)
  local data = utils.read_2d_map(input_file)

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
