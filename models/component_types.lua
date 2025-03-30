local utils = require 'core.utils'

---@enum ComponentTypes
local ctypes = utils.make_enum({
  "Position",
  "Player",
  "Speed",
  "Sprite",
  "Animation",
  "Grid",
  "Direction",
  "InMovement"

})

return ctypes
