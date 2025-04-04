local ECS = require "core.ecs"
local game_states = require 'models.game_states'
local ge = require "models.game_events"

local p_factory = require 'systems.player_factory'
local render_system = require 'systems.render_system'
local player_input_system = require 'systems.player_input_system'
local player_movement_system = require 'systems.player_movement_system'
local camera_follow_system = require 'systems.camera_follow_system'
local name_render_system = require 'systems.name_render_system'
local camera_system = require 'systems.camera_system'


local map_system = require "systems.map_system"

local debug_system = require 'systems.debug_system'

local keyboard_system = require 'systems.keyboard_system'


local bullet_system = require 'systems.bullet_system'

---@class Game
---@field world Ecs | nil
---@field game_state number
local Game = {
  game_state = game_states.Starting,
  dt = 0,
  world = nil,
}
Game.__index = Game

function Game:new()
  local game = {
    world = ECS:new()
  }

  game.world:add_system(p_factory)
  game.world:add_system(player_movement_system)
  game.world:add_system(camera_follow_system)
  game.world:add_system(camera_system)
  -- game.world:add_system(map_system)
  game.world:add_system(require "systems.eneme_factory")
  game.world:add_system(player_input_system)
  game.world:add_system(keyboard_system)


  -- game.world:add_system(bullet_system)
  -- game.world:add_system(require 'systems.bullet_movement_system')

  --Render
  game.world:add_system(render_system)
  game.world:add_system(require 'systems.isometric_render_system')
  game.world:add_system(require 'systems.isometric_shadow_system')
  game.world:add_system(require 'systems.grid_system')
  game.world:add_system(require 'systems.entity_render_system')
  game.world:add_system(require 'systems.name_render_system')
  game.world:add_system(require 'systems.debug_ui_system')


  -- Debug UI

  game.world:start()
  setmetatable(game, Game)

  return game
end

---@param dt number
function Game:update(dt)
  self.dt = dt
  if self.world ~= nil then
    if #self.world.systems == 0 then return end

    self.world:add_event({
      type = ge.Tick
    })
    self.world:update(dt)
  end
end

---@param state number
function Game:setState(state)
  self.game_state = state
end

---@param event NewEvent
function Game:add_event(event)
  if self.world ~= nil then
    self.world:add_event(event)
  end
end

function Game:draw()
  if self.world ~= nil then
    self.world:add_event({ type = ge.Render })
    self.world:update(self.dt)
  end
end

---@param w number
---@param h number
function Game:resize(w, h)
  ---@type WindowSize
  -- local window_size = {
  --   width = w,
  --   height = h
  -- }
  -- self.game_ui:resize(window_size)
end

return Game
