local c_type = require 'models.component_types'
local events = require 'models.game_events'
local inspect = require 'libs.inspect'


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
  local to_follow = w:new_query({ c_type.CameraFollow }, "camera_follow_system:CameraFollow")[1]

  if to_follow == nil then return end

  local to_follow_position = w:get_component(to_follow, c_type.Transform).data.position
  local camera_id          = w:new_query({ c_type.Camera }, "camera_follow_system:Camera")[1]

  if camera_id ~= nil then
    local camera_position = w:get_component(camera_id, c_type.Position).data
    local camera          = w:get_component(camera_id, c_type.Camera).data

    camera:lookAt(to_follow_position.x, to_follow_position.y)
    w:set_component(camera_id, c_type.Position, to_follow_position)
  end
end

return CameraFollow
