ECS = require "libs.ecs-lua.ECS"

world = nil

function love.load()
    local World, System, Query, Component = ECS.World, ECS.System, ECS.Query, ECS.Component

    -- Corrigindo a definição do componente Health
    local Health = Component({ value = 100 })
    local Position = Component({ x = 0, y = 0 })
    local txt = "Hello world";

    local isInAcid = Query.Filter(function()
        return true -- it's wet season
    end)

    local InAcidSystem = System("process", Query.All(Health, Position, isInAcid()))

    function InAcidSystem:Update()
        for i, entity in self:Result():Iterator() do
            local health = entity:Get(Health)
            health.value = health.value - 0.01
        end
    end

    -- Inicializando a variável world
    world = World({ InAcidSystem })

    -- Criando uma entidade com os componentes Position e Health
    world:Entity(Position({ x = 5.0 }), Health({ value = 100 }))
end

function love.draw()
    for _, entity in world:Exec(ECS.Query.All(Health)):Iterator() do
        local health = entity:Get(Health)
        love.graphics.print("Health: " .. math.floor(health.value), 10, 10)
    end
end

function love.update(dt)
    world:Update("process", dt)
end
