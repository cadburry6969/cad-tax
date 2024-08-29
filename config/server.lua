Config = {}

Config.Locale = 'en' -- 'en'
Config.Notify = 'ox' -- 'qb', 'qb-phone', 'ox', 'snappy-phone'
Config.Logger = 'qb' -- 'qb', 'ox'

-- Enable/Disable the taxes
Config.TaxStatus = {
    income = true,
    vehicle = true,
    property = true
}

Config.IncomeTax = {
    -- { bracket = 'NAME', amount = THRESHOLD_AMOUNT, percentage = 0-100% (decimal allowed) },
    { bracket = 'low', amount = 100000, percentage = 5 },
    { bracket = 'medium', amount = 250000, percentage = 10 },
    { bracket = 'high', amount = 500000, percentage = 15 },
    { bracket = 'ultra', amount = 1000000, percentage = 20 },
    { bracket = 'extreme', amount = 2000000, percentage = 25 },
}
Config.IncomeTaxStandard = 100 -- standard amount if does not meet any tax bracket
Config.IncomeTaxInterval = 60 -- in minutes

Config.VehicleTax = 100 -- $100 per car
Config.VehicleTaxInterval = 120 -- in minutes

Config.PropertyTax = 500 -- $500 per property
Config.PropertyTaxInterval = 120 -- in minutes

-- account where all the taxes will go to
Config.TaxesAccountEnabled = false
Config.TaxesAccount = {
    accountType = 'business', -- 'business' or 'player'
    playerCitizenId = 'XX1111', -- player citizenid (only for player account)
    business_name = 'state', -- 'businessName' (only for business account)
    business_id = 1 -- -- 'businessId' (only for business account)
}

-- citizen ids mentioned here will not have to pay any taxes
Config.TaxesFreeIdentifiers = {
    ["AHJ95674"] = true
}