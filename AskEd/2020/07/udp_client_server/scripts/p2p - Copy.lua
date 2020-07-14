-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local socket = require "socket"
local json = require "json"

local ip,uid

-- =============================================================
local p2p = {}

p2p.getIP = function( testIP, debugEn )
   testIP = testIP or "74.125.115.104"
   local s = socket.udp() 
   s:setpeername( testIP, 80 ) 
   local ip, port = s:getsockname()
   if( debugEn ) then
      print( "My IP => " .. tostring(ip) .. " : " .. tostring(port) ..  "; testIP: " .. testIP )
   end
   return ip, port
end


function p2p.createServer()
	port = port or 12345
	local udp = socket.udp( port )
	udp:settimeout(0)
	udp:setsockname('*', port)

	local function revieveUdpMsg()
		local data, msg_or_ip, port_or_nil = udp:receivefrom()		
		if data ~= nil then
			print(data,msg_or_ip,port_or_nil)
			post( "onMsg", { data = data } )
		elseif msg_or_ip ~= 'timeout' then
			error("Unknown network error: "..tostring(msg))
			return
		end
		socket.sleep(0.01)
		--
		timer.performWithDelay( 100, revieveUdpMsg )
	end
	timer.performWithDelay( 1000, revieveUdpMsg )

	local server = {}
	function server.sendMsg( msg )
		local udp = socket.udp()
		udp:settimeout(0)
		udp:setpeername("localhost", port)
		local snd = udp:send(msg)
		print("Sent: " .. msg)
	end
	return server
end

function p2p.createClient(port)
	port = port or 12345
	local address, port = "localhost", port

	local server = socket.udp( port )
	server:settimeout(0)
	server:setsockname('*', port)
	local function revieveUdpMsg()
		local data, msg_or_ip, port_or_nil = server:receivefrom()				
		local gotMsg = false
		if data ~= nil then
			data = json.decode(data)
			--gotMsg = data.id ~= uid
			gotMsg = true
		end
		if gotMsg then				
			print(data.msg, msg_or_ip, port_or_nil )
			post( "onMsg", data )
		elseif msg_or_ip ~= 'timeout' then
			error("Unknown network error: "..tostring(msg))
			return
		end
		socket.sleep(0.01)
		--
		timer.performWithDelay( 100, revieveUdpMsg )
	end
	timer.performWithDelay( 1000, revieveUdpMsg )

	local client = {}
	function client.sendMsg( msg )
		local client = socket.udp()
		client:settimeout(0)
		client:setpeername("localhost", port)
		local data  = { msg = msg, time = system.getTimer(), id = uid }
		data = json.encode(data)
		local snd = client:send(data)
		print("Sent: " .. msg)
	end
	return client
end

-- init my IP and uid (port #)
ip,uid = p2p.getIP()



return p2p

