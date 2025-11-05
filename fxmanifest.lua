fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM'

author 'MrMoen'
description 'mrmoen_whispers - Dynamic graveyard & forest hauntings for RedM (RSGCore)'
version '1.0.0'

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

shared_script '@rsg-core/shared/locale.lua'

dependency 'rsg-core'
