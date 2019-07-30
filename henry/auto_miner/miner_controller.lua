local component = require("component")
local event = require("event")
local tunnel = component.tunnel

local function mymessage(tcard, fcar, tport, fport, str, ...)
	if str=="location" then
		local file = io.open(fcar,"w")
		io.output(file)
		io.write(fcar,str,...)
		io.close(file)
	else if str=="dungeon" then
		local file = io.open("dungeon","a")
		io.output(file)
		io.write(fcar,str,...)
		io.close(file)
	end end
end
event.listen("modem_message",mymessage)