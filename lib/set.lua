---@class Set
---@field _items table<any, boolean>
local Set = {}
Set.__index = Set

---Create a new Set from an optional list of initial values
---@param list? table Initial values to add to the set
---@return Set
local function createSet(list)
  local self = setmetatable({}, Set)
  self._items = {}

  if list then
    for _, value in ipairs(list) do
      self._items[value] = true
    end
  end

  return self
end

---Add a value to the set
---@param value any
---@return Set self
function Set:add(value)
  self._items[value] = true
  return self
end

---Remove a value from the set
---@param value any
---@return boolean removed True if value was in set and removed, false otherwise
function Set:remove(value)
  local existed = self._items[value] ~= nil
  self._items[value] = nil
  return existed
end

---Check if a value exists in the set
---@param value any
---@return boolean
function Set:has(value)
  return self._items[value] ~= nil
end

---Get the number of elements in the set
---@return integer
function Set:size()
  local count = 0
  for _ in pairs(self._items) do
    count = count + 1
  end
  return count
end

---Clear all elements from the set
function Set:clear()
  self._items = {}
end

---Get all values as a list
---@return table
function Set:values()
  local result = {}
  for value in pairs(self._items) do
    table.insert(result, value)
  end
  return result
end

---Iterate over all values in the set
function Set:iter()
  return pairs(self._items)
end

return createSet
