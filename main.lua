local Game = require 'game'
local ge = require "models.game_events"
require 'globals'

function love.load()
  love.window.setTitle("Meu RPG 2D")


  local displays = love.window.getDisplayCount() -- Conta quantos monitores existem
  local targetDisplay = 2                        -- Altere esse valor para o monitor desejado (1, 2, ...)

  if targetDisplay > displays then
    targetDisplay = 1 -- Se o monitor não existir, usa o principal
  end

  -- Obtém informações do monitor alvo
  local width, height = love.window.getDesktopDimensions(targetDisplay)

  -- Configura a janela em fullscreen no monitor desejado
  love.window.setMode(width, height, {
    fullscreen = true,
    display = targetDisplay
  })

  game = Game:new()
end

local time = 0
local time_const = 1 / 60

function love.update(dt)
  time = time + dt
  if time >= time_const then
    game:update(time_const)
    time = time - (time_const)
  end
end

function love.draw()
  game:draw()
end

function love.resize(w, h)
  game:resize(w, h)
end

function love.keypressed(key)
  game:add_event({
    type = ge.KeyboardInput,
    data = { key = key, isDown = true }
  })
end

function love.keyreleased(key)
  game:add_event({
    type = ge.KeyboardInput,
    data = { key = key, isDown = false }
  })
end
