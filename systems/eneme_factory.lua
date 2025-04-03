local c_types = require 'models.component_types'
local utils = require 'core.utils'
local anim8 = require 'libs.anim8.anim8'

local enemy_factory = {
  events = {},
  sprite_regions = {
    idle = { x = 57, y = 13, width = 20, height = 38 }
  },
  sprites_path = {
    player = 'assets/chrono.png'
  }
}

function enemy_factory:start(ecs)
  local width, height, _ = utils.get_display_size()
  local sprite = utils.removeColorBackgroundFromImage("assets/chrono.png", { 255, 0, 255 })

  local regions = {
    idle = {
      { x = 57, y = 11, width = 18, height = 38 },
      { x = 77, y = 11, width = 18, height = 38 },
      { x = 97, y = 11, width = 18, height = 38 }
    },
    down = {
      { x = 127, y = 13, width = 20, height = 38 },
      { x = 147, y = 13, width = 20, height = 38 },
      { x = 169, y = 13, width = 20, height = 38 },
      { x = 191, y = 13, width = 20, height = 38 },
      { x = 211, y = 13, width = 20, height = 38 },
      { x = 232, y = 13, width = 20, height = 38 },
    },
    right = {
      { x = 124, y = 94, width = 22, height = 38 },
      { x = 147, y = 94, width = 22, height = 38 },
      { x = 169, y = 94, width = 22, height = 38 },
      { x = 194, y = 94, width = 22, height = 38 },
      { x = 216, y = 94, width = 22, height = 38 },
      { x = 238, y = 94, width = 22, height = 38 },
    },
    up = {
      { x = 126, y = 57, width = 21, height = 38 },
      { x = 148, y = 57, width = 21, height = 38 },
      { x = 170, y = 57, width = 21, height = 38 },
      { x = 191, y = 57, width = 21, height = 38 },
      { x = 211, y = 57, width = 21, height = 38 },
      { x = 232, y = 57, width = 21, height = 38 },
    }
  }

  local animations = {
    idle = anim8.newAnimation(utils.createQuads(regions.idle, sprite), 1),
    down = anim8.newAnimation(utils.createQuads(regions.down, sprite), 0.2),
    left = anim8.newAnimation(utils.createQuads(regions.right, sprite), 0.2):flipH(),
    right = anim8.newAnimation(utils.createQuads(regions.right, sprite), 0.2),
    up = anim8.newAnimation(utils.createQuads(regions.up, sprite), 0.2)
  }


  ecs:add_entity({
    { type = c_types.InMovement, data = false },
    { type = c_types.Name,       data = "Elon Musk" },
    { type = c_types.Enemy,      data = true },
    { type = c_types.Render,     data = true },
    { type = c_types.Direction,  data = "up" },
    { type = c_types.Speed,      data = 5 },

    {
      type = c_types.Transform,
      data = {
        position = { x = width - width / 3, y = height / 1.5 },
        scale = { sx = 2, sy = 2 },
        angle = 0,
        rotation = { ox = 0, oy = 0 },
        size = {
          width = 38,
          height = 76
        }
      }
    },
    { type = c_types.Sprite, data = sprite },
    {
      type = c_types.Animation,
      data = {
        current_animation = animations.idle,
        animations = animations
      }
    }
  })
end

return enemy_factory
