local Quadtree = {}
Quadtree.__index = Quadtree

function Quadtree:new(level, bounds)
  local qt = {
    level = level,
    bounds = bounds,
    objects = {},
    nodes = {}
  }

  setmetatable(qt, Quadtree)
  return qt
end

function Quadtree:clear()
  self.objects = {}
  for i = 1, 4 do
    if self.nodes[i] then
      self.nodes[i]:clear()
      self.nodes[i] = nil
    end
  end
end

function Quadtree:split()
  local subWidth = self.bounds.width / 2
  local subHeight = self.bounds.height / 2
  local x = self.bounds.x
  local y = self.bounds.y

  self.nodes[1] = Quadtree:new(self.level + 1, { x = x + subWidth, y = y, width = subWidth, height = subHeight })
  self.nodes[2] = Quadtree:new(self.level + 1, { x = x, y = y, width = subWidth, height = subHeight })
  self.nodes[3] = Quadtree:new(self.level + 1, { x = x, y = y + subHeight, width = subWidth, height = subHeight })
  self.nodes[4] = Quadtree:new(self.level + 1,
    { x = x + subWidth, y = y + subHeight, width = subWidth, height = subHeight })
end

function Quadtree:getIndex(rect)
  local index = -1
  local verticalMidpoint = self.bounds.x + (self.bounds.width / 2)
  local horizontalMidpoint = self.bounds.y + (self.bounds.height / 2)

  local topQuadrant = (rect.y < horizontalMidpoint and rect.y + rect.height < horizontalMidpoint)
  local bottomQuadrant = (rect.y > horizontalMidpoint)

  if rect.x < verticalMidpoint and rect.x + rect.width < verticalMidpoint then
    if topQuadrant then
      index = 2
    elseif bottomQuadrant then
      index = 3
    end
  elseif rect.x > verticalMidpoint then
    if topQuadrant then
      index = 1
    elseif bottomQuadrant then
      index = 4
    end
  end

  return index
end

function Quadtree:insert(rect)
  if self.nodes[1] then
    local index = self:getIndex(rect)

    if index ~= -1 then
      self.nodes[index]:insert(rect)
      return
    end
  end

  table.insert(self.objects, rect)

  if #self.objects > 4 and self.level < 5 then
    if not self.nodes[1] then
      self:split()
    end

    local i = 1
    while i <= #self.objects do
      local index = self:getIndex(self.objects[i])
      if index ~= -1 then
        table.insert(self.nodes[index].objects, table.remove(self.objects, i))
      else
        i = i + 1
      end
    end
  end
end

function Quadtree:retrieve(returnObjects, rect)
  local index = self:getIndex(rect)
  if index ~= -1 and self.nodes[1] then
    self.nodes[index]:retrieve(returnObjects, rect)
  end

  for _, obj in ipairs(self.objects) do
    table.insert(returnObjects, obj)
  end

  return returnObjects
end

return Quadtree
