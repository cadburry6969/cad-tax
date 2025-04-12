local function addMoneyToAccount(amount, reason)
    if not Config.TaxesAccountEnabled then return end
    if Config.TaxesAccount.accountType == 'business' then
        AddMoneyToAccount(amount, reason)
    elseif Config.TaxesAccount.accountType == 'player' then
        AddMoneyToOfflinePlayer(amount, reason)
    end
end

local function isTaxWaivedOff(citizenid)
    return Config.TaxesFreeIdentifiers[citizenid]
end

local function notification(src, msg)
    if Config.Notify == 'qb' then
        TriggerClientEvent("QBCore:Notify", src, msg, nil, 10000)
    elseif Config.Notify == 'ox' then
        TriggerClientEvent("ox_lib:notify", src, { description = msg, duration = 10000 })
    elseif Config.Notify == 'qb-phone' then
        local player = GetPlayer(src)
        if not player then return end
        exports['qb-phone']:sendNewMailToOffline(player.citizenid, {
            sender = Language('notify_header'),
            subject = Language('notify_subject'),
            message = msg,
        })
    elseif Config.Notify == 'snappy-phone' then
        TriggerClientEvent('phone:client:notification', src, {
            title = Language('notify_header'),
            icon = 'wallet',
            description = msg,
            duration = 10000,
        })
    elseif Config.Notify == 'yseries' then
        exports.yseries:SendNotification({
            app = 'ypay',
            title = Language('notify_header'),
            text = msg,
            timeout = 10000,
        }, 'source', src)
    elseif Config.Notify == 'lb-phone' then
        exports["lb-phone"]:SendNotification(src, {
            app = "Settings",
            title = Language('notify_header'),
            content = msg,
        })
    end
end

local function sendLog(src, msg)
    if Config.Logger == 'qb' then
        TriggerEvent("qb-log:server:CreateLog", "cadtax", msg)
    elseif Config.Logger == 'ox' and lib and lib?.logger then
        lib.logger(src, 'cadtax', msg)
    end
end

function PlayersTax()
    local accountAmount = 0
    local players = GetAllPlayers()
    for src, player in pairs(players) do
        if player then
            local citizenid = player.citizenid
            local playerCash = player.cash
            local playerBank = player.bank
            local taxInfo = nil
            if isTaxWaivedOff(citizenid) then goto skip end
            for _, tax in pairs(Config.IncomeTax) do
                if (playerCash > tax.amount) then
                    local _amount = math.floor(playerCash * (tax.percentage / 100))
                    taxInfo = { type = 'cash', amount = _amount, percentage = tax.percentage }
                end
                if (playerBank > tax.amount) then
                    local _amount = math.floor(playerBank * (tax.percentage / 100))
                    taxInfo = { type = 'bank', amount = _amount, percentage = tax.percentage }
                end
            end
            if not taxInfo then
                taxInfo = { type = 'bank', amount = Config.IncomeTaxStandard }
            end
            player.removeMoney(taxInfo.type, taxInfo.amount, "incometax")
            accountAmount = accountAmount + taxInfo.amount
            notification(src, string.format(Language('player_taxed'), taxInfo.percentage, taxInfo.amount))
            sendLog(src, string.format(Language('player_taxed_log'), citizenid, taxInfo.amount))
        end
        ::skip::
    end
    accountAmount = math.floor(accountAmount)
    addMoneyToAccount(accountAmount, string.format(Language('player_tax_recieved'), accountAmount))
    SetTimeout(Config.IncomeTaxInterval * (60 * 1000), PlayersTax)
end

