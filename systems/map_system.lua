local c_type = require 'models.component_types'
local inspect = require 'libs.inspect'
local events = require 'models.game_events'
local resources = require 'models.resource_types'
local utils = require 'core.utils'

local sti = require "libs.sti.sti"

---@class MapSystem
local MapSystem = {
  events = { events.Render },
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
    }
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
function MapSystem:update(world, dt)
  local width, height = utils.get_display_size();

  local camera_id = world:query({ c_type.Camera })[1]
  local camera_position = world:get_component(camera_id, c_type.Position).data

  if camera_position ~= nil then
    self.maps[self.current_map].map_handle:draw(
      -camera_position.x + width / 2,
      -camera_position.y + height / 2
    )
  end
end

function draw_debug(self)
  for k, v in pairs(self.maps) do
    love.graphics.print(inspect(v.size), 100, 100)
  end
end

return MapSystem
