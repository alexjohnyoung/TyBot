local tyb = {}
tyb.forceclosepanels = true 
tyb.chatback = true
tyb.paused = true
tyb.strafewhenclose = false 
tyb.enableaimbot = true
tyb.emergencymodeenabled = true 
tyb.emergencymodedamage = 7
tyb.emergencymodejustlooking = false -- false = if emergency mode cant find any looking, use radius too
tyb.randomjumps = true  
tyb.randomangles = false
tyb.deactivatelowkarma = true 
tyb.meshmoveonlowkarma = true 
tyb.meshmoveafternocommands = true 
tyb.sortbyhealth = false
tyb.lowkarma = 700
tyb.blacklistedplayers = {}
tyb.folowplayerto = 140 
tyb.deadchats = true
tyb.deadchatstable = {"ffs", "that was bs", "how does that make sense", "lol ok", "ridiculous", "what was that??", "lol sure", "broken game"}
tyb.killastraitor = true 
tyb.flaregunafterkill = true
-- Configurable options
tyb.safemode = false 
tyb.jumpondamage = true 
tyb.aimbot = {} 
tyb.aimbot.smooth = true
tyb.aimbot.smoothiteration = 0.5
tyb.aimbot.closest = true -- Aimbot closest player 
tyb.aimbot.los = true
tyb.aimbot.targetsameteam = true 
tyb.aimbot.autoshoot = true
tyb.aimbot.onlylookingatme = true
tyb.aimbot.onlylookingatmedistance = 150
tyb.flashlightspam = false 
tyb.flashlightinterval = 1
tyb.fullbright = true 
tyb.render = {}
tyb.render.myview = true 
tyb.namechanger = true 
tyb.killonlowhp = true 
tyb.killonlowhphp = 8 
tyb.misc = {}
tyb.misc.insertmeshmovecmdonmesh = true 
tyb.misc.randomsay = false
tyb.alive = LocalPlayer():Alive()
tyb.starttime = nil 
tyb.announce = false 
tyb.saytimer = true 
tyb.firstcommand = 3 -- Find Weapon
tyb.changewepdelay = nil
tyb.blacklistedwep = {}
tyb.activateonnoadmin = false 
tyb.aimbotradius = 2000
tyb.followradius = 150
tyb.findwepradius = 800
tyb.thirdperson = true 
tyb.map = game.GetMap()
tyb.gamemode = "" 

tyb.paused = false 
tyb.radiusDraw = {}
tyb.myweps = {} 
tyb.myhealth = LocalPlayer():Health()
tyb.checkpositionstuck = nil 
tyb.drawtarget = nil 
tyb.checkpositionstuckreset = nil 
tyb.checkpositionstuck = false 
tyb.randompresstimer = nil 
tyb.checkpositiontime = nil 
tyb.checkpositionposition = nil 
tyb.usingradius = nil
tyb.changewepD = nil 
tyb.blacklistedwep = {}
tyb.blacklistedDoors = {} 
tyb.automaticWaypointTimer = nil 
tyb.drawwaypoints = true 

tyb.ttt = {}
tyb.ttt.radio = {"imwith", "suspect"}
tyb.ttt.possibletraitors = {}
tyb.ttt.onlyaimbotastraitor = true   
tyb.ttt.buytraitorarmor = true 
tyb.ttt.useradio = true 
tyb.ttt.targetfellowtraitors = false 
tyb.ttt.notifytraitorwep = true 
tyb.ttt.knife = true 
tyb.ttt.firsttimetraitor = false 
tyb.ttt.traitorequipment = {} 


----------------------------------------------

if IsValid(tybmenu) then tybmenu:Close() end 
if IsValid(TybRenderView) then TybRenderView:Close() end 

file.CreateDir("tyb")
file.CreateDir("tyb/mapdata")

function tyb:readfromfile()
	if file.Exists("tyb/settings.txt", "DATA") then 
		local txt = file.Read("tyb/settings.txt", "DATA")
		local json = util.JSONToTable(txt)

		chat.AddText(Color(0, 255, 0), "Settings file exists, reading..")

		if type(json) == "table" then 
			tyb = json
			chat.AddText(Color(0, 255, 0), "Settings loaded!")
		end 
	else 
		chat.AddText(color_white, "No settings file exists, loading default values")
		tyb:savetofile()

	end  
end 

function tyb:savetofile()
	file.Delete("tyb/settings.txt")
	local ourTab = table.Copy(tyb) 

	for k,v in pairs(ourTab) do 
		if k == "mapdata" or k == "lastmeshspot" then 
			ourTab[k] = nil 
		end 
		if k == 'saytimertime' then 
			ourTab[k] = nil 
		end 
		if type(ourTab[k]) == "function" then 
			ourTab[k] = nil 
		end 
		if type(ourTab[k]) == "table" then 
			for e,r in pairs(v) do 
				if type(r) == "function" then 
					ourTab[k][r] = nil 
				end 
			end 
		end 
	end 

	local converted = util.TableToJSON(ourTab)

	file.Write("tyb/settings.txt", converted)
end 

tyb:readfromfile()


if tyb.copy == nil then
	tyb.copy = {} 
end 

if tyb.copy.surface == nil then 
	tyb.copy.surface = {}
end 

if tyb.copy.surface.createfont == nil then 
	tyb.copy.surface.createfont = surface.CreateFont 
end 

if tyb.copy.rcc == nil then
	tyb.copy.rcc = RunConsoleCommand 
end 

if tyb.copy.ts == nil then 
	tyb.copy.ts = timer.Simple 
end 

if tyb.copy.tc == nil then 
	tyb.copy.tc = timer.Create 
end 

if tyb.copy.tr == nil then 
	tyb.copy.tr = timer.Remove 
end 

if mapsfmapwapnwranwr == nil then 
	mapsfmapwapnwranwr = vgui.Create 
end 

tyb.copy.surface.createfont("tyb.drl", {
	font = "Open Sans",
	size = 17,
	weight = 400
} )
tyb.copy.surface.createfont("tyb.drlr", {
		font = "Open Sans",
		size = 15,
		weight = 400
} )

tyb.copy.surface.createfont("tyb.cb", {
		font = "Open Sans",
		size = 15, 
		weight = 400
} )

