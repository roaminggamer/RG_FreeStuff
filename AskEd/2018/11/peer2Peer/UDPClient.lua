-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018
-- =============================================================
-- Simple UDP Client
-- =============================================================
--[[
User Functions:
function clientClass:setAddress( ip )
function clientClass:autoConnect()
function clientClass:stop()
function clientClass:send( cmd, msgTable )

function clientClass.getIP( testIP, debugEn )


-- Internal Functions (should not or cannot be called exteranl to module):
function clientClass:heartLoop()
function clientClass:listenLoop()
--]]

local socket = require( "socket" )
local json   = require( "json" )

local serverTimeoutDelay = 1000
local heartBeatTime      = 300
local listenLoopTime     = 30

local clientIDLen = 5

local clientClass = {}

-- =============================================================
-- External Use OK
-- =============================================================

-- the address and port of the server
clientClass.address = "localhost"
clientClass.port    = 0xc001

function clientClass:setAddress( ip )
	clientClass.address = ip or "localhost"
	print( "Setting IP to:", ip)
end

function clientClass:autoConnect()
	self.udp = socket.udp()
    self.udp:settimeout(0)
    self.udp:setpeername(self.address, self.port) -- designates where future send() calls go 

    --print(self.address, self.port)

	self.uid = system.getInfo( "deviceID" )
	self.uid = self.uid:sub(1,clientIDLen)

	self.running = true
	self.connected = false

	self:send("connect")
    
	self.t = system.getTimer()

	local closure = function() self:listenLoop() end
	timer.performWithDelay( listenLoopTime, closure )

	local closure = function() self:heartLoop() end
	timer.performWithDelay( heartBeatTime, closure )
end

function clientClass:stop()
	self.running = false
	self.connected = false
	if(self.udp) then
		self:send("disconnect")
		self.udp:close()
		self.udp = nil
	end
end


function clientClass:send( cmd, msgTable )
	if(not self.udp) then return end

	if(cmd) then 
		if(cmd ~= "clientAlive") then
			print( "aClient:send() cmd = " .. tostring(cmd)) 
		end
	end
	--[[
	if(msgTable and table.dump) then 
		--print( "aClient:send() msgTable: ") 
		table.dump(msgTable)
	end
	--]]

	local datagram = {}
	datagram.cmd = cmd
	datagram.payload = msgTable

	datagram = json.encode( datagram )

	local msg = string.format("%s %s ", self.uid, datagram)

	self.udp:send(msg)
end


clientClass.getIP = function( testIP, debugEn )
   testIP = testIP or "74.125.115.104"
   local s = socket.udp() 
   s:setpeername( testIP, 80 ) 
   local ip, port = s:getsockname()
   if( debugEn ) then
      print( "My IP => " .. tostring(ip) .. " : " .. tostring(port) ..  "; testIP: " .. testIP )
   end
   return ip, port
end


-- =============================================================
-- Internal Use Only
-- =============================================================



function clientClass:heartLoop()
	if(self.running == false) then
		return 
	end

	-- 1. See if server has timed out
	local curTime = system.getTimer()
	if( (curTime - self.t) > serverTimeoutDelay) then
		if(self.connected) then
			Runtime:dispatchEvent( { name = "SERVER_DROPPED"} )
		else
			Runtime:dispatchEvent( { name = "SERVER_CONNECTION_FAILED"} )
		end
		
		return
	end

	if(self.connected) then
		-- 2. Send a heartbeat to the server
		self:send( "clientAlive" )
	end
	
	local closure = function() self:heartLoop() end
	timer.performWithDelay( heartBeatTime, closure )
end

function clientClass:listenLoop()
	local data, msg
	local entity, cmd, parms

	--print("client listening", data, msg_or_ip, port_or_nil)

	if(self.running == false) then
		return 
	end

    data, msg = self.udp:receive()
	if data then
		--print("clientClass:listenLoop()", tostring(data))
		parms = data:match("^(.*)")

		parms = json.decode(parms)
		cmd = parms.cmd

		if cmd == "serverAlive" then
			self.t = system.getTimer()

		elseif cmd == "connectionAccepted" then
			Runtime:dispatchEvent( { name = "SERVER_CONNECTED"} )
			self.connected = true
			system.getTimer()

		elseif cmd == "disconnect" then
			Runtime:dispatchEvent( { name = "SERVER_DISCONNECTED" } )
			self:stop()

		else
			Runtime:dispatchEvent( { name = "SERVER_MSG", cmd = cmd, msg = parms.payload } )
		end
       
	elseif msg ~= "timeout" then 
	end

	local closure = function() self:listenLoop() end
	timer.performWithDelay( listenLoopTime, closure )

end


------------------------------------
return clientClass