local c_type = require 'models.component_types'
local events = require 'models.game_events'

local BulletSystem = {
  events = { events.Shot, events.Tick },
  keys = {
    ["f1"] = events.ChangeMap,
    ["f2"] = "left",
    ["f3"] = "down",
    ["f4"] = "right",
    ["space"] = events.Shot,
  },
  pressed_keys = {},
}

---@param event NewEvent
function BulletSystem:update(world, dt, event)
  if event.type == events.Shot then
    local player = world:query({ c_type.Player })[1]

    local player_position = world:get_component(player, c_type.Position).data
    world:add_entity({
      { type = c_type.Bullet,   data = { width = 5, height = 5 } },
      { type = c_type.LifeTime, data = 1 },
      { type = c_type.Position, data = { x = player_position.x, y = player_position.y } },
    })
  end

  if event.type == events.Tick then
    local live_bullets = world:query({ c_type.Bullet })

    if live_bullets ~= nil then
      for _, v in ipairs(live_bullets) do
        local position = world:get_component(v, c_type.Position).data
        local lt = world:get_component(v, c_type.LifeTime).data

        if lt < 100 then
          lt = lt + 1

          world:set_component(v, c_type.LifeTime, lt)

          if position ~= nil then
            position.x = position.x + 1 * 5
          end
        end
      end
    end
  end
end

return BulletSystem
