RegisterNetEvent('mrmoen_whispers:playSound')
AddEventHandler('mrmoen_whispers:playSound', function(distance, soundFile, volume)
    TriggerClientEvent('InteractSound_CL:PlayWithinDistance', -1, distance, soundFile, volume)
end)





-- Versjons-sjekk system for mrmoen_whispers
local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
local resourceName = GetCurrentResourceName()
local githubVersionURL = "https://raw.githubusercontent.com/MrMoen/mrmoen_whispers/main/fxmanifest.lua"

CreateThread(function()
    print("^3["..resourceName.."]^7 Laster versjonssjekk...")
    PerformHttpRequest(githubVersionURL, function(statusCode, response, headers)
        if statusCode == 200 then
            local latestVersion = response:match("version ['\"]([0-9%.]+)['\"]")
            if latestVersion then
                if latestVersion ~= currentVersion then
                    print("^6["..resourceName.."]^7 En ny versjon er tilgjengelig!")
                    print("^2Din versjon:^7 " .. currentVersion .. "  ^3Nyeste versjon:^7 " .. latestVersion)
                    print("^5Oppdater fra GitHub:^7 https://github.com/MrMoen/mrmoen_whispers")
                else
                    print("^2["..resourceName.."]^7 Du kjører siste versjon ("..currentVersion..")")
                end
            end
        else
            print("^1["..resourceName.."]^7 Kunne ikke sjekke versjon (GitHub-status: " .. statusCode .. ")")
        end
    end, "GET", "", {["User-Agent"] = "mrmoen_whispers-version-check"})
end)
