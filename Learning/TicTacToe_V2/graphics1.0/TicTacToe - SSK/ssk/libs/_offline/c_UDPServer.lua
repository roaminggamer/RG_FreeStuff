-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Simple UDP Server - OFFLINE
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
--
-- =============================================================


--[[
function serverClass:start()
function serverClass:stop()
function serverClass:heartLoop()
function serverClass:listenLoop()

function aClient:send( cmd, msgTable )
function serverClass:getClient( clientID )
function serverClass:getClients()
function serverClass:getClientCount()
function serverClass:msgClient( clientID, cmd, msg )
function serverClass:msgClients( cmd, msg )

--]]


local socket = require "socket"
local json   = require( "json" )

local clientTimeoutDelay = 1000
local heartBeatTime      = 300
local listenLoopTime     = 30

local serverClass = {}

function serverClass:start()

	self.address = "*"
	self.port    = 0xc001

	self.udp = socket.udp()

	self.udp:settimeout(0)
	self.udp:setsockname(self.address, self.port)

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
		
	if data then
		--print(tostring(data))
		clientID, parms = data:match("^(%S*) (.*)")

		parms = json.decode(parms)
		cmd = parms.cmd
        
		if cmd == "connect" then
			if(self.clients[clientID]) then
				--print(tostring( clientID ) .. " tried to connect again. ip: " .. tostring( msg_or_ip ) .. ":" .. tostring( port_or_nil ))
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
							print( "aClient:send() cmd = " .. tostring(cmd)) 
						end
					end
					--[[
					if(msgTable) then 
						print( "aClient:send() msgTable: ") 
						table.dump(msgTable)
					end
					--]]

					local datagram = {}
					datagram.cmd = cmd
					datagram.payload = msgTable

					datagram = json.encode( datagram )

					local msg = string.format("%s ", datagram)
	
					self.udp:sendto(msg, self.ip, self.port)
				end

				self.clients[clientID] = aClient
				self.clientCount = self.clientCount + 1

				Runtime:dispatchEvent( { name = "CLIENT_CONNECTED", clientID = clientID, ip = aClient.ip, port = aClient.port } )
				aClient:send("connectionAccepted")
			end
			
		elseif cmd == "clientAlive" then
			self.clients[clientID].t = system.getTimer()
        
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
		v:send(cmd, msg)
	end
end





----------------------------------
return serverClass
