local Players = {}
local Jobs = {}

CreateThread(function ()
    local players = ESX.GetExtendedPlayers()

    for _, xPlayer in next, players do
        Players[xPlayer.source] = {
            name = xPlayer.getName(),
            job = xPlayer.getJob().name,
            type = "default",
            hasTracker = xPlayer.hasItem(Config.Item)
        }
    end
end)

RegisterNetEvent("esx:playerLoaded", function(source, xPlayer)
    local xPlayer = xPlayer
    local source = source

    if not xPlayer then
        return
    end

    Players[source] = {
        name = xPlayer.getName(),
        job = xPlayer.getJob().name,
        type = "default",
        hasTracker = xPlayer.hasItem(Config.Item)
    }
end)

RegisterNetEvent("playerDropped", function()
    local source = source

    if not Players[source] then
        return
    end

    local jobName = Players[source].job

    if jobName and Jobs[jobName] then
        Jobs[jobName][source] = nil
    end

    Players[source] = nil
end)

RegisterNetEvent("esx:setJob", function(source, job, lastJob)
    local source = source

    if not Players[source] then
        return
    end

    Players[source].job = job.name

    if Jobs[lastJob.name] then
        Jobs[lastJob.name][source] = nil
    end
end)

RegisterNetEvent("esx:onAddInventoryItem", function(source, name, count)
    local source = source

    if name ~= Config.Item or not Players[source] then
        return
    end

    if count and count > 0 then
        if Players[source] then
            Players[source].hasTracker = true
        end
    end
end)

RegisterNetEvent("esx:onRemoveInventoryItem", function(source, name, count)
    local source = source

    if name ~= Config.Item or not Players[source] then
        return
    end

    if count and count == 0 then
        if Players[source] then
            local jobName = Players[source].job

            if jobName and Jobs[jobName] then
                Jobs[jobName][source] = nil
                Players[source].hasTracker = false
            end
        end
    end
end)

RegisterNetEvent("esx:onPlayerDeath", function()
    local source = source

    if not Players[source] then
        return
    end

    Players[source].type = "dead"
end)

RegisterNetEvent("esx:onPlayerSpawn", function()
    local source = source

    if not Players[source] then
        return
    end

    Players[source].type = "default"
end)

RegisterNetEvent("esx:enteredVehicle", function(plate, seat, displayName, netId)
    local source = source
    
    if not Players[source] then
        return
    end

    local p = promise.new()

    ESX.GetVehicleType(GetEntityModel(NetworkGetEntityFromNetworkId(netId)), source, function(vehicleType)
        p:resolve(vehicleType)
    end)

    local vehicleType = Citizen.Await(p)

    Players[source].type = vehicleType
end)

RegisterNetEvent("esx:exitedVehicle", function(plate, seat, displayName, netId)
    local source = source

    if not Players[source] then
        return
    end

    Players[source].type = "default"
end)

CreateThread(function()
    while true do
        Wait(6000)

        for playerId, data in next, Players do
            local playerPed = GetPlayerPed(playerId)

            if not data.hasTracker or data.job == "unemployed" then
                goto continue
            end

            Jobs[data.job] = Jobs[data.job] or {}

            Jobs[data.job][playerId] = {
                name = data.name,
                type = data.type,
                coords = GetEntityCoords(playerPed),
                visible = IsEntityVisible(playerPed)
            }

            ::continue::
        end

        for jobName, tracker in next, Jobs do
            for playerId, data in next, tracker do
                TriggerLatentClientEvent("senora_tracker:update", playerId, 9999, tracker)
            end
        end
    end
end)
