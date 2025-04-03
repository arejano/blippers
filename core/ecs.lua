local utils = require 'core.utils'
local inspect = require 'libs.inspect'


---@class Array<T>: { [integer]: T }

local C_COUNTER = 0

---@class Ecs
---@field game_modes any[]
---@field game_events any[]
---@field entitites number[]
---@field entity_by_c_type = number[]
local ECS = {
  last_entity = 1,
  state = "Starting",
  resize = 0,
  game_modes = {},
  game_events = {},
  last_key = "nil",
  player_direction = "up",

  entities = {},
  -- lista de entidades que cada component_type possui
  entity_by_c_type = {},
  components = {},

  systems = {},
  systems_status = {},
  systems_by_event = {},

  pool_event = {},
  resources = {},

  -- query
  query_data = nil,
  query_types = nil,
  delta_time = 0,

  counters = {
    new_events = 0,
    event_consumed = 0,
  },
  counters_by_event = {}
}
ECS.__index = ECS

function ECS:new()
  local ecs = {}
  setmetatable(ecs, ECS)
  return ecs
end

function ECS:start()
  self.state = "Running"
end

function ECS:add_resource(type, resource)
  if self.resources[type] == nil then
    self.resources[type] = {}
  end
  table.insert(self.resources[type], resource)
end

function ECS:get_resource(resource_name)
  return self.resources[resource_name]
end

function ECS:merge_query(...)
  local queries = {}

  for i, v in ipairs({ ... }) do
    table.insert(queries, self:new_query(v))
  end
  return utils.merge(queries)
end

function ECS:new_query(c_types, system_info)
  if c_types == nil or #c_types == 0 then return {} end

  local min_key = c_types[1]

  if min_key == nil then return {} end

  for _, c_type in ipairs(c_types) do
    if self.entity_by_c_type[c_type] == nil then return {} end

    if #self.entity_by_c_type[c_type] < #self.entity_by_c_type[min_key] then
      min_key = c_type
    end
  end

  local entity_set = {}
  for _, entity in ipairs(self.entity_by_c_type[min_key]) do
    entity_set[entity] = true
  end

  for _, key in ipairs(c_types) do
    if key ~= min_key then
      local new_set = {}
      for _, entity in ipairs(self.entity_by_c_type[key]) do
        if entity_set[entity] then
          new_set[entity] = true
        end
      end
      entity_set = new_set
    end
  end

  local result = {}
  for key, value in pairs(entity_set) do
    table.insert(result, key)
  end

  return result
end

---@param c_types number[]
---@oaram system_info SystemInfo
function ECS:new_query_2(c_types, system_info)
  if c_types == nil or #c_types == 0 then return {} end

  local min_key = c_types[1]

  if min_key == nil then return {} end

  for _, c_type in ipairs(c_types) do
    if self.entity_by_c_type[c_type] == nil then return {} end

    if #self.entity_by_c_type[c_type] < #self.entity_by_c_type[min_key] then
      min_key = c_type
    end
  end

  local entity_set = {}
  for _, entity in ipairs(self.entity_by_c_type[min_key]) do
    entity_set[entity] = true
  end

  for _, key in ipairs(c_types) do
    if key ~= min_key then
      local new_set = {}
      for _, entity in ipairs(self.entity_by_c_type[key]) do
        new_set[entity] = true
      end

      entity_set = new_set
    end
  end


  local result = {}
  for key, value in pairs(entity_set) do
    table.insert(result, key)
  end

  -- Para manter a ordem da lista na saida ?? Acho que nao precisa
  -- table.sort(result)

  return result
end

---@param c_types Array<integer>
function ECS:query(c_types, system_info)
  return self:new_query(c_types)
  -- if system_info == nil then system_info = "null_system" end

  -- -- local qr = self:new_query(ctypes, system_info)

  -- ---@type Array<integer>
  -- local result = {}

  -- for _, v in pairs(ctypes) do
  --   if self.entity_by_c_type[v] then
  --     for _, entity_id in ipairs(self.entity_by_c_type[v]) do
  --       if not result[entity_id] then
  --         table.insert(result, entity_id)
  --       end
  --     end
  --   end
  -- end

  -- return result
end

-- function ECS:each(fn)
--   if fn == nil then return end
--   fn(self.query_data)
-- end

---@param components Array<any>
function ECS:add_entity(components)
  local new_entity = self.last_entity + 1
  self.last_entity = new_entity

  for _, component in pairs(components) do
    self:register_component(new_entity, component)
  end
