if IsDuplicityVersion() then
    Senora = {}
    Senora.PlayerLoaded = {}
    local clientScripts = {
        "client.lua",
    }
    
    Senora.ClientCode = {}
    
    for _, script in ipairs(clientScripts) do
        local filePath = string.format("./client/%s", script)
        table.insert(Senora.ClientCode, LoadResourceFile(GetCurrentResourceName(), filePath))
    end    

    RegisterNetEvent(GetCurrentResourceName().. ":loadClient_1", function()
        local src = source

        if src == -1 then
            return
        end

        if not Senora.PlayerLoaded[src] then
            Senora.PlayerLoaded[src] = true
            TriggerClientEvent(GetCurrentResourceName().. ":sendClient_1", src, Senora.ClientCode)
        else
            DropPlayer(src, "[EXPLOIT] DETECTED")
        end
    end)
else
    CreateThread(function()
        while not NetworkIsSessionStarted() do
            Wait(0)
        end

        RegisterNetEvent(GetCurrentResourceName().. ":sendClient_1", function(codes)
            for i=1, #codes do
                if not codes[i] then
                    return
                end

               assert(load(codes[i], "error"))()
            end
        end)
        
        TriggerServerEvent(GetCurrentResourceName().. ":loadClient_1")
    end)
end