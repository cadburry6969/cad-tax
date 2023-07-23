Shared = {}

Shared.EconomyTax = {
    ['low'] = 100000,
    ['medium'] = 250000,
    ['high'] = 500000,    
    ['ultra'] = 1000000,
    ['extreme'] = 2000000,
}

Shared.EconomyTaxPercentage = {
    ['low'] = 0.1,
    ['medium'] = 0.5,
    ['high'] = 0.6,    
    ['ultra'] = 0.8,
    ['extreme'] = 1,
}

Shared.EconomyTaxInterval = 120 -- in minutes (2 hrs)

Shared.CarTaxRate = 100 -- $100 per car
Shared.CarTaxInterval = 180 -- in minutes (3hrs)

Shared.HouseTaxRate = 500 -- $500 per house 
Shared.HouseTaxInterval = 180 -- in minutes (3hrs)

-- account where all the taxes will go to
Shared.TaxesAccountEnabled = false
Shared.TaxesAccount = {
    accountType = 'business', -- 'business' or 'player'
    playerCitizenId = 'XX1111', -- player citizenid (only for player account)
    business_name = 'state', -- 'businessName' (only for business account)
    business_id = 1 -- -- 'businessId' (only for business account)
}

Shared.Lang = {
    player_tax = 'Player tax recieved $%d',
    car_tax = 'Vehicle tax recieved $%d',
    house_tax = 'House tax recieved $%d'
}