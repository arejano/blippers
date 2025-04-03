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
  -- if not self.data.player then
  --   self.data.player = world:query({ c_type.Player }, "render_system_player")[1]
  -- end

  -- if self.data.player == nil then return end

  -- if not self.data.sprite then
  -- self.data.sprite = world:get_component(self.data.player, c_type.Sprite).data
  -- end

  if self.data.camera_id == nil then
    self.data.camera_id = world:new_query({ c_type.Camera }, "render_system_camera")[1]
  end

  if self.data.camera_id == nil then
    local w, h = utils.get_display_size()
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("fill", w / 2, h / 2, 500, 40)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("LOG:MapSystem::camera_id == nil - Valide a Entidade:Camera ou ECS:query()", w / 2, h / 2)
    return
  end

  local camera = world:get_component(self.data.camera_id, c_type.Camera).data

  -- Camera
  camera:attach()

  -- Entities With Animation -  Render
  local to_render = world:new_query({ c_type.Render }, "to_render")

  if to_render ~= nil then
    for _, v in ipairs(to_render) do
      local transform = world:get_component(v, c_type.Transform).data
      local animation = world:get_component(v, c_type.Animation).data
      local sprite = world:get_component(v, c_type.Sprite).data

      if animation ~= nil then
        if animation.current_animation ~= nil then
          animation.current_animation:update(dt)
          animation.current_animation:draw(
          --image
            sprite,
            -- x
            transform.position.x,
            -- y
            transform.position.y,
            -- angke
            nil,
            -- sx
            2,
            --sy
            2,
            -- ox
            0,
            --ox
            nil,
            --kx
            nil,
            --ky
            nil
          )
        end
      else
        love.graphics.draw(
        --image
          sprite,
          -- x
          transform.position.x,
          --y
          transform.position.y,
          -- r
          transform.rotation.ox,
          -- sx
          2,
          --sy
          2,
          -- ox
          0,
          --ox
          nil
        )
      end
    end
  end

  -- -- Name Render
  -- local name_render = world:get_resource("NameRender")
  -- if name_render ~= nil then
  --   name_render:update(world, dt)
  -- end

  local render = world:get_resource("render")

  for i, v in ipairs(render) do
    v:update(world, dt)
  end

  camera:detach()

  love.graphics.print(1 / world.delta_time, 10, 10);
  love.graphics.print("Entidades: " .. #world.entities, 10, 30);
  love.graphics.print("resources: " .. inspect(world.resources), 10, 50);
end

return render_system
