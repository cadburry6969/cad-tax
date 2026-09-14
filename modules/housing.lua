function GetPropertySQL()
    if GetResourceState('qb-houses') == 'started' or GetResourceState('qs-housing') == 'started' then
        return {
            query = 'SELECT * FROM player_houses',
            identifier = 'citizenid'
        }
    elseif GetResourceState('ps-housing') == 'started' then
        return {
            query = 'SELECT * FROM properties',
            identifier = 'owner_citizenid'
        }
    elseif GetResourceState('kartik-properties') == 'started' then
        return {
            query = `SELECT * FROM kp_properties WHERE owner_type = 'citizen'`,
            identifier = 'owner_id'
        }
    elseif GetResourceState('nolag_properties') == 'started' then
        return {
            query = 'SELECT * FROM properties_owners',
            identifier = 'identifier'
        }
    elseif GetResourceState('qs-housing') == 'started' then
        return {
            query = 'SELECT * FROM player_houses',
            identifier = 'citizenid'
        }
    elseif GetResourceState('qbx_properties') == 'started' then
        return {
            query = 'SELECT * FROM properties',
            identifier = 'owner'
        }
    elseif GetResourceState('sn_properties') == 'started' then
        return {
            query = 'SELECT * FROM properties',
            identifier = 'owner'
        }
    elseif GetResourceState('origen_housing') == 'started' then
        return {
            query = 'SELECT * FROM origen_housing',
            identifier = 'citizenid'
        }
    else
        return nil
    end
end