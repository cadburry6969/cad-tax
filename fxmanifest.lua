fx_version "cerulean"
game "gta5"
lua54 "yes"

author "Cadburry"
description "QBCore Tax System"
version "0.1.1"

shared_script "shared.lua"
server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "sv_tax.lua"
}

server_exports {
    "GetCurrentTax",
    "PlayersTax",
    "CarsTax",
    "HousesTax",
}

lua54 'yes'
