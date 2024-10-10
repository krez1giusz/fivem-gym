CreateThread(function()
	initGym()
	exports.ox_inventory:displayMetadata('dueto', 'Ważność ')

end)


initGym = function()

	for k,v in pairs(Ultrax.Gym) do
		for i=1, #v.Loc do
			exports.ox_target:addBoxZone({
		 		coords = vec3(v.Loc[i].x,v.Loc[i].y,v.Loc[i].z+1.0),
		 		radius = 2.5,
		 		debug = false,
		 		options ={{ 
					name = v.Target.name..'_'..i,
                    onSelect = function()
						local action = v.Action
						local loc = v.Loc[i]
						local time = v.Time
						local progress = v.progressLabel
						local scenario = v.scenario
						local statPoints = v.statPoints
						local haskarnet = getMemberShip()
						if haskarnet then
							startWorkOut(action, loc,time,progress,scenario,statPoints)
						else
							ESX.ShowNotification('Nie posiadasz czynnego karnetu na siłowni... Zajrzyj do recepcji',4000,'error')
						end
                        -- startWorkOut(v.Action, v.Loc[i],v.Time,v.progressLabel,v.scenario,v.statPoints)
                    end,
					icon = "fa-solid fa-dumbbell",
					label = v.Target.Label
				}},
		  	})
		end
	end

end


getMemberShip = function()
	local karnet = exports.ox_inventory:Search('slots', 'karnet_gym')
	for k,v in pairs(karnet) do
		if v.metadata.dueto ~= "WYCZERPANY" and v.metadata.dueto > 0 then
			return true
		else
			return false
		end
	end

	return false
end


startWorkOut = function(workout, coords,time,progLabel,anim,stats)

	if performing then 
		return
	end

	performing = true
	TaskPedSlideToCoord(PlayerPedId(), coords.x,coords.y,coords.z, coords.w, 1000)
	Wait(3000)

	if lib.progressBar({
		duration = time,
		label = progLabel,
		useWhileDead = false,
		canCancel = true,
		disable = {
			car = true,
		},
		anim = {
			scenario = anim
		},
	}) then workOutCompleted(workout,stats) else cancelAnim() end
end

workOutCompleted = function(workout,stats)


	ClearAreaOfObjects(GetEntityCoords(PlayerPedId()), 0.4, 0)


	if workout == 'Pullup' then
		exports.esx_skillz:uSkill('strength', stats)
		print('dodaje: '..stats..' pkt. statystyk siły')
	elseif workout == 'biceps' then
		exports.esx_skillz:uSkill('strength', stats)
		print('dodaje: '..stats..' pkt. statystyk siły')
	elseif workout == 'pompki' then
		exports.esx_skillz:uSkill('strength', stats)
		print('dodaje: '..stats..' pkt. statystyk siły')
	elseif workout == 'yoga' then
		TriggerEvent('esx_status:remove', 'stres', stats)
		print('usuwam: '..stats..' punktów stresu')
	elseif workout == 'brzuszki' then
		exports.esx_skillz:uSkill('strength', stats)
		print('dodaje: '..stats..' pkt. statystyk siły')
	end
	performing = false
end

cancelAnim = function()
	ClearPedTasks(PlayerPedId())
	ESX.ShowNotification('Ćwiczenie przerwane...', 4000, 'info')
end

RegisterNetEvent('ultrax:gym:membership', function()
	lib.registerContext({
		id = 'gym_menu',
		title = 'Siłownia',
		options = {
			{
				title = 'Karnety',
				description = 'Kup karnet na siłownię',
				icon = 'fa-regular fa-id-card',
				onSelect = function()
					membershipMenu()
				end,
			},
			{
				title = 'Sklep',
				description = 'Potrzebujesz przedtreningówki lub napoju?',
				icon = 'fa-solid fa-basket-shopping',
				onSelect = function()
					shopMenu()
				end,
			},
		}
	})
	lib.showContext('gym_menu')
end)