tyb.runcommand = nil 
tyb.commands = 
{
	{
		alreadyran = false,
		runfor = 6,
		name = "aimbot",
		func = function()

			if !tyb.enableaimbot then 
				return false 
			end 

			if tyb.gamemode == "ttt" then 
				if GAMEMODE.round_state == 2 or GAMEMODE.round_state == 4 then 
					return false 
				end 
				if tyb.ttt.onlyaimbotastraitor then 
					if !LocalPlayer():IsTraitor() then 
						return false 
					end 
				end 
			end 

			local wep = LocalPlayer():GetActiveWeapon()

			if (!IsValid(wep)) then 
				return false 
			end 

			if LocalPlayer():GetAmmoCount( wep:GetPrimaryAmmoType() ) > 0 and LocalPlayer():GetActiveWeapon():Clip1() == 0 then 
				tyb.copy.rcc("+reload")
				tyb.copy.ts(0.2, function() tyb.copy.rcc("-reload") end )
			end

			if IsValid(wep) and wep:Clip1() == -1 then 
				return false 
			end 

			if LocalPlayer():GetAmmoCount( wep:GetPrimaryAmmoType() ) == 0 and LocalPlayer():GetActiveWeapon():Clip1() == 0 then 
				return false 
			end 

			if !tyb.aimbot.onlylookingatme then 
				players = tyb:findwithinrange("player", tyb.aimbotradius)
			else 
				players = tyb:lookingatme(true)
			end 

			if #players == 0 then 
				return false 
			end 

			local ourTarget = players[1] 
			tyb:aimbotplayer(ourTarget)
			return true 
		end,
	},
	{
		alreadyran = false,
		name = "followplayer",
		runfor = 1,
		func = function()

			local players = tyb:findwithinrange("player", tyb.followradius, true, "follow")

			if #players == 0 then 
				return false 
			end 
			
			if LocalPlayer():GetActiveWeapon() != nil then 
				if LocalPlayer():GetActiveWeapon().GetPrimaryAmmoType != nil then 
					if LocalPlayer():GetAmmoCount( LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType() ) > 0 and LocalPlayer():GetActiveWeapon():Clip1() == 0 then 
						tyb.copy.rcc("+reload")
						tyb.copy.ts(0.2, function() tyb.copy.rcc("-reload") end )
					end 
				end 
			end

			if LocalPlayer():GetActiveWeapon() == nil then 
				tyb:changewep()
			end 

			if LocalPlayer():GetActiveWeapon().Clip1 != nil then 
				if LocalPlayer():GetActiveWeapon().GetPrimaryAmmoType != nil then 
					if LocalPlayer():GetActiveWeapon():Clip1() == 0 and LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()) == 0 then 
						tyb:changewep()
					end 
				end 
			end 


			if LocalPlayer():GetActiveWeapon().Clip1 != nil then 
				if LocalPlayer():GetActiveWeapon():Clip1() == -1 then 
					tyb:changewep()
				end 
			end 

			local ourTarget = players[1]
			tyb.drawtarget = ourTarget:GetPos() 

			local headBone = ourTarget:LookupBone("ValveBiped.Bip01_Head1")	
			if headBone != nil then 
				local targetHeadPos, targetHeadAngle = ourTarget:GetBonePosition(headBone)
				targetHeadPos = targetHeadPos + Vector(0, 0, -40)
				
				local _rand = math.random(1, 2)
				if _rand == 1 then 
					targetHeadPos = targetHeadPos + Vector(20, 0, 0)
				else
					targetHeadPos = targetHeadPos + Vector(-20, 0, 0)
				end 


				local ang = (targetHeadPos - LocalPlayer():GetShootPos()):Angle()
				if tyb.aimbot.smooth then
					tyb:lookAtSmooth(ang)
				else 
					LocalPlayer():SetEyeAngles(ang)
				end 

				if LocalPlayer():GetPos():Distance(ourTarget:GetPos()) > tyb.folowplayerto then 
					tyb.copy.rcc("+forward")
					StatusTextBoxRRR:SetText("Following "..ourTarget:Nick())
					tyb:say("Currently following: "..ourTarget:Nick())
				else 
					tyb.copy.rcc("-forward")
					StatusTextBoxRRR:SetText("Following "..ourTarget:Nick().." [in range]")
					tyb:say("Currently following: "..ourTarget:Nick().." [in range to execute]")
					if tyb.strafewhenclose then 
						local ch = math.random(1, 5)
						if ch == 5 then
							tyb:randomleftright()
						end 
					else 
						tyb:resetmovement()
					end 
				end 
			else 
				local targetHeadPos = ourTarget:GetPos()+Vector(0, 0, 50)
				local ang = (targetHeadPos - LocalPlayer():GetShootPos()):Angle()
				LocalPlayer():SetEyeAngles(ang)
				if LocalPlayer():GetPos():Distance(ourTarget:GetPos()) > tyb.folowplayerto then 
					
					LocalPlayer():SetEyeAngles(ang)
					StatusTextBoxRRR:SetText("Following "..ourTarget:Nick())
					tyb.copy.rcc("+forward")
				else
					tyb.copy.rcc("-forward")
					tyb:randomleftright()
				end  
			end 

			return true 
		end,
	},
	{
		alreadyran = false,
		name = "findweapon",
		runfor = 3,
		func = function()
			local weps = tyb:findwithinrange("weapon", tyb.findwepradius)

			if #weps == 0 then 
				return false 
			end 

			if LocalPlayer():GetActiveWeapon() != nil then
				if LocalPlayer():GetActiveWeapon().Clip1 != nil then 
					if LocalPlayer():GetActiveWeapon():Clip1() != nil then
						if LocalPlayer():GetActiveWeapon():Clip1() > 0 then 
							return false 
						end 
					end 
				end 
				if LocalPlayer():GetActiveWeapon().Clip1 and LocalPlayer():GetActiveWeapon():Clip1() == 0 and LocalPlayer():GetAmmoCount( LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType() ) > 0 then 
					tyb.copy.rcc("+reload")
					tyb.copy.ts(0.1, function()
						tyb.copy.rcc("-reload")
					end )
					return true 
				end

				if tyb.gamemode == "ttt" then 
					if LocalPlayer():GetActiveWeapon().Clip1 and LocalPlayer():GetActiveWeapon():Clip1() == 0 and LocalPlayer():GetAmmoCount( LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType() ) == 0 then 
						tyb.blacklistedwep[LocalPlayer():GetActiveWeapon()] = true 
						tyb.copy.rcc("+menu")
						tyb.copy.ts(0.2, function()
							tyb.copy.rcc("-menu")
						end )
					end 
				end 
			end 

			if LocalPlayer():GetActiveWeapon() == nil or (LocalPlayer():GetActiveWeapon().Clip1 and LocalPlayer():GetActiveWeapon():Clip1() == -1) then
				tyb:changewep()
			end 

			if #weps >= 1 then 
				local firstWep = weps[1] 
				if IsValid(firstWep) then
					tyb.drawtarget = firstWep:GetPos() 

					if firstWep.lookForTimer == nil and tyb.blacklistedwep[firstWep] == nil then 
						firstWep.lookForTimes = 1
						firstWep.lookForTimer = CurTime()+3 
					end 

					if CurTime() > firstWep.lookForTimer then 
						if (CurTime() - firstWep.lookForTimer) > 4 then
							firstWep.lookForTimes = 1
							firstWep.lookForTimer = CurTime() + 3
						else
							firstWep.lookForTimer = CurTime() + 3
							firstWep.lookForTimes = firstWep.lookForTimes + 1 
						end 
					end

					if firstWep.lookForTimes >= 2 then 
						tyb:log("Blacklisting weapon")
						tyb.blacklistedwep[firstWep] = true 
						firstWep.lookForTimer = nil 
						firstWep.lookForTimes = 0
					end 

					local ang = (firstWep:GetPos() - LocalPlayer():GetShootPos()):Angle()
					if tyb.aimbot.smooth then 

						local myAng = LocalPlayer():EyeAngles()
						local setToReal = LerpAngle(tyb.aimbot.smoothiteration, myAng, ang)
						setToReal.p = math.NormalizeAngle(setToReal.p)
						setToReal.y = math.NormalizeAngle(setToReal.y)
						LocalPlayer():SetEyeAngles(setToReal)
					else
						LocalPlayer():SetEyeAngles(ang)
					end 
					tyb.copy.rcc("+forward")
					tyb.copy.rcc("+use")
					StatusTextBoxRRR:SetText("Moving towards weapon "..firstWep:GetClass())
					tyb:say("Picking up weapon: ["..firstWep:GetClass().."]")
					tyb.copy.ts(1, function()
						tyb.copy.rcc("-forward")
						tyb.copy.rcc("-use")
					end )

				end 
			end 

			return true 
		end,
	},	
}

tyb.misc.meshmovecommand = 
{
	alreadyran = false,
	name = "meshmove",
	runfor = 3,
	func = function()

		local players = tyb:findwithinrange("player", 300, true)

		if #players > 0 then
			return false 
		end 

		local spots = tyb:getMapDataSpot() 

		if #spots == 0 then 
			return false
		end 

		local firstSpot = spots[1]

		if firstSpot == nil then 
			return false 
		end 
		if tyb.randomjumps then tyb:jump() end
		tyb:moveMesh(firstSpot) 

		local _x = firstSpot.x 
		local _y = firstSpot.y 
		local _z = firstSpot.z 

		StatusTextBoxRRR:SetText("Moving on mesh [x: ".._x..", y: ".._y..", z: ".._z.."]")
		tyb:say("Moving on mesh: [x: ".._x..", y: ".._y..", z: ".._z.."]")
		return true 
	end 
}

tyb.misc.identifybody = 
{
	alreadyran = false,
	name = "identifybody",
	runfor = 5, 
	func = function()

		if LocalPlayer():IsTraitor() then return end 

		local ragdolls = tyb:findwithinrange("prop_ragdoll", 300)

		if #ragdolls == 0 then 
			return false 
		end 

		local actualRagdolls = {} 
		local count = 0 

		for k,v in pairs(ragdolls) do 
			if v:GetDTBool(CORPSE.dti.BOOL_FOUND) == false then
				count = count + 1 
				actualRagdolls[count] = v 
			end 
		end 

		if #actualRagdolls == 0 then 
			tyb.copy.rcc("-use")
			tyb.copy.rcc("-duck")
			return false 
		end 						

		local firstRagdoll = actualRagdolls[1] 
		local dist = firstRagdoll:GetPos():Distance(LocalPlayer():GetPos())


		if dist > 60 then 
			tyb:lookAtSmooth((firstRagdoll:GetPos() - LocalPlayer():GetShootPos()):Angle())
			tyb.copy.rcc("+forward")
			StatusTextBoxRRR:SetText("Moving towards unidentified body")
			tyb:say("Identifying body..")
			RunConsoleCommand("-use")
		else  
			tyb:resetmovement()
			tyb.copy.rcc("+duck")
			tyb.copy.rcc("+use")
			timer.Simple(0.01, function()
				tyb.copy.rcc("-use")
			end ) 

			tyb:lookAtSmooth((firstRagdoll:GetPos() - LocalPlayer():GetShootPos()):Angle())
			StatusTextBoxRRR:SetText("Identifying body")
			tyb:say("Identifying body..")
		end 

		return true 
	end 
}


function tyb:determinegamemode()
	if string.find(tyb.map, "gm_") != nil then 
		tyb.gamemode = "ttt"
		print("[TYB] ON "..string.upper(tyb.gamemode).."!")
		table.insert(tyb.commands, tyb.misc.identifybody)
		return 
	end 

	if string.find(tyb.map, "ttt_") != nil then 
		tyb.gamemode = "ttt"
		print("[TYB] ON "..string.upper(tyb.gamemode).."!")
		table.insert(tyb.commands, tyb.misc.identifybody)
		return 
	end 

	if string.find(tyb.map, "rp_") != nil then 
		tyb.gamemode = "darkrp"
		print("[TYB] ON "..string.upper(tyb.gamemode).."!")
		return 
	end 
end 

tyb:determinegamemode()

function tyb:log(...)
	local args = {...}
	chat.AddText(Color(255, 255, 255), "[", Color(77, 0, 255), "TyB", Color(255, 255, 255), "]: ", unpack(args))
end 


tyb.mapdata = {} 


function tyb:readmapdata()
	local currentMap = game.GetMap()..".txt"

	if file.Exists("tyb/mapdata/"..currentMap, "DATA") then 
		tyb:log("Map data exists for this map, loading..")

		local read = file.Read("tyb/mapdata/"..currentMap, "DATA")
		local tab = util.JSONToTable(read)

		if type(tab) == "table" then 

			tyb.mapdata[game.GetMap()] = tab 
			if tyb.misc.insertmeshmovecmdonmesh then 
				table.insert(tyb.commands, tyb.misc.meshmovecommand)
				tyb:log("Loaded meshmove command!")
			end 
		end 
		tyb:log("Map data loaded!")
	else 
		tyb:log("I have not found existing mesh data for this map, but will construct a walkable path using player movements.")
		
	end 
end 

tyb:readmapdata()

function tyb:hasMapData()
	local currentMap = game.GetMap()
	return tyb.mapdata[currentMap] != nil 
end 

tyb.blacklistedWaypoints = {} 
function tyb:getMapDataSpot()
	local thisMap = game.GetMap()
	local mapData = tyb.mapdata[thisMap]

	local count = 0 
	local newTab = {} 

	for k,v in pairs(mapData) do 
		if tyb.lastmeshspot == nil then 
			if tyb:cansee(v) and LocalPlayer():GetPos():Distance(v) < 700 and tyb.blacklistedWaypoints[v] == nil and LocalPlayer():GetPos():Distance(v) > 50 then

				count = count + 1 
				newTab[count] = v 
			end 
		else 
			if tyb:cansee(v) and LocalPlayer():GetPos():Distance(v) < 700 and tyb.blacklistedWaypoints[v] == nil and LocalPlayer():GetPos():Distance(v) > 50 then
				count = count + 1 
				newTab[count] = v 
			end 
		end 
	end 

	if #newTab > 1 then 

		table.sort(newTab, function(a, b)
			return a:Distance(LocalPlayer():GetPos()) < b:Distance(LocalPlayer():GetPos())
		end ) 
	end 

	return newTab
