local inspect = require 'libs.inspect'
local systems = {}
systems.__add = function(left, right)
  local temp = {}
  for i, v in ipairs(left) do
    table.insert(temp, v)
  end

  for i, v in ipairs(right) do
    table.insert(temp, v)
  end

  return temp
end

local s1 = setmetatable({ "a", "b", "c" }, systems)
local s2 = setmetatable({ "d", "e", "f" }, systems)

local r = s1 + s2

print(inspect(r))

-- print(" Gustavo \n Arejano \n dos \n Santos \n Arejano")
