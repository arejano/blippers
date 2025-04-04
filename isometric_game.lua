local map = {
  { 1, 1, 1, 1 },
  { 1, 0, 0, 1 },
  { 1, 0, 0, 1 },
  { 1, 1, 1, 1 }
}

local tileWidth = 64
local tileHeight = 32
local tileImage
local player = { x = 2, y = 2 }

function love.load()
  tileImage = love.graphics.newImage("grass.png")
end

function love.update(dt)
  -- Atualizar lógica do jogo (se necessário)
end

function love.draw()
  -- Desenhar o mapa
  for y = 1, #map do
    for x = 1, #map[y] do
      local tile = map[y][x]
      if tile == 1 then
        -- Transformação das coordenadas do mapa para coordenadas da tela
        local screenX = (x - y) * tileWidth / 2
        local screenY = (x + y) * tileHeight / 2
        -- Desenhar o tile na posição transformada
        love.graphics.draw(tileImage, screenX, screenY)
      end
    end
  end

  -- Transformação das coordenadas do personagem
  local playerScreenX = (player.x - player.y) * tileWidth / 2
  local playerScreenY = (player.x + player.y) * tileHeight / 2
  -- Desenhar o personagem na posição transformada
  love.graphics.circle("fill", playerScreenX + tileWidth / 2, playerScreenY + tileHeight / 2, 10)
end

function love.keypressed(key)
  if key == "up" then
    player.y = player.y - 1
  elseif key == "down" then
    player.y = player.y + 1
  elseif key == "left" then
    player.x = player.x - 1
  elseif key == "right" then
    player.x = player.x + 1
  end
end
