local c_type = require 'models.component_types'
local events = require 'models.game_events'

---@class NameRenderSystem
local NameRenderSystem = {
  watch = {
    -- [c_type.Player] = false,
  },
}

function NameRenderSystem:start(world)
  world:add_resource("render", self)
end

---@param world Ecs
function NameRenderSystem:update(world, _)
  local entities_with_name = world:new_query({ c_type.Name, c_type.Position })

  if entities_with_name ~= nil then
    for _, v in ipairs(entities_with_name) do
      local position = world:get_component(v, c_type.Position).data
      local name = world:get_component(v, c_type.Name).data
      local sprite_size = world:get_component(v, c_type.SpriteSize).data

      if position == nil or name == nil or sprite_size == nil then
        return
      end

      local x = position.x
      local y = position.y
      if position ~= nil and name ~= nil then
        if sprite_size ~= nil then
          if sprite_size.w ~= nil then
            x = x - sprite_size.w / 2
          end
        end

        love.graphics.setColor(0.8, 0.5, 0.8)
        love.graphics.rectangle("fill", x - 20, y - 18, #name * 10.5, 20)
        love.graphics.setColor(255, 255, 255)

        love.graphics.print(name, x - #name, y - 18)
      end
    end
  end
end

return NameRenderSystem
