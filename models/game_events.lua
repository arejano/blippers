local utils = require 'core.utils'

---@enum GameEvents
local ge = utils.make_enum({
  "Render",
  "KeyboardInput",
  "MouseInput",
  "Tick",
  "WindowResize",
  "ChangeMap",
  "Shot"
})

return ge
