fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
author 'MrMoen'
description 'mrmoen_whispers - Dynamic graveyard & forest hauntings for RedM (RSGCore)'
version '1.0.5'

shared_script '@ox_lib/init.lua'

client_scripts {
    'config.lua',
    'locales/*.lua',
    'client/client.lua'
}

server_scripts {
    '@rsg-core/shared/locale.lua',
    'config.lua',
    'locales/*.lua',
    'server/server.lua'
}

shared_scripts {
    'shared/locale_init.lua',
    'config.lua',
    'locales/*.lua'
}

dependency {
    'rsg-core',
    'ox_lib',
    'interact-sound'
}

lua54 'yes'