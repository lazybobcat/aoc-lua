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

local function compute_largest_area(points, valid_segment_checker)
  local largest_area = 0
  local file = io.open("largest_area.svg", "a")
  io.output(file)

  for i = 1, #points - 1 do
    for j = 1, #points do
      local a = points[i]
      local b = points[j]
      if valid_segment_checker(a, b) then
        local area = (math.abs(a.x - b.x) + 1) * (math.abs(a.y - b.y) + 1)
        largest_area = math.max(largest_area, area)
        io.write('<rect x="' ..
          a.x .. '" y="' .. a.y .. '" width="' .. b.x - a.x .. '" height="' .. b.y - a.y .. '" fill="green" />')
      end
    end
  end

  file:close()
  return largest_area
end

local function extract_polygon_segments(polygon)
  local segments = {}
  for i = 1, #polygon - 1 do
    local a = polygon[i]
    local b = polygon[i + 1]
    table.insert(segments, { a, b })
  end

  table.insert(segments, { polygon[#polygon], polygon[1] })

  return segments
end

local function segment_intersects_checker(segments)
  -- thanks wikipedia for the formula
  local function orient(p, q, r)
    return (q.x - p.x) * (r.y - p.y) - (q.y - p.y) * (r.x - p.x)
  end

  local function segment_intersects(a, b, c, d)
    local o1 = orient(a, b, c)
    local o2 = orient(a, b, d)
    local o3 = orient(c, d, a)
    local o4 = orient(c, d, b)

    return o1 * o2 < 0 and o3 * o4 < 0
  end


  -- returns a function that takes a diagonal (da, db) and checks if the rectangle it defines intersects any of the segments in segments
  return function(da, db)
    local pt1 = da
    local pt2 = { x = da.x, y = db.y }
    local pt3 = db
    local pt4 = { x = db.x, y = da.y }
    local sides = { { da, db }, { pt1, pt2 }, { pt2, pt3 }, { pt3, pt4 }, { pt4, pt1 } }
    for _, side in ipairs(sides) do
      for _, segment in ipairs(segments) do
        local a = side[1]
        local b = side[2]
        local c = segment[1]
        local d = segment[2]
        if segment_intersects(a, b, c, d) then
          return false
        end
      end
    end

    return true
  end
end

-- Part 1 solution
function Day.part1(data, is_test)
  local parsed = parse_input(data)
  local largest_area = compute_largest_area(parsed, function() return true end)

  return largest_area
end

-- Part 2 solution
function Day.part2(data, is_test)
  local parsed = parse_input(data)
  local segments = extract_polygon_segments(parsed)
  local checker = segment_intersects_checker(segments)
  local largest_area = compute_largest_area(parsed, checker)

  return largest_area
end

return require("lib.runner").run(Day)
