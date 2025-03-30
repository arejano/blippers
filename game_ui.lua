local Quadtree = require 'core.quadtree'
local game_states = require 'models.game_states'
local lv = love

---@class GameUI
---@field ui_states any[]
---@field debug_components any[]
---@field window_size WindowSize
local GameUI = {}
GameUI.__index = GameUI

function GameUI:new()
  local ui = {
    debug_components = {},
    ui_states = {
      [game_states.Starting] = {
        button = {
          x = 1000,
          y = 10,
          height = 40,
          width = 150,
          label = globals.buttons_label.new_game,
          text_color = globals.text_color
        },
        -- exit_button = {
        --   x = 400,
        --   y = 10,
        --   height = 40,
        --   width = 150,
        --   label = globals.buttons_label.exit,
        --   text_color = globals.text_color
        -- }

      }
    }
  }

  setmetatable(ui, GameUI)
  return ui
end

function GameUI:start()
  self.qt = Quadtree:new(0, { x = 0, y = 0, width = 800, height = 600 })
end

---@param ws WindowSize
function GameUI:resize(ws)
  self.window_size = ws
end

---@param game_state number
function GameUI:draw(game_state)
  if #self.ui_states ~= 0 then
    for _, button in pairs(self.ui_states[game_state]) do
      draw_primary_button(button)
    end
  end

  if #self.debug_components ~= 0 then
    for _, component in pairs(self.debug_components) do
      component:draw()
    end
  end
end

function draw_primary_button(button)
  love.graphics.setColor(0.8, 0.5, 0.8)
  lv.graphics.rectangle("fill", button.x, button.y, button.width, button.height)
  lv.graphics.setColor(button.text_color[1], button.text_color[2], button.text_color[3]) -- Cor do texto

  local font = lv.graphics.getFont()
  local tw, th = font:getWidth(button.label), font:getHeight(button.label)

  lv.graphics.print(button.label, button.x + (button.width - tw) / 2,
    button.y + (button.height - th) / 2)
end

return GameUI
