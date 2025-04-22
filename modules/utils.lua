function Notification(src, msg)
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

function SendLog(src, msg)
    if Config.Logger == 'qb' then
        TriggerEvent("qb-log:server:CreateLog", "cadtax", msg)
    elseif Config.Logger == 'ox' and lib and lib?.logger then
        lib.logger(src, 'cadtax', msg)
    end
end