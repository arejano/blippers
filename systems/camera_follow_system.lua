local c_type = require 'models.component_types'
local events = require 'models.game_events'

---@class CameraSystem
local CameraFollow = {
  data = {},
  events = { events.Tick }
}

---@param w Ecs
function CameraFollow:start(w)
end

---@param w Ecs
---@param dt integer
---@param event NewEvent
function CameraFollow:update(w, dt, event)
  local to_follow          = w:query({ c_type.CameraFollow })[1]

  local to_follow_position = w:get_component(to_follow, c_type.Position).data
  local camera_id          = w:query({ c_type.Camera })[1]

  if camera_id ~= nil then
    local camera_position = w:get_component(camera_id, c_type.Position).data
    local camera          = w:get_component(camera_id, c_type.Camera).data

    camera:lookAt(to_follow_position.x, to_follow_position.y)
    w:set_component(camera_id, c_type.Position, to_follow_position)
  end
end

return CameraFollow
