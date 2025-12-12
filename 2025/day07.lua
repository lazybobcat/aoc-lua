local utils = require("lib.utils")

local Day = {}

---@type DayConfig
Day.config = {
  name = "Laboratories",
  reader = utils.read_2d_map,
  expected = {
    part1 = 21,
    part2 = 40,
  },
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
function Day.part1(data, is_test)
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
function Day.part2(data, is_test)
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

return require("lib.runner").run(Day)
