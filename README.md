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
exports["cad-tax"]:GetCurrentTax(src, type)    -- Get Current Tax percent for the type ["vehicle", "property", "house", "income"]
exports["cad-tax"]:IsTaxWaivedOff(citizenid) -- Check the player has tax waived off
exports["cad-tax"]:PlayersTax() -- To start manually
exports["cad-tax"]:VehiclesTax()  -- To start manually
exports["cad-tax"]:PropertiesTax()  -- To start manually
exports["cad-tax"]:CarsTax()  -- To start manually (deprecated)
exports["cad-tax"]:HousesTax()  -- To start manually (deprecated)
```

# Setup Logs

> For qb logs
- Add below code in `qb-smallresources/server/logs.lua`
```lua
['cadtax'] = 'PUT_WEBHOOK_HERE',
```

> For ox logs
- Refer [Overextended Docs](https://overextended.dev/ox_lib/Modules/Logger/Server)
