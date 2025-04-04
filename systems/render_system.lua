local inspect = require 'libs.inspect'
local c_type = require 'models.component_types'
local events = require 'models.game_events'
local utils = require 'core.utils'
-- local resources = require 'models.resource_types'

-- local sti = require "libs.sti.sti"


---@class RenderSystem
local render_system = {
  name = "render_system",
  watch = {
    [c_type.Animation] = true,
    [c_type.Sprite] = true
  },
  data = {
    player = nil,
    map = nil,
  },
  events = { events.Render }
}

function render_system:start(w)
  local width, height = utils.get_display_size();

  love.physics.setMeter(32)

  -- Init Camera
  local Camera = require 'libs.hump.camera'
  local camera = Camera()

  w:add_entity({
    { type = c_type.Transform, data = { position = { x = width / 2, y = height / 2 } } },
    { type = c_type.Camera,    data = camera }
  })
end

---@param world Ecs
---@param dt integer
function render_system:update(world, dt, event)
  if self.data.camera_id == nil then
    self.data.camera_id = world:new_query({ c_type.Camera }, "render_system_camera")[1]
  end

  local camera = world:get_component(self.data.camera_id, c_type.Camera).data

  -- Camera
  camera:attach()

  local render = world:get_resource("render")

  for i, v in ipairs(render) do
    -- print(i .. " - " .. v.name)
    v:update(world, dt)
  end

  camera:detach()

  love.graphics.print("FPS: " .. 1 / world.delta_time, 10, 10);
  love.graphics.print("Entidades: " .. #world.entities, 10, 30);
  -- love.graphics.print("resources: " .. inspect(world.resources), 10, 50);
end

return render_system
