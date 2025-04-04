local c_type = require 'models.component_types'
local events = require 'models.game_events'

local BulletMoveSystem = {
  name = "bullet_movement_system",
  watch = { [c_type.Bullet] = true, },
  events = { events.Tick },
}

---@param event NewEvent
function BulletMoveSystem:update(world, dt, event)
  local live_bullets = world:new_query({ c_type.Bullet })

  if live_bullets ~= nil then
    for _, bullet_id in ipairs(live_bullets) do
      local transform = world:get_component(bullet_id, c_type.Transform).data
      local lt = world:get_component(bullet_id, c_type.LifeTime).data

      if lt < 100 then
        lt = lt + 1

        world:set_component(bullet_id, c_type.LifeTime, lt)

        if transform.position ~= nil then
          transform.position.x = transform.position.x + 1 * 5
        end
      else
        world:remove_entity(bullet_id)
      end
    end
  end
end

return BulletMoveSystem