end

function ECS:remove_entity(entity_id)
  -- Verifica se a entidade existe
  if not self.entities[entity_id] then
    return
  end

  -- Remove a entidade das listas de componentes
  for _, component_type in ipairs(self.entities[entity_id]) do
    local entities_with_component = self.entity_by_c_type[component_type]
    for i, entity in ipairs(entities_with_component) do
      if entity == entity_id then
        table.remove(entities_with_component, i)
        break
      end
    end
  end

  -- Remove os componentes da tabela de componentes
  for _, component_type in ipairs(self.entities[entity_id]) do
    local key = entity_id .. component_type
    self.components[key] = nil
  end

  -- Remove a entidade da lista de entidades
  self.entities[entity_id] = nil


  -- Apos Remover os sistemas, entender se existem mais componentes daquele sistema.
  -- se nao existem, desligar os sistemas que nao precisam executar
end

---@param entity integer
---@param component Component
function ECS:register_component(entity, component)
  -- Escape
  local invalid_keys = utils.check_keys({ "type", "data" }, component)
  if #invalid_keys > 0 then return nil end

  -- Cria a tabela caso nao exista
  if self.entity_by_c_type[component.type] == nil then
    self.entity_by_c_type[component.type] = {}
  end
  table.insert(self.entity_by_c_type[component.type], entity)

  -- Update Componentes
  local key = entity .. component.type
  if self.components[key] == nil then
    self.components[key] = {}
  end
  -- table.insert(self.components[key], component.data)
  self.components[key] = component.data

  -- Update Entitites -> List<CType>
  if self.entities[entity] == nil then
    self.entities[entity] = {}
  end
  table.insert(self.entities[entity], component.type)
  C_COUNTER = C_COUNTER + 1

  self:update_system_state()
end

function ECS:update_system_state()
  for index, sys in ipairs(self.systems) do
    -- if sys.system.watch ~= nil then
    -- if sys.system.watch[component.type] == true then
    self.systems_status[index] = true
    -- end
    -- end
  end
end

---@param event NewEvent
function ECS:add_event(event)
  self.counters.new_events = self.counters.new_events + 1;
  self:update_counter_by_event(event)
  table.insert(self.pool_event, event)
end

---@param event NewEvent
function ECS:update_counter_by_event(event)
  if self.counters_by_event[event.type] == nil then
    self.counters_by_event[event.type] = 0
  end

  self.counters_by_event[event.type] = self.counters_by_event[event.type] + 1
end

---@param entity integer
---@param c_type integer
---@return ComponentResult | nil
function ECS:get_component(entity, c_type)
  if entity == nil then return nil end
  return {
    key = entity .. c_type,
    data = self.components[entity .. c_type]
  }
end

---@param entity integer
---@param c_type integer
---@param data table
function ECS:set_component(entity, c_type, data)
  if entity == nil or c_type == nil or data == data == nil then
    return
  end

  self.components[entity .. c_type] = data
end

---@param system any
function ECS:add_system(system)
  local new_id = #self.systems + 1;

  self.systems[new_id] = {
    system = system
  }

  self.systems_status[new_id] = true

  if system.start then
    system:start(self)
  end

  if system.events ~= nil and #system.events ~= 0 then
    for _, event in pairs(system.events) do
      if self.systems_by_event[event] == nil then
        self.systems_by_event[event] = {}
      end
      table.insert(self.systems_by_event[event], new_id)
    end
  end
end

---@param dt integer?
function ECS:update(dt)
  if dt then
    self.delta_time = dt
  end
  while #self.pool_event > 0 do
    local event = table.remove(self.pool_event, 1)

    self.counters.event_consumed = self.counters.event_consumed + 1

    local to_run = self.systems_by_event[event.type]
    if to_run == nil then return end

    for i, s in pairs(to_run) do
      local system = self.systems[s]

      if self.systems_status[s] == true then
        if system.system.update ~= nil then
          system.system:update(self, self.delta_time, event)
        end
      end
    end
  end
end

---@param event NewEvent
function ECS:run_system_by_event(event)
  self:update_counter_by_event { type = event.type }
  local to_run = self.systems_by_event[event.type]

  if to_run ~= nil then
    for i, s in pairs(to_run) do
      self.systems[s].system:update(self, self.delta_time, event)
    end
  end
end

return ECS
