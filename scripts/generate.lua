#!/usr/bin/env lua

local function usage()
    print("Usage: lua scripts/generate.lua <year> <day>")
    print("Example: lua scripts/generate.lua 2024 1")
    os.exit(1)
end

local function file_exists(path)
    local f = io.open(path, "r")
    if f then
        f:close()
        return true
    end
    return false
end

local function mkdir_p(path)
    os.execute(string.format("mkdir -p '%s'", path))
end

local function copy_template(template_path, dest_path)
    local template = io.open(template_path, "r")
    if not template then
        error("Template file not found: " .. template_path)
    end

    local content = template:read("*all")
    template:close()

    local dest = io.open(dest_path, "w")
    dest:write(content)
    dest:close()
end

local function generate_day(year, day)
    local year_dir = tostring(year)
    local day_str = string.format("%02d", day)
    local day_file = string.format("%s/day%s.lua", year_dir, day_str)
    local input_dir = string.format("%s/inputs", year_dir)
    local input_file = string.format("%s/day%s.txt", input_dir, day_str)
    local example_file = string.format("%s/day%s_example.txt", input_dir, day_str)

    -- Create directories
    mkdir_p(year_dir)
    mkdir_p(input_dir)

    -- Create day file from template
    if file_exists(day_file) then
        print(string.format("Warning: %s already exists, skipping...", day_file))
    else
        copy_template("templates/day.lua", day_file)
        print(string.format("Created: %s", day_file))
    end

    -- Create empty input files
    if not file_exists(input_file) then
        local f = io.open(input_file, "w")
        f:write("-- Paste your input here\n")
        f:close()
        print(string.format("Created: %s", input_file))
    end

    if not file_exists(example_file) then
        local f = io.open(example_file, "w")
        f:write("-- Paste example input here\n")
        f:close()
        print(string.format("Created: %s", example_file))
    end
end

-- Main
local year = tonumber(arg[1])
local day = tonumber(arg[2])

if not year or not day or day < 1 or day > 25 then
    usage()
end

generate_day(year, day)
print(string.format("\nDone! You can now solve %d day %d", year, day))
