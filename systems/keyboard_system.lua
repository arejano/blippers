local c_type = require 'models.component_types'
local events = require 'models.game_events'

local KeyboardSystem = {
  name = "keyboard_system",
  watch = {
    [c_type.Player] = true,
  },
  events = { events.KeyboardInput },
  keys = {
    ["f1"] = events.ChangeMap,
    ["f2"] = "left",
    ["f3"] = "down",
    ["f4"] = "right",
    ["space"] = events.Shot,
  },
  pressed_keys = {},
}

---@param event NewEvent
function KeyboardSystem:update(w, dt, event)
  if event.data == nil or not self.keys[event.data.key] then
    return
  end

  if event.data.isDown then
    w:add_event({
      type = self.keys[event.data.key]
    })
    -- self.pressed_keys[event.data.key] = true
    -- else
    -- self.pressed_keys[event.data.key] = nil
  end
end

return KeyboardSystem
