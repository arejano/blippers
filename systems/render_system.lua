-- local inspect = require 'libs.inspect'
local c_type = require 'models.component_types'
local events = require 'models.game_events'
local utils = require 'core.utils'
-- local resources = require 'models.resource_types'

-- local sti = require "libs.sti.sti"


---@class RenderSystem
local render_system = {
  data = {
    player = nil,
    map = nil,
    window_size = {
      width = 0,
      height = 0
    }
  },
  events = { events.Render }
}

function render_system:start(w)
  -- Init Map
  local width, height = utils.get_display_size();

  love.physics.setMeter(32)

  -- Prepare collision objects
  -- local map = sti('assets/first_map.lua', { "box2d" })

  -- local world = love.physics.newWorld(0, 0)
  -- self.data.map = map
  -- self.data.map:box2d_init(world)

  -- Init Camera
  local Camera = require 'libs.hump.camera'
  self.data.window_size = { width = width, height = height }
  local camera = Camera()

  w:add_entity({
    { type = c_type.Position, data = { x = width / 2, y = height / 2 } },
    { type = c_type.Camera,   data = camera }
  })
end

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


  local camera_id = world:query({ c_type.Camera })[1]
  local camera    = world:get_component(camera_id, c_type.Camera).data

  -- Camera
  camera:attach()
  -- local camera_position = world:get_component(camera_id, c_type.Position).data

  -- Map Render
  -- local map = world:get_resource(resources.MapRender)
  -- if map ~= nil then
  --   love.graphics.setColor(1, 1, 1)
  --   map:draw(-camera_position.x + self.data.window_size.width / 2,
  --     -camera_position.y + self.data.window_size.height / 2)
  -- end

  -- Entities Render
  local to_render = world:query({ c_type.Sprite, c_type.Animation })

  if to_render ~= nil then
    for _, v in ipairs(to_render) do
      local position = world:get_component(v, c_type.Position).data
      local animation = world:get_component(v, c_type.Animation).data

      if animation ~= nil and position ~= nil then
        animation.current_animation:update(dt)
        animation.current_animation:draw(self.data.sprite, position.x, position.y, nil, 2, 2, 0, nil)
      end
    end
  end

  -- Name Render
  local name_render = world:get_resource("NameRender")
  if name_render ~= nil then
    name_render:update(world, dt)
  end

  camera:detach()
end

return render_system
