local utils = require("lib.utils")
local inspect = require("lib.inspect")

local Day = {}

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

local function mark_rolls(map, max_neighbors)
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
              if marked_map[i + di][j + dj] ~= "." then
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

-- Part 1 solution
function Day.part1(data)
  local parsed = parse_input(data)
  local accessible = mark_rolls(parsed, 4)
  print(utils.map2d_to_string(accessible))

  return utils.sum(utils.map(accessible, function(row)
    local xs = utils.filter(row, function(char)
      return char == "x"
    end)

    return #xs
  end))
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
