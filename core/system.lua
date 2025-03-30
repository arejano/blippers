---@class System
---@field start function
---@field update function
---@field destroy function
local System = {}
System.__index = System

function System:new(start, update, destroy)
  local system = {
    start = start,
    update = update,
    destroy = destroy
  }
  setmetatable(system, System)
  return system
end

---@param world Ecs
function System:start(world)
  self.start(world)
end

---@param world Ecs
function System:update(world)
  self.update(world)
end

---@param world Ecs
function System:destroy(world)
  self.destroy(world)
end

return System
