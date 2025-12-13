current_year := "2025"

# Default recipe to display help information
default:
    @echo "Welcome to AOC {{current_year}} 🎄"
    @just list
    @echo "--------------------------------------------------"
    @just --list

# Generate a new day solution file
gen day:
    lua scripts/generate.lua {{current_year}} {{day}}

# Run solution for a specific year, day, and optional part
run day part="":
    #!/usr/bin/env bash
    day_padded=$(printf "%02d" {{day}})
    cd {{current_year}} && LUA_PATH="../?.lua;../?/init.lua;;" lua "day${day_padded}.lua" "inputs/day${day_padded}.txt" {{part}}

# Run only part 1
p1 day:
    @just run {{day}} 1

# Run only part 2
p2 day:
    @just run {{day}} 2

[private]
example day part="":
    #!/usr/bin/env bash
    day_padded=$(printf "%02d" {{day}})
    cd {{current_year}} && LUA_PATH="../?.lua;../?/init.lua;;" lua "day${day_padded}.lua" "inputs/day${day_padded}_example.txt" {{part}} --test

# Test with example input
test day part="":
    @just example {{day}} {{part}}

# Test all days for a year with example input
test-all:
    #!/usr/bin/env bash
    for day in {1..12}; do
        day_padded=$(printf "%02d" $day)
        if [ -f "{{current_year}}/day${day_padded}.lua" ]; then
            echo "Testing day $day..."
            just test $day || echo "Day $day failed"
            echo ""
        fi
    done

# Create all day files for a year
gen-year:
    #!/usr/bin/env bash
    for day in {1..12}; do
        just gen $day
    done

# Initialize a new year directory
init:
    mkdir -p {{current_year}}/inputs
    echo "Initialized year {{current_year}}"
                
# List all puzzles for a year with their names
list:
    @LUA_PATH="./?.lua;./?/init.lua;;" lua scripts/list_puzzles.lua {{current_year}} --with-tests