end 

tyb.playerWepData = {} 
tyb.recentlyLostAmmo = {} 
tyb.recentlyLostAmmoCount = 0 
tyb.ttt.traitorequipmentcount = 0 

function tyb.ttt:hasTraitorWeapon(ply)
	if !tyb.ttt.firsttimetraitor then return end 
	if tyb.ttt.traitorequipmentcount == 0 then return end 
	local does = false 
	local wep = "" 
	local wepEnt = nil 

	local playerWeps = ply:GetWeapons()

	for e,r in pairs(playerWeps) do 
		if tyb.ttt.traitorequipment[r:GetClass()] then
			does = true  
			wep = r:GetClass()
			wepEnt = r 
			break 
		end  
	end 

	return does, wep, wepEnt  
end 

function tyb:attemptLearnWaypoints()

	local currentMap = game.GetMap() 
	if file.Exists("tyb/mapdata/"..currentMap, "DATA") then return end 

	if tyb.automaticWaypointTimer == nil then 
		tyb.automaticWaypointTimer = CurTime() - 0.1 
	end 

	if tyb.mapdata[game.GetMap()] == nil then 
		tyb.mapdata[game.GetMap()] = {} 
	end 

	if #tyb.mapdata[game.GetMap()] >= 350 then 
		return 
	end 

	if CurTime() < tyb.automaticWaypointTimer then 
		return 
	end 


	for k,v in pairs(player.GetAll()) do 
		if v ~= LocalPlayer() and v:IsOnGround() then 

			local _pos = v:GetPos() 
			local _shouldAdd = true 
			for e,r in pairs(tyb.mapdata[game.GetMap()]) do 
				if r:Distance(_pos) < 100 then 
					_shouldAdd = false 
				end 	
			end 
			if _shouldAdd then 
				local _count = #tyb.mapdata[game.GetMap()]+1
				tyb.mapdata[game.GetMap()][_count] = _pos 
			end 
		end 
	end 


	local _count = #tyb.mapdata[game.GetMap()]
	local _alreadyAdded = false 
	if _count >= 100 then 
		for k,v in pairs(tyb.commands) do 
			if v.name == "meshmove" then 
				_alreadyAdded = true 
			end 
		end 

		if !_alreadyAdded then
			table.insert(tyb.commands, tyb.misc.meshmovecommand)
			tyb.drawwaypoints = false 
			tyb:log("Automatically added >100 waypoints, adding meshmove command and hiding waypoints for FPS")
		end 
	end 


	tyb.automaticWaypointTimer = CurTime() + 0.5  
end 



function tyb:jump()
	if !LocalPlayer():Alive() then return end 
	if tyb.randomjumpdelay == nil then 
		tyb.randomjumpdelay = CurTime() + 0.5 
	end 

	if CurTime() > tyb.randomjumpdelay then  
		local chance = math.random(1, 2)
		if chance == 2 then 
			if LocalPlayer():OnGround() then 
				tyb.copy.rcc("+jump")
				tyb.copy.rcc("+duck")
				tyb.copy.ts(0.2, function() tyb.copy.rcc("-jump") tyb.copy.rcc("-duck") end )
			end 
		end 
		tyb.randomjumpdelay = CurTime() + 0.3
	end 
end 


function tyb:randomcommand()
	local count = 0
	tyb.starttime = nil 

	for k,v in pairs(tyb.commands) do 
		if !v.alreadyran then 
			count = count + 1  
		end 
	end 
	
	if count > 0 then 
		for t,p in pairs(tyb.commands) do 
			if !p.alreadyran then 
				--for o,p in pairs(tyb.commands) do 
					--tyb.commands[o].alreadyran = false 
				--end 

				return tyb.commands[t] 
			end 
		end 
	else 
		for k,v in pairs(tyb.commands) do 
			tyb.commands[k].alreadyran = false 
		end 
		return tyb:randomcommand()
	end
end 

function tyb:executecommand()

	if tyb.runcommand == nil then 
		if !tyb.commands[tyb.firstcommand].alreadyran then
			tyb.runcommand = tyb.commands[tyb.firstcommand]
		else 
			tyb.runcommand = tyb:randomcommand()
		end 
		return true 
	end 

	if tyb.runcommand.func() then
		if tyb.runcommand.runfor != nil then 

			if tyb.starttime == nil then 
				tyb.starttime = CurTime() 
			end 

			if tyb.starttime != nil and CurTime() <= tyb.starttime + tyb.runcommand.runfor then 
				-- nothing here yet
			else
				for k,v in pairs(tyb.commands) do 
					if tyb.runcommand.name == v.name then 
						tyb.commands[k].alreadyran = true 
					end 
				end 
				tyb.runcommand = tyb:randomcommand()
				tyb.starttime = nil 
			end 
		else 
			tyb:say(tyb.runcommand.name.." -> "..(tyb.starttime + tyb.runcommand.runfor) - CurTime().." seconds")
		end 
	else 
		--tyb:say("Finished running "..tyb.runcommand.name.."!")
		for k,v in pairs(tyb.commands) do 
			if tyb.runcommand.name == v.name then 
				tyb.commands[k].alreadyran = true 
			end 
		end 
		tyb.runcommand = tyb:randomcommand()
		return true 
	end 
end 

function tyb:say(txt)
	if !tyb.announce then return end 
	if tyb.saytimer then 
		if tyb.saytimertime == nil then 
			tyb.saytimertime = CurTime() + 0.1
		end 
		if CurTime() > tyb.saytimertime then 
			tyb.saytimertime = CurTime() + 1
			tyb.copy.rcc("say", "[TyB] = "..txt.." = ")

		end 
	else 
		tyb.copy.rcc("say", "[TyB] = "..txt.." =")
	end
end 

function tyb:saveweps()
	tyb.myweps = {} 
	local count = 0

	for k,v in pairs(ents.FindByClass("weapon_*")) do
		if v:GetOwner() == LocalPlayer() then 
			count = count + 1 
			tyb.myweps[count] = v 
		end 
	end 
end 



function tyb:flashlight()
	if !tyb.flashlightspam then return end 

	if tyb.flashlightspamtimer == nil then 
		tyb.flashlightspamtimer = CurTime() + 0.1 
	end 

	if CurTime() > tyb.flashlightspamtimer then 
		tyb.flashlightspamtimer = CurTime() + tyb.flashlightinterval
		tyb.copy.rcc("impulse", "100")
	end 
end 

function tyb:checkposition()
	if !LocalPlayer():Alive() or LocalPlayer():Team() == 1002 then return end 

	if tyb.blacklistedWaypointsReset != nil then 
		if CurTime() > tyb.blacklistedWaypointsReset then 
			tyb.blacklistedWaypoints = {} 
		end 
	end 


	if tyb.checkpositionstuck then
		if tyb.checkpositionstuckreset == nil then 
			if tyb:hasMapData() then 
				tyb.checkpositionstuckreset = CurTime() + 6
			else 
				tyb.checkpositionstuckreset = CurTime() + 3 
			end 
		end 
		if CurTime() > tyb.checkpositionstuckreset then 
			tyb.checkpositionstuck = false 
			tyb.checkpositionstuckreset = nil 
			tyb.checkpositionposition = nil 
			tyb.checkpositiontimecount = 0 
			tyb.checkpositiontime = nil 
			tyb.copy.rcc("-left")
			tyb.copy.rcc("-right")
		else 
			if tyb.randomjumps then tyb:jump() end 
			return 
		end  
	end  

	if tyb.checkpositiontime == nil then
		tyb.checkpositiontime = CurTime() + 1
		if tyb.checkpositiontimecount == nil then 
			tyb.checkpositiontimecount = 0
		end 
		if tyb.checkpositionposition == nil then 
			tyb.checkpositionposition = LocalPlayer():GetPos()
		end 
		if tyb.checkpositionstuck == nil then 
			tyb.checkpositionstuck = false 
		end 
	end 

	if CurTime() > tyb.checkpositiontime then 
		tyb.checkpositiontime = CurTime() + 1

		local ourPos = LocalPlayer():GetPos()

		if tyb.checkpositionposition != nil then 
			if ourPos:Distance(tyb.checkpositionposition) < 100 then 
				tyb.checkpositiontimecount = tyb.checkpositiontimecount + 1 
				tyb:log("Same position ["..tyb.checkpositiontimecount.."]")

				tyb.blacklistedWaypoints[tyb.drawtarget] = true 
				tyb.blacklistedWaypointsReset = CurTime() + 3
				tyb.lastmeshspot = LocalPlayer():GetPos()
			else 
				tyb.checkpositionstuck = false 
				tyb.checkpositionstuckreset = nil 
				tyb.checkpositionposition = nil 
				tyb.checkpositiontimecount = 0 
				tyb.checkpositiontime = nil 
				tyb.randompresstimer = nil 
			end 
		end 

		if tyb.checkpositiontimecount >= 3 and !tyb.checkpositionstuck then 
			-- We're stuck
			tyb:log("Okay, we might be stuck.. trying to move.")
			tyb:say("Same position detected, performing standard move")
			tyb.checkpositionstuck = true 
		end 
	end 
end 

tyb.ttt.boughtarmor = false 

function tyb.ttt:buyrandomwep()
	if tyb.gamemode != "ttt" then return end 
	if !LocalPlayer():Alive() or !LocalPlayer():IsTraitor() and !LocalPlayer():IsDetective() then return end 

	local equip = GetEquipmentForRole(LocalPlayer():GetRole())
	local id = 0
	local found = false 
	local _alr = false 
	for e,r in pairs(LocalPlayer():GetWeapons()) do 
		if r:GetClass() == "weapon_ttt_flaregun" then 
			_alr = true 
		end 
	end 

	if _alr then 
		return 
	end 


	for k,v in pairs(equip) do 
		if string.find(v.name, "flare") then 
			id = v.id 
			found = true 
		end 
	end 


	if found then
	 	tyb.copy.rcc('ttt_order_equipment', id)
	 	tyb:log("Purchased flare gun")
 	end 
end 