membershipMenu = function()
	lib.registerContext({
		id = 'gym_karnety',
		title = 'Karnety',
		options = {
			{
				title = 'Karnet 2-dniowy ( 500 $ )',
				description = 'Chcesz się sprawdzić? 2-dniowy karnet to idealna opcja!',
				icon = 'fa-regular fa-id-card',
				onSelect = function()
					proceedMemberShip(2)
				end,
			},
			{
				title = 'Karnet 7-dniowy ( 1000 $ )',
				description = 'Jesteś tymczasowo w mieście i potrzebujesz miejsca do ćwiczeń?',
				icon = 'fa-solid fa-basket-shopping',
				onSelect = function()
					proceedMemberShip(7)
				end,
			},
			{
				title = 'Karnet miesięczny ( 1500 $ )',
				description = 'Przeznaczony dla wyjadaczy żelastwa...',
				icon = 'fa-solid fa-basket-shopping',
				onSelect = function()
					proceedMemberShip(31)
				end,
			},
		}
	})
	lib.showContext('gym_karnety')
end


proceedMemberShip = function(due)
	local ms = Ultrax.memberShips[due]
	local msPrice = ms.Price
	ESX.TriggerServerCallback('ultrax:engine:checkCash', function(has)
		if has then
			TriggerServerEvent('ultrax:gym:buyMembership', due)
		else
			ESX.ShowNotification("Nie posiadasz wystarczającej ilości gotówki w portfelu... ("..msPrice.."$)", 4000, 'error')
		end
	end, msPrice) 
end

-- RegisterCommand('inv', function()
-- 	local inv = ESX.GetPlayerData().inventory
-- 	print(json.encode(inv))
-- 	for i=1, #inv do
-- 		print(json.encode(inv[i]))

-- 		if inv[i].metadata.dueto ~= nil and inv[i].name == 'karnet_gym' then
-- 			print('Usuwam o jeden dzień')
-- 			inv[i].metadata.dueto = inv[i].metadata.dueto - 1
-- 		end

-- 	end
-- end)

-- RegisterNetEvent("ultrax:gyms:updateMemberships", function()
-- 	local inv = ESX.GetPlayerData().inventory
-- 	print(json.encode(inv))

-- end)
local point = lib.points.new({
    coords = vec3(-1207.66015625, -1571.0903320312, 3.5633964538574),
    distance = 3.0,
    dunak = 'nerd',
})
 
function point:onEnter()
	inZone = not inZone
end
 
function point:onExit()
	inZone = not inZone
end



RegisterNetEvent('ultrax:gym:renewMembership', function(data,slot)
	local dueto = slot.metadata.dueto
	if not inZone then
		ESX.ShowNotification("Nie znajdujesz się w pobliżu recepcji...", 4000, 'info')
		return
	end

	if dueto == 'WYCZERPANY' then
		


		lib.registerContext({
			id = 'renew_karnet',
			title = 'Siłownia',
			options = {
				{
					title = '2 Dni',
					description = 'Przedłuż karnet o 2 dni ('..Ultrax.memberShips[2].Price..'$)',
					icon = 'fa-regular fa-id-card',
					onSelect = function()
						TriggerServerEvent('ultrax:gym:renewMembership', 2,Ultrax.memberShips[2].Price,data, slot)
					end,
				},
				{
					title = '7 Dni',
					description = 'Przedłuż karnet o 7 dni ('..Ultrax.memberShips[7].Price..'$)',
					icon = 'fa-regular fa-id-card',
					onSelect = function()
						TriggerServerEvent('ultrax:gym:renewMembership', 7,Ultrax.memberShips[7].Price,data, slot)
					end,
				},
				{
					title = '31 Dni',
					description = 'Przedłuż karnet o 31 dni ('..Ultrax.memberShips[31].Price..'$)',
					icon = 'fa-regular fa-id-card',
					onSelect = function()
						TriggerServerEvent('ultrax:gym:renewMembership', 31,Ultrax.memberShips[31].Price, data, slot)
					end,
				},
			}
		})
		lib.showContext('renew_karnet')
	end


end)

shopMenu = function()
	exports.ox_inventory:openInventory('shop', { type = 'Silownia' })

end


