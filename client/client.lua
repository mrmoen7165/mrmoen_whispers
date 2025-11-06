
-- Kjerne

local RSGCore = exports['rsg-core']:GetCoreObject()
local locale = Locales and Locales[Config.Locale] or {}

local function debugPrint(msg)
    if Config.Debug then
        print(('[^3DEBUG^7] %s'):format(msg))
    end
end

local nightStart, nightEnd = Config.NightStart, Config.NightEnd

local lib = {}
if exports['ox_lib'] and exports['ox_lib'].notify then
    lib.notify = function(data)
        debugPrint(("ox_lib notify: %s"):format(data.title or ""))
        exports['ox_lib']:notify(data)
    end
else
    lib.notify = function(data)
        local msg = type(data) == 'table' and (data.description or data.title) or tostring(data)
        debugPrint(("chat notify: %s"):format(msg))
        TriggerEvent('chat:addMessage', { color = {255, 200, 0}, args = {'mrmoen_whispers', msg} })
    end
end

local function playSound(sound)
    debugPrint(("Spiller lyd: %s (range %.1f, volume %.1f)"):format(tostring(sound), Config.SoundRange, Config.SoundVolume))
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", Config.SoundRange, sound, Config.SoundVolume)
end


-- Spawn ghost ped Spøkelses peds

local function spawnGhost(model, coords)
    debugPrint(("Forsøker å spawne ghost: %s @ %.2f %.2f %.2f"):format(model, coords.x, coords.y, coords.z))
    local hash = GetHashKey(model)
    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(10) end

    local ghost = CreatePed(hash, coords.x, coords.y, coords.z, 0.0, false, true)
    if not DoesEntityExist(ghost) then
        debugPrint("FEIL: Klarte ikke lage ghost-ped")
        return
    end

    SetEntityAlpha(ghost, 100, false)
    SetEntityInvincible(ghost, true)
    SetBlockingOfNonTemporaryEvents(ghost, true)
    SetPedCanRagdoll(ghost, false)

    for i = 0, 100, 10 do
        SetEntityAlpha(ghost, i, false)
        Wait(100)
    end

    Wait(Config.GhostLifetime * 1000)

    for i = 100, 0, -10 do
        SetEntityAlpha(ghost, i, false)
        Wait(100)
    end

    DeleteEntity(ghost)
    debugPrint("Ghost slettet igjen")
end


--Prester

CreateThread(function()
    local priestData = {}
    local shown = {}
    for i, priest in ipairs(Config.Priests) do
        priestData[i] = { ped = nil, active = false }
        shown[i] = false
    end
    while true do
        Wait(1000)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local hour = GetClockHours()
        local isNight = (hour >= Config.NightStart or hour < Config.NightEnd)
        local isDay = not isNight

        for i, priest in ipairs(Config.Priests) do
            local data = priestData[i]
            local c = priest.coords
            local dist = #(playerCoords - vector3(c.x, c.y, c.z))
            if isNight and not data.active then
                local npcModel = type(priest.model) == "string" and GetHashKey(priest.model) or priest.model
                RequestModel(npcModel)
                while not HasModelLoaded(npcModel) do Wait(10) end
                print(("[DEBUG] Spawner prest %s (%s)"):format(priest.name, priest.model))
                local ped = CreatePed(npcModel, c.x, c.y, c.z - 1.0, c.w, false, false, 0, 0)
                while not DoesEntityExist(ped) do Wait(100) end
                Citizen.InvokeNative(0x283978A15512B2FE, ped, true)
                PlaceEntityOnGroundProperly(ped, true)
                SetPedRandomComponentVariation(ped, 0)
                SetEntityAlpha(ped, 0, false)
                SetEntityCanBeDamaged(ped, false)
                SetEntityInvincible(ped, true)
                FreezeEntityPosition(ped, true)
                SetBlockingOfNonTemporaryEvents(ped, true)
                SetPedCanBeTargetted(ped, false)
                SetEntityVisible(ped, true, false)
                if Config.FadeIn then
                    for a = 0, 255, 51 do
                        Wait(50)
                        SetEntityAlpha(ped, a, false)
                    end
                else
                    SetEntityAlpha(ped, 255, false)
                end
                data.ped = ped
                data.active = true
                priestData[i] = data
                print(("[DEBUG] Prest %s spawn OK, synlig"):format(priest.name))
            end

            if isDay and data.active then
                if DoesEntityExist(data.ped) then
                    if Config.FadeIn then
                        for a = 255, 0, -51 do
                            Wait(50)
                            SetEntityAlpha(data.ped, a, false)
                        end
                    end
                    DeleteEntity(data.ped)
                    print(("[DEBUG] Prest fjernet (dag): %s"):format(priest.name))
                end
                data.active = false
            end

            if isNight and data.active and dist < priest.radius then
                if not shown[i] then
                    shown[i] = true
                    lib.notify({
                        title = priest.notify.title or "Advarsel",
                        description = priest.notify.description or "Du bør ikke være her etter mørkets frembrudd, sønn...",
                        type = priest.notify.type or "warning",
                        duration = priest.notify.duration or 7000
                    })
                    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, priest.sound or "priest", 1.0)
                    print(("[DEBUG] Prest notify utløst: %s"):format(priest.name))
                end
            else
                shown[i] = false
            end
        end
    end
end)

--Ghosts Spøkelser

CreateThread(function()
    local ghostTriggered = {}
    debugPrint("Ghost-thread startet")
    while true do
        Wait(Config.CheckInterval)
        local hour = Citizen.InvokeNative(0xC82CF208C2B19199, 0, Citizen.ResultAsInteger())
        local isNight = (hour >= nightStart or hour < nightEnd)
        local playerCoords = GetEntityCoords(PlayerPedId())

        for i, ghost in ipairs(Config.Ghosts) do
            ghostTriggered[i] = ghostTriggered[i] or false
            local dist = #(playerCoords - ghost.coords)

            if isNight and dist < ghost.radius then
                if not ghostTriggered[i] then
                    ghostTriggered[i] = true
                    debugPrint(("Ghost-trigger: %s"):format(ghost.name))
                    lib.notify(ghost.notify)
                    playSound(ghost.sound)
                    spawnGhost(ghost.model, ghost.coords)
                end
            else
                if not isNight then ghostTriggered[i] = false end
            end
        end
    end
end)

--  Haunted (hjemsøkte plasser)

CreateThread(function()
    local hauntedTriggered = {}
    debugPrint("Haunted-thread startet")

    while true do
        Wait(Config.CheckInterval)
        local hour = Citizen.InvokeNative(0xC82CF208C2B19199, 0, Citizen.ResultAsInteger())
        local isNight = (hour >= nightStart or hour < nightEnd)
        local playerCoords = GetEntityCoords(PlayerPedId())

        for i, spot in ipairs(Config.Haunted) do
            hauntedTriggered[i] = hauntedTriggered[i] or false
            local dist = #(playerCoords - spot.coords)

            if isNight and dist < spot.radius then
                if not hauntedTriggered[i] then
                    hauntedTriggered[i] = true
                    debugPrint(("Haunted aktivert: %s"):format(spot.name))
                    lib.notify(spot.notify)
                    playSound(spot.sound)
                end
            else
                if not isNight then hauntedTriggered[i] = false end
            end
        end
    end
end)
