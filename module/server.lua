local QBCore = exports['qb-core']:GetCoreObject()

local function addMoneyToAccount(amount, text)
    if not Config.TaxesAccountEnabled then return end
    if Config.TaxesAccount.accountType == 'business' then
        local business = exports['qb-banking']:business(Config.TaxesAccount.name, Config.TaxesAccount.business_id)
        if business then business.addBalance(amount, text) end
    elseif Config.TaxesAccount.accountType == 'player' then
        local onlinePlayer = QBCore.Functions.GetPlayerByCitizenId(Config.TaxesAccount.playerCitizenId)
        if onlinePlayer then
            onlinePlayer.Functions.SetMoney('bank', amount, text)
        else
            local offlinePlayer = QBCore.Functions.GetOfflinePlayerByCitizenId(Config.TaxesAccount.playerCitizenId)
            offlinePlayer.Functions.SetMoney('bank', amount, text)
        end
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
        local player = QBCore.Functions.GetPlayer(src)
        if not player then return end
        exports['qb-phone']:sendNewMailToOffline(player.PlayerData.citizenid, {
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
    end
end

local function sendLog(src, msg)
    if Config.Logger == 'qb' then
        TriggerEvent("qb-log:server:CreateLog", "cadtax", msg)
    elseif Config.Logger == 'ox' then
        lib.logger(src, 'cadtax', msg)
    end
end

function PlayersTax()
    local accountAmount = 0
    local players = QBCore.Functions.GetQBPlayers()
    for src in pairs(players) do
        local player = QBCore.Functions.GetPlayer(src)
        if player then
            local citizenid = player.PlayerData.citizenid
            local playerCash = player.PlayerData.money.cash
            local playerBank = player.PlayerData.money.bank
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
            player.Functions.RemoveMoney(taxInfo.type, taxInfo.amount, "incometax")
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
    local players = QBCore.Functions.GetQBPlayers()
    MySQL.query('SELECT * FROM player_vehicles', {}, function(vehicles)
        for src in pairs(players) do
            local player = QBCore.Functions.GetPlayer(src)
            if player then
                local vehicleCount = 0
                local citizenid = player.PlayerData.citizenid
                if isTaxWaivedOff(citizenid) then goto skip end
                for i = 1, #vehicles, 1 do
                    if citizenid == vehicles[i].citizenid then
                        vehicleCount = vehicleCount + 1
                    end
                end
                if vehicleCount > 0 then
                    local tax = math.floor(vehicleCount * Config.VehicleTax)
                    player.Functions.RemoveMoney("bank", tax, "vehicletax")
                    accountAmount = accountAmount + tax
                    notification(player.PlayerData.source, string.format(Language('vehicle_taxed'), tax))
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
    local players = QBCore.Functions.GetQBPlayers()
    MySQL.query('SELECT * FROM player_houses', {}, function(properties)
        for src in pairs(players) do
            local propertyCount = 0
            local player = QBCore.Functions.GetPlayer(src)
            if player then
                local citizenid = player.PlayerData.citizenid
                if isTaxWaivedOff(citizenid) then goto skip end
                for i = 1, #properties, 1 do
                    if citizenid == properties[i].citizenid then
                        propertyCount = propertyCount + 1
                    end
                end
                if propertyCount > 0 then
                    local tax = math.floor(propertyCount * Config.PropertyTax)
                    player.Functions.RemoveMoney("bank", tax, "housetax")
                    accountAmount = accountAmount + tax
                    notification(player.PlayerData.source, string.format(Language('property_taxed'), tax))
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
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return false end
    if taxtype == 'income' then
        local playerCash = player.PlayerData.money.cash
        local playerBank = player.PlayerData.money.bank
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

-- Exports
exports('GetCurrentTax', GetCurrentTax)
exports('PlayersTax', PlayersTax)
exports('PropertiesTax', PropertiesTax)
exports('VehiclesTax', VehiclesTax)
exports('IsTaxWaivedOff', isTaxWaivedOff)

-- Old Exports
exports('HousesTax', PropertiesTax)
exports('CarsTax', VehiclesTax)

-- Wait for server to load properly then execute the taxes
SetTimeout(30000, function()
    if Config.TaxStatus.income then PlayersTax() end
    if Config.TaxStatus.vehicle then VehiclesTax() end
    if Config.TaxStatus.property then PropertiesTax() end
end)
