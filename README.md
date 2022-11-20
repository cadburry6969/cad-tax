# cad-tax

A Simple QBCore Tax System

# Installation

* First add this to resources folder and ensure in `server.cfg`
* Change Config values in `cad-tax/shared.lua` to your liking.
* Done

# Server Exports

```lua
exports["cad-tax"]:GetCurrentTax(src, type)    -- Get Current Tax percent for the type ["vehicle", "house", "income"]
exports["cad-tax"]:PlayersTax() -- Run this tax manually
exports["cad-tax"]:CarsTax()  -- Run this tax manually
exports["cad-tax"]:HousesTax()  -- Run this tax manually
```


# Setup Logs

Add this in your `qb-smallresources/server/logs.lua`

`['cadtax'] = 'PUT_WEBHOOK_HERE',`
