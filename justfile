# Default recipe to display help information
default:
    @just --list

# Generate a new day solution file
gen year day:
    lua scripts/generate.lua {{year}} {{day}}

# Run solution for a specific year, day, and optional part
run year day part="":
    #!/usr/bin/env bash
    day_padded=$(printf "%02d" {{day}})
    cd {{year}} && LUA_PATH="../?.lua;../?/init.lua;;" lua "day${day_padded}.lua" "inputs/day${day_padded}.txt" {{part}}

# Run with example input
example year day part="":
    #!/usr/bin/env bash
    day_padded=$(printf "%02d" {{day}})
    cd {{year}} && LUA_PATH="../?.lua;../?/init.lua;;" lua "day${day_padded}.lua" "inputs/day${day_padded}_example.txt" {{part}}

# Run only part 1
p1 year day:
    @just run {{year}} {{day}} 1

# Run only part 2
p2 year day:
    @just run {{year}} {{day}} 2

# Run both parts (explicit)
both year day:
    @just run {{year}} {{day}}

# Test with example input
test year day part="":
    @just example {{year}} {{day}} {{part}}

# Create all day files for a year
gen-year year:
    #!/usr/bin/env bash
    for day in {1..25}; do
        just gen {{year}} $day
    done

# Initialize a new year directory
init year:
    mkdir -p {{year}}/inputs
    echo "Initialized year {{year}}"
