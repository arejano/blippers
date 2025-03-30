local inspect = require 'libs.inspect'
local c_type = require 'models.component_types'
local events = require 'models.game_events'

---@class PlayerInputSystem
local player_input_system = {
	data = { player = nil },
	events = { events.KeyboardInput, events.Tick },
	player_keys = {
		["w"] = "up",
		["a"] = "left",
		["s"] = "down",
		["d"] = "right",
	},
	pressed_keys = {},

	animations_direction = {
		["up"] = "up",
		["left"] = "left",
		["down"] = "idle",
		["right"] = "right",
	},
}

---@param w Ecs
---@param dt integer
---@param e NewEvent
function player_input_system:update(w, dt, e)
	if e.data == nil or not self.player_keys[e.data.key] then
		return
	end

	-- Player
	if not self.data.player then
		self.data.player = w:query({ c_type.Player })[1]
	end

	if e.data.isDown then
		self.pressed_keys[e.data.key] = true
	else
		self.pressed_keys[e.data.key] = nil
	end

	local directions = {}
	for key, direction in pairs(self.player_keys) do
		if self.pressed_keys[key] then
			table.insert(directions, direction)
		end
	end



	w:set_component(self.data.player, c_type.Direction, directions)
	w:set_component(self.data.player, c_type.InMovement, #directions > 0)
	if #directions > 0 then
		local animation = w:get_component(self.data.player, c_type.Animation).data
		animation.current_animation = animation.animations[self.animations_direction[directions[1]]]
	end
end

return player_input_system
