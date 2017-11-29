-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- This tool uses the free AutoLan by M.Y. Developers
-- http://www.mydevelopersgames.com/AutoLAN/Features.html
local client = require("ssk2.external.mydevelopers.autolan.Client")

local theServer
local events

local public = {}
-- =============================================================
local getTimer     = system.getTimer

function public.getIP()
	local socket = require( "socket" )
	local tmp = socket.connect( "www.google.com", 80 )
	local ip, port = tmp:getsockname() 
	print( "IP: " .. tostring(ip) .. " Port: " .. tostring(port) )
end


function public.init( requestedEvents )
	events = requestedEvents or {}
	
	client:start()
	client:scanServers()
	local function onServerFound(event)
		print("Connecting to: ", event.serverIP )
		client:connect(event.serverIP)
		ignore( "autolanServerFound", onServerFound ) 
	end
	listen( "autolanServerFound", onServerFound ) 
end

--function public.send( msg )
	--print("---------------------- ", msg)
	--client:send( { name = "reflect", event = { msg = msg } } )
--end

-- Handle client joins and drops
local function onServerConnected( event )
	print("CONNECTED TO SERVER")
	client:send( { name = "reflect_request", events = events } )
	post("onServerConnected")
end
Runtime:addEventListener("autolanConnected", onServerConnected)


local function onMessage( event )
	if( event.message.name == "reflect_event" ) then
		local revent = event.message.event
		revent.name = revent.name -- .. "_r"
		Runtime:dispatchEvent( revent )
	end
end
Runtime:addEventListener("autolanReceived", onMessage)	

return public