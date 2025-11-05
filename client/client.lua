local RSGCore = exports['rsg-core']:GetCoreObject()
local locale = Locales[Config.Locale]

-- Spawn prest-NPC ved oppstart
CreateThread(function()
    local model = Config.Priest.model
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end

    local ped = CreatePed(model, Config.Priest.coords.x, Config.Priest.coords.y, Config.Priest.coords.z, Config.Priest.coords.heading, false, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
end)

-- Spøkelse-funksjon
local function spawnGhost(coords)
    local model = Config.GhostModel
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end
    local ghost = CreatePed(model, coords.x, coords.y, coords.z, 0.0, false, true)
    SetEntityAlpha(ghost, 100, false)
    SetEntityInvincible(ghost, true)
    SetBlockingOfNonTemporaryEvents(ghost, true)
    Wait(Config.GhostLifetime * 1000)
    DeleteEntity(ghost)
end

CreateThread(function()
    while true do
        Wait(Config.CheckInterval)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local hour = GetClockHours()

        -- Ghost activity på kirkegårder
        if hour >= Config.NightStart or hour <= Config.NightEnd then
            for _, grave in ipairs(Config.Graveyards) do
                local dist = #(coords - vector3(grave.x, grave.y, grave.z))
                if dist < Config.TriggerDistance and math.random(1, 100) <= Config.GhostChance then
                    local msg = locale.ghost_near
                    local snd = Config.Sounds.ghostWhispers[math.random(1, #Config.Sounds.ghostWhispers)]
                    lib.notify({title = locale.ghost_spawn_title, description = msg, type = 'inform'})
                    TriggerServerEvent('mrmoen_whispers:playSound', Config.SoundRange, snd, Config.SoundVolume)
                    local offset = vector3(grave.x + math.random(-5,5), grave.y + math.random(-5,5), grave.z)
                    spawnGhost(offset)
                end
            end
        end

        -- Haunted spots (woman cry)
        for _, spot in ipairs(Config.HauntedSpots) do
            local dist = #(coords - spot.coords)
            if dist < spot.radius and math.random(1, 100) <= spot.chance then
                lib.notify({title = '???', description = spot.message, type = 'error'})
                TriggerServerEvent('mrmoen_whispers:playSound', 20.0, spot.sound, 0.5)
                Wait(10000)
            end
        end

        -- Forest ambience (random natt)
        if hour >= Config.NightStart or hour <= Config.NightEnd then
            if math.random(1,100) <= 10 then
                TriggerServerEvent('mrmoen_whispers:playSound', 25.0, 'forest_night1', 0.3)
            end
        end
    end
end)
