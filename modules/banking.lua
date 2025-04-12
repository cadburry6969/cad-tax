function AddMoneyToAccount(amount, reason)
    if GetResourceState('snipe-banking') == 'started' then
        exports['snipe-banking']:AddMoneyToAccount(Config.TaxesAccount.accountName, amount)
        -- exports['snipe-banking']:CreateJobTransactions(Config.TaxesAccount.accountName, amount, reason, 'deposit', Config.TaxesAccount.playerCitizenId, Config.TaxesAccount.accountName, true)
    elseif GetResourceState('Renewed-Banking') == 'started' then
        return exports['Renewed-Banking']:addAccountMoney(Config.TaxesAccount.accountName, amount)
    elseif GetResourceState('qb-banking') == 'started' then
        local business = exports['qb-banking']:AddMoney(Config.TaxesAccount.accountName, amount, reason)
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
