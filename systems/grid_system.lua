-- systems/isometric_grid_system.lua

local c_type = require 'models.component_types'
local events = require 'models.game_events'
local utils = require 'core.utils'

---@class IsometricGridSystem
local isometric_grid_system = {
  name = "isometric_grid_system",
}

local tileWidth = 64
local tileHeight = 32

function isometric_grid_system:start(w)
  w:add_resource("render", self)
end

---@param world Ecs
---@param dt integer
function isometric_grid_system:update(world, dt, event)
  local player_id = world:new_query({ c_type.Player }, "isometric_grid_system_player")[1]
  if not player_id then return end

  local player_transform = world:get_component(player_id, c_type.Transform).data
  local player_x = player_transform.position.x
  local player_y = player_transform.position.y

  -- Calcular o ponto central da tela
  local screenWidth, screenHeight = love.graphics.getDimensions()
  local centerX = screenWidth / 4
  local centerY = screenHeight / 4

  -- Transformação isométrica para a posição do jogador
  local playerScreenX = (player_x - player_y) * tileWidth / 2 + centerX
  local playerScreenY = (player_x + player_y) * tileHeight / 2 + centerY

  -- Desenhar o grid ao redor do jogador
  local gridSize = 15                  -- Tamanho do grid ao redor do jogador
  love.graphics.setColor(1, 1, 1, 0.5) -- Cor branca com transparência

  for i = -gridSize, gridSize do
    for j = -gridSize, gridSize do
      local screenX = (player_x + i - (player_y + j)) * tileWidth / 2 + centerX
      local screenY = (player_x + i + (player_y + j)) * tileHeight / 2 + centerY

      -- Desenhar linhas horizontais
      love.graphics.line(screenX, screenY, screenX + tileWidth / 2, screenY + tileHeight / 2)
      love.graphics.line(screenX, screenY, screenX - tileWidth / 2, screenY + tileHeight / 2)

      -- Desenhar linhas verticais
      love.graphics.line(screenX, screenY, screenX + tileWidth / 2, screenY - tileHeight / 2)
      love.graphics.line(screenX, screenY, screenX - tileWidth / 2, screenY - tileHeight / 2)
    end
  end

  love.graphics.setColor(1, 1, 1, 1) -- Resetar a cor para branco
end

return isometric_grid_system
