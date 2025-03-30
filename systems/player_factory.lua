local c_types = require 'models.component_types'
local anim8 = require 'libs.anim8.anim8'

local player_factory = {
	events = {},
}

function player_factory:start(ecs)
	-- Player
	local player_sprite = love.graphics.newImage('assets/1_pink_monster/idle.png')
	local player_grid = anim8.newGrid(32, 32, player_sprite:getWidth(), player_sprite:getHeight())

	local player_animations = {
		idle = anim8.newAnimation(player_grid('1-4', 1), 0.2),
		-- left = anim8.newAnimation(player_grid('1-4', 2), 0.2),
		-- right = anim8.newAnimation(player_grid('1-4', 3), 0.2),
		-- up = anim8.newAnimation(player_grid('1-4', 4), 0.2),
	}
	ecs:add_entity({
		{ type = c_types.Player,     data = true },
		{ type = c_types.InMovement, data = false},
		{ type = c_types.Position,   data = { x = 100, y = 100 } },
		{ type = c_types.Direction,  data = "up" },
		{ type = c_types.Speed,      data = 5 },
		{ type = c_types.Sprite,     data = player_sprite },
		{ type = c_types.Grid,       data = player_grid },
		{
			type = c_types.Animation,
			data = {
				current_animation = player_animations.idle,
				animations = player_animations
			}
		}
	})
end

return player_factory
