local ge = require "models.game_events"
local inspect = require 'libs.inspect'
local lv = love

---@class System
local DebugSystem = {
  events = { ge.Render }
}
DebugSystem.__index = DebugSystem

function DebugSystem:new()
  local system = {
  }
  setmetatable(system, DebugSystem)
  return system
end

---@param world Ecs
function DebugSystem:start(world)
end

---@param w Ecs
function DebugSystem:update(w)
  -- self:update_counter(w)

  lv.graphics.print(w.delta_time, 10, 10)
  lv.graphics.print(inspect(#w.resources), 10, 40)
end

function DebugSystem:update_counter(world)
  local c = world.counters.debug_system
  if c == nil then
    c = 0
    world.counters.debug_system = 0
  end
  world.counters.debug_system = c + 1
end

---@param world Ecs
function DebugSystem:destroy(world)
end

return DebugSystem