function tyb:tryunstuck()
	if !tyb.checkpositionstuck then 
		tyb.checkpositionstuckreset = nil 
		tyb.randompresstimer = nil 
		tyb.checkpositionposition = nil 
		tyb.checkpositiontimecount = 0 
		tyb.checkpositiontime = nil 
		tyb.copy.rcc("-right")
		tyb.copy.rcc("-left")
		tyb.copy.rcc("-forward")
		return 
	end  

	if tyb.lastunstucktime == nil then 
		tyb.lastunstucktime = CurTime() + 0.05
	end 

	if CurTime() > tyb.lastunstucktime then 
		tyb.lastunstucktime = CurTime() + 3

		local doors = tyb:findwithinrange("door", 200, false)

		if #doors >= 1 then 
			tyb:say("Possibly stuck, moving to door")
			tyb:moveToDoor()
			if IsValid(StatusTextBoxRRR) then
				StatusTextBoxRRR:SetText("Trying to unstuck (door)") 
			end 

			return 
		end 

		if tyb:hasMapData() then
			local spots = tyb:getMapDataSpot()
			PrintTable(spots)
			local firstSpot = spots[1] 
			if firstSpot != nil then 
				tyb.drawtarget = firstSpot + Vector(0, 0, 20)

				if IsValid(StatusTextBoxRRR) then
					StatusTextBoxRRR:SetText("Trying to unstuck (mesh)") 
				end 
				tyb:say("Possibly stuck, moving using mesh..")
				tyb:moveMesh(firstSpot)
			else 
				if IsValid(StatusTextBoxRRR) then
					StatusTextBoxRRR:SetText("Trying to unstuck (random press)") 
				end 

				if tyb.randompresstimer == nil then 
					tyb.randompresstimer = CurTime() + 0.1 
				end 

				if CurTime() > tyb.randompresstimer then
					tyb.randompresstimer = CurTime() + 3 

					tyb.copy.rcc("+moveleft")
					tyb.copy.ts(1, function()
						tyb.copy.rcc("-moveleft")
					end ) 
				end 
			end 
		else 
			if IsValid(StatusTextBoxRRR) then
				StatusTextBoxRRR:SetText("Trying to unstuck (random press)") 
			end 

			if tyb.randompresstimer == nil then 
					tyb.randompresstimer = CurTime() + 0.1 
				end 

			if CurTime() > tyb.randompresstimer then
				tyb.randompresstimer = CurTime() + 3 

				tyb.copy.rcc("+moveleft")
				tyb.copy.ts(1, function()
					tyb.copy.rcc("-moveleft")
				end ) 
			end 
		end  
	end 
end 



function tyb:notifyTraitorWep()
	if !tyb.ttt.notifytraitorwep then return end 
	if tyb.ttt.traitorequipmentcount == 0 then return end 
	if tyb.gamemode != "ttt" then return end 

	if GAMEMODE.round_state == 2 or GAMEMODE.round_state == 4 then 
		tyb.ttt.boughtarmor = false
		if tyb.ttt.traitorcount > 0 then 
			tyb.ttt.possibletraitors = {}  
			tyb.ttt.traitorcount = 0 
			tyb:resetourtables()
			tyb:log("Traitor table reset!")
		end 
	end 

	for k,v in pairs(player.GetAll()) do 
		if v:Team() != 1002 and v:Health() > 0 and v:GetFriendStatus() != "friend" then 
			local traitor, wepname, wep = tyb.ttt:hasTraitorWeapon(v)
			if traitor and tyb.ttt.possibletraitors[v] == nil and wep.alreadyFlagged == nil then 
				tyb:log(v:Nick().." has traitor weapon "..wepname..", flagging as possible traitor.")
				wep.alreadyFlagged = true 
				tyb.ttt.possibletraitors[v] = true 
				tyb.ttt.traitorcount = tyb.ttt.traitorcount + 1 

			end 
		end 
	end 
end 


function tyb:emergency()
	if !tyb.emergencymodeenabled then return end 

	if tyb.checkhptime == nil then 
		tyb.checkhptime = CurTime() + 0.01
	end 

	if CurTime() < tyb.checkhptime then 
		return
	end 

	if tyb.emergencymode then 
		if tyb.emergencymodetimer == nil then 
			tyb.emergencymodetimer = CurTime() + 2
		end 

		if CurTime() > tyb.emergencymodetimer then 
			tyb:say("Emergency mode disabled, reason: Expired")
			tyb.emergencymodetimer = nil 
			tyb.emergencymode = false 
		end 
	end 



	tyb.checkhptime = CurTime() + 0.02 

	if LocalPlayer():Health() < tyb.myhealth then 
		if LocalPlayer():Health() > 0 then 

			if tyb.killonlowhp then 
				if LocalPlayer():Health() <= tyb.killonlowhphp then 
					RunConsoleCommand("kill")
					tyb.myhealth = LocalPlayer():Health() 
					tyb:log("Killing on Low HP")
					return 
				end 
			end 

			local healthLost = (tyb.myhealth - LocalPlayer():Health())
			if healthLost >= tyb.emergencymodedamage then 
				tyb.emergencymode = true 
				tyb:log("Moved into emergency mode, reason: Took damage")
				tyb:say("Moved into emergency mode, reason: Took damage")

				if tyb.jumpondamage and LocalPlayer():OnGround() then 
					tyb:log("Jumping!")
					tyb.copy.rcc("+jump")
					tyb.copy.ts(0.1, function()
						tyb.copy.rcc("-jump")
					end )
				end 
			end 
		end 
		tyb.myhealth = LocalPlayer():Health() 
	elseif LocalPlayer():Health() > tyb.myhealth then 
		tyb.myhealth = LocalPlayer():Health()
	end 
end

function tyb:moveTo(target)
	if IsValid(target) then 
		local pos = target:GetPos() + Vector(-10, 0, 0)
		tyb:lookAtSmooth((pos - LocalPlayer():GetShootPos()):Angle())

		if pos:Distance(LocalPlayer():GetPos()) > 100 then 
			tyb.copy.rcc("+forward")
			tyb:log("Not at door")
			return false 
		else
			tyb:log("At door")
			return true 
		end 
	end 
end 

function tyb:moveToDoor()
	local doors = tyb:findwithinrange("door", 300, false)
	if #doors == 0 then return end 
	local ourDoor = doors[1] 
	if IsValid(ourDoor) then 
		tyb.drawtarget = ourDoor:GetPos()

		if tyb:moveTo(ourDoor) then 
			tyb:log("Pressing E")
			tyb.copy.rcc("+use")

			tyb.copy.ts(0.02, function()
				tyb.copy.rcc("-use")
				tyb.blacklistedDoors[ourDoor] = true
				tyb.clearblacklistdoors = CurTime() + 6
				
				tyb.copy.ts(1, function()
					tyb.checkpositionstuck = false 
					tyb.checkpositionstuckreset = nil 
					tyb.checkpositionposition = nil 
					tyb.randompresstimer = nil
					tyb.checkpositiontimecount = 0 
					tyb.checkpositiontime = nil 
				end )
			end )
		end 
	end 
end 

-- tyb.playerWepData#
tyb.playerWepDataLogCD = nil 

function tyb:logWepAmmo()

	if tyb.playerWepData == nil then 
		tyb.playerWepData = {} 
	end 
	
	if tyb.playerWepDataLogCD == nil then 
		tyb.playerWepDataLogCD = CurTime() - 0.1 
	end 

	if CurTime() < tyb.playerWepDataLogCD then 
		return 
	end 



	for k,v in pairs(player.GetAll()) do 
		if v:Alive() and v:Team() != 1002 and IsValid(v:GetActiveWeapon()) then 
			if tyb.playerWepData[v] == nil then 
				tyb.playerWepData[v] = {
					wep = v:GetActiveWeapon(),
					ammo = v:GetActiveWeapon():Clip1(),
					recentlyLost = false,
					lostTime = 0,

				}
			else 
				if !tyb.playerWepData[v].recentlyLost then 
					local _gunNow = v:GetActiveWeapon()
					local _gunThen = tyb.playerWepData[v].wep 
					local _ammoNow = v:GetActiveWeapon():Clip1() 
					local _ammoBefore = tyb.playerWepData[v].ammo 

					if _gunNow == _gunThen and _ammoNow < _ammoBefore and _ammoNow ~= -1 then 
						tyb.playerWepData[v].recentlyLost = true 
						tyb.playerWepData[v].lostTime = CurTime() + 1 
					elseif _gunNow ~= _gunThen then 
						tyb.playerWepData[v] = {
							wep = v:GetActiveWeapon(),
							ammo = v:GetActiveWeapon():Clip1(),
							recentlyLost = false,
							lostTime = 0,
						}
					end 
				else 
					if CurTime() > tyb.playerWepData[v].lostTime then 
						tyb.playerWepData[v].lostTime = 0 
						tyb.playerWepData[v].recentlyLost = false 
						tyb.playerWepData[v].ammo = v:GetActiveWeapon():Clip1()
						tyb.playerWepData[v].wep = v:GetActiveWeapon()
					end 
				end 
			end 
		end 
	end 

	tyb.playerWepDataLogCD = CurTime() + 0.1
end 

function tyb:HasRecentlyLostAmmo(ply)
	if tyb.playerWepData[ply] ~= nil then 
		if tyb.playerWepData[ply].recentlyLost then 
			return true 
		end 
	end 

	return false 
end 



