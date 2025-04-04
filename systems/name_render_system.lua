local c_type = require 'models.component_types'
local events = require 'models.game_events'


local tileWidth = 64
local tileHeight = 32

---@class NameRenderSystem
local NameRenderSystem = {
  name = "name_render_system"
}

function NameRenderSystem:start(world)
  world:add_resource("render", self)
end

---@param world Ecs
function NameRenderSystem:update(world, _)
  local entities_with_name = world:new_query({ c_type.Name, c_type.Transform })

  if entities_with_name ~= nil then
    for _, v in ipairs(entities_with_name) do
      local transform = world:get_component(v, c_type.Transform).data
      local name = world:get_component(v, c_type.Name).data

      if transform == nil then return end

      local x = transform.position.x
      local y = transform.position.y

      local screenX = (transform.position.x - transform.position.y) * tileWidth / 2
      local screenY = (transform.position.x + transform.position.y) * tileHeight / 2

      if transform.position ~= nil and name ~= nil then
        -- if transform.size ~= nil then
        --   if transform.size.width ~= nil then
        --     x = x - transform.size.width / 2
        --   end
        -- end

        love.graphics.setColor(0.8, 0.5, 0.8)
        love.graphics.rectangle("fill", screenX, screenY - 22, 7 * #name, 20)
        love.graphics.setColor(255, 255, 255)
        love.graphics.print(name, screenX, screenY - 18)
      end
    end
  end
end

return NameRenderSystem
