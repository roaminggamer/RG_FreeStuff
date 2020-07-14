-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local socket = require "socket"
local json = require "json"

local ip,uid

-- =============================================================
local p2p = {}

-- ==
--
-- ==
function p2p.createPeer(port)
	port = port or 12345
	local address, port = "localhost", port

	local otherPort

	--
	-- Server
	--
	local server = socket.udp( port )
	server:settimeout(0)
	server:setsockname('*', port)
	--
	local function waitForMsg()
		local data, msg_or_ip, port_or_nil = server:receivefrom()				
		local gotMsg = false
		--
		if data ~= nil then
			data = json.decode(data)
			print( data.id, data, msg_or_ip, port_or_nil  )
			otherPort = otherPort or port_or_nil
			--gotMsg = data.id ~= uid
			gotMsg = true
		end
		--
		if gotMsg then				
			print(data.msg, msg_or_ip, port_or_nil )
			post( "onMsg", data )
		end
		socket.sleep(0.01)
		--
		timer.performWithDelay( 100, waitForMsg )
	end
	timer.performWithDelay( 1000, waitForMsg )

	-- Client
	local client = socket.udp()
	client:settimeout(0)
	client:setpeername("localhost", port)
	
	-- 
	-- Peer 
	--
	local peer = {}

	function peer.sendMsg( msg )
		---- Client
		--local client = socket.udp()
		--client:settimeout(0)
		--client:setpeername("localhost", port)
		local data  = { msg = msg, time = system.getTimer(), id = uid }
		data = json.encode(data)
		if( otherPort ) then
			server:sendto(data,ip,otherPort)
		else
			client:send(data)
		end

		--local snd = client:send(data)

		print("My IP and Port ", p2p.getIP() )
		print("Sent: " .. msg)
	end
	return peer
end

-- ==
--
-- ==
p2p.getIP = function( testIP, debugEn )
	if( ip and uid) then return ip,uid end
   testIP = testIP or "74.125.115.104"
   local s = socket.udp() 
   s:setpeername( testIP, 80 ) 
   local ip, port = s:getsockname()
   if( debugEn ) then
      print( "My IP => " .. tostring(ip) .. " : " .. tostring(port) ..  "; testIP: " .. testIP )
   end
   return ip, port
end


-- Capture this app's IP and uid (port #)
ip,uid = p2p.getIP()

return p2p

