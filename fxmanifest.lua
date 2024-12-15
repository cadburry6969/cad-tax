fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Cadburry'
description 'Simple Tax System'
version '0.3'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    -- '@ox_lib/init.lua', -- uncomment this if your are using ox_lib
    'locales/*',
    'config/server.lua',
    'modules/*'
}

dependencies {
    'oxmysql',
}