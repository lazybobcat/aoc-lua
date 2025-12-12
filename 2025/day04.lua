local utils = require("lib.utils")
local inspect = require("lib.inspect")

local Day = {}

-- Expected results for example input
Day.expected = {
  part1 = 13,
  part2 = 43,
}

local function parse_input(lines)
  local parsed = {}
  for i = 1, #lines do
    local line = lines[i]
    local row = {}
    for j = 1, #line do
      local char = line:sub(j, j)
      row[j] = char
    end
    parsed[i] = row
  end

  return parsed
end

local function mark_rolls(map, max_neighbors, valid_neighbors_chars)
  valid_neighbors_chars = valid_neighbors_chars or "@x"
  local marked_map = utils.clone(map)
  -- in the map, rolls are represented by "@".
  -- we want to mark all rolls that are connected to a maximum of max_neighbors with "x"
  for i = 1, #marked_map do
    for j = 1, #marked_map[i] do
      if marked_map[i][j] == "@" then
        local neighbors = 0
        for di = -1, 1 do
          for dj = -1, 1 do
            if i + di > 0 and i + di <= #marked_map and j + dj > 0 and j + dj <= #marked_map[i + di] then
              if string.find(valid_neighbors_chars, marked_map[i + di][j + dj], 1, true) then
                neighbors = neighbors + 1
              end
            end
          end
        end
        marked_map[i][j] = neighbors <= max_neighbors and "x" or "@"
      end
    end
  end

  return marked_map
end

local function count_xs(map)
  return utils.sum(utils.map(map, function(row)
    local xs = utils.filter(row, function(char)
      return char == "x"
    end)

    return #xs
  end))
end

-- Part 1 solution
function Day.part1(data)
  local parsed = parse_input(data)
  local accessible = mark_rolls(parsed, 4)
  -- print(utils.map2d_to_string(accessible))

  return count_xs(accessible)
end

-- Part 2 solution
function Day.part2(data)
  local parsed = parse_input(data)
  local accessible = {}

  local latest_results = mark_rolls(parsed, 4, "@")
  local latest_results_count = count_xs(latest_results)
  local total = 0
  while latest_results_count > total
  do
    accessible = latest_results
    total = latest_results_count
    latest_results = mark_rolls(latest_results, 4, "@")
    latest_results_count = count_xs(latest_results)
  end
  -- print(utils.map2d_to_string(accessible))

  return count_xs(accessible)
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
