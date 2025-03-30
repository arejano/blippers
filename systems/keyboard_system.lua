local inspect = require 'libs.inspect'
local c_type = require 'game.enums.c_types'
local events = require 'game.enums.events'

return {
    events = { events.Keyboard },
    process = function(world, dt)
    
        world.counter.keyboard_system = world.counter.keyboard_system + 1;
    
        local player = world:query({ c_type.Player })[1]
        local enemy = world:query({ c_type.Enemy })[1]

        local player_position = world:get_component(player, c_type.Position)
        local enemy_position = world:get_component(enemy, c_type.Position)

        if not player_position or not enemy_position then
            return
        end

        world:set_component(player, c_type.Position, {
            x = player_position.x + 1,
            y = player_position.y + 1,
            z = player_position.z
        })

        world:set_component(enemy, c_type.Position, {
            x = enemy_position.x + 1,
            y = enemy_position.y + 1,
            z = enemy_position.z
        })
    end
}
