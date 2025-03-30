local c_type = require 'models.component_types'
local events = require 'models.game_events'

---@class EnemyTargetSystem
local EnemyTargetSystem = {
  data = {},
  events = { events.Render }
}

---@param w Ecs
function EnemyTargetSystem:start(w)
end

---@param world Ecs
---@param dt integer
function EnemyTargetSystem:update(world, dt)
  local target = world:query({ c_type.Enemy })

  if target ~= nil then
    for _, v in ipairs(target) do
      local position = world:get_component(v, c_type.Position).data
      local size = world:get_component(v, c_type.SpriteSize).data
      love.graphics.rectangle("fill", position.x, position.y, size.width, size.height)
    end
  end
end

return EnemyTargetSystem
