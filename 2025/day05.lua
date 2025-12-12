local utils = require("lib.utils")
local set = require("lib.set")

local Day = {}

---@type DayConfig
Day.config = {
  name = "Cafeteria",
  expected = {
    part1 = 3,
    part2 = 14,
  },
}

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
  local marked = set()

  for _, ingredient in ipairs(ingredients) do
    for _, range in ipairs(ranges) do
      if ingredient >= range[1] and ingredient <= range[2] then
        marked:add(ingredient)
        break
      end
    end
  end

  return marked
end

local function get_fresh_ingredients_ids_count(overlapping_ranges)
  -- first we need to mutually exclude overlapping ranges
  -- then we can count the number of ids in the remaining ranges
  local ranges = {}
  local sortFn = function(a, b)
    return a[1] < b[1]
  end
  table.sort(overlapping_ranges, sortFn)

  local previous_finish = nil
  for _, range in ipairs(overlapping_ranges) do
    local start, finish = range[1], range[2]
    if previous_finish == nil then
      table.insert(ranges, { start, finish })
      previous_finish = finish
    elseif start <= previous_finish and previous_finish < finish then
      start = previous_finish + 1
      table.insert(ranges, { start, finish })
      previous_finish = finish
    elseif start > previous_finish then
      table.insert(ranges, { start, finish })
      previous_finish = finish
    end
  end

  return utils.sum(utils.map(ranges, function(range)
    return range[2] - range[1] + 1
  end))
end

-- Part 1 solution
function Day.part1(data, is_test)
  local ranges, ingredients = parse_input(data)
  local fresh = get_fresh_ingredients(ranges, ingredients)

  return fresh:size()
end

-- Part 2 solution
function Day.part2(data, is_test)
  local ranges = parse_input(data)
  local total = get_fresh_ingredients_ids_count(ranges)

  -- NOTE: I first tried to use the naive approach of inserting every ID into a set
  -- but this was too slow and crashed with real input. So I switched to a more
  -- efficient approach of removing overlaps in the ranges and then counting the
  -- number of IDs in the remaining ranges.

  return total
end

return require("lib.runner").run(Day)
