-- require 'globals'

local Game = require 'game'
local ge = require "models.game_events"
local utils = require 'core.utils'


function love.load()
  love.window.setTitle("Blippers")
  local width, height, target = utils.get_display_size()

  -- Configura a janela em fullscreen no monitor desejado
  love.window.setMode(width, height, {
    fullscreen = true,
    display = target,
    -- resizable = true
  })

  GAME = Game:new()
end

local time = 0
local time_const = 1 / 60


function love.update(dt)
  require("libs.lovebird.lovebird").update()

  -- local nowFullscreen = love.window.getFullscreen()
  -- -- Detecta mudança de fullscreen
  -- if nowFullscreen ~= globals.fullscreen then
  --   globals.fullscreen = nowFullscreen
  --   local width, height = love.graphics.getDimensions()
  --   love.resize(width, height)
  -- end

  time = time + dt
  if time >= time_const then
    GAME:update(time_const)
    time = time - (time_const)
  end
end

function love.draw()
  GAME:draw()
end

function love.resize(w, h)
  GAME:add_event({
    type = ge.WindowResize,
    data = { width = w, height = h }
  })
end

function love.keypressed(key)
  GAME:add_event({
    type = ge.KeyboardInput,
    data = { key = key, isDown = true }
  })
end

function love.keyreleased(key)
  GAME:add_event({
    type = ge.KeyboardInput,
    data = { key = key, isDown = false }
  })
end

function love.mousepressed(x, y, button)
  -- print("mouse pressed", x, y)
  GAME.world:add_event({
    type = ge.Shot
  })
end

function love.mouserelease(x, y, button)
  print("mouse release", x, y)
end

function love.conf(t)
  t.console = true
end
