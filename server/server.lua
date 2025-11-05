RegisterNetEvent('mrmoen_whispers:playSound')
AddEventHandler('mrmoen_whispers:playSound', function(distance, soundFile, volume)
    TriggerClientEvent('InteractSound_CL:PlayWithinDistance', -1, distance, soundFile, volume)
end)
