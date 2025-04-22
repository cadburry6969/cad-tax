function AddMoneyToAccount(amount, reason)
    if GetResourceState('snipe-banking') == 'started' then
        exports['snipe-banking']:AddMoneyToAccount(Config.TaxesAccount.accountName, amount)
        -- exports['snipe-banking']:CreateJobTransactions(Config.TaxesAccount.accountName, amount, reason, 'deposit', Config.TaxesAccount.playerCitizenId, Config.TaxesAccount.accountName, true)
    elseif GetResourceState('Renewed-Banking') == 'started' then
        return exports['Renewed-Banking']:addAccountMoney(Config.TaxesAccount.accountName, amount)
    elseif GetResourceState('qb-banking') == 'started' then
        local status, business = pcall(function() return exports['qb-banking']:business(Config.TaxesAccount.accountName, Config.TaxesAccount.accountId) end)
        if status and business then
            return business.addBalance(amount, reason)
        else
            return exports['qb-banking']:AddMoney(Config.TaxesAccount.accountName, amount, reason) or false
        end
        return business or false
    elseif GetResourceState('okokBanking') == 'started' then
        return exports['okokBanking']:AddMoney(Config.TaxesAccount.accountName, amount)
    elseif GetResourceState('tgg-banking') == 'started' then
        return exports['tgg-banking']:AddSocietyMoney(Config.TaxesAccount.accountName, amount)
    elseif GetResourceState('fd_banking') == 'started' then
        return exports['tgg-banking']:AddMoney(Config.TaxesAccount.accountName, amount, reason)
    else
        print("NO BANKING CONFIGURED")
        return false
    end
end
