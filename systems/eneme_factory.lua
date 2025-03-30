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
  -- Player
  local player_sprite = utils.removeColorBackgroundFromImage("assets/chrono.png", { 255, 0, 255 })

  -- Define the regions for each animation
  local regions = {
    idle = {
      { x = 57, y = 13, width = 20, height = 38 },
      { x = 77, y = 13, width = 20, height = 38 },
      { x = 97, y = 13, width = 20, height = 38 }
    },
    down = {
      { x = 57, y = 13, width = 20, height = 38 },
      { x = 77, y = 13, width = 20, height = 38 },
      { x = 97, y = 13, width = 20, height = 38 }
    },
    left = {
      { x = 57, y = 53, width = 20, height = 38 },
      { x = 77, y = 53, width = 20, height = 38 }
    },
    right = {
      { x = 57, y = 93, width = 20, height = 38 },
      { x = 77, y = 93, width = 20, height = 38 }
    },
    up = {
      { x = 57, y = 133, width = 20, height = 38 },
      { x = 77, y = 133, width = 20, height = 38 }
    }
  }

  -- Create quads for each frame
  local function createQuads(region)
    local quads = {}
    for _, frame in ipairs(region) do
      table.insert(quads,
        love.graphics.newQuad(frame.x, frame.y, frame.width, frame.height, player_sprite:getWidth(),
          player_sprite:getHeight()))
    end
    return quads
  end

  local animations = {
    idle = anim8.newAnimation(createQuads(regions.idle), 1),
    down = anim8.newAnimation(createQuads(regions.idle), 1),
    left = anim8.newAnimation(createQuads(regions.left), 0.2),
    right = anim8.newAnimation(createQuads(regions.right), 0.2),
    up = anim8.newAnimation(createQuads(regions.up), 0.2)
  }

  local width, height, _ = utils.get_display_size()
  ecs:add_entity({
    { type = c_types.InMovement, data = false },
    { type = c_types.Name,       data = "Elon Musk" },
    { type = c_types.Enemy,      data = true },
    { type = c_types.Position,   data = { x = 10, y = height / 2 } },
    { type = c_types.Direction,  data = "up" },
    { type = c_types.Speed,      data = 5 },
    { type = c_types.Sprite,     data = player_sprite },
    { type = c_types.SpriteSize, data = { w = 20, h = 32 } },
    {
      type = c_types.Animation,
      data = {
        current_animation = animations.idle,
        animations = animations
      }
    }
  })

  ecs:add_entity({
    { type = c_types.InMovement, data = false },
    { type = c_types.Name,       data = "Francisquinho" },
    { type = c_types.Enemy,      data = true },
    { type = c_types.Position,   data = { x = 150, y = height / 2 } },
    { type = c_types.Direction,  data = "up" },
    { type = c_types.Speed,      data = 5 },
    { type = c_types.Sprite,     data = player_sprite },
    { type = c_types.SpriteSize, data = { w = 20, h = 32 } },
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
