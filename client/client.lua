-------------------------------------------------------
-- Core og helper
-------------------------------------------------------
local RSGCore = exports['rsg-core']:GetCoreObject()
local locale = Locales and Locales[Config.Locale] or {}

local function debugPrint(msg)
    if Config.Debug then print("^3[DEBUG]^7 " .. msg) end
end

local nightStart, nightEnd = Config.NightStart, Config.NightEnd

local lib = {}
if exports['ox_lib'] and exports['ox_lib'].notify then
    lib.notify = function(data)
        exports['ox_lib']:notify(data)
    end
else
    lib.notify = function(data)
        local msg = type(data) == 'table' and (data.description or data.title) or tostring(data)
        TriggerEvent('chat:addMessage', {color = {255, 200, 0}, args = {'mrmoen_whispers', msg}})
    end
end

local function playSound(sound)
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", Config.SoundRange, sound, Config.SoundVolume)
end

-------------------------------------------------------
-- Spawn ghost ped
-------------------------------------------------------
local function spawnGhost(model, coords)
    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do Wait(10) end

    local ghost = CreatePed(GetHashKey(model), coords.x, coords.y, coords.z, 0.0, false, true)
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
end

-------------------------------------------------------
-- 1️⃣ Prester
-------------------------------------------------------
CreateThread(function()
    local priestSpawned = {}

    while true do
        Wait(Config.CheckInterval)
        local hour = Citizen.InvokeNative(0xC82CF208C2B19199, 0, Citizen.ResultAsInteger())
        local isNight = (hour >= nightStart or hour < nightEnd)
        local playerCoords = GetEntityCoords(PlayerPedId())

        for i, priest in ipairs(Config.Priests) do
            priestSpawned[i] = priestSpawned[i] or {active = false, shown = false, ped = nil}
            local data = priestSpawned[i]
            local dist = #(playerCoords - vector3(priest.coords.x, priest.coords.y, priest.coords.z))

            if isNight and not data.active then
                RequestModel(GetHashKey(priest.model))
                while not HasModelLoaded(GetHashKey(priest.model)) do Wait(10) end
                data.ped = CreatePed(GetHashKey(priest.model),
                    priest.coords.x, priest.coords.y, priest.coords.z - 1.0, priest.coords.w, false, false, 0, 0)
                FreezeEntityPosition(data.ped, true)
                SetEntityInvincible(data.ped, true)
                SetBlockingOfNonTemporaryEvents(data.ped, true)
                data.active = true
                debugPrint("Prest aktivert: " .. priest.name)
            elseif not isNight and data.active then
                if DoesEntityExist(data.ped) then DeleteEntity(data.ped) end
                data.active, data.shown = false, false
                debugPrint("Prest fjernet: " .. priest.name)
            end

            if isNight and data.active and dist < priest.radius then
                if not data.shown then
                    data.shown = true
                    lib.notify(priest.notify)
                    playSound(priest.sound)
                end
            else
                data.shown = false
            end
        end
    end
end)

-------------------------------------------------------
-- 2️⃣ Ghosts
-------------------------------------------------------
CreateThread(function()
    local ghostTriggered = {}

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
                    lib.notify(ghost.notify)
                    playSound(ghost.sound)
                    spawnGhost(ghost.model, ghost.coords)
                    debugPrint("Spøkelse utløst: " .. ghost.name)
                end
            else
                if not isNight then ghostTriggered[i] = false end
            end
        end
    end
end)

-------------------------------------------------------
-- 3️⃣ Haunted spots
-------------------------------------------------------
CreateThread(function()
    local hauntedTriggered = {}

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
                    lib.notify(spot.notify)
                    playSound(spot.sound)
                    debugPrint("Haunted aktivert: " .. spot.name)
                end
            else
                if not isNight then hauntedTriggered[i] = false end
            end
        end
    end
end)
