-- systems/isometric_render_system.lua

local inspect = require 'libs.inspect'
local c_type = require 'models.component_types'
local events = require 'models.game_events'
local utils = require 'core.utils'

---@class IsometricRenderSystem
local isometric_render_system = {
  name = "isometric_render_system",
}

local map = {}
for i = 1, 100 do
  local line = {}
  for j = 1, 100 do
    table.insert(line, 1)
  end
  table.insert(map, line)
end

local tileWidth = 64
local tileHeight = 32
local tileImage

function isometric_render_system:start(w)
  tileImage = love.graphics.newImage("assets/grass.png")
  w:add_resource("render", self)
end

---@param world Ecs
---@param dt integer
function isometric_render_system:update(world, dt, event)
  local screenWidth, screenHeight = love.graphics.getDimensions()

  -- Calcular o ponto central do mapa
  local mapWidth = #map[1]
  local mapHeight = #map
  local centerX = mapWidth / 2
  local centerY = mapHeight / 2

  -- Transformação isométrica para o ponto central do mapa
  local centerScreenX = (centerX - centerY) * tileWidth / 2
  local centerScreenY = (centerX + centerY) * tileHeight / 2

  -- Calcular os offsets para centralizar o mapa na tela
  local offsetX = screenWidth / 2 - centerScreenX
  local offsetY = screenHeight / 2 - centerScreenY

  -- Desenhar o mapa
  for y = 1, #map do
    for x = 1, #map[y] do
      local tile = map[y][x]
      if tile == 1 then
        -- Transformação das coordenadas do mapa para coordenadas da tela
        local screenX = (x - y) * tileWidth / 2 + offsetX
        local screenY = (x + y) * tileHeight / 2 + offsetY
        -- Desenhar o tile na posição transformada
        love.graphics.draw(tileImage, screenX, screenY)
      end
    end
  end
end

return isometric_render_system