function VehiclesTax()
    local accountAmount = 0
    local players = GetAllPlayers()
    MySQL.query(Config.VehicleSQL.query, {}, function(vehicles)
        for src, player in pairs(players) do
            if player then
                local vehicleCount = 0
                local citizenid = player.citizenid
                if isTaxWaivedOff(citizenid) then goto skip end
                for i = 1, #vehicles, 1 do
                    if citizenid == vehicles[i][Config.VehicleSQL.identifier] then
                        vehicleCount = vehicleCount + 1
                    end
                end
                if vehicleCount > 0 then
                    local tax = math.floor(vehicleCount * Config.VehicleTax)
                    player.removeMoney("bank", tax, "vehicletax")
                    accountAmount = accountAmount + tax
                    notification(player.source, string.format(Language('vehicle_taxed'), tax))
                    sendLog(src, string.format(Language('vehicle_taxed_log'), citizenid, tax))
                end
            end
            ::skip::
        end
        accountAmount = math.floor(accountAmount)
        addMoneyToAccount(accountAmount, string.format(Language('vehicle_tax_recieved'), accountAmount))
    end)
    SetTimeout(Config.VehicleTaxInterval * (60 * 1000), VehiclesTax)
end

function PropertiesTax()
    local accountAmount = 0
    local players = GetAllPlayers()
    MySQL.query(Config.PropertySQL.query, {}, function(properties)
        for src, player in pairs(players) do
            local propertyCount = 0
            if player then
                local citizenid = player.citizenid
                if isTaxWaivedOff(citizenid) then goto skip end
                for i = 1, #properties, 1 do
                    if citizenid == properties[i][Config.PropertySQL.identifier] then
                        propertyCount = propertyCount + 1
                    end
                end
                if propertyCount > 0 then
                    local tax = math.floor(propertyCount * Config.PropertyTax)
                    player.removeMoney("bank", tax, "housetax")
                    accountAmount = accountAmount + tax
                    notification(player.source, string.format(Language('property_taxed'), tax))
                    sendLog(src, string.format(Language('property_taxed_log'), citizenid, tax))
                end
            end
            ::skip::
        end
        accountAmount = math.floor(accountAmount)
        addMoneyToAccount(accountAmount, string.format(Language('property_tax_recieved'), accountAmount))
    end)
    SetTimeout(Config.PropertyTaxInterval * (60 * 1000), PropertiesTax)
end

function GetCurrentTax(src, taxtype)
    local player = GetPlayer(src)
    if not player then return false end
    if taxtype == 'income' then
        local playerCash = player.cash
        local playerBank = player.bank
        local taxAmount = nil
        for _, tax in pairs(Config.IncomeTax) do
            if (playerCash >= tax.amount) and (not taxAmount) then
                taxAmount = tax.amount
            end
            if (playerBank >= tax.amount) and (not taxAmount) then
                taxAmount = tax.amount
            end
        end
        return taxAmount or 100
    elseif taxtype == 'vehicle' then
        return Config.VehicleTax
    elseif taxtype == 'house' or taxtype == 'property' then
        return Config.PropertyTax
    end
end

function ChargeTax(source, data)
    local amount, accountType, taxdata = data.amount, data.type, Config.OtherTax[data?.taxtype]
    if not source or not amount or not taxdata then return false end
    local player = GetPlayer(source)
    if not player then return false end
    local _amount = math.floor(amount * (taxdata.percentage / 100))
    return player.removeMoney(accountType or 'bank', _amount, taxdata.label)
end

-- Exports
exports('GetCurrentTax', GetCurrentTax)
exports('PlayersTax', PlayersTax)
exports('PropertiesTax', PropertiesTax)
exports('VehiclesTax', VehiclesTax)
exports('IsTaxWaivedOff', isTaxWaivedOff)
exports('ChargeTax', ChargeTax)

-- Old Exports
exports('HousesTax', PropertiesTax)
exports('CarsTax', VehiclesTax)

-- Wait for server to load properly then execute the taxes
SetTimeout(Config.TaxStatusStartDelay * 1000, function()
    if Config.TaxStatus.income then PlayersTax() end
    if Config.TaxStatus.vehicle then VehiclesTax() end
    if Config.TaxStatus.property then PropertiesTax() end
end)
