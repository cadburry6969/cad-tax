fx_version "adamant"
game "gta5"

author "Cadburry"
description "QBCore Tax System by Cadburry#7547"
version "0.1.0"

shared_script "shared.lua"
server_script "sv_tax.lua"

server_exports {
    "GetCurrentTax",    
    "PlayersTax",
    "CarsTax",
    "HousesTax",
}

lua54 'yes'