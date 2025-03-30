local inspect = require 'libs.inspect'
local c_type = require 'models.component_types'
local events = require 'models.game_events'

---@class PlayerRenderSystem
local render_system = {
  data = { player = nil },
  events = { events.Render }
}

---@param world Ecs
---@param dt integer
function render_system:update(world, dt)
  -- Player
  if not self.data.player then
    self.data.player = world:query({ c_type.Player })[1]
  end

  if not self.data.sprite then
    self.data.sprite = world:get_component(self.data.player, c_type.Sprite).data
  end


  local sprite = world:get_component(self.data.player, c_type.Sprite).data


  local position = world:get_component(self.data.player, c_type.Position).data
  local animation = world:get_component(self.data.player, c_type.Animation).data

  if animation ~= nil and position ~= nil then
    animation.current_animation:draw(self.data.sprite, position.x, position.y, nil, 2, nil, 0, 0)
  end

end

return render_system
