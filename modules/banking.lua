function AddMoneyToAccount(amount, reason)
    if GetResourceState('snipe-banking') == 'started' then
        exports['snipe-banking']:AddMoneyToAccount(Config.TaxesAccount.accountName, amount)
        -- exports['snipe-banking']:CreateJobTransactions(Config.TaxesAccount.accountName, amount, reason, 'deposit', Config.TaxesAccount.playerCitizenId, Config.TaxesAccount.accountName, true)
    elseif GetResourceState('Renewed-Banking') == 'started' then
        return exports['Renewed-Banking']:addAccountMoney(Config.TaxesAccount.accountName, amount)
    elseif GetResourceState('qb-banking') == 'started' then
        local business = exports['qb-banking']:business(Config.TaxesAccount.accountName, Config.TaxesAccount.accountId)
        return (business and business.addBalance(amount, reason)) or false
    else
        print("NO BANKING CONFIGURED")
        return false
    end
end