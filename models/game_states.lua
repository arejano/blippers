local utils = require 'core.utils'

---@enum GameState
local game_states = utils.make_enum({
  "Starting",
  "Running",
  "Paused",
  "Menu",
})

return game_states
