local component = require("component")
local event = require("event")
local tunnel = component.tunnel

local function mymessage(messagetype, tcard, fcard, tport, fport, str, x, y, z)
	print("get a message to ",tcard)
	print("about ",str)
	print("at",x,y,z)
	if str=="location" then
		local file = io.open(tcard,"w")
		io.output(file)
		io.write(tcard," ",str," ",x," ",y," ",z"\n")
		io.close(file)
	else if str=="dungeon" then
		local file = io.open("dungeons","a")
		io.output(file)
		io.write(tcard," ",str," ",x," ",y," ",z"\n")
		io.close(file)
	end end
	return
end

event.listen("modem_message",mymessage)