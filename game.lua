local ECS = require "core.ecs"
local game_states = require 'models.game_states'
local GameUI = require 'game_ui'
local ge = require "models.game_events"

local p_factory = require 'systems.player_factory'
local player_render_system = require 'systems.player_render_system'
local player_input_system = require 'systems.player_input_system'
local player_movement_system = require 'systems.player_movement_system'

local debug_system = require 'systems.debug_system'

---@class Game
---@field world Ecs
---@field game_state number
---@field game_ui GameUI
local Game = {
  game_state = game_states.Starting,
  delta_time = 0,

  game_ui = {},

  world = {},
}
Game.__index = Game

function Game:new()
  local game = {
    game_ui = GameUI:new(),
    world = ECS:new()
  }

  game.world:add_system(debug_system)
  game.world:add_system(p_factory)
  game.world:add_system(player_render_system)
  game.world:add_system(player_input_system)
  game.world:add_system(player_movement_system)

  setmetatable(game, Game)
  return game
end

---@param dt number
function Game:update(dt)
  self.world:add_event({
    type = ge.Tick
  })
  self.delta_time = dt
  self.world:update(dt)
end

---@param state number
function Game:setState(state)
  self.game_state = state
end

---@param event NewEvent
function Game:add_event(event)
  self.world:add_event(event)
end

function Game:draw()
  self.world:run_system_by_event(ge.Render)
  self.game_ui:draw(self.game_state)
end

---@param w number
---@param h number
function Game:resize(w, h)
  ---@type WindowSize
  local window_size = {
    width = w,
    height = h
  }
  -- self.game_ui:resize(window_size)
end

return Game
