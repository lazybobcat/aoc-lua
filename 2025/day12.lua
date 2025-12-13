local utils = require("lib.utils")
local inspect = require("lib.inspect")

local Day = {}

---@type DayConfig
Day.config = {
  name = "Puzzle Name",
  -- reader = utils.read_lines,  -- default: read_lines
  -- OR use per-part readers:
  -- readers = {
  --   part1 = utils.read_lines,
  --   part2 = utils.read_file,
  -- },
  expected = {
    part1 = nil,
    part2 = nil,
  },
}

local function parse_input(lines)
  local parsed = {}
  -- TODO: transform lines into useful data

  return parsed
end

-- Part 1 solution
function Day.part1(data, is_test)
  -- Implement part 1 here
  local parsed = parse_input(data)
  return 0
end

-- Part 2 solution
function Day.part2(data, is_test)
  -- Implement part 2 here
  local parsed = parse_input(data)
  return 0
end

return require("lib.runner").run(Day)
