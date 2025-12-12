local utils = require("lib.utils")
local inspect = require("lib.inspect")

local Day = {}

-- Expected results for example input
Day.expected = {
  part1 = 21,
  part2 = 40,
}

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
        local left_square = data[step + 1][i - 1]
        local right_square = data[step + 1][i + 1]

        if type(left_square) == "number" then
          data[step + 1][i - 1] = left_square + char
        else
          data[step + 1][i - 1] = char
        end

        if type(right_square) == "number" then
          data[step + 1][i + 1] = right_square + char
        else
          data[step + 1][i + 1] = char
        end

        split_count = split_count + 1
      elseif type(bottom_square) == "number" then
        data[step + 1][i] = char + bottom_square
      end
    end
  end

  return split_count
end

-- Part 1 solution
function Day.part1(data)
  local manifold = utils.clone(data)
  local step, max_steps, split_count = 1, #manifold - 1, 0

  -- print("--- BEGIN SIMULATION (" .. max_steps .. " steps) ---")
  while step <= max_steps do
    -- print("-- STEP " .. step .. " --")
    split_count = split_count + advance_beams(manifold, step)
    step = step + 1
    -- print(utils.map2d_to_string(manifold))
  end
  -- print("--- END SIMULATION ---")

  return split_count
end

-- Part 2 solution
function Day.part2(data)
  local manifold = utils.clone(data)
  local step, max_steps, split_count = 1, #manifold - 1, 0

  -- print("--- BEGIN SIMULATION (" .. max_steps .. " steps) ---")
  while step <= max_steps do
    -- print("-- STEP " .. step .. " --")
    split_count = split_count + advance_beams(manifold, step)
    step = step + 1
    -- print(utils.map2d_to_string(manifold))
  end
  -- print("--- END SIMULATION ---")

  local finish_line = manifold[#manifold]

  return utils.reduce(finish_line, function(acc, char)
    if type(char) == "number" then
      return acc + char
    end

    return acc
  end, 0)
end

-- Main execution
function Day.run(input_file, part, is_test)
  local data = utils.read_2d_map(input_file)

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