function tyb:lookingatme(sort)
	local count = 0 
	local tab = {} 

	if sort == nil then 
		sort = true
	end 

	for k,v in pairs(player.GetAll()) do 
		if tyb:HasRecentlyLostAmmo(v) and v != LocalPlayer() and v:Alive() and v:Team() != 1002 and tyb:cansee(v) and v:GetFriendStatus() != "friend" then 
			if IsValid(v:GetEyeTrace().Entity) then 
				local ent = v:GetEyeTrace().Entity 
				if ent == LocalPlayer() then 
					if tyb.gamemode == "ttt" and tyb.ttt.targetfellowtraitors then 
						if LocalPlayer():IsTraitor() then 
							if !v:IsTraitor() then 
								count = count + 1 
								tab[count] = v 
							end 
						else 
							count = count + 1 
							tab[count] = v 
						end 
					else  
						count = count + 1 
						tab[count] = v 
					end  
				end 
			end 
		end 
	end 

	if count == 0 then 
		for k,v in pairs(player.GetAll()) do 
			if tyb:HasRecentlyLostAmmo(v) and v != LocalPlayer() and v:Alive() and v:Team() != 1002 and tyb:cansee(v) and v:GetFriendStatus() != "friend" then
				local hitPos = v:GetEyeTrace().HitPos 
				local LetsUseThis = LocalPlayer():GetPos() + Vector(0, 0, 30)
				local dist = v:GetEyeTrace().HitPos:Distance(LetsUseThis)
				if dist <= tyb.aimbot.onlylookingatmedistance then 
					if tyb.gamemode == "ttt" and tyb.ttt.targetfellowtraitors then 
						if LocalPlayer():IsTraitor() then 
							if !v:IsTraitor() then 
								if tyb:HasRecentlyLostAmmo(v) then 
									count = count + 1 
									tab[count] = v 
								end 
							end 
						else 
							if tyb:HasRecentlyLostAmmo(v) then 
								count = count + 1 
								tab[count] = v 
							end 
						end 
					else 
						if tyb:HasRecentlyLostAmmo(v) then 
							count = count + 1 
							tab[count] = v 
						end
					end 
				end 
			end 
		end 
	end 

	if sort and #tab > 1 then 
		if !tyb.sortbyhealth then 
			table.sort(tab, function(a, b)
				return a:GetPos():Distance(LocalPlayer():GetPos()) < b:GetPos():Distance(LocalPlayer():GetPos())
			end ) 
		else 
			table.sort(tab, function(a, b)
				return a:Health() < b:Health() 
			end )
		end 
	end 

	return tab 
end 


function tyb:setrandomangles()
	local ranA = 90
	local ranB = 360

	local randomP = math.random(ranA, ranB)
	local randomY = math.random(ranA, ranB)
	local randomR = math.random(ranA, ranB)
	local use = Angle(randomP, randomY, randomR)
	LocalPlayer():SetEyeAngles(use)
end 

function tyb:aimbotplayer(ourTarget)
	if !IsValid(ourTarget) then return end 
	tyb.drawtarget = ourTarget:GetPos()

	local targetDist = ourTarget:GetPos():Distance(LocalPlayer():GetPos())
	local targetHead = nil 
	local usebones = true 

	if targetDist > 800 then
		targetHead = ourTarget:LookupBone("ValveBiped.Bip01_Spine")
	else 
		targetHead = ourTarget:LookupBone("ValveBiped.Bip01_Head1")
	end 

	if targetHead == nil then 
		usebones = false 
	end 

	local targetHeadPos = nil 	
	if usebones then 
		targetHeadPos, targetHeadAngle = ourTarget:GetBonePosition(targetHead)
	else 
		targetHeadPos = ourTarget:GetPos()+Vector(0, 0, 35)
	end 
	if targetHeadPos == nil then return end 

	local useMax = (targetHeadPos + Vector(-5, 0, 0)) + (ourTarget:GetVelocity()*0.1 )
	--targetHeadPos = targetHeadPos + Vector(-5, 0, 0) + (ourTarget:GetForward() * 5)
	local setTo = (useMax - LocalPlayer():GetShootPos()):Angle() 

			
	if tyb.aimbot.autoshoot then 

		local wep = LocalPlayer():GetActiveWeapon() 

		if LocalPlayer():Alive() then
			if wep != nil then 
				if wep.Clip1 and wep:Clip1() != nil then
					if wep:Clip1() == -1 then 
						return false
					end
				end 
			end 
		end 

		local myAng = LocalPlayer():EyeAngles()
		local setToReal = LerpAngle(0.7, myAng, setTo)
		setToReal.p = math.NormalizeAngle(setToReal.p)
		setToReal.y = math.NormalizeAngle(setToReal.y)
		LocalPlayer():SetEyeAngles(setToReal)

		if wep != nil then 
			if wep.Clip1 == nil then return end 

			if wep:Clip1() != nil then
				if wep:Clip1() > 0 then  
					tyb.copy.rcc("+attack")
							
					tyb.copy.ts(0.05, function() 
						tyb.copy.rcc("-attack")
					end )
				end
			end 
		end 
	else 
		if tyb.aimbot.smooth then 
			local myAng = LocalPlayer():EyeAngles()
			local setToReal = LerpAngle(tyb.aimbot.smoothiteration, myAng, setTo)
			setToReal.p = math.NormalizeAngle(setToReal.p)
			setToReal.y = math.NormalizeAngle(setToReal.y)

			LocalPlayer():SetEyeAngles(setToReal)
		else 
			LocalPlayer():SetEyeAngles(setTo)
		end 
		tyb:say("Not shooting at "..ourTarget:Nick()..", autoshoot off.")
	end  
end 

