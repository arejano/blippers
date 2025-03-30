local inspect = require 'libs.inspect'
local c_type = require 'models.component_types'
local events = require 'models.game_events'

---@class PlayerMovementSystem
local player_movement_system = {
  data = { player = nil },
  events = { events.Tick }
}

---@param w Ecs
---@param dt integer
---@param e NewEvent
function player_movement_system:update(w, dt, e)
  -- Player
  if not self.data.player then
    self.data.player = w:query({ c_type.Player })[1]
  end

  ---@type boolean
  local in_movement = w:get_component(self.data.player, c_type.InMovement).data
  if in_movement then
    local position_data = w:get_component(self.data.player, c_type.Position).data
    local speed_data = w:get_component(self.data.player, c_type.Speed).data
    local directions = w:get_component(self.data.player, c_type.Direction).data

    local dx, dy = 0, 0
    for _, direction in ipairs(directions) do
      if direction == "up" then
        dy = dy - 1
      end
      if direction == "down" then
        dy = dy + 1
      end
      if direction == "left" then
        dx = dx - 1
      end
      if direction == "right" then
        dx = dx + 1
      end
    end

    -- Normalize diagonal movement
    if dx ~= 0 and dy ~= 0 then
      dx = dx * math.sqrt(0.5)
      dy = dy * math.sqrt(0.5)
    end

    position_data.x = position_data.x + dx * speed_data
    position_data.y = position_data.y + dy * speed_data
  end
end

return player_movement_system
