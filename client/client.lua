local tracker = {}
local blips = {}

RegisterNetEvent("senora_tracker:update")
AddEventHandler("senora_tracker:update", function(newTracker)
    tracker = newTracker

    syncBlips()
end)

CreateThread(function()
    while true do
        Wait(2000)

        if not ESX.PlayerLoaded or not hasItem(Config.Item) then
            removeAllBlips()
        else
            syncBlips()
        end
    end
end)

function syncBlips()
    if ESX.PlayerData.job.name == "unemployed" then
        return removeAllBlips()
    end

    for source, v in pairs(tracker) do
        local playerId = GetPlayerFromServerId(source)

        if v.visible and playerId ~= PlayerId() then
            if NetworkIsPlayerActive(playerId) and Config.LiveSync then
                if blips[source] and not blips[source].ped then
                    RemoveBlip(blips[source].blip)
                    blips[source] = nil
                end

                if not blips[source] then
                    blips[source] = {
                        blip = AddBlipForEntity(GetPlayerPed(playerId)),
                        ped = GetPlayerPed(playerId),
                    }

                    ShowHeadingIndicatorOnBlip(blips[source].blip, Config.Blip.Settings.showHeading)
                    setBlipSettings(blips[source].blip, v.type, v.name)
                else
                    updateBlip(blips[source].blip, nil, v.type, v.name)
                end
            else
                if blips[source] and blips[source].ped then
                    RemoveBlip(blips[source].blip)
                    blips[source] = nil
                end

                if not blips[source] then
                    blips[source] = {
                        blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z),
                        ped = false
                    }

                    setBlipSettings(blips[source].blip, v.type, v.name)
                else
                    updateBlip(blips[source].blip, v.coords, v.type, v.name)
                end
            end
        else
            if blips[source] and blips[source].ped then
                RemoveBlip(blips[source].blip)
                blips[source] = nil
            elseif blips[source] and not blips[source].ped then
                RemoveBlip(blips[source].blip)
                blips[source] = nil
            end
        end
    end

    cleanUpBlips()
end

function updateBlip(blip, coords, type, name)
    if coords then
        SetBlipCoords(blip, coords.x, coords.y, coords.z)
    end

    SetBlipSprite(blip, Config.Blip.Types[type])
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
end

function setBlipSettings(blip, type, name)
    SetBlipSprite(blip, Config.Blip.Types[type])
    SetBlipColour(blip, Config.Blip.Settings.color)
    SetBlipScale(blip, Config.Blip.Settings.scale)
    SetBlipAsShortRange(blip, Config.Blip.Settings.shortRange)
    SetBlipDisplay(blip, Config.Blip.Settings.display)
    ShowCrewIndicatorOnBlip(blip, Config.Blip.Settings.showCrewIndicator)
    ShowFriendIndicatorOnBlip(blip, Config.Blip.Settings.showFriendIndicator)
    SetBlipCategory(blip, 7)
    AddTextEntry("BLIP_OTHPLYR", "GPS")
end

function cleanUpBlips()
    for source, data in pairs(blips) do
        if not tracker[source] then
            if DoesBlipExist(data.blip) then
                RemoveBlip(data.blip)
            end
            blips[source] = nil
        end
    end
end

function removeAllBlips()
    for _, data in pairs(blips) do
        if DoesBlipExist(data.blip) then
            RemoveBlip(data.blip)
        end
    end

    blips = {}
end

function hasItem(itemName)
    for _, item in pairs(ESX.GetPlayerData().inventory or {}) do
        if item.name == itemName and item.count > 0 then
            return true
        end
    end
    return false
end
