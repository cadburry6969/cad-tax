Simple Tax System for QBCore

# Installation

- First add this to resources folder and ensure in `server.cfg`
- Configure values in files present in `cad-tax/config/` as required.

# Supported
- ESX / QBCore
- qb-banking / Renewed-Banking / snipe-banking
- ox lib logger / qb logs
- ox lib notify / qb notify / qb-phone / snappy-phone / yseries

# Server Exports

```lua
--- Get Current Tax percent for the type
--- @param string citizenid
--- @param string ["vehicle", "property", "house", "income"]
--- @return boolean
exports["cad-tax"]:GetCurrentTax(src, type)
--- Check the player has tax waived off
--- @param string citizenid
--- @return boolean
exports["cad-tax"]:IsTaxWaivedOff(citizenid)
--- To start manually
exports["cad-tax"]:PlayersTax() -- To start manually
--- To start manually
exports["cad-tax"]:VehiclesTax()  -- To start manually
--- To start manually
exports["cad-tax"]:PropertiesTax()
--- To start manually (deprecated)
exports["cad-tax"]:CarsTax()  -- To start manually (deprecated)
--- To start manually (deprecated)
exports["cad-tax"]:HousesTax()
--- Charge manual tax apart from the automated ones using this export
--- @param table { amount: number, type: string ['cash', 'bank' ...], taxtype: string ['food' ...] }
--- @return boolean
exports["cad-tax"]:ChargeTax(source, data)
```

# Setup Logs

> For qb logs
- Add below code in `qb-smallresources/server/logs.lua`
```lua
['cadtax'] = 'PUT_WEBHOOK_HERE',
```

> For ox logs
- Refer [Overextended Docs](https://overextended.dev/ox_lib/Modules/Logger/Server)
