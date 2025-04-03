local utils = require 'core.utils'

---@enum ComponentTypes
local ctypes = utils.make_enum({
  "Position",
  "Render",
  "Transform",
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
  "SpriteSize",
  "Bullet",
  "LifeTime",
})

return ctypes
