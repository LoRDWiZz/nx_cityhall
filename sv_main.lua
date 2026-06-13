local config = require 'sh_config'

local function isNearCityhall()
    local source = source
    local pedCoords = GetEntityCoords(GetPlayerPed(source))
    for _, cityhall in pairs(config.cityhalls) do
        local dist = #(pedCoords - vec3(cityhall.coords.x, cityhall.coords.y, cityhall.coords.z))
        if dist <= (maxDistance or 3.0) then
            return true, cityhall
        end
    end

    return false, nil
end

lib.callback.register('nx_cityhall:server:setJob', function(source, job)
    if not isNearCityhall() then return end
    local player = NX.GetPlayer(source)
    if not player then return end

    local exists = false
    for _, v in ipairs(config.jobs) do
        if v.id == job then
            exists = true
            break
        end
    end
    if not exists then
        NX.Notify(source, "You have new job!", 'success')
        return false
    end

    NX.SetJob(source, job, 0)
    NX.Notify(source, "You have new job!", 'success')
end)

lib.callback.register('nx_cityhall:server:giveLicense', function(source, itemData)
    if not isNearCityhall() then return end
    local player = NX.GetPlayer(source)
    if not player then return end

    local exists
    for _, v in ipairs(config.licenses) do
        if v.id == itemData.id then
            exists = v
            break
        end
    end
    if not exists then return end

    if not NX.RemoveMoney(source, 'cash', itemData.price) then
        return NX.Notify(source, "You don't have enough money", 'error')
    end

    NX.AddItem(source, itemData.item, 1)
end)