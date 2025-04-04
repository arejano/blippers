-- systems/isometric_shadow_system.lua

local c_type = require 'models.component_types'
local inspect = require 'libs.inspect'
local events = require 'models.game_events'
local utils = require 'core.utils'

---@class IsometricShadowSystem
local isometric_shadow_system = {
  name = "isometric_shadow_system",
}

local tileWidth = 64
local tileHeight = 32

function isometric_shadow_system:start(w)
  w:add_resource("render", self)
end

---@param world Ecs
---@param dt integer
function isometric_shadow_system:update(world, dt, event)
  local camera_id = world:new_query({ c_type.Camera }, "isometric_shadow_system_camera")[1]
  local camera = world:get_component(camera_id, c_type.Camera).data

  -- Entities With Position and Sprite - Render Shadows
  local to_render = world:new_query({ c_type.Transform, c_type.Sprite }, "to_render")

  if to_render ~= nil then
    for _, v in ipairs(to_render) do
      local transform = world:get_component(v, c_type.Transform).data

      if transform == nil then return end

      local screenX = (transform.position.x - transform.position.y) * tileWidth / 2
      local screenY = (transform.position.x + transform.position.y) * tileHeight / 2

      love.graphics.setColor(255, 255, 255, 0.2) -- Cor preta com transparência

      love.graphics.push()
      love.graphics.translate(screenX + tileWidth / 2, screenY + tileHeight / 2)
      love.graphics.rotate(math.rad(45)) -- Rotacionar a elipse em 45 graus
      love.graphics.ellipse("fill", 0, 0, transform.size.width / 2, transform.size.height / 4)
      love.graphics.pop()

      love.graphics.setColor(255, 255, 255)
    end
  end
end

return isometric_shadow_system
