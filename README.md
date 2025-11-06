# 📦 MRMOEN_WHISPERS

Et stemningsfylt RedM-script for RSGCore som bringer liv (og død) til kirkegårder og skoger.  
Spillere kan oppleve spøkelser, hvisking, tåke og en gråtende kvinne i mørket.  


---

## 🧭 INSTALLASJON

1. Pakk ut mappen **"mrmoen_whispers"** til din **server/resources/**  
2. Åpne **server.cfg** og legg til:  
   ```cfg
   ensure mrmoen_whispers
⚙️ AVHENGIGHETER
rsg-core

interact-sound

ox_lib (for lib.notify og progressBar)

🔊 LYDFILER
Legg inn disse filene i interact-sound/client/html/sounds/:

ghost_whisper1.ogg

ghost_whisper2.ogg

forest_night1.ogg

woman_cry.ogg


🌙 I SPILLET
Etter installasjon, start serveren og besøk en kirkegård etter kl. 22:00 (in-game tid).

Du vil oppleve:

🙏 En prest som står ved gravplassen og advarer spillere.

👻 Spøkelser og lyder ved gravene.

😢 En gråtende kvinne i skogen.

🌫️ Stemningsfull natt med vind og hvisking.

🌍 SPRÅK
Endre språk i config.lua:

Config.Locale = "no" -- eller "en"