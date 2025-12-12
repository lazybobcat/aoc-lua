local utils = require("lib.utils")

local Day = {}

---@type DayConfig
Day.config = {
  name = "Printing Department",
  expected = {
    part1 = 13,
    part2 = 43,
  },
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
function Day.part1(data, is_test)
  local parsed = parse_input(data)
  local accessible = mark_rolls(parsed, 4)
  -- print(utils.map2d_to_string(accessible))

  return count_xs(accessible)
end

-- Part 2 solution
function Day.part2(data, is_test)
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

return require("lib.runner").run(Day)
