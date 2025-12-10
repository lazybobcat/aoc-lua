# Advent of Code - Lua Solutions

Solutions for [Advent of Code](https://adventofcode.com/) challenges written in Lua.

## Prerequisites

- Lua 5.1+ (or LuaJIT)
- [just](https://github.com/casey/just) command runner

## Project Structure

- `YEAR/` - Solutions organized by year
  - `dayXX.lua` - Solution for day XX (both parts)
  - `inputs/dayXX.txt` - Input data for day XX
  - `inputs/dayXX_example.txt` - Example input for testing
- `lib/` - Common utility functions
- `templates/` - Templates for generating new solutions
- `scripts/` - Helper scripts

## Usage

### Generate a new day solution

```bash
just gen 2024 1  # Creates 2024/day01.lua and input files
```

### Generate all days for a year

```bash
just gen-year 2024  # Creates day01.lua through day25.lua
```

### Run a solution

```bash
just run 2024 1      # Run both parts for 2024 day 1
just p1 2024 1       # Run only part 1
just p2 2024 1       # Run only part 2
```

### Test with example input

```bash
just example 2024 1  # Run with example input
just test 2024 1     # Alias for example
```

### Manual execution

You can also run solutions directly:

```bash
cd 2024
lua day01.lua inputs/day01.txt     # Both parts
lua day01.lua inputs/day01.txt 1   # Part 1 only
lua day01.lua inputs/day01.txt 2   # Part 2 only
```

## Development Workflow

1. Generate day file: `just gen 2024 1`
2. Paste input data into `2024/inputs/day01.txt`
3. Paste example into `2024/inputs/day01_example.txt` (optional)
4. Implement solution in `2024/day01.lua`
5. Test: `just test 2024 1`
6. Run: `just run 2024 1`

## Utilities

The `lib/utils.lua` module provides common functions:
- String operations: `split()`, `trim()`
- Table operations: `map()`, `filter()`, `sum()`
- File operations: `read_file()`, `read_lines()`

Import in your solutions:
```lua
local utils = require("lib.utils")
```

## Template Structure

Each day file (`dayXX.lua`) follows this structure:

```lua
local utils = require("lib.utils")

local Day = {}

-- Parse input file
function Day.parse_input(filename)
    -- Parse your input here
end

-- Part 1 solution
function Day.part1(data)
    -- Implement part 1 here
    return 0
end

-- Part 2 solution
function Day.part2(data)
    -- Implement part 2 here
    return 0
end

-- Main execution
function Day.run(input_file, part)
    -- Runs part 1, part 2, or both
end

return Day
```

## Tips

- Update `templates/day.lua` to change the template for new days
- Use `just test` with example input to verify your solution
- The `lib/utils.lua` file can be extended with more helper functions
- Each year is self-contained with its own input files

## Quick Start

```bash
# Generate day 1 of 2024
just gen 2024 1

# Edit the file and add your solution
vim 2024/day01.lua

# Add your puzzle input
vim 2024/inputs/day01.txt

# Run your solution
just run 2024 1
```
