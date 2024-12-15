if GetResourceState('qb-houses') == 'started' or GetResourceState('qs-housing') == 'started' then
    Config.PropertySQL = {
        query = 'SELECT * FROM player_houses',
        identifier = 'citizenid'
    }
elseif GetResourceState('ps-housing') == 'started' then
    Config.PropertySQL = {
        query = 'SELECT * FROM properties',
        identifier = 'owner_citizenid'
    }
elseif GetResourceState('nolag_properties') == 'started' then
    Config.PropertySQL = {
        query = 'SELECT * FROM properties_owners',
        identifier = 'identifier'
    }
end