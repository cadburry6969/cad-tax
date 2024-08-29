fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Cadburry'
description 'Simple Tax System'
version '0.2'

-- shared_script '@ox_lib/init.lua' -- uncomment this if your are using ox_lib

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'locales/*',
    'config/server.lua',
    'module/server.lua'
}

dependencies {
    'oxmysql',
}