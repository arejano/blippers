local inspect = require 'libs.inspect'
local c_type = require 'game.enums.c_types'
local events = require 'game.enums.events'

return {
    events = { events.Mouse },
    process = function(world, dt)
        local query = world:query({ c_type.Velocity })
        local key = query[1] .. c_type.Velocity
        local velocity_data = world.components[key]
    end
}
