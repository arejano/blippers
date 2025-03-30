require 'globals'

local Game = require 'game'
local ge = require "models.game_events"
local utils = require 'core.utils'
local LoveProfiler = require 'loveprofiler'


function love.load()
  love.window.setTitle("Meu RPG 2D")

  profiler = LoveProfiler:new { config = {
    driver = "console",
    font_size = 17,
    draw_x = 400,
    color = { 0, 0, 1, 1 }
  } }
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
  require("libs.lovebird.lovebird").update()
  time = time + dt
  if time >= time_const then
    game:update(time_const)
    time = time - (time_const)
  end
end

function love.draw()
  profiler:start()
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
