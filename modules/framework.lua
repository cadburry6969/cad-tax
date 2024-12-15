if GetResourceState('qb-core') == 'started' then
local QBCore = exports['qb-core']:GetCoreObject()

Config.VehicleSQL = {
    query = 'SELECT * FROM player_vehicles',
    identifier = 'citizenid',
}

function GetAllPlayers()
    local players = {}
    for src, player in ipairs(QBCore.Functions.GetQBPlayers()) do
        players[player.PlayerData.source] = {
            source = player.PlayerData.source,
            citizenid = player.PlayerData.citizenid,
            cash = player.PlayerData.money.cash,
            bank = player.PlayerData.money.bank,
            addMoney = function(account, amount, reason)
                return player.Functions.SetMoney(account or 'bank', amount, reason)
            end,
            removeMoney = function(account, amount, reason)
                return player.Functions.RemoveMoney(account or 'bank', amount, reason)
            end
        }
    end
    return players
end

function GetPlayer(src)
    local player = QBCore.Functions.GetPlayer(src)
    return player and {
        source = player.PlayerData.source,
        citizenid = player.PlayerData.citizenid,
        cash = player.PlayerData.money.cash,
        bank = player.PlayerData.money.bank,
        addMoney = function(account, amount, reason)
            return player.Functions.SetMoney(account or 'bank', amount, reason)
        end,
        removeMoney = function(account, amount, reason)
            return player.Functions.RemoveMoney(account or 'bank', amount, reason)
        end
    }
end

function AddMoneyToOfflinePlayer(amount, reason)
    local onlinePlayer = QBCore.Functions.GetPlayerByCitizenId(Config.TaxesAccount.playerCitizenId)
    if onlinePlayer then
        onlinePlayer.Functions.SetMoney('bank', amount, reason)
    else
        local offlinePlayer = QBCore.Functions.GetOfflinePlayerByCitizenId(Config.TaxesAccount.playerCitizenId)
        offlinePlayer.Functions.SetMoney('bank', amount, reason)
    end
end

elseif GetResourceState('es_extended') == 'started' then
local ESX = exports.es_extended:getSharedObject()

Config.VehicleSQL = {
    query = 'SELECT * FROM owned_vehicles',
    identifier = 'owner',
}

function GetAllPlayers()
    local players = {}
    for _, player in ipairs(ESX.GetExtendedPlayers()) do
        players[player.source] = {
            source = player.source,
            citizenid = player.getIdentifier(),
            cash = player.getAccount('money').money,
            bank = player.getAccount('bank').money,
            addMoney = function(account, amount, reason)
                return player.addAccountMoney(account or 'bank', amount)
            end,
            removeMoney = function(account, amount, reason)
                return player.removeAccountMoney(account or 'money', amount)
            end
        }
    end
    return players
end

function GetPlayer(src)
    local player = ESX.GetPlayerFromId(src)
    return player and {
        source = player.source or source,
        citizenid = player.getIdentifier(),
        cash = player.getAccount('money').money,
        bank = player.getAccount('bank').money,
        addMoney = function(account, amount, reason)
            return player.addAccountMoney(account or 'bank', amount)
        end,
        removeMoney = function(account, amount, reason)
            return player.removeAccountMoney(account or 'money', amount)
        end
    }
end

function AddMoneyToOfflinePlayer(amount, reason)
    -- TO BE DONE
    print('ADDING MONEY FOR OFFLINE PLAYER IS STILL WORK IN PROGRESS')
end

end