-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018
-- =============================================================
-- Simple UDP Server
-- =============================================================
--[[
User Functions:
function serverClass:start()
function serverClass:stop()
function serverClass:getClient( clientID )
function serverClass:getClients()
function serverClass:getClientCount()
function serverClass:msgClient( clientID, cmd, msg )
function serverClass:msgClients( cmd, msg )

function serverClass.getIP( testIP, debugEn )

-- Internal Functions (should not or cannot be called exteranl to module):
function serverClass:heartLoop()
function serverClass:listenLoop()
function aClient:send( cmd, msgTable )
--]]

local socket = require "socket"
local json   = require( "json" )

local clientTimeoutDelay = 1000
local heartBeatTime      = 300
local listenLoopTime     = 30

local serverClass = {}


-- =============================================================
-- External Use OK
-- =============================================================
function serverClass:start()
	self.address = "*" 
	self.port    = 0xc001

	self.udp = socket.udp()

	self.udp:settimeout(0)
	self.udp:setsockname(self.address, self.port)

	print(self.address, self.port)

	self.clients = nil
	self.clientCount = 0
	self.clients = {}

	self.running = true

	local closure = function() self:listenLoop() end
	timer.performWithDelay( listenLoopTime, closure )

	local closure = function() self:heartLoop() end
	timer.performWithDelay( heartBeatTime, closure )
end

function serverClass:stop()
	self.running = false
	if(self.udp) then

		for k,v in pairs(self.clients) do 
			v:send("disconnect")
		end

		self.udp:close()
		self.udp = nil
	end
end


function serverClass:getClient( clientID )
	return self.clients[clientID]
end

function serverClass:getClients()
	return self.clients
end

function serverClass:getClientCount()
	return self.clientCount
end

function serverClass:msgClient( clientID, cmd, msg )
	self.clients[clientID]:send(cmd, msg)
end

function serverClass:msgClients( cmd, msg )
	for k,v in pairs(self.clients) do 
		print(k,v,cmd,msg)
		v:send(cmd, msg)
	end
end

serverClass.getIP = function( testIP, debugEn )
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

function serverClass:heartLoop()

	if(self.running == false) then
		return 
	end

	local curTime = system.getTimer()

	local dropList = {}

	-- 1. Check for timed out clients
	for k,v in pairs(self.clients) do 
		if( (curTime - v.t) > clientTimeoutDelay ) then
			Runtime:dispatchEvent( { name = "CLIENT_TIMED_OUT", clientID = k, ip = v.ip, port = v.port } )
			dropList[k] = v
		end
	end

	-- 2. Remove any marked for drop
	for k,v in pairs(dropList) do 
		self.clients[k] = nil
		self.clientCount = self.clientCount - 1
	end
	dropList = nil

	-- 3. Send out heartbeats to clients
	for k,v in pairs(self.clients) do 
		v:send("serverAlive")
	end

	local closure = function() self:heartLoop() end
	timer.performWithDelay( heartBeatTime, closure )
end


function serverClass:listenLoop()
	local data, msg_or_ip, port_or_nil
	local clientID, cmd, parms

	if(self.running == false) then
		return 
	end

	data, msg_or_ip, port_or_nil = self.udp:receivefrom()
		
	--print("server listening", data, msg_or_ip, port_or_nil)

	if data then
		--print("EDO", tostring(data))
		clientID, parms = data:match("^(%S*) (.*)")

		--EFM
		clientID = clientID .. "_" .. (port_or_nil or "")

		parms = json.decode(parms)
		cmd = parms.cmd

		if cmd == "connect" then			
			if(self.clients[clientID]) then
				print(tostring( clientID ) .. " tried to connect again. ip: " .. tostring( msg_or_ip ) .. ":" .. tostring( port_or_nil ))
			else
				local aClient = {}
				aClient.ip       = msg_or_ip
				aClient.port     = port_or_nil
				aClient.t        = system.getTimer()
				aClient.udp      = self.udp

				----------
				-- SEND --
				----------
				function aClient:send( cmd, msgTable )
					if(not self.udp) then return end

					if(cmd) then 
						if(cmd ~= "serverAlive") then
							--print( "aClient:send() cmd = " .. tostring(cmd)) 
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

					local msg = string.format("%s ", datagram)
	
					self.udp:sendto(msg, self.ip, self.port)
					--EFM: This keeps happening.  Why?
					--print("Client ", clientID, "connected.", system.getTimer())
				end

				self.clients[clientID] = aClient
				self.clientCount = self.clientCount + 1

				Runtime:dispatchEvent( { name = "CLIENT_CONNECTED", clientID = clientID, ip = aClient.ip, port = aClient.port } )
				aClient:send("connectionAccepted")
			end
			
		elseif cmd == "clientAlive" then
			if( self.clients[clientID] ) then
				self.clients[clientID].t = system.getTimer()
			else
				-- IGNORE FOR NOW
			end
        
		elseif cmd == "disconnect" then
			local aClient = self.clients[clientID]
			local ip = aClient.ip
			local port = aClient.port

			self.clients[clientID] = nil
			self.clientCount = self.clientCount - 1

			Runtime:dispatchEvent( { name = "CLIENT_DISCONNECTED", clientID = clientID, ip = ip, port = port } )

		else
			Runtime:dispatchEvent( { name = "CLIENT_MSG", clientID = clientID, cmd = cmd, msg = parms.payload } )
		end
		
	elseif msg_or_ip ~= "timeout" then
	end

	local closure = function() self:listenLoop() end
	timer.performWithDelay( listenLoopTime, closure )
end

----------------------------------
return serverClass
