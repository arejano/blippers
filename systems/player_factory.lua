local c_types = require 'models.component_types'
local utils = require 'core.utils'
local anim8 = require 'libs.anim8.anim8'

local Generators = require "core.generators"

local player_factory = {
	events = {},
	sprite_regions = {
		idle = { x = 57, y = 13, width = 20, height = 38 }
	},
	sprites_path = {
		player = 'assets/chrono.png'
	}
}

function player_factory:start(ecs)
	local width, height, _ = utils.get_display_size()
	local sprite = utils.removeColorBackgroundFromImage("assets/chrono.png", { 255, 0, 255 })

	local regions = {
		-- walking = {},
		-- running = {},
		-- stopped = {}
		idle = {
			duration = 0.2,
			frames = {
				{ x = 57, y = 11, width = 18, height = 38 },
				{ x = 77, y = 11, width = 18, height = 38 },
				{ x = 97, y = 11, width = 18, height = 38 }
			}
		},
		down = {
			duration = 0.2,
			frames = {
				{ x = 127, y = 13, width = 20, height = 38 },
				{ x = 147, y = 13, width = 20, height = 38 },
				{ x = 169, y = 13, width = 20, height = 38 },
				{ x = 191, y = 13, width = 20, height = 38 },
				{ x = 211, y = 13, width = 20, height = 38 },
				{ x = 232, y = 13, width = 20, height = 38 },
			}
		},
		right = {
			duration = 0.2,
			frames = {
				{ x = 124, y = 94, width = 22, height = 38 },
				{ x = 147, y = 94, width = 22, height = 38 },
				{ x = 169, y = 94, width = 22, height = 38 },
				{ x = 194, y = 94, width = 22, height = 38 },
				{ x = 216, y = 94, width = 22, height = 38 },
				{ x = 238, y = 94, width = 22, height = 38 },
			}
		},
		left = {
			duration = 0.2,
			flip = true,
			frames = {
				{ x = 124, y = 94, width = 22, height = 38 },
				{ x = 147, y = 94, width = 22, height = 38 },
				{ x = 169, y = 94, width = 22, height = 38 },
				{ x = 194, y = 94, width = 22, height = 38 },
				{ x = 216, y = 94, width = 22, height = 38 },
				{ x = 238, y = 94, width = 22, height = 38 },
			}
		},
		up = {
			duration = 0.2,
			frames = {
				{ x = 126, y = 57, width = 21, height = 38 },
				{ x = 148, y = 57, width = 21, height = 38 },
				{ x = 170, y = 57, width = 21, height = 38 },
				{ x = 191, y = 57, width = 21, height = 38 },
				{ x = 211, y = 57, width = 21, height = 38 },
				{ x = 232, y = 57, width = 21, height = 38 },
			}
		}
	}

	-- local animations = Generators.animations(regions, sprite)

	-- Create quads for each frame
	local function createQuads(region)
		local quads = {}
		for _, frame in ipairs(region) do
			table.insert(quads,
				love.graphics.newQuad(frame.x, frame.y, frame.width, frame.height, sprite:getWidth(),
					sprite:getHeight()))
		end
		return quads
	end

	local animations = {
		idle = anim8.newAnimation(createQuads(regions.idle.frames), 1),
		down = anim8.newAnimation(createQuads(regions.down.frames), 0.2),
		left = anim8.newAnimation(createQuads(regions.right.frames), 0.2):flipH(),
		right = anim8.newAnimation(createQuads(regions.right.frames), 0.2),
		up = anim8.newAnimation(createQuads(regions.up.frames), 0.2)
	}

	ecs:add_entity({
		{ type = c_types.Player,       data = true },
		{ type = c_types.InMovement,   data = false },
		{ type = c_types.Name,         data = "Richard Feyman" },
		{ type = c_types.CameraFollow, data = true },
		{ type = c_types.Position,     data = { x = width / 2, y = height / 2 } },
		{ type = c_types.Direction,    data = "up" },
		{ type = c_types.Speed,        data = 5 },
		{ type = c_types.SpriteSize,   data = { w = 20, h = 32 } },
		{ type = c_types.Sprite,       data = sprite },
		{
			type = c_types.Animation,
			data = {
				current_animation = animations.idle,
				animations = animations
			}
		}
	})
end

return player_factory
