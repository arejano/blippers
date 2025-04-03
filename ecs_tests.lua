function get_existentem_em_todos(keys)
    local e_ct = {
        [1] = {1,2,4},
        [2] = {1,2,3,4},
        [3] = {2,3,5},
        [4] = {1,3,4}
    }

    -- Se não há chaves, retornar vazio
    if #keys == 0 then return {} end

    -- Escolher a menor lista para começar (reduz interseções desnecessárias)
    local min_key = keys[1]
    for _, key in ipairs(keys) do
        if #e_ct[key] < #e_ct[min_key] then
            min_key = key
        end
    end

    -- Criar um conjunto inicial a partir da menor lista
    local entity_set = {}
    for _, entity in ipairs(e_ct[min_key]) do
        entity_set[entity] = true
    end

    -- Fazer interseção progressiva com as outras listas
    for _, key in ipairs(keys) do
        if key ~= min_key then
            local new_set = {}
            for _, entity in ipairs(e_ct[key]) do
                if entity_set[entity] then
                    new_set[entity] = true
                end
            end
            entity_set = new_set  -- Atualizar o conjunto com a interseção
        end
    end

    -- Converter o set para lista ordenada
    local result = {}
    for entity in pairs(entity_set) do
        table.insert(result, entity)
    end
    table.sort(result) -- Para manter consistência na saída

    return result
end

-- Testando a função
local resultado = get_existentem_em_todos({2,3,4})
for _, v in ipairs(resultado) do
    print(v)
end
