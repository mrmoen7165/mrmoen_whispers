Config = {}

Config.Locale = "no"

Config.NightStart = 22
Config.NightEnd = 4
Config.CheckInterval = 5000
Config.GhostChance = 25
Config.TriggerDistance = 40.0
Config.GhostLifetime = 7
Config.SoundRange = 15.0
Config.SoundVolume = 0.4

-- Kirkegårder
Config.Graveyards = {
    {x = -273.21, y = 805.32, z = 119.37, name = "Valentine Graveyard"},
    {x = -756.23, y = -1322.41, z = 43.87, name = "Saint Denis Graveyard"},
    {x = -288.93, y = 705.32, z = 113.42, name = "Emerald Ranch Graveyard"}
}

-- Prest ved Valentine
Config.Priest = {
    model = `A_M_M_Priest_01`,
    coords = {x = -275.0, y = 803.0, z = 119.37, heading = 180.0},
    warningText = "Du bør ikke være her etter mørkets frembrudd, sønn..."
}

-- Lyder
Config.Sounds = {
    ghostWhispers = {"ghost_whisper1", "ghost_whisper2"},
    womanCry = {"woman_cry"},
    forestAmbience = {"forest_night1", "forest_wind1"}
}

-- Spøkelsesmodell
Config.GhostModel = `A_M_M_UniCorpse_01`
Config.EnableGraveRobberyLink = true

-- Spesielle steder for gråt
Config.HauntedSpots = {
    {
        coords = vector3(-1035.82, 529.41, 95.17),
        radius = 25.0,
        sound = "woman_cry",
        message = "Du hører en kvinne gråte svakt i mørket...",
        chance = 50
    }
}
