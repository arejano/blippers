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
  "InMovement",
  "Camera",
  "CameraFollow",
  "MapSTI",
  "Name",
  "Enemy",
  "SpriteSize"

})

return ctypes
