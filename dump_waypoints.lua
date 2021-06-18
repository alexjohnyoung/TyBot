local testTable = {}

concommand.Add("add_waypoint_to_table", function()
	local num = #testTable 
	local pos = LocalPlayer():GetPos()
	testTable[num+1] = pos 
end )
concommand.Add("dump_waypoint_data", function()
	if #testTable == 0 then print("Need more data") return end 

	local json = util.TableToJSON(testTable)
	file.Write("tyb/mapdata/"..game.GetMap()..".txt", json)
	print(json)
end )