RegisterServerEvent('ultrax:gym:buyMembership', function(days)
    exports.ox_inventory:AddItem(source, 'karnet_gym', 1, {dueto = days})
end)


local function playerMemberships()
    local xPlayers = ESX.GetExtendedPlayers() -- Returns all xPlayers
    for _, xPlayer in pairs(xPlayers) do
        itemLoop(xPlayer.source)
    end
end

itemLoop = function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local karnety = exports.ox_inventory:GetSlotsWithItem(source, 'karnet_gym', {dueto}, false)

    for k,v in ipairs(karnety) do

        if v.metadata.dueto ~= "WYCZERPANY" and v.metadata.dueto > 0 then

            if (v.metadata.dueto - 1) == 0 then
                exports.ox_inventory:SetMetadata(source, v.slot, {dueto = "WYCZERPANY"})
            else
                exports.ox_inventory:SetMetadata(source, v.slot, {dueto = (v.metadata.dueto-1)})
            end
        end

    end

    exports.ox_inventory:syncinv(source)

end


lib.cron.new('0 0 * * *', function(task, date)
    playerMemberships()
end)

RegisterServerEvent('ultrax:gym:renewMembership', function(days,price,data,slot)
    print(slot.slot)
    local xPlayer = ESX.GetPlayerFromId(source)
    local cash = exports.pefcl:getCash(source)
    local slot = slot.slot
    if cash.data >= price then
        exports.ox_inventory:SetMetadata(source, slot, {dueto = days})
        xPlayer.showNotification('Przedłużyłeś karnet, miłego korzystania z siłowni!', 4000, 'success')
    else
        xPlayer.showNotification("Brakuje Ci gotówki aby przedłużyć karnet o: "..days..' dni. ('..price..'$)')
    end
end)