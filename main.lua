local Game = require 'game'
local ge = require "models.game_events"
local utils = require 'core.utils'
require 'globals'

function love.load()
  love.window.setTitle("Meu RPG 2D")

  local width, height, target = utils.get_display_size()

  -- Configura a janela em fullscreen no monitor desejado
  love.window.setMode(width, height, {
    -- fullscreen = true,
    display = target
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
