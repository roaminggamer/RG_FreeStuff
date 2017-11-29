-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- This tool uses the free AutoLan by M.Y. Developers
-- http://www.mydevelopersgames.com/AutoLAN/Features.html
local server = require("ssk2.external.mydevelopers.autolan.Server") 
local listeners = {}

local public = {}
-- =============================================================
local getTimer     = system.getTimer

--[[
local reflectorEvents = {
	"accelerometer",
	"audio",
	"axis", 
	"collision",
	"colorSample",
	"completion",
	"fbconnect",
	"finalize",
	"gameNetwork",
	"gyroscope",
	"heading",
	"inputDeviceStatus",
	"key",
	"licensing",
	"location",
	"mapAddress",
	"mapLocation",
	"mapMarker",
	"mapTap",
	"memoryWarning",
	"mouse",
	"networkRequest",
	"networkStatus",
	"notification",
	"orientation",
	"particleCollision",
	"popup",
	"postCollision",
	"preCollision",
	"productList",
	"resize",
	"scene",
	"sprite",
	"storeTransaction",
	"system",
	"tap",
	"timer",
	"touch",
	"unhandledError",
	"urlRequest",
	"userInput",	
	"ON_KEY" -- SSK event (from RGEasyKeys)	
}
--]]
local function purgeListeners()
	for k,v in pairs( listeners ) do
		ignore( k,v)
	end 
	listeners = {}
	post( "reflectedEvents" )
end


function public.getIP()
	local socket = require( "socket" )
	local tmp = socket.connect( "www.google.com", 80 )
	local ip, port = tmp:getsockname() 
	print( "IP: " .. tostring(ip) .. " Port: " .. tostring(port) )
end

function public.init()
	print("HOSTING")
	server:setCustomBroadcast("1 Player")
	server:start()
end

-- Handle client joins and drops
local function onClientConnected( event )
	--table.dump(event)
	client = event.client
	post("onClientConnected")
end
Runtime:addEventListener("autolanPlayerJoined", onClientConnected)

local function onClientDropped(event)
	client = nil
	post("onClientDropped")
	purgeListeners()	
end
Runtime:addEventListener("autolanPlayerDropped", onClientDropped)


local function onMessage( event )
	--table.print_r(event)
	if( event.message.name == "reflect_request" ) then		
		local clientID 	= tonumber(event.clientID)
		local events 	= event.message.events
		local reflectedEvents
		print( "Receiver requested events... ", clientID, client)		
		--table.dump(events)

		for i = 1, #events do 
			local event = events[i]

			-- User requesed 'easyInput' input module activation
			if( string.match( event, "easyInput" ) ~= nil ) then
				-- Dispatch a special event handled by the 'reflectorApp'
				-- 
				post("onEasyInput", { type = event } )

			else
				reflectedEvents = (reflectedEvents) and (reflectedEvents .. ", " .. event) or event
				if( not listeners[event] ) then
					print("Create reflector listener for event: ", event )
					local function reflection_listener( e )
						--e.name = event .. "_r"
						e.name = event
						e.time = e.time or system.getTimer()
						if( client ) then
							client:send( { name = "reflect_event", event = e } )
						end
					end
					listeners[event] = reflection_listener
					listen( event, reflection_listener )
				end
			end
		end
		print(reflectedEvents)
		post("reflectedEvents", { events = reflectedEvents } )
	end
end
Runtime:addEventListener("autolanReceived", onMessage)	


return public