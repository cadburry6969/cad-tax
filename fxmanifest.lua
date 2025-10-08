fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Cadburry (Bytecode Studios)'
description 'Simple Tax System'
version '0.4'

shared_scripts {
    -- '@ox_lib/init.lua', -- uncomment this if your are using ox_lib
    'config/language.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config/server.lua',
    'modules/framework.lua',
    'modules/banking.lua',
    'modules/housing.lua',
    'modules/utils.lua',
    'modules/main.lua',
}

dependencies {
    'oxmysql',
}
