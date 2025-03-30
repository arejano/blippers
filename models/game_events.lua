local utils = require 'core.utils'

---@enum GameEvents
local ge = utils.make_enum({
  "KeyboardInput",
  "MouseInput",
  "Render",
  "Tick",
})

return ge
