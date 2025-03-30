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
  end
}
