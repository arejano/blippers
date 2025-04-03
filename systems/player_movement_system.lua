local c_type = require 'models.component_types'
local events = require 'models.game_events'

---@class PlayerMovementSystem
local player_movement_system = {
  watch = {
    [c_type.Player] = true,
  },
  data = { player = nil },
  events = { events.Tick }
}

---@param w Ecs
---@param dt integer
---@param e NewEvent
function player_movement_system:update(w, dt, e)
  -- Player
  if not self.data.player then
    local id = w:new_query({ c_type.Player })[1]
    if id == nil then return end
    self.data.player = id
  end

  ---@type boolean
  local in_movement = w:get_component(self.data.player, c_type.InMovement).data
  if in_movement then
    local player_position = w:get_component(self.data.player, c_type.Transform).data.position
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

    player_position.x = player_position.x + dx * speed_data
    player_position.y = player_position.y + dy * speed_data


    -- local camera_id = w:query({ c_type.Camera })[1]
    -- local camera_position = w:get_component(camera_id, c_type.Position).data
    -- local camera = w:get_component(camera_id, c_type.Camera).data

    -- camera:lookAt(player_position.x, player_position.y)
    -- w:set_component(camera_id, c_type.Position, player_position)
  end
end

return player_movement_system
