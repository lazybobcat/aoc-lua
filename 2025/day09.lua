local utils = require("lib.utils")
local inspect = require("lib.inspect")

local Day = {}

---@type DayConfig
Day.config = {
  name = "Movie Theater",
  -- reader = utils.read_lines,  -- default: read_lines
  -- OR use per-part readers:
  -- readers = {
  --   part1 = utils.read_lines,
  --   part2 = utils.read_file,
  -- },
  expected = {
    part1 = 50,
    part2 = 24,
  },
}

local function parse_input(lines)
  local parsed = {}
  -- lines are in the format "x,y"
  for _, line in ipairs(lines) do
    local pos = utils.split(line, ",")
    table.insert(parsed, { x = tonumber(pos[1]), y = tonumber(pos[2]) })
  end

  return parsed
end

-- local function compute_areas(points)
--   local areas = {}
--   for i = 1, #points - 1 do
--     for j = i + 1, #points do
--       local a = points[i]
--       local b = points[j]
--       local area = (math.abs(a.x - b.x) + 1) * (math.abs(a.y - b.y) + 1)
--       table.insert(areas, area)
--     end
--   end
--
--   table.sort(areas, function(a, b)
--     return a > b
--   end)
--
--   return areas
-- end

local function compute_largest_area(points)
  local largest_area = 0
  for i = 1, #points - 1 do
    for j = i + 1, #points do
      local a = points[i]
      local b = points[j]
      local area = (math.abs(a.x - b.x) + 1) * (math.abs(a.y - b.y) + 1)
      largest_area = math.max(largest_area, area)
    end
  end

  return largest_area
end

-- Part 1 solution
function Day.part1(data, is_test)
  local parsed = parse_input(data)
  local largest_area = compute_largest_area(parsed)

  return largest_area
end

-- Part 2 solution
function Day.part2(data, is_test)
  -- Implement part 2 here
  local parsed = parse_input(data)
  return 0
end

return require("lib.runner").run(Day)
