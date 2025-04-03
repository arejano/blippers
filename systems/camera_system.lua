local c_type = require 'models.component_types'
local events = require 'models.game_events'
local utils = require 'core.utils'

---@class CameraSystem
local CameraSystem = {
  data = {},
  events = { events.WindowResize }
}

---@param w Ecs
function CameraSystem:start(w)
end

---@param w Ecs
---@param dt number
---@param event NewEvent
function CameraSystem:update(w, dt, event)
  print("camera_system")
  if event.type == events.WindowResize then
    local camera_id = w:query({ c_type.Camera }, "camera_system")[1]
    local width, height = utils.get_display_size()

    if camera_id ~= nil then
      local scaleX  = event.data.width / width
      local scaleY  = event.data.height / height
      local newZoom = math.min(scaleX, scaleY) -- Mantém proporção correta

      local camera  = w:get_component(camera_id, c_type.Camera).data
      camera:zoomTo(newZoom)
      w.resize = w.resize + 1
    end
  end
end

return CameraSystem
