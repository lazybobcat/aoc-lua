local utils = require("lib.utils")
local inspect = require("lib.inspect")

local Day = {}

--[[
The safe has a dial with only an arrow on it; around the dial are the numbers 0 through 99 in order. As you turn the dial, it makes a small click noise as it reaches each number.

The attached document (your puzzle input) contains a sequence of rotations, one per line, which tell you how to open the safe. A rotation starts with an L or R which indicates whether the rotation should be to the left (toward lower numbers) or to the right (toward higher numbers). Then, the rotation has a distance value which indicates how many clicks the dial should be rotated in that direction.

So, if the dial were pointing at 11, a rotation of R8 would cause the dial to point at 19. After that, a rotation of L19 would cause it to point at 0.

Because the dial is a circle, turning the dial left from 0 one click makes it point at 99. Similarly, turning the dial right from 99 one click makes it point at 0.

So, if the dial were pointing at 5, a rotation of L10 would cause it to point at 95. After that, a rotation of R5 could cause it to point at 0.

The dial starts by pointing at 50.

You could follow the instructions, but your recent required official North Pole secret entrance security training seminar taught you that the safe is actually a decoy. The actual password is the number of times the dial is left pointing at 0 after any rotation in the sequence.
--]] --

function parse_input(lines)
  local parsed = {}
  for _, line in ipairs(lines) do
    local direction, steps = line:match("([LR])(%d+)")
    table.insert(parsed, {
      direction = direction,
      steps = tonumber(steps),
    })
  end

  return parsed
end

function dialRight(start, steps)
  local result = (start + steps) % 100
  return result
end

function dialLeft(start, steps)
  local result = math.abs((start - steps) % 100)
  return result
end

-- Part 1 solution
function Day.part1(data)
  -- Implement part 1 here
  local parsed = parse_input(data)
  local start = 50
  local zeroCount = 0
  for _, step in ipairs(parsed) do
    if step.direction == "L" then
      start = dialLeft(start, step.steps)
    elseif step.direction == "R" then
      start = dialRight(start, step.steps)
    end

    if start == 0 then
      zeroCount = zeroCount + 1
    end
  end

  return zeroCount
end

-- Part 2 solution
function Day.part2(data)
  -- Implement part 2 here
  print(inspect(data))
  return 0
end

-- Main execution
function Day.run(input_file, part)
  local data = utils.read_file(input_file)

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
