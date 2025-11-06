Config = {}


-- Generelt

Config.Locale = "no"
Config.Debug = true
Config.NightStart = 22
Config.NightEnd = 4
Config.CheckInterval = 1000
Config.FadeIn = true
Config.SoundRange = 25.0        -- rekkevidde for lyd
Config.SoundVolume = 0.4        -- volum (0.0–1.0)
Config.GhostLifetime = 10000      -- sekunder spøkelse varer
Config.GhostChance = 100        -- sjanse (1–100) for at et spøkelse spawner


-- Prester

Config.Priests = {
    {
        name = "Valentine Church",
        model = "U_M_M_ValDoctor_01",
        coords = vector4(-231.85, 796.23, 124.63, 75.85),
        radius = 3.0,
        sound = "priest",
        notify = {
            title = "Advarsel",
            description = "Du bør ikke være her etter mørkets frembrudd..",
            type = "warning",
            duration = 7000
        }
    },
    {
        name = "Blackwater Church",
        model = "U_M_M_RhdGenStoreOwner_01",
        coords = vector4(-971.34, -1199.66, 59.18, 199.06),
        radius = 3.0,
        sound = "priest",
        notify = {
            title = "Prest",
            description = "Kirken er stengt etter mørkets frembrudd.",
            type = "warning",
            duration = 7000
        }
    }
}


--Spøkelser

Config.Ghosts = {
    {
        name = "Valentine Graveyard",
        coords = vector3(-228.09, 824.71, 124.43),
        model = "A_M_M_Rancher_01",
        radius = 8.0,
        sound = "ghost_whisper1",
        notify = {
            title = "Spøkelse",
            description = "Du hører hvisking i vinden...",
            type = "inform",
            duration = 8000
        }
    },
    {
        name = "Blackwater Graveyard",
        coords = vector3(-1014.05, -1194.79, 59.45),
        model = "A_M_M_Rancher_01",
        radius = 8.0,
        sound = "ghost_whisper1",
        notify = {
            title = "Spøkelse",
            description = "Stemmer visker mellom gravene...",
            type = "inform",
            duration = 8000
        }
    }
}

-- Haunted (hjemsøkte plasser)

Config.Haunted = {
    {
        name = "Valentine Woods",  -- der Ketil tok med like til Rockis
        coords = vector3(-613.36, 528.34, 94.62),
        radius = 4.0,
        sound = "woman_cry",
        notify = {
            title = "Sykdom?",
            description = "En kvinne gråter svakt i mørket hennes mann har gått vekk..",
            type = "error",
            duration = 9000
        }
    },
    {
        name = "Blackwater monumentplass",
        coords = vector3(-892.07, -1152.32, 46.88),
        radius = 10.0,
        sound = "woman_cry",
        notify = {
            title = "???",
            description = "En sørgmodig stemme ekkoer mellom trærne...",
            type = "error",
            duration = 9000
        }
    }
}

