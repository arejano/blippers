return {
  check_keys = function(keys, t)
    local invalids = {}
    for k, i in pairs(keys) do
      if t[i] == nil then
        table.insert(invalids, i)
      end
    end
    return invalids
  end,
  make_enum = function(t)
    local enum = {}
    for i, v in ipairs(t) do
      enum[v] = i
    end
    return setmetatable(enum, {
      __index = function(_, key)
        error("Chave" .. tostring(v) .. " nao existe no enum")
      end,
      __newindex = function(_, key, value)
        error("Nao eh possivel modificar o enum")
      end
    })
  end,
  get_display_size = function()
    local displays = love.window.getDisplayCount() -- Conta quantos monitores existem
    local targetDisplay = 2                        -- Altere esse valor para o monitor desejado (1, 2, ...)

    if targetDisplay > displays then
      targetDisplay = 1 -- Se o monitor não existir, usa o principal
    end

    -- Obtém informações do monitor alvo
    local width, height = love.window.getDesktopDimensions(targetDisplay)

    return width, height, targetDisplay
  end,

  removeColorBackgroundFromImage = function(imagePath, color)
    local imageData = love.image.newImageData(imagePath)

    -- Define a cor rosa que será removida (255, 0, 255)
    local rKey, gKey, bKey = color[1], color[2], color[3]

    imageData:mapPixel(function(x, y, r, g, b, a)
      -- Se o pixel for rosa, torná-lo transparente
      if r == rKey and g == gKey and b == bKey then
        return r, g, b, 0 -- Define a transparência (0 no Alpha)
      end
      return r, g, b, a   -- Mantém os outros pixels inalterados
    end)

    return love.graphics.newImage(imageData) -- Retorna a nova imagem se
  end,

  createQuads = function(region, sprite)
    local quads = {}
    for _, frame in ipairs(region) do
      table.insert(quads,
        love.graphics.newQuad(frame.x, frame.y, frame.width, frame.height, sprite:getWidth(),
          sprite:getHeight()))
    end
    return quads
  end
}
