local config = require 'sh_config'

local function isNearCityhall()
    local pedCoords = GetEntityCoords(cache.ped)
    for _, cityhall in pairs(config.cityhalls) do
        local dist = #(pedCoords - vec3(cityhall.coords.x, cityhall.coords.y, cityhall.coords.z))
        if dist <= (maxDistance or 3.0) then
            return true, cityhall
        end
    end

    return false, nil
end

local function openCityhall()
    if not isNearCityhall() then return end
    SendNUIMessage({
        type = "showMenu",
        visible = true,
        jobs = config.jobs,
        licenses = config.licenses,
    })
    SetNuiFocus(true, true)
end

local function initResource()
    for k, v in pairs(config.cityhalls) do
        local modelHash = GetHashKey(v.pedModel)
        lib.requestModel(modelHash)
        ped = CreatePed(1, modelHash, v.coords.x, v.coords.y, v.coords.z-1, v.coords.w, false, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)

        if v.blip.show then
            blip = AddBlipForCoord(v.blip.coords.x, v.blip.coords.y, v.blip.coords.z)
            SetBlipSprite(blip, v.blip.id)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.9)
            SetBlipColour(blip, v.blip.color)
            SetBlipAsShortRange(blip, true)
	        BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.label)
            EndTextCommandSetBlipName(blip)
        end

        if NX.Framework == 'qbx' then
            exports.ox_target:addLocalEntity(ped, {{
                name = 'cityhall' .. k,
                icon = 'fa-solid fa-city',
                label = "Open Cityhall",
                distance = 2.0,
                onSelect = function()
                    openCityhall()
                end
            }})
        elseif NX.Framework == 'qb' then
            exports['qb-target']:AddTargetEntity(ped, {
                options = {
                  {
                    icon = "fas fa-city",
                    label = "Open Cityhall",
                    action = function(entity)
                      openCityhall()
                    end,
                  }
                },
                distance = 2.0
            })
        end
    end
end

RegisterNuiCallback('selectJob', function(data, cb)
    lib.callback.await('nx_cityhall:server:setJob', false, data.id)
    cb('ok')
end)

RegisterNuiCallback('selectLicense', function(data, cb)
    lib.callback.await('nx_cityhall:server:giveLicense', false, data)
    cb('ok')
end)

RegisterNuiCallback('closeMenu', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    initResource()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    DeletePed(ped)
end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= cache.resource then return end
    initResource()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= cache.resource then return end
    DeletePed(ped)
end)