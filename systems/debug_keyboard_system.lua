local c_type = require 'game.enums.c_types'
local inspect = require 'libs.inspect'
local events = require 'game.enums.events'
local debug_ui = require 'game.ui.debug_components'

return {
  events = { events.Tick },
  start = function(w, _, _)
    w.debug_components = {}


    w.counters[events.Tick] = 0
    w.debug_components.items = { "Item 1", "Item 2", "Item 3", "Item 4", "Item 5" }
    w.debug_components.items_render = debug_ui:list_component(50, 50, 200, 30, w.debug_components.items)
  end,
  process = function(w, _, _)
    -- local line_size = 20
    
    love.graphics.print(inspect(w.systems),50,50)
    -- love.graphics.print("player_input" .. w.counter.player_input, 10, 10)

    -- w.debug_components.items_render:draw()

    -- w.counters[events.Tick] = w.counters[events.Tick] + 1


    -- for k, i in ipairs(w.counters) do
    -- love.graphics.print(k .. " - " .. i, 5, 20)
    -- end
  end
}
