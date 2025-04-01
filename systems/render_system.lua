local inspect = require 'libs.inspect'
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
  local camera = Camera()

  w:add_entity({
    { type = c_type.Position, data = { x = width / 2, y = height / 2 } },
    { type = c_type.Camera,   data = camera }
  })
end

---@param world Ecs
---@param dt integer
function render_system:update(world, dt, event)
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

  -- Entities With Animation -  Render
  local to_render = world:query({ c_type.Render })

  if to_render ~= nil then
    for _, v in ipairs(to_render) do
      local position = world:get_component(v, c_type.Position).data
      local animation = world:get_component(v, c_type.Animation).data
      local sprite = world:get_component(v, c_type.Sprite).data

      if animation ~= nil then
        if animation.current_animation ~= nil then
          animation.current_animation:update(dt)
          animation.current_animation:draw(sprite, position.x, position.y, nil, 2, 2, 0, nil)
        end
      else
        love.graphics.draw(sprite, position.x, position.y)
      end
    end
  end

  -- Simple Entities
  -- local simple_to_render = world:query({ c_type.Bullet })
  -- if simple_to_render ~= nil then
  --   for _, v in ipairs(simple_to_render) do
  --     local position = world:get_component(v, c_type.Position).data
  --     local bullet = world:get_component(v, c_type.Bullet).data
  --     local sprite = world:get_component(v, c_type.BulletSprite).data

  --     if position ~= nil and bullet ~= nil then
  --       love.graphics.draw(sprite, position.x, position.y)
  --     end
  --   end
  -- end

  -- Name Render
  local name_render = world:get_resource("NameRender")
  if name_render ~= nil then
    name_render:update(world, dt)
  end

  camera:detach()

  love.graphics.print(1 / world.delta_time, 10, 10);
  love.graphics.print("Entidades: " .. #world.entities, 10, 20);
end

return render_system
