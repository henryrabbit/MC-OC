local component = require("component")
local event = require("event")
local tunnel = coponent.tunnel

local function mymessage(tcard, fcar, tport, fport, ...)
	if ...[1]=="location" then
		file = io.open(fcar,"w")
		file:write(...)
		file:close
	else if ...[1]=="dungeon" then
		file = io.open("dungeon","a")
		file:write(...)
		file:close
	end end
end
event.listen("modem_message",finishmessage)