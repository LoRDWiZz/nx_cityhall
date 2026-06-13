NX = {}

local function getFramework()
    if GetResourceState('qbx_core') == 'started' then
        return 'qbx'
    elseif GetResourceState('qb-core') == 'started' then
        QBCore = exports['qb-core']:GetCoreObject()
        return 'qb'
    end
end

NX.Framework = getFramework()

function NX.Notify(source, text, type)
    if NX.Framework == 'qbx' then
        return exports.qbx_core:Notify(source, text, type)
    elseif NX.Framework == 'qb' then
        return TriggerClientEvent('QBCore:Notify', source, text, type)
    end
end

function NX.GetPlayer(source)
    if NX.Framework == 'qbx' then
        return exports.qbx_core:GetPlayer(source)
    elseif NX.Framework == 'qb' then
        return QBCore.Functions.GetPlayer(source)
    end
end

function NX.SetJob(source, job, grade)
    if NX.Framework == 'qbx' then
        return exports.qbx_core:SetJob(source, job, grade)
    elseif NX.Framework == 'qb' then
        local Player = NX.GetPlayer(source)
        return Player.Functions.SetJob(job, grade)
    end
end

function NX.RemoveMoney(source, type, amount)
    if NX.Framework == 'qbx' then
        return exports.qbx_core:RemoveMoney(source, type, amount)
    elseif NX.Framework == 'qb' then
        local Player = NX.GetPlayer(source)
        return Player.Functions.RemoveMoney(type, amount)
    end
end

function NX.AddItem(source, item, amount)
    if NX.Framework == 'qbx' then
        return exports.qbx_idcard:CreateMetaLicense(source, item)
    elseif NX.Framework == 'qb' then
        local Player = NX.GetPlayer(source)
        local info = {}
        if item == 'id_card' then
            info.citizenid = Player.PlayerData.citizenid
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.gender = Player.PlayerData.charinfo.gender
            info.nationality = Player.PlayerData.charinfo.nationality
        elseif item == 'driver_license' then
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.type = 'Class C Driver License'
        elseif item == 'weaponlicense' then
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
        end
        TriggerClientEvent('qb-inventory:client:ItemBox', source, QBCore.Shared.Items[item], 'add')
        return exports['qb-inventory']:AddItem(source, item, amount, false, info, 'nx_cityhall:addItem')
    end
end