function tyb:changewep()

	if tyb.changewepD == nil then 
		tyb.changewepD = CurTime() + 0.2
		return true 
	end 

	if CurTime() > tyb.changewepD then 
		tyb.changewepD = CurTime() + 0.2 
		local ran = math.random(1, #LocalPlayer():GetWeapons())
		input.SelectWeapon(LocalPlayer():GetWeapons()[ran])

		return true 
	end 
end 

function tyb:returnadmins()
	local adminTable = {} 
	local count = 0 
	for k,v in pairs(player.GetAll()) do 
		if v:IsAdmin() and v != LocalPlayer() and v:GetFriendStatus() != "friend" then 
			count = count + 1 
			adminTable[count] = v 
		end 
	end 

	return adminTable 
end 

function tyb:findbutcantsee(ent, range)
	local foundEnts = {} 
	local count = 0 

	for k,v in pairs(ents.FindInSphere(LocalPlayer():GetPos(), range)) do 
		if v != LocalPlayer() and string.find(v:GetClass(), ent) != nil then 
			if ent == "player" then 
				if v:IsPlayer() then 
					if v:Health() > 0 then 
						count = count + 1 
						foundEnts[count] = v 
					end 
				end 
			end 
		end 
	end 

	return foundEnts 
end 

function tyb:findwithinrange(ent, range, sameteam, why)
	local foundEnts = {} 
	local count = 0 

	if sameteam == nil then 
		if tyb.aimbot.targetsameteam then
			sameteam = true 
		else 
			sameteam = false 
		end 
	end 

	for k,v in pairs(ents.FindInSphere(LocalPlayer():GetPos(), range)) do 
		if tyb:cansee(v) and v != LocalPlayer() and string.find(v:GetClass(), ent) != nil then 
			if ent == "player" then 
				if v:IsPlayer() then
					if v:Health() > 0 then
						if v:Team() != 1002 then
							if sameteam then
								if why != "follow" and tyb.gamemode == "ttt" and !tyb.ttt.targetfellowtraitors then -- on terrortown 
									if LocalPlayer():IsTraitor() then 
										if !v:IsTraitor() then 
											count = count + 1 
											foundEnts[count] = v 
										end 
									else 
										count = count + 1 
										foundEnts[count] = v
									end 
								else 
									count = count + 1 
									foundEnts[count] = v
								end 
							else
								if v:Team() != LocalPlayer():Team() then 
									if why != "follow" and tyb.gamemode == "ttt" and !tyb.ttt.targetfellowtraitors then 
										if LocalPlayer():IsTraitor() then 
											if !v:IsTraitor() then 
												count = count + 1 
												foundEnts[count] = v 
											end 
										else 
											count = count + 1 
											foundEnts[count] = v
										end 
									else 
										count = count + 1 
										foundEnts[count] = v 
									end 
								end 
							end 
						end
					end 
				end 
			elseif ent == "weapon" then 
				if !IsValid(v:GetOwner()) and tyb.blacklistedwep[v] == nil and string.find(v:GetClass(), "grenade") == nil then 
					count = count + 1 
					foundEnts[count] = v 
				end 
			elseif ent == "door" then 
				if tyb.blacklistedDoors[v] == nil then 
					count = count + 1 
					foundEnts[count] = v 
				end 
			elseif ent == "prop_ragdoll" then 
				if tyb.blacklistedBodies[v] == nil then 
					count = count + 1 
					foundEnts[count] = v 
				end 
			end  
		end 
	end 

	if #foundEnts > 1 then 

		table.sort(foundEnts, function(a, b)
			return a:GetPos():Distance(LocalPlayer():GetPos()) < b:GetPos():Distance(LocalPlayer():GetPos())
		end )

		if tyb.sortbyhealth then 
			if why != "follow" and ent != "weapon" and ent != "door" then 
				tyb:log("Sorting by health!")
				table.sort(foundEnts, function(a, b)
					return a:Health() < b:Health() 
				end )
			end 
		end 
	end 

	tyb.usingradius = range 
	tyb.radiusDraw = foundEnts 

	return foundEnts 
end 

function tyb:clearblacklistedDoors()
	if tyb.clearblacklistdoors != nil then 
		if CurTime() > tyb.clearblacklistdoors then 
			tyb.blacklistedDoors = {}
			tyb.clearblacklistdoors = nil
		end 
	end 
end 

function tyb:cansee(ent)
	if IsValid(ent) then 
		local trLOS = {} 
		trLOS.start = LocalPlayer():LocalToWorld(LocalPlayer():OBBCenter())
		trLOS.endpos = ent:LocalToWorld(ent:OBBCenter())
		trLOS.filter = {LocalPlayer(), ent}

		return util.TraceLine(trLOS).Fraction == 1 
	elseif type(ent) == "Vector" then 
		local trLOS = {} 
		trLOS.start = LocalPlayer():LocalToWorld(LocalPlayer():OBBCenter())
		trLOS.endpos = ent + Vector(0, 0, 15)
		trLOS.filter = {LocalPlayer(), ent}

		return util.TraceLine(trLOS).Fraction == 1 
	end 
end 

function tyb:randomleftright()
	local ch = math.random(1, 2)
	if ch == 1 then 
		tyb.copy.rcc("+moveleft")
		tyb.copy.ts(0.3, function()
			tyb.copy.rcc("-moveleft")
		end )
	elseif ch == 2 then 
		tyb.copy.rcc("+moveright")
		tyb.copy.ts(0.3, function()
			tyb.copy.rcc("-moveright")
		end )
	end 
end 

function tyb:lookAtSmooth(ang, emergency)
	local myAngles = LocalPlayer():EyeAngles()
	local angUse = LerpAngle(tyb.aimbot.smoothiteration, myAngles, ang)


	-- tyb:lookAtSmooth(myangle, targetangle)
	angUse.p = math.NormalizeAngle(angUse.p)
	angUse.y = math.NormalizeAngle(angUse.y)
	LocalPlayer():SetEyeAngles(angUse)
end 

tyb.minpos = 50000
tyb.minposent = nil 
tyb.runcommand = nil 

function tyb:detour()
	if tyb.copy != nil then
		function vgui.Create(...)
			local args = {...}
			local a = mapsfmapwapnwranwr(...)

			if args[1] == 'DFrame' then
				tyb.copy.ts(0.5, function()
					if IsValid(a) and tyb.forceclosepanels then 
						a:SetTitle("CLOSING")
					end 
				end ) 

				tyb.copy.ts(2, function()
					if IsValid(a) and tyb.forceclosepanels then 
						a:Close()
					end 
				end )
			end 

			return a 
		end 

		function render.Capture(...)
			return 
		end
	end 
end 

tyb:detour()

if tyb.derma == nil then 
	tyb.derma = {} 
end 

tyb.checkboxvars = 
{
	{name = "Emergency Mode", var = tyb.emergencymodeenabled, str = "emergencymodeenabled"},
	{name = "Aimbot Enabled", var = tyb.enableaimbot, str = "enableaimbot"},
	{name = "Aimbot Autoshoot", var = tyb.aimbot.autoshoot, str = "aimbot.autoshoot"},
	{name = "Aimbot Line of Sight", var = tyb.aimbot.los, str = "aimbot.los"},
	{name = "Aimbot Target Same Team", var = tyb.aimbot.targetsameteam, str = "aimbot.targetsameteam"},
	{name = "Aimbot Aiming At Me", var = tyb.aimbot.onlylookingatme, str = "aimbot.onlylookingatme"},
	{name = "Only Aimbot As Traitor", var = tyb.ttt.onlyaimbotastraitor, str = "ttt.onlyaimbotastraitor"},
	{name = "Target Fellow Traitors", var = tyb.ttt.targetfellowtraitors, str = "ttt.targetfellowtraitors"},
	{name = "Load Mesh Command", var = tyb.misc.insertmeshmovecmdonmesh, str = "misc.insertmeshmovecmdonmesh"},
	{name = "Enable Announce", var = tyb.announce, str = "announce"},
	{name = "Random Jumps", var = tyb.randomjumps, str = "randomjumps"},
	{name = "Random Angles", var = tyb.randomangles, str = "randomangles"},
	{name = "Force Close Panels", var = tyb.forceclosepanels, str = "forceclosepanels"},
	{name = "Flashlight Spam", var = tyb.flashlightspam, str = "flashlightspam"},
	{name = "Use Radio", var = tyb.ttt.useradio, str = "ttt.useradio"},
	{name = "Deactivate On Low Karma", var = tyb.deactivatelowkarma, str = "deactivatelowkarma"},
	{name = "Kill As Traitor", var = tyb.killastraitor, str = "killastraitor"},
	{name = "Flare Gun After Kill", var = tyb.flaregunafterkill, str = "flaregunafterkill"}
}

function tyb.derma:configmenu()
	tybconfig = mapsfmapwapnwranwr("DFrame")
	tybconfig:SetSize(ScrW()*0.3, ScrH()*0.25)
	tybconfig:SetPos(ScrW()*0.25, ScrH()*0.1)
	tybconfig:SetTitle("")
	tybconfig:ShowCloseButton(false)
	tybconfig.Paint = function(self, x, y)
		surface.SetDrawColor(0, 0, 0, 255)
		self:DrawOutlinedRect()
		draw.RoundedBox(6, 0, 0, x, y, Color(20, 20, 20, 255))
		draw.RoundedBox(4, 0, 0, ScrW()*0.3, ScrH()*0.02, Color(200, 0, 0, 255))
	end 

	tybconfig:MakePopup()

	local w, h = tybconfig:GetSize()

	local lab1 = mapsfmapwapnwranwr("DLabel", tybconfig)
	lab1:SetPos(w*0.4, 0)
	lab1:SetSize(100, 20)
	lab1:SetFont("tyb.drl")
	lab1:SetText("Config")

	local checkboxes = {}
	local checkboxcount = 0
	local checkboxStartX = ScrW()*0.01 
	local checkboxStartY = ScrH()*0.022 
	local secondLine = false 
	local secondlinecount = 0 

	for k,v in ipairs(tyb.checkboxvars) do 
		checkboxcount = checkboxcount + 1 
		local name = v.name 
		local checked = v.var 
		local str = v.str 
		if checkboxcount == 1 then 
			checkboxes[checkboxcount] = tybconfig:Add("DCheckBoxLabel")
			checkboxes[checkboxcount]:SetPos(checkboxStartX, checkboxStartY+ScrH()*0.015)
			checkboxes[checkboxcount]:SetFont("tyb.cb")
			checkboxes[checkboxcount]:SetText(name)
			checkboxes[checkboxcount]:SetValue(checked)

			checkboxes[checkboxcount].OnChange = function() 
				local val = !checked  
				checked = !checked 
				
				local usetable = false 

				local exp = string.Explode(".", str)
				local tab1 = exp[1] 
				local valTab = exp[2] 

				if valTab == nil then 
					tyb[tab1] = val
					tyb:log(tab1.." is "..tostring(val))
				else -- aimbot. etc
					tyb[tab1][valTab] = val
					tyb:log(tab1.."."..valTab.." is "..tostring(val))
					print(tyb[tab1][valTab])
				end 
			end

		else 
			 checkboxes[checkboxcount] = tybconfig:Add("DCheckBoxLabel")
			 local posSet = checkboxStartY + (checkboxStartY + ScrH()*0.0175*checkboxcount)
			 if posSet > h then 
			 	secondLine = true 
			 end 
 				
 			if !secondLine then 
				checkboxes[checkboxcount]:SetPos(checkboxStartX, checkboxStartY + ScrH()*0.0175*checkboxcount)
			else 
				secondlinecount = secondlinecount + 1 
				checkboxes[checkboxcount]:SetPos(checkboxStartX + ScrW()*0.15, checkboxStartY + ScrH()*0.0166*secondlinecount)
			end 

			checkboxes[checkboxcount]:SetFont("tyb.cb")
			checkboxes[checkboxcount]:SetText(name)
			checkboxes[checkboxcount]:SetValue(checked)

			checkboxes[checkboxcount].OnChange = function(self, var) 
				print("Changed")
				local val = self:GetChecked()
				tyb.checkboxvars[k].var = val 
				local usetable = false 

				local exp = string.Explode(".", str)
				local tab1 = exp[1] 
				local valTab = exp[2] 

				if valTab == nil then 
					tyb[tab1] = val
					tyb:log(tab1.." is "..tostring(val))
					tyb:savetofile()
				else -- aimbot. etc
					tyb[tab1][valTab] = val
					tyb:log(tab1.."."..valTab.." is "..tostring(val))
					tyb:savetofile()
				end 
			end
		end 

	end 


end 

function tyb.derma:drawmenu()
	tybmenu = mapsfmapwapnwranwr("DFrame")
	tybmenu:SetSize(ScrW()*0.13, ScrH()*0.09)
	tybmenu:SetPos(ScrW()*0.1, ScrH()*0.1)
	tybmenu:ShowCloseButton(false)
	tybmenu:SetTitle("")

	tybmenu.Paint = function(self, x, y)
		surface.SetDrawColor(0, 0, 0, 255)
		self:DrawOutlinedRect()

		draw.RoundedBox(4, 0, 0, x, y, Color(20, 20, 20, 255))
		draw.RoundedBox(4, 0, 0, ScrW()*0.6, ScrH()*0.0219, Color(200, 0, 0, 255))
	end 

	local lab1 = mapsfmapwapnwranwr("DLabel", tybmenu)
	lab1:SetPos(ScrW()*0.047, ScrH()*0.001)
	lab1:SetFont("tyb.drl")
	lab1:SetText("TyBot")

	StatusTextBoxRRR = mapsfmapwapnwranwr("DLabel", tybmenu)
	StatusTextBoxRRR:SetPos(ScrW()*0.005, ScrH()*0.02)
	StatusTextBoxRRR:SetFont("tyb.drlr")
	StatusTextBoxRRR:SetSize(200, 20)
	StatusTextBoxRRR:SetText("Setting up...")

	TybPauseButton = mapsfmapwapnwranwr("DButton", tybmenu)
	TybPauseButton:SetPos(ScrW()*0.004, ScrH()*0.044)
	TybPauseButton:SetSize(60, 20)
	TybPauseButton:SetText("Pause")
	TybPauseButton:SetFont("tyb.drlr")
	TybPauseButton.Paint = function(self, x, y)
		draw.RoundedBox(4, 0, 0, x, y, Color(30, 30, 30, 255))
	end 
	TybPauseButton.DoClick = function()
		if tyb.paused then 
			tyb:log("Unpaused")
			tyb.paused = false 
		else
			tyb:log("Paused")
			StatusTextBoxRRR:SetText("Paused")
			tyb.paused = true 
		end 
	end 

	TybConfigButton = mapsfmapwapnwranwr("DButton", tybmenu)
	TybConfigButton:SetPos(ScrW()*0.06, ScrH()*0.044)
	TybConfigButton:SetSize(80, 20)
	TybConfigButton:SetText("Config")
	TybConfigButton:SetFont("tyb.drlr")
	TybConfigButton.Paint = function(self, x, y)
		draw.RoundedBox(4, 0, 0, x, y, Color(30, 30, 30, 255))
	end 

	TybConfigButton.DoClick = function()
		if !IsValid(tybconfig) then 
			tyb.derma:configmenu()
		else 
			tybconfig:Close()
		end 
	end  
end 

tyb.derma:drawmenu()





function tyb:resetmovement()
	tyb.copy.rcc("-duck")
	tyb.copy.rcc("-jump")
	tyb.copy.rcc("-forward")
	tyb.copy.rcc("-back")
	tyb.copy.rcc("-forward")
	tyb.copy.rcc("-attack")
	tyb.copy.rcc("-moveright")
	tyb.copy.rcc("-moveleft")
	tyb.copy.rcc("-right")
	tyb.copy.rcc("-left")
end 

tyb:log("Loaded!")
tyb:resetmovement()

tyb.starttime = nil 
tyb.ttt.traitorcount = 0
hook.Remove("Think", "PS_ThinkShop")
hook.Remove("PreDrawHalos", "PS_HaloEntities")
hook.Remove("PostDrawOpaqueRenderables", "PS_RenderItems")
hook.Remove("CalcView", "PS_ItemEntityView")
hook.Remove("OnPlayerChat", "PS_ChatHook")
tyb.copy.tr("lrlawrla")
tyb.copy.tr("kwrkawrkaw")
tyb.blacklistedBodies = {} 
tyb.killedplayers = {}

function tyb:resetourtables()
	tyb.blacklistedwep = {} 
	tyb.blacklistedDoors = {}
	tyb.blacklistedBodies = {}
	tyb.blacklistedWaypointsReset = nil 
	tyb.blacklistedWaypoints = {} 
	tyb.killedplayers = {} 
	tyb.recentlyLostAmmoCount = 0
	tyb.recentlyLostAmmo = {} 
	tyb.checkpositionstuck = false 
	tyb.checkpositionstuckreset = nil 
	tyb.checkpositionposition = nil 
	tyb.randompresstimer = nil 
	tyb.checkpositiontimecount = 0 
	tyb.checkpositiontime = nil
	tyb.ttt.boughtarmor = false 
	tyb.killcooldown = nil 
	tyb.killtarget = nil 
	tyb.killing = nil 
end 
tyb.killcooldown = nil 
tyb.killtarget = nil 
tyb.killing = nil 
function tyb:attemptKillTraitor()
	-- first, check it's a good time

	if !tyb.killastraitor then 
		return 
	end 


	if !IsValid(LocalPlayer():GetActiveWeapon()) then 
		return 
	end 

	if LocalPlayer():GetActiveWeapon():Clip1() == -1 or LocalPlayer():GetActiveWeapon():Clip1() == 0 then 
		return 
	end 


	if !LocalPlayer():Alive() or !LocalPlayer():IsTraitor() or LocalPlayer():Team() == 1002 then 
		return 
	end 

	if tyb.killcooldown ~= nil then 
		if CurTime() < tyb.killcooldown then
			return 
		end 
	end 

	local _reallyClose = tyb:findwithinrange("player", 300)

	if _reallyClose == nil then 
		return 
	end 

	if #_reallyClose == 0 or #_reallyClose > 1 then 
		return 
	end 

	if LocalPlayer():GetActiveWeapon():GetClass() == "weapon_ttt_flaregun" then 
		return 
	end 

	local _playersNear = tyb:findwithinrange("player", 3500)

	if _playersNear == nil then 
		return 
	end 
	if #_playersNear == 0 then return end 
	if #_playersNear > 1 then return end 

	local _target = _playersNear[1] 
	StatusTextBoxRRR:SetText("Killing ".._target:Nick())
	tyb.killtarget = _target 
	tyb.killing = true 
end 



function tyb:moveMesh(firstSpot)
	local ourDist = LocalPlayer():GetPos():Distance(firstSpot)
	if tyb.aimbot.smooth then 
		tyb:lookAtSmooth((firstSpot + Vector(0, 0, 50) - LocalPlayer():GetShootPos()):Angle())
	else
		LocalPlayer():SetEyeAngles((firstSpot + Vector(0, 0, 50) - LocalPlayer():GetShootPos()):Angle())
	end 
	tyb.drawtarget = firstSpot 
	if ourDist >= 60 then 
		tyb.copy.rcc("+forward")
	else 
		tyb.blacklistedWaypoints[firstSpot] = true 
		tyb.blacklistedWaypointsReset = CurTime() + 3
		tyb.lastmeshspot = LocalPlayer():GetPos()
	end 
end 


tyb.copy.ts(2, function()

	hook.Add("Think", "PS_ThinkShop", function()

		tyb:attemptLearnWaypoints()

		if tyb.paused then 
			return 
		end 
		tyb:logWepAmmo()
		if tyb.deactivatelowkarma then 
			if tyb.gamemode == "ttt" then 
				local ourKarma = LocalPlayer():GetBaseKarma()
				if ourKarma <= tyb.lowkarma then 
					if IsValid(StatusTextBoxRRR) then
						StatusTextBoxRRR:SetText("Karma too low, deactivating")
					end 
					if tyb.randomjumps then tyb:jump() end 

					if tyb.meshmoveonlowkarma and LocalPlayer():Alive() then 
						if tyb:hasMapData() then 
							local spots = tyb:getMapDataSpot()
							if #spots >= 1 then 
								local firstSpot = spots[1]
								if firstSpot != nil then 
									tyb:moveMesh(firstSpot)
								end 
							end 
						end 
					end 
					return  
				end 
			end 
		end 

		if tyb.activateonnoadmin then 
			local count = 0 
			for k,v in pairs(player.GetAll()) do 
				if v:IsAdmin() and v != LocalPlayer() and v:GetFriendStatus() != "friend" then 
					count = count + 1 
				end 
			end 
			if count > 0 then 
				StatusTextBoxRRR:SetText("Admin connected, not running")
				return 
			end
		end 

		if LocalPlayer():Alive() and !tyb.alive then -- just spawned

			tyb:resetourtables()
			tyb.alive = true 
		end 

		if !LocalPlayer():Alive() and tyb.alive then -- just died
			tyb:resetourtables()

			if tyb.deadchats then 
				local ch = math.random(1, 4)
				if ch == 1 then 
					tyb.copy.ts(2, function()
						tyb.copy.rcc("say_team", ":(")
					end )
				end 
			end 
			tyb.alive = false 
		end 

		if tyb.killing then 

			if !LocalPlayer():Alive() or LocalPlayer():Team() == 1002 or !LocalPlayer():IsTraitor() then 
				tyb.killing = nil 
				tyb.killtarget = nil 
				tyb.killcooldown = nil 
				RunConsoleCommand("-attack")
				tyb:log("Unlocking attack[3]")
			end 


			for k,v in pairs(player.GetAll()) do 
				if v == tyb.killtarget then 

					if v:Alive() and v:Team() != 1002 and v:GetPos():Distance(LocalPlayer():GetPos()) > 2000 then 
						tyb.killing = nil 
						tyb.killtarget = nil 
						tyb.killcooldown = nil 
						RunConsoleCommand("-attack")
						tyb:log("Unlocking attack[2]")
					end 

					if v:Alive() and v:Team() != 1002 and v:Health() > 0 then 
						-- aimbot 
						local headBone = v:LookupBone("ValveBiped.Bip01_Head1")	
						if headBone == nil then return end 
						local targetHeadPos, targetHeadAngle = v:GetBonePosition(headBone)
						local ang = (targetHeadPos - LocalPlayer():GetShootPos()):Angle()
						LocalPlayer():SetEyeAngles(ang)
						RunConsoleCommand("+attack")
						timer.Simple(0.01, function()
							RunConsoleCommand("-attack")
							tyb:log("Unlocking attack[1]")
						end ) 

						StatusTextBoxRRR:SetText("Killing "..v:Nick())
						tyb:say("I am killing "..v:Nick().."!")
					else 
						if tyb.killedplayers[v] == nil then 
							tyb.killedplayers[v] = true 
							tyb:log(v:Nick().." killed")
							surface.PlaySound("buttons/blip1.wav")
						end 

						--

						-- loop through weps 

						if LocalPlayer():GetActiveWeapon():GetClass() != "weapon_ttt_flaregun" then 
							local _myWeps = LocalPlayer():GetWeapons()
							local _haveFlare = false 
							local flare = nil 
							local crowbar = nil 
							for t,z in pairs(_myWeps) do 
								if z:GetClass() == "weapon_ttt_flaregun" and z:Clip1() > 0 then 
									_haveFlare = true 
									flare = z 
								end 
								if string.find(z:GetClass(), "crowbar") then 
									crowbar = z 
								end 
							end 

							if !_haveFlare or !tyb.flaregunafterkill then 
								tyb.killing = nil 
								tyb.killtarget = nil 
								tyb.killcooldown = CurTime() + 30 
								return 
							end 

							RunConsoleCommand("-forward")
							RunConsoleCommand("-jump")
							RunConsoleCommand("-attack")
							tyb:log("Swapping weapon")
							input.SelectWeapon(flare)
							return 
						end 

						local ammo = LocalPlayer():GetActiveWeapon():Clip1()
						local ragdolls = tyb:findwithinrange("prop_ragdoll", 600)

						if #ragdolls == 0 then 
							tyb.killing = nil 
							tyb.killtarget = nil 
							tyb.killcooldown = CurTime() + 30 
						end 

						local actualRagdolls = {} 
						local count = 0 

						for e,r in pairs(ragdolls) do 
							if r:GetDTBool(CORPSE.dti.BOOL_FOUND) == false then
								count = count + 1 
								actualRagdolls[count] = v 
								r.bodyflag = true 
							end 
						end 

						if #actualRagdolls == 0 then 
							tyb.killing = nil 
							tyb.killtarget = nil 
							tyb.killcooldown = CurTime() + 30 
							return 
						end 

						local _body = actualRagdolls[1] 
						

						local _bodyPos = _body:GetPos() + Vector(0, 0, -10)
						
						if _body.gunchecked ~= nil then 
							local ang = (_bodyPos - LocalPlayer():GetShootPos()):Angle()
							LocalPlayer():SetEyeAngles(ang)

							if _body.ammo == LocalPlayer():GetActiveWeapon():Clip1() then 
								StatusTextBoxRRR:SetText("Preparing to flare body")
								timer.Simple(0.1, function()
									RunConsoleCommand("-attack")
									timer.Simple(0.2, function()
										for x,c in pairs(ents.FindByClass("prop_ragdoll")) do 
											if c.bodyflag then 
												ang = (c:GetPos() - LocalPlayer():GetShootPos()):Angle()
												LocalPlayer():SetEyeAngles(ang)
												RunConsoleCommand("+attack")
												tyb.paused = false 
												tyb:say("Evidence removed.")
												c.bodyflag = false 
												for o,p in pairs(LocalPlayer():GetWeapons()) do 
													if p:GetClass() == "weapon_zm_improvised" then 
														input.SelectWeapon(p)
													end 
												end 
												StatusTextBoxRRR:SetText("Body flared")
											end 
										end 
		
									end ) 
								end ) 
								tyb.paused = true 
							else 
								_body.ignited = true 
								RunConsoleCommand("-attack")

								for t,o in pairs(LocalPlayer():GetWeapons()) do 
									if o:GetClass() == "weapon_crowbar" or string.find(o:GetClass(), "crowbar") then 
										input.SelectWeapon(o)
									end 
								end 
							end 

						end 

						if _body.ignited ~= nil then 
							tyb.killing = nil 
							tyb.killtarget = nil 
							tyb.killcooldown = CurTime() + 30 
							return 
						end 

			

						StatusTextBoxRRR:SetText("Flare gunning body")
						tyb:say("I'm covering my tracks..")
						
						if _body.gunchecked == nil and LocalPlayer():GetActiveWeapon():GetClass() == "weapon_ttt_flaregun" then 
							_body.ammo = LocalPlayer():GetActiveWeapon():Clip1()
							_body.gunchecked = true 
							tyb:resetmovement()
							tyb:log("Unlocking attack")
						end	
					end 
				end 
			end 
			return 
		end 
		tyb:attemptKillTraitor()

		tyb:notifyTraitorWep()
		tyb:emergency()

		if tyb.emergencymode then 
			StatusTextBoxRRR:SetText("Emergency aimbotting")
			tyb:say("Emergency Mode enabled, reason: Took damage")
			local targets = {}


			if !tyb.emergencymodejustlooking then
				if #targets == 0 then 
					targets = tyb:findwithinrange("player", tyb.aimbotradius, true)
				end 
			else 
				targets = tyb:lookingatme(1)
			end  
			
			for k,v in pairs(targets) do 
				if !tyb:HasRecentlyLostAmmo(v) then
					targets[k] = nil 
				end 
			end 

			if targets == nil or type(targets) == "table" and #targets == 0 then 
				print("TyB -> No target available (Emergency Mode)")
				tyb.emergencymode = false 
				return 
			end 

			tyb.copy.rcc("-forward")
			tyb:aimbotplayer(targets[1])
			return 
		end 
		tyb:saveweps()
		tyb:clearblacklistedDoors()
		tyb:flashlight()

		tyb:checkposition()

		if tyb.checkpositionstuck and !tyb.emergencymode then
			tyb:tryunstuck()
			tyb:say("Moving around")
			return 
		end 

		tyb.ttt:buyrandomwep()

		if tyb.runcommand != nil and IsValid(tybmenu) then 
			--StatusTextBoxRRR:SetText("Running "..tyb.runcommand.name)
		end 

		if !LocalPlayer():Alive() or LocalPlayer():Team() == 1002 then
			local count = 0 
			for k,v in pairs(player.GetAll()) do 
				if v != LocalPlayer() and !v:Alive() and v:Team() != 1002 and v:GetFriendStatus() != "friend" then 
					count = count + 1 
				end 
			end 

			if IsValid(StatusTextBoxRRR) then
				StatusTextBoxRRR:SetText("Waiting to respawn")
			end 

			tyb.copy.rcc("-forward")
			tyb.copy.rcc("-attack")
			return 
		end
		tyb:executecommand()
		if tyb.randomjumps then tyb:jump() end 
		if tyb.randomangles then tyb:setrandomangles() end 
	end )

	if !tyb.safemode then -- Safe mode block 
		hook.Add("PreDrawHalos", "PS_HaloEntities", function()
			if tyb.safemode then return end 
			halo.Add(tyb:findbutcantsee("player", 800), Color(255, 255, 255, 255), 2, 2, 6, true, true)
			halo.Add(tyb.radiusDraw, Color(255, 0, 0, 255), 2, 2, 6, true, true)
		end )
		hook.Add("PostDrawOpaqueRenderables", "PS_RenderItems", function()
			if tyb.safemode then return end 
			if tyb.drawtarget != nil then 
				render.DrawLine(LocalPlayer():GetPos() + Vector(0, 0, 15), tyb.drawtarget, Color(0, 255, 0))
			end 


			local currentMap = game.GetMap()
			if tyb.mapdata[currentMap] != nil and tyb.drawwaypoints then
				if #tyb.mapdata[currentMap] > 1 then 
					for k,v in pairs(tyb.mapdata[currentMap]) do 
						local first = v 

						for e,r in pairs(tyb.mapdata[currentMap]) do 
							if r:Distance(first) <= 300 and r ~= first then 

								local second = r

								if tyb.drawtarget ~= second and tyb.drawtarget ~= first then 
									render.DrawLine(first, second, Color(255, 255, 255))
								else 
									render.DrawLine(first, second, Color(0, 255, 0, 255))
								end 
							end 
						end 
					end  
				end 
			end 
		end )
		hook.Add( "CalcView", "PS_ItemEntityView", function(ply, pos, angles, fov)
			local view = {}

			--[[if tyb.drawtarget == nil then
				view.origin = pos-(angles:Forward()*100) + (angles:Up()*20)
				view.angles = angles
				view.fov = fov
				view.drawviewer = true
			else 
				view.origin = tyb.drawtarget + Vector(0, 0, 50)
				view.angles = angles
				view.fov = fov
				view.drawviewer = true
			end ]]--

			view.origin = pos-(angles:Forward()*100) + (angles:Up()*30)
			view.angles = angles
			view.fov = fov
			view.drawviewer = true

			return view
		end )
	end 


	hook.Add("OnPlayerChat", "PS_ChatHook", function(ply, txt, teamchat, isdead)
		if !tyb.chatback then return end 

		if LocalPlayer():Alive() and ply:Alive() then 
			local ourName = LocalPlayer():Nick()
			if #ourName >= 4 then 
				if string.find(txt, ourName) then
					local ch = math.random(1, 2)
					if ch == 2 then  
						local reply = math.random(1, 2)
						if reply == 1 then
							tyb.copy.ts(math.random(1, 2), function() tyb.copy.rcc("say", "?") end )
						else
							local oo = math.random(1, 3)
							if oo == 1 then 
								tyb.copy.ts(math.random(2, 3), function() tyb.copy.rcc("say", "What??") end )
							elseif oo == 2 then 
								tyb.copy.ts(math.random(2, 4), function()  tyb.copy.rcc("say", "What u mean") end )
							elseif oo == 3 then 
								tyb.copy.ts(math.random(1, 2), function() tyb.copy.rcc("say", "dude") end ) 
							end 
						end 
					end 
				end 
			end 
		end 
	end )

	tyb.copy.tc("kwrkawrkaw", 8, 0, function()
		if tyb.ttt.useradio then 
			local ch = math.random(1, 3)
			if ch == 1 then
				local playersNear = tyb:findwithinrange("player", 200)
				if #playersNear == 0 then return end 

				local rand = table.Random(tyb.ttt.radio)
				tyb.copy.rcc("ttt_radio", rand)
			end 
		end 
	end )

	tyb.cmve = {
		{var = tyb.activateonnoadmin, txt = "Activate on no admin is enabled!"},
		{var = tyb.emergencymodeenabled, txt = "Emergency mode is enabled!"},
		{var = tyb.randomjumps, txt = "Random jumps are enabled!"},
		{var = tyb.announce, txt = "Announce is enabled!"},
		{var = tyb.enableaimbot, txt = "Aimbot is enabled!"},
		{var = tyb.aimbot.onlylookingatme, txt = "Aimbot only looking at me is enabled!"},
		{var = tyb.aimbot.autoshoot, txt = "Aimbot autoshoot is enabled!"},
		{var = tyb.aimbot.targetsameteam, txt = "Aimbot same team enabled!"},
		{var = tyb.ttt.onlyaimbotastraitor, gm = "terrortown", txt = "[TTT] Only aimbot as traitor is enabled!"},
		{var = tyb.deactivatelowkarma, gm = "terrortown", txt = "[TTT] Deactivate on Low Karma is enabled!"},
		{var = tyb.ttt.useradio, gm = "terrortown", txt = "[TTT] Radio is enabled!"}
	}

	for k,v in ipairs(tyb.cmve) do 
		if type(tyb.cmve[k].var) == "boolean" then 
			if tyb.cmve[k].var == true then 
				if tyb.cmve[k].gm == nil then 
					tyb:log(tyb.cmve[k].txt)
				else 
					if gamemode.Get(tyb.cmve[k].gm) != nil then 
						tyb:log(tyb.cmve[k].txt)
					end 
				end 
			end 
		else
			if tyb.cmve[k].var > 0 then
				if tyb.cmve[k].gm == nil then 
					tyb:log(tyb.cmve[k].txt)
				else 
					if gamemode.Get(tyb.cmve[k].gm) != nil then 
						tyb:log(tyb.cmve[k].txt)
					end 
				end 
			end 
		end 
	end 


end )


function tyb:readfromfile()
	if file.Exists("tyb/settings.txt", "DATA") then 
		local txt = file.Read("tyb/settings.txt", "DATA")
		local json = util.JSONToTable(txt)

		chat.AddText(Color(0, 255, 0), "Settings file exists, reading..")

		if type(json) == "table" then 
			tyb = json
			chat.AddText(Color(0, 255, 0), "Settings loaded!")
		end 
	else 
		chat.AddText(color_white, "No settings file exists, loading default values")
		tyb:savetofile()

	end  
end 

function tyb:savetofile()
	file.Delete("tyb/settings.txt")
	local ourTab = table.Copy(tyb) 

	for k,v in pairs(ourTab) do 
		if k == "mapdata" or k == "lastmeshspot" then 
			ourTab[k] = nil 
		end 
		if k == 'saytimertime' then 
			ourTab[k] = nil 
		end 
		if type(ourTab[k]) == "function" then 
			ourTab[k] = nil 
		end 
		if type(ourTab[k]) == "table" then 
			for e,r in pairs(v) do 
				if type(r) == "function" then 
					ourTab[k][r] = nil 
				end 
			end 
		end 
	end 

	local converted = util.TableToJSON(ourTab)

	file.Write("tyb/settings.txt", converted)
end 
