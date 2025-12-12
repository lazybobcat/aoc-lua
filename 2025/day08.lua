local utils = require("lib.utils")
local inspect = require("lib.inspect")
local Set = require("lib.set")

local Day = {}

---@type DayConfig
Day.config = {
  name = "Playground",
  expected = {
    part1 = 40,
    part2 = nil,
  },
}

local function parse_input(lines)
  local parsed = {}
  for _, line in ipairs(lines) do
    local position = utils.split(line, ",")
    table.insert(parsed, { x = tonumber(position[1]), y = tonumber(position[2]), z = tonumber(position[3]) })
  end

  return parsed
end

local function coords_to_index(position)
  return position.x .. "," .. position.y .. "," .. position.z
end

-- this actually compute the squared distances, faster on CPU than a squirt
local function compute_distances(boxes)
  local distances = {}
  local visited = {}
  for _, box in pairs(boxes) do
    visited[coords_to_index(box)] = Set()
  end

  for _, box1 in pairs(boxes) do
    for _, box2 in pairs(boxes) do
      local ibox1, ibox2 = coords_to_index(box1), coords_to_index(box2)
      if ibox1 ~= ibox2 and not visited[ibox1]:has(ibox2) and not visited[ibox2]:has(ibox1) then
        local distance = math.floor(math.pow(box1.x - box2.x, 2) + math.pow(box1.y - box2.y, 2) +
          math.pow(box1.z - box2.z, 2))
        table.insert(distances, {
          box1 = ibox1,
          box2 = ibox2,
          distance = distance,
        })
        visited[ibox1]:add(ibox2)
        visited[ibox2]:add(ibox1)
      end
    end
  end

  table.sort(distances, function(a, b)
    return a.distance < b.distance
  end)

  return distances
end

local function make_circuits(boxes, boxes_distances, nb_connections)
  local circuits = {}
  local circuits_indices = {}
  for _, box in pairs(boxes) do
    local xyz = coords_to_index(box)
    circuits_indices[xyz] = xyz
    circuits[xyz] = { xyz }
  end

  for i = 1, nb_connections do
    local distance = boxes_distances[i]
    local box1 = distance.box1
    local box2 = distance.box2
    local i1 = circuits_indices[box1]
    local i2 = circuits_indices[box2]

    if i1 ~= i2 then
      local circuit1 = circuits[i1]
      local circuit2 = circuits[i2]
      while #circuit2 > 0 do
        local item = table.remove(circuit2, 1)
        table.insert(circuit1, item)
        circuits_indices[item] = i1
      end
    end
  end

  local circuits_lengths = {}
  for _, circuit in pairs(circuits) do
    table.insert(circuits_lengths, #circuit)
  end
  table.sort(circuits_lengths, function(a, b)
    return a > b
  end)

  return circuits, circuits_lengths
end

-- Part 1 solution
function Day.part1(data, is_test)
  local nb_connections = is_test and 10 or 1000

  local boxes = parse_input(data)
  local boxes_distances = compute_distances(boxes)

  local circuits, circuits_lengths = make_circuits(boxes, boxes_distances, nb_connections)
  print(circuits_lengths[1], circuits_lengths[2], circuits_lengths[3])

  return circuits_lengths[1] * circuits_lengths[2] * circuits_lengths[3]
end

-- Part 2 solution
function Day.part2(data, is_test)
  -- Implement part 2 here
  local parsed = parse_input(data)
  return 0
end

return require("lib.runner").run(Day)
