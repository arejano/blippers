local c_type = require 'models.component_types'
local inspect = require 'libs.inspect'
local events = require 'models.game_events'
local resources = require 'models.resource_types'
local utils = require 'core.utils'

local sti = require "libs.sti.sti"

---@class MapSystem
local MapSystem = {
  name = "map_system",
  events = { events.Render, events.ChangeMap },
  current_map = nil,
  maps_name = {},
  maps = {
    starter = {
      map_handle = nil,
      path = "assets/first_map.lua",
      size = {
        width = nil,
        height = nil,
      }
    },
    -- small = {
    --   map_handle = nil,
    --   path = "assets/second_map.lua",
    --   size = {
    --     width = nil,
    --     height = nil,
    --   }
    -- }
  }
}

---@param w Ecs
function MapSystem:start(w)
  for k, v in pairs(self.maps) do
    table.insert(self.maps_name, k)
    self.maps[k].map_handle = sti(v.path)
    self.maps[k].size.width = self.maps[k].map_handle.tilesets[1].imagewidth
    self.maps[k].size.width = self.maps[k].map_handle.tilesets[1].imageheight
  end

  self.current_map = self.maps_name[1]

  -- w:add_resource(resources.MapRender, map_sti)
end

---@param w Ecs
---@param dt integer
---@param event NewEvent
function MapSystem:update(world, dt, event)
  -- if event.type == events.ChangeMap then
  --   print("ChangeMap")

  --   if self.current_map == "starter" then
  --     self.current_map = "small"
  --   else
  --     self.current_map = "starter"
  --   end
  -- end


  local camera_id = world:new_query({ c_type.Camera }, "map_system")[1]

  if camera_id == nil then
    local w, h = utils.get_display_size()
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("fill", w / 2, h / 2, 200, 40)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("LOG:MapSystem::camera_id == nil - Valide a Entidade:Camera ou ECS:query()")
    return
  end


  local camera_position = world:get_component(camera_id, c_type.Position).data

  local width, height = utils.get_display_size()

  if camera_position ~= nil then
    self.maps[self.current_map].map_handle:draw(
      -camera_position.x + width / 2,
      -camera_position.y + height / 2
    )
  end
end

return MapSystem
