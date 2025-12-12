local utils = require("lib.utils")

local Day = {}

---@type DayConfig
Day.config = {
  name = "Trash Compactor",
  readers = {
    part1 = utils.read_lines,
    part2 = function(file)
      local lines = {}
      for line in io.lines(file) do
        table.insert(lines, line) -- no trim
      end
      return lines
    end
  },
  expected = {
    part1 = 4277556,
    part2 = 3263827,
  },
}

local function parse_input(lines)
  local parsed = {}
  for _, line in ipairs(lines) do
    local symbols = utils.split(utils.trim(line))
    table.insert(parsed, symbols)
  end

  return utils.map2d_rotate(parsed)
end

local function parse_input_cephalopod(lines)
  local parsed = {}
  local length = #lines[1]
  local operator_index = #lines
  local current_operator = nil
  local current_operands = {}

  local operator_line_table = utils.string_to_table(lines[operator_index])
  for i = 1, length do
    local operator = operator_line_table[i]

    -- if operator is not a space, then we have a new compute, so we can save the current operands
    if operator ~= " " then
      if #current_operands > 0 then
        table.insert(parsed, utils.concat(current_operands, { current_operator }))
      end
      current_operator = operator
      current_operands = {}
    end

    -- we retrieve the operand
    local operand = ""
    for j = 1, operator_index - 1 do
      local digit = utils.string_to_table(lines[j])[i]
      if digit ~= " " then
        operand = operand .. digit
      end
    end
    table.insert(current_operands, tonumber(operand))
  end

  -- at the end insert the last operand
  if #current_operands > 0 then
    table.insert(parsed, utils.concat(current_operands, { current_operator }))
  end


  return parsed
end

local function compute_addition(acc, operand)
  return acc + operand
end

local function compute_multiplication(acc, operand)
  return acc * operand
end

local function compute(line)
  local operation = table.remove(line)
  local operands = utils.map(line, tonumber)

  local compute_operation = operation == "+" and compute_addition or compute_multiplication
  local start = operation == "+" and 0 or 1

  return utils.reduce(operands, compute_operation, start)
end

-- Part 1 solution
function Day.part1(data, is_test)
  local parsed = parse_input(data)
  local total = 0
  for _, line in ipairs(parsed) do
    total = total + compute(line)
  end

  return total
end

-- Part 2 solution
function Day.part2(data, is_test)
  local parsed = parse_input_cephalopod(data)
  local total = 0
  for _, line in ipairs(parsed) do
    total = total + compute(line)
  end

  return total
end

return require("lib.runner").run(Day)
