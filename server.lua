local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
fisH = {}
Tunnel.bindInterface("puzzle_fisher",fisH)
config = module("puzzle_fisher","config")
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
local catchedFish = ""

function fisH.checkAndPay(check, pay)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		
		catchedFish = config.peixes[math.random(#config.peixes)].x

		if check == true then
			if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(catchedFish) <= vRP.getInventoryMaxWeight(user_id) then
				if vRP.tryGetInventoryItem(user_id,config.required,1) then
					return true
				end
			end
		end
		
		if pay == true then
			vRP.giveInventoryItem(user_id,catchedFish,1)
			return true
		end

	end
end