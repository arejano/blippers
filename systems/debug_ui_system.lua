local c_type = require 'models.component_types'
local inspect = require 'libs.inspect'
local events = require 'models.game_events'
local utils = require 'core.utils'

---@class CameraSystem
local DebugUiSystem = {
  data = {},
  events = {}
}

---@param w Ecs
function DebugUiSystem:start(w)
  w:add_resource("render", self)
end

---@param w Ecs
---@param dt number
---@param event NewEvent
function DebugUiSystem:update(w, dt, event)
  local to_render = w:merge_query(
    { c_type.Render, c_type.Player },
    { c_type.Render, c_type.Bullet }
  )

  if to_render ~= nil then
    for i, v in ipairs(to_render) do
      local transform = w:get_component(v, c_type.Transform).data

      if transform == nil then return end

      -- love.graphics.setColor(255, 0, 255)
      love.graphics.rectangle("line", transform.position.x, transform.position.y, transform.size.width,
        transform.size.height)
    end
  end
end

return DebugUiSystem
