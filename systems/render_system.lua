local c_type = require 'game.enums.c_types'
local debug_ui = require 'game.ui.debug_components'

return {
    render = function(world)
        local dt = world.delta_time;
        local renderable = world:query({ c_type.Renderable })

        debug_ui:button(dt, 10, 10)
    end
}
