local anim8 = require 'libs.anim8.anim8'

---@class Generators
local Generator = {}

function Generator.animations(regions, sprite)
  local animation_keys = {}
  for k, v in pairs(regions) do
    table.insert(animation_keys, v)
  end

  local animations = {}

  for index, value in ipairs(animation_keys) do
    local quads = createQuads(regions[value].frame, sprite)
    if regions[value].flip ~= nil then
      animations[value] = anim8.newAnimation(quads, regions[value].duration):flipH()
    else
      animations[value] = anim8.newAnimation(quads, regions[value].duration):flipH()
    end
  end
end

-- Create quads for each frame
function createQuads(region, sprite)
  local quads = {}
  for _, frame in ipairs(region) do
    table.insert(quads,
      love.graphics.newQuad(frame.x, frame.y, frame.width, frame.height, sprite:getWidth(),
        sprite:getHeight()))
  end
  return quads
end

return Generator
