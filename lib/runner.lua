--- Runner module for Advent of Code solutions
--- Centralizes all boilerplate code for running AoC puzzles

---@class DayConfigHooks
---@field before_part1? fun(data: any, is_test: boolean) Hook before part 1
---@field after_part1? fun(data: any, result: any, is_test: boolean) Hook after part 1
---@field before_part2? fun(data: any, is_test: boolean) Hook before part 2
---@field after_part2? fun(data: any, result: any, is_test: boolean) Hook after part 2

---@class DayConfigReaders
---@field part1? fun(filepath: string): any Reader for part 1
---@field part2? fun(filepath: string): any Reader for part 2

---@class DayConfigSkip
---@field part1? boolean Skip part 1
---@field part2? boolean Skip part 2

---@class DayConfigExpected
---@field part1? any Expected result for part 1 test
---@field part2? any Expected result for part 2 test

---@class DayConfig
---@field name? string Name of the puzzle
---@field reader? fun(filepath: string): any Default reader function
---@field readers? DayConfigReaders Per-part reader functions
---@field hooks? DayConfigHooks Lifecycle hooks
---@field skip? DayConfigSkip Skip configuration
---@field expected? DayConfigExpected Expected test results

---@class runner
local runner = {}

local utils = require("lib.utils")

--- Parse command line arguments
---@param arg table Command line arguments
---@return string|nil input_file The input file path
---@return number|nil part The part number (1, 2, or nil for both)
---@return boolean is_test Whether this is a test run
local function parse_args(arg)
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

  return input_file, part, is_test
end

--- Get the input file path, with fallback to default
---@param input_file string|nil Provided input file
---@param script_name string The script name (e.g., "day01.lua")
---@return string The resolved input file path
local function get_input_file(input_file, script_name)
  if input_file then
    return input_file
  end

  local day_num = script_name:match("day(%d+)%.lua$")
  if day_num then
    return string.format("inputs/day%s.txt", day_num)
  end

  error("Could not determine input file")
end

--- Get the appropriate reader function for a part
---@param config DayConfig|nil The Day.config table
---@param part number The part number (1 or 2)
---@return function The reader function
local function get_reader(config, part)
  if not config then
    return utils.read_lines
  end

  -- Check for per-part readers first
  if config.readers then
    if part == 1 and config.readers.part1 then
      return config.readers.part1
    elseif part == 2 and config.readers.part2 then
      return config.readers.part2
    end
  end

  -- Fall back to single reader or default
  return config.reader or utils.read_lines
end

--- Check if a part should be skipped
---@param config DayConfig|nil The Day.config table
---@param part number The part number (1 or 2)
---@return boolean True if the part should be skipped
local function should_skip_part(config, part)
  if not config or not config.skip then
    return false
  end

  if part == 1 then
    return config.skip.part1 == true
  elseif part == 2 then
    return config.skip.part2 == true
  end

  return false
end

--- Run a single part with error handling and validation
---@param Day table The Day module
---@param part_num number The part number (1 or 2)
---@param data any The input data
---@param is_test boolean Whether this is a test run
---@return boolean success Whether the part ran successfully
local function run_part(Day, part_num, data, is_test)
  local part_name = string.format("part%d", part_num)
  local part_func = Day[part_name]

  if not part_func then
    print(string.format("✗ Part %d: not implemented", part_num))
    return false
  end

  -- Check if part should be skipped
  if should_skip_part(Day.config, part_num) then
    print(string.format("⊘ Part %d: skipped", part_num))
    return true
  end

  -- Run before hook if present
  if Day.config and Day.config.hooks then
    local before_hook = Day.config.hooks[string.format("before_part%d", part_num)]
    if before_hook then
      local success, err = pcall(before_hook, data, is_test)
      if not success then
        print(string.format("✗ Part %d before hook ERROR: %s", part_num, err))
        return false
      end
    end
  end

  -- Run the part function
  local success, result = pcall(part_func, data, is_test)
  if not success then
    print(string.format("✗ Part %d ERROR: %s", part_num, result))
    return false
  end

  print(string.format("Part %d: %s", part_num, result))

  -- Validate against expected result if in test mode
  if is_test and Day.config and Day.config.expected and Day.config.expected[part_name] then
    if result == Day.config.expected[part_name] then
      print(string.format("✓ Part %d test passed", part_num))
    else
      print(string.format("✗ Part %d assertion failed: expected %s, got %s",
        part_num, Day.config.expected[part_name], result))
      return false
    end
  end

  -- Run after hook if present
  if Day.config and Day.config.hooks then
    local after_hook = Day.config.hooks[string.format("after_part%d", part_num)]
    if after_hook then
      local hook_success, err = pcall(after_hook, data, result, is_test)
      if not hook_success then
        print(string.format("✗ Part %d after hook ERROR: %s", part_num, err))
        return false
      end
    end
  end

  return true
end

--- Get puzzle information for listing
---@param Day table The Day module
---@param day_num string The day number (e.g., "01")
---@return table Puzzle info with day, name, parts
function runner.get_puzzle_info(Day, day_num)
  local name = "N/A"
  if Day.config and Day.config.name then
    name = Day.config.name
  end

  local parts = {}
  if Day.part1 then
    table.insert(parts, 1)
  end
  if Day.part2 then
    table.insert(parts, 2)
  end

  return {
    day = day_num,
    name = name,
    parts = parts,
  }
end

--- Main entry point for running a Day module
---@param Day table The Day module with part1, part2, and optional config
---@return table The Day module (for chaining)
function runner.run(Day)
  -- Only run if executed as a script
  if not arg or not arg[0] or not arg[0]:match("day%d+%.lua$") then
    return Day
  end

  local input_file, part, is_test = parse_args(arg)
  input_file = get_input_file(input_file, arg[0])

  -- Determine which parts to run
  local run_part1 = (part == 1 or part == nil)
  local run_part2 = (part == 2 or part == nil)

  -- Run part 1
  if run_part1 then
    local reader = get_reader(Day.config, 1)
    local data = reader(input_file)
    run_part(Day, 1, data, is_test)
  end

  -- Run part 2
  if run_part2 then
    local reader = get_reader(Day.config, 2)
    local data = reader(input_file)
    run_part(Day, 2, data, is_test)
  end

  return Day
end

return runner
