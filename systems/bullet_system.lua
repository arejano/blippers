local c_type = require 'models.component_types'
local events = require 'models.game_events'

local BulletSystem = {
  name = "bullet_system",
  watch = {
    [c_type.Player] = true,
  },
  events = { events.Shot },
  bullet_sprite = love.graphics.newImage("assets/bullet.png"),
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
    local player = world:new_query({ c_type.Player })[1]
    if player == nil then return end

    local player_position = world:get_component(player, c_type.Transform).data.position
    -- for i = 1, 1000 do
    world:add_entity({
      { type = c_type.Bullet,   data = { width = 5, height = 5 } },
      { type = c_type.Render,   data = true },
      { type = c_type.LifeTime, data = 1 },
      {
        type = c_type.Transform,
        data = {
          position = { x = player_position.x + 20, y = player_position.y + 30 },
          rotation = { ox = 0, oy = 0 },
          scale = { sx = 2, sy = 2 },
          size = { width = 20, height = 10 }
        },
      },
      { type = c_type.Sprite, data = self.bullet_sprite }
    })
    -- end
  end
end

return BulletSystem
