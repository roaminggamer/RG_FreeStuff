-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local public = {}
-- =============================================================
local getTimer     = system.getTimer
local updatePeriod = 0

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

function public.getReflectorEvents() return reflectorEvents end
function public.setReflectorEvents( newEvents ) reflectorEvents = newEvents or reflectorEvents end
function public.printReflectorEvents() 
	for i = 1, #reflectorEvents do
		print( i, reflectorEvents[i] )
	end
end

function public.getIP()
	local socket = require( "socket" )
	local tmp = socket.connect( "www.google.com", 80 )
	local ip, port = tmp:getsockname() 
	print( "IP: " .. tostring(ip) .. " Port: " .. tostring(port) )
end

function public.setUpdatePeriod( period )
	updatePeriod = period or 0
end

function public.getUpdatePeriod( )
	return updatePeriod
end


function public.initReceiver( params )

	params = params or {}
	params.events = events or reflectorEvents
	local events = params.events

	local server = require "RGEventReflector.UDPServer"
	events = events or reflectorEvents
	local function onClientMessage( event )
		--table.dump( event )
		if( event.cmd == "reflect" ) then
			local msg = event.msg
			-- Dispatch all Runtime events we're listening for
			for i = 1, #events do
				if( events[i] == msg.name ) then
					msg._isReflected = true
					for k,v in pairs(msg) do
						if( tonumber(v) ~= nil ) then
							--msg[k] = tonumber(v)
							--print("converted", k, v, type(msg[k]))
						end
					end
					Runtime:dispatchEvent( msg )
					--print("Got reflected event: ", msg.name)
					--table.dump(msg)
				end
			end
		end
	end
	listen( "CLIENT_MSG", onClientMessage )
	server:start()
end

function public.initSender( params )
	local client = require "RGEventReflector.UDPClient"

	params = params or {}
	params.events = events or reflectorEvents
	local events = params.events

	if( params.receiverIP ) then 
		client:setAddress( params.receiverIP )
	end

	table.dump(params)

	local lastUpdate   = getTimer()
	local function reflection_listener( event )
		local curTime = getTimer()
		local dt = curTime - lastUpdate
		if( dt < updatePeriod ) then return end
		lastUpdate = curTime
		client:send( "reflect", event )
	end
	for i = 1, #events do
		Runtime:addEventListener( events[i], reflection_listener )
	end
	client:autoConnect()
end
return public