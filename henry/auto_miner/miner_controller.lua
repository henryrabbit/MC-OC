local component = require("component")
local event = require("event")
local tunnel = component.tunnel

local function mymessage(messagetype, tcard, fcard, tport, fport, str, x, y, z)
	--print("get a message to ",tcard)
	--print("about ",str)
	--print("at",x,y,z)
	local file
	if str=="location" then
		file = io.open(tcard,"w")
		
	else if str=="dungeon" then
		file = io.open("dungeons","a")
	end end
	file:write(tcard.." "..str.." "..x.." "..y.." "..z.."\n")
	--print(tcard.." "..str.." "..x.." "..y.." "..z.."\n")
	file:close()
	return
end

event.listen("modem_message",mymessage)
print("Log service starts successfully! Please use cat to check logs.")