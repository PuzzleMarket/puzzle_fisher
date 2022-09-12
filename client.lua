local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
fisH = Tunnel.getInterface("puzzle_fisher")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
config = module("puzzle_fisher","config")
local processo = false
local segundos = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROCESSO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local idle = 1000
		if not processo then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			for k,v in pairs(config.locais) do
				local distance = Vdist(x,y,z,v[1],v[2],v[3])
				if distance <= 10 then
					idle = 5
					DrawMarker(27,v[1],v[2],v[3]-0.9,0,0,0,0,180.0,130.0,1.0,1.0,1.0,250,100,50,200,0,0,0,1)
					if distance <= 1.2 then
						idle = 5
						drawTxt("PRESSIONE  ~r~E~w~  PARA ~y~PESCAR ~r~( REQ.: 1x ISCA )",4,0.5,0.90,0.50,255,255,255,200)
						if IsControlJustPressed(0,38) and not IsPedInAnyVehicle(ped) then
							if fisH.checkAndPay(true, false) then

							processo = true
							segundos = config.fishDuration
							TriggerEvent("countDown",segundos)

							SetEntityCoords(ped,v[1],v[2],v[3]-1)
							SetEntityHeading(ped,v[4])
							if not IsEntityPlayingAnim(ped,"amb@world_human_stand_fishing@base","base",3) then
								vRP._CarregarObjeto("amb@world_human_stand_fishing@base","base","prop_fishing_rod_01",15,60309)
							end

							TriggerEvent("progress", segundos * 1000,"Pescando")
							TriggerEvent('cancelando',true)

							SetTimeout(segundos * 1000, function()
								fisH.checkAndPay(false, true)
								PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
							end)

							end
						end
					end
				end
			end
		end
	Citizen.Wait(idle)
	end
end)

RegisterNetEvent('countDown')
AddEventHandler('countDown',function(segundos)
	repeat
		Citizen.Wait(1000)
		segundos = segundos - 1
		if segundos == 0 then
			TriggerEvent('cancelando',false)
			ClearPedTasks(PlayerPedId())
			vRP._DeletarObjeto()
			processo = false
		end
	until segundos == 0
end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(1000)
-- 		if segundos > 0 then
-- 			segundos = segundos - 1
-- 			if segundos == 0 then
-- 				processo = false
-- 				if not IsEntityPlayingAnim(PlayerPedId(),"amb@world_human_stand_fishing@idle_a","idle_c",3) then
-- 					vRP._stopAnim(false)
-- 					vRP._DeletarObjeto()
-- 				end
-- 				TriggerEvent('cancelando',false)
-- 			end
-- 		end
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end