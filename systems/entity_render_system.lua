local inspect = require 'libs.inspect'
local c_type = require 'models.component_types'
local events = require 'models.game_events'
local utils = require 'core.utils'

---@class IsometricRenderSystem
local entity_render_system = {
  name = "entity_render_system",
  watch = {
    [c_type.Position] = true,
    [c_type.Sprite] = true
  },
}

local tileWidth = 64
local tileHeight = 32

function entity_render_system:start(w)
  w:add_resource("render", self)
end

---@param world Ecs
---@param dt integer
function entity_render_system:update(world, dt, event)
  -- Entities With Animation -  Render
  local to_render = world:new_query({ c_type.Render }, "to_render")

  if to_render ~= nil then
    for _, v in ipairs(to_render) do
      local transform = world:get_component(v, c_type.Transform).data
      local animation = world:get_component(v, c_type.Animation).data
      local sprite = world:get_component(v, c_type.Sprite).data

      local screenX = (transform.position.x - transform.position.y) * tileWidth / 2
      local screenY = (transform.position.x + transform.position.y) * tileHeight / 2


      if animation ~= nil then
        if animation.current_animation ~= nil then
          animation.current_animation:update(dt)
          animation.current_animation:draw(
          --image
            sprite,
            -- x
            --transform.position.x,
            screenX,
            -- y
            --transform.position.y,
            screenY,
            -- angke
            nil,
            -- sx
            transform.scale.sx,
            --sy
            transform.scale.sy,
            -- ox
            transform.rotation.ox,
            --ox
            transform.rotation.oy,
            --kx
            nil,
            --ky
            nil
          )
        end
      else
        if sprite == nil or transform == nil then return end

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
end

return entity_render_system
