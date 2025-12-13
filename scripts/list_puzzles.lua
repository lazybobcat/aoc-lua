#!/usr/bin/env lua
--- Script to list all puzzles for a given year with their names
local runner = require("lib.runner")

local function list_puzzles(year, with_tests)
  local year_dir = string.format("%s", year)

  -- Check if year directory exists
  local test_file = io.open(year_dir .. "/day01.lua", "r")
  if not test_file then
    print(string.format("Year %s not found or has no puzzles", year))
    return
  end
  io.close(test_file)

  print(string.format("Puzzles for year %s:", year))
  print(string.rep("-", 50))

  -- Star tracking
  local stars_earned = 0
  local total_stars = 0

  -- Iterate through potential days (1-25)
  for day = 1, 25 do
    local day_padded = string.format("%02d", day)
    local day_file = string.format("%s/day%s.lua", year_dir, day_padded)

    -- Check if file exists
    local file = io.open(day_file, "r")
    if file then
      io.close(file)

      -- Load the module to get puzzle info
      local original_path = package.path
      package.path = string.format("./?/init.lua;./?.lua;%s", package.path)

      -- Change to year directory for proper requires
      local original_dir = os.getenv("PWD") or "."
      os.execute(string.format("cd %s", year_dir))

      local success, Day = pcall(require, string.format("%s.day%s", year, day_padded))

      -- Restore original directory
      os.execute(string.format("cd %s", original_dir))
      package.path = original_path

      if success and Day then
        local info = runner.get_puzzle_info(Day, day_padded)
        local parts_str = table.concat(info.parts, ", ")

        -- Build the output string
        local output = string.format("Day %s: %-30s [Parts: %s]", info.day, info.name, parts_str)

        -- Count total possible stars for this day
        total_stars = total_stars + 2

        -- Add test status if requested
        if with_tests then
          local status_parts = {}
          local example_file = string.format("%s/inputs/day%s_example.txt", year_dir, day_padded)

          -- Test part 1 if it exists
          if Day.part1 then
            local status1 = runner.test_part(Day, 1, example_file)
            table.insert(status_parts, status1)
            if status1 == "✓" then
              stars_earned = stars_earned + 1
            end
          else
            table.insert(status_parts, "?")
          end

          -- Test part 2 if it exists
          if Day.part2 then
            local status2 = runner.test_part(Day, 2, example_file)
            table.insert(status_parts, status2)
            if status2 == "✓" then
              stars_earned = stars_earned + 1
            end
          else
            table.insert(status_parts, "?")
          end

          local status_str = table.concat(status_parts, ", ")
          output = output .. string.format(" [%s]", status_str)
        end

        print(output)

        -- Unload the module to avoid conflicts
        package.loaded[string.format("%s.day%s", year, day_padded)] = nil
      else
        print(string.format("Day %s: %-30s [Error loading]", day_padded, "N/A"))
      end
    end
  end

  -- Display star summary
  print(string.rep("-", 50))
  print(string.format("Stars earned: %d / %d ⭐", stars_earned, total_stars))
end

-- Main execution
if not arg[1] then
  print("Usage: lua scripts/list_puzzles.lua <year> [--with-tests]")
  os.exit(1)
end

local year = arg[1]
local with_tests = false

-- Check for --with-tests flag
for i = 2, #arg do
  if arg[i] == "--with-tests" then
    with_tests = true
    break
  end
end

list_puzzles(year, with_tests)
