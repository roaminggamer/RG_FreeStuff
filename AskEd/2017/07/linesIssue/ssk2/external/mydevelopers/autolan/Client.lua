-- MODIFIED TO SUPPORT IPV6 (see https://github.com/roaminggamer/AutoLan-IPv6)
--[[
Corona AutoLAN v 1.2
Author: M.Y. Developers
Copyright (C) 2011 M.Y. Developers All Rights Reserved
Support: mydevelopergames@gmail.com
Website: http://www.mygamedevelopers.com/Corona--Profiler.html
License: You are free:
to Share — to copy, distribute and transmit the work
to Remix — to adapt the work
to make commercial use of the work. You cannot however sell the
library itself.
Under the following conditions:
Attribution — You must attribute the work in the manner specified by the author or licensor (but not in any way that suggests that they endorse you or your use of the work).
With the understanding that:
Waiver — Any of the above conditions can be waived if you get permission from the copyright holder.
Public Domain — Where the work or any of its elements is in the public domain under applicable law, that status is in no way affected by the license.
Other Rights — In no way are any of the following rights affected by the license:
Your fair dealing or fair use rights, or other applicable copyright exceptions and limitations;
The author's moral rights;
Rights other persons may have either in the work itself or in how the work is used, such as publicity or privacy rights.
Notice — For any reuse or distribution, you must make clear to others the license terms of this work. The best way to do this is with a link to this web page.
--]]

local socket = require "socket"
local json = require "json"
local multiplayer = {}
local applicationName = "Default"

local client = {} --master object

----------------
--common client/server --takes care of the send queue/priority system
local circularBufferSize = 100
local bufferIndexLow = 1
local bufferIndexLowSend = 1 --last index looked at by send routine
local bufferIndexHigh = 1
local bufferIndexHighSend = 1 --last index looked at by send routine
local sendQueueLow = {} --will be a circular buffer
local sendQueueHigh = {} --will be an associative array
local sendQueueHighCallbacks = {}
local fileQueue = {}
local pendingFiles = {}
local fileQueueNumber = 0
local packetSize = 2000 ---in bytes
local myClientID
local connected = false
local onUpdate
local handshake


----------------
--UDP packet types
--type 1 = initial handshake, create a client object on server

------------client code
local broadcastListener
local listenTime = 1000
local scanTime = 30000
local timers = {}
local availibleServers = {} --key = ip, value = port
local serverIP,serverPort
local myIP,myPort
local handshakeTable = {"CoronaMultiplayer", applicationName}
local broadcastTime = 1000 --in ms, frequency to send broadcast for network discovery
local connectionTimeout = 2000
local connectionAttemptTime = 100
local networkRate = 30 --main loop
local UDPClient, HandshakeClient, tempClient
local HighPriorityRecieved = {0}
local numHighPriorityRecieved = 0
local HighPriorityCounters = {}
local HighPriorityCount = 50 --num cycles to wait before resending
--------hearbeat time
local heartbeatTime = 40
local timeoutPeriod = 150
local timeoutsLeft = timeoutPeriod
local heartbeatTimer = heartbeatTime --called every x frames nothing was sent to maintain connection
local numMessagesRecieved = 0 --keeps track of how many acks to send for flow control

--------flow control

local maxCredits = 9999 --num packets to send before waiting for a reply
local sendCredits = 1000 --each time we send one, we deduct a credit, each ACK we add credit
local rechargeRate = 500 --in ms
local rechargeAmount = 10 --if no response by rechargeRate then slowly fill up credits

------internet------------------------------------------------------------------------------------
local fallBackAddress = "74.125.115.104"

-- Check if this is socket 2 or later
local isSocket2 = (string.match( require("socket")._VERSION, "LuaSocket 2" ) ~= nil )

-- Check if this is socket 2 or later
local isSocket2 = (string.match( require("socket")._VERSION, "LuaSocket 2" ) ~= nil )

local forceIPV4 	= true

local socketUDP 	= (isSocket2) and socket.udp or(socket.udp6 or socket.udp4 or socket.udp) 
local socketTCP 	= (isSocket2) and socket.tcp or(socket.tcp6 or socket.tcp4 or socket.tcp) 

if( forceIPV4 and isSocket2 == false ) then
	socketUDP 	= socket.udp4 or socket.udp 
	socketTCP 	= socket.tcp4 or socket.tcp
end

-- If we are using Socket 3, we still need to determine if the local network is
-- ipv4 or ipv6 compliant.  Assume it is, but test for failure
local ipv6Test = true
if( isSocket2 == false ) then
	local socketTest1 = socket.udp6()
	socketTest1:setpeername( "google.com", 54613 )
	local testPeerIP = socketTest1:getsockname()
	if (testPeerIP == "::") then
		ipv6Test = false
	end
end

local peerIP, peerPort 
local s = socketUDP()
s:setpeername( "google.com", 54613 )
peerIP, peerPort = s:getsockname(), 54613

if( peerIP == nil ) then
	s:setpeername( fallBackAddress, 54613 )
	peerIP, peerPort = s:getsockname(), 54613
end
s = nil

--print("BOODLES", peerIP, peerPort, socketUDP, socketTCP )



local matchmakerTCPclient, pendingConnection

local function send(input, priority, listener) --adds to send buffer and assigns priority
	if(priority == 1) then
			if(UDPClient) then
				--print ("sending interface")
				heartbeatTimer = heartbeatTime 
				local packetTemplate = {}
				packetTemplate[1] = input --payload
				packetTemplate[2] ={1,numMessagesRecieved} --flow control/acks
				packetTemplate[3] = HighPriorityRecieved --high priority acks	
				numHighPriorityRecieved = 0 			
				HighPriorityRecieved = {0}					
				numMessagesRecieved = 0
				UDPClient:send( json.encode(packetTemplate) ) --send data entry
				sendCredits = sendCredits-1
			end


			
	else
		--high priority
		sendQueueHighCallbacks[bufferIndexHigh] = listener			
	--		numMessagesRecieved = 0
	--		heartbeatTimer = heartbeatTime 
			if(UDPClient) then
				local packetTemplate = {}
				packetTemplate[1] = input --payload
				packetTemplate[2] ={2,numMessagesRecieved,bufferIndexHigh} -- control/acks
				packetTemplate[3] = HighPriorityRecieved --high priority acks	
				numHighPriorityRecieved = 0 	
				numMessagesRecieved = 0		
				HighPriorityRecieved = {0}	
				HighPriorityCounters[bufferIndexHigh] = HighPriorityCount --controls when to resend
				sendQueueHigh[bufferIndexHigh] = packetTemplate
				UDPClient:send( json.encode(packetTemplate) ) --send data entry
				sendCredits = sendCredits-1
				bufferIndexHigh = bufferIndexHigh+1	
					if(bufferIndexHigh == circularBufferSize) then
						bufferIndexHigh = 1 --wrap
					end	

			end		
		
			
	end
end

local function sendFile(filename, path, destFile)
	path = (system.pathForFile(filename, path))
	filename = destFile or filename
	local file = io.open(path, "rb")
	if(file) then
		
		fileQueueNumber = fileQueueNumber+1
		local fileTable = {}
		fileTable = {}
		fileTable.file = file
		local fileSize = file:seek("end")
		fileTable.filename = filename
		fileTable.size = fileSize
		fileTable.numPackets = math.ceil(fileSize/packetSize)
		fileTable.currentPacket = 1 --must send number of packets in case out of order
		fileQueue[fileQueueNumber] = fileTable
		file:seek("set",0) -- reset to beginning of file
	end
end

local function addCredits(credit)
	sendCredits = sendCredits+credit
	if(sendCredits > maxCredits) then
		sendCredits = maxCredits
	end
end

------------

local function failedConnection()
	timer.cancel(timers.connectionAttempt)
	timers.connectionAttempt = nil
	------print("connection attempt failed")
	Runtime:dispatchEvent({name = "autolanConnectionFailed", serverIP = serverIP})
end

local function receive()
	if(UDPClient) then
		
		local message, error = UDPClient:receive()

		local noError = false
		while(message) do
		--print("message", message)
		noError = true

			numMessagesRecieved = numMessagesRecieved+1
			----print(#message,numMessagesRecieved)
			message = json.decode(message)
		if(message[1] == "e" or message[1] == "c") then
			return
		end
		if(message[2][1]==2) then
				--high priority,record ack to send
				numHighPriorityRecieved = numHighPriorityRecieved+1
				HighPriorityRecieved[numHighPriorityRecieved] = message[2][3] --log to send ack in a future packet (pooling)
			else
				--low priority, dont send ack
				--------print(json.encode(message[3]))
			end
			
			if(message[3][1] ~= 0) then --contains a high priorit ack
				local acks = message[3]
				--contain high priority acks
				for i=1,#acks do
					local ack = acks[i]
					sendQueueHigh[ack] = nil
					HighPriorityCounters[ack] = nil
					if(sendQueueHighCallbacks[ack]) then
						sendQueueHighCallbacks[ack]({phase = "complete"})
					end
				end
			end
			--------print("credits", sendCredits,message[2][2])					
			addCredits(message[2][2])	

			-------------------on top of transport layer, figure out message type
			local userMessage = message[1]
	
			if(userMessage[1]==2) then --file transfer
				------print(userMessage[1],userMessage[2],userMessage[3],userMessage[4], #userMessage[5])		
				--write file
				local filename = userMessage[2]
			
				if(pendingFiles[filename]==nil) then
					pendingFile = {}
					pendingFile.file = io.open(system.pathForFile(userMessage[2],system.DocumentsDirectory),"wb")
					pendingFile.recieved = {}
					pendingFile.buffer = {}
					pendingFile.index = 1 --file position
					pendingFiles[filename] = pendingFile
				end
				local pendingFile = pendingFiles[filename]		
				local packetindex = userMessage[3]
				pendingFile.recieved[packetindex] = 1 --1 = recieved but not written, 2 = written, nil = not rec.
				pendingFile.buffer[packetindex] = userMessage[5]
				local currentBuffer = pendingFile.buffer[pendingFile.index]
				while(currentBuffer ~= nil) do --if we reiceve packets out of order wait ultil we have a writable chunk
					------print("writing",pendingFile.index)
					pendingFile.file:write(currentBuffer)
					currentBuffer = nil
					pendingFile.index = pendingFile.index+1
					currentBuffer = pendingFile.buffer[pendingFile.index]
				end
				if(pendingFile.index == userMessage[4]+1) then
					--file transfer finished, trigger event
					------print("FILE DONE")
					Runtime:dispatchEvent({name = "autolanFileReceived", filename = filename})
					pendingFile.file:close()
					pendingFiles[filename]	 = nil
				end
			elseif userMessage[1]==1 then
				--print("client recieved")
				Runtime:dispatchEvent({name = "autolanReceived",  message = userMessage[2]})	
			end
			
			message, error = UDPClient:receive()
			
		end
		if error and not noError then
				if error == "timeout" then
					timeoutsLeft = timeoutsLeft-1 --clients responsibility to send alive packets
					if(timeoutsLeft == 0) then
						--this connection has timed out so kill it
						UDPClient:close()
						UDPClient = nil
						Runtime:dispatchEvent({name = "autolanDisconnected",  serverIP = serverIP, message = "timeout"})				
					end
				elseif error == "closed" then
					Runtime:dispatchEvent({name = "autolanDisconnected",  serverIP = serverIP, message = "closed"})					
					UDPClient:close()
					UDPClient = nil
					------print("closed")
				end
		else
			timeoutsLeft = timeoutPeriod --reset timeouts
		end
		
		
	end
end
local function mainLoop()		
	if(sendCredits >0) then
			local fileTable = fileQueue[1] --only send 1 file at a time, send the first in fifo
			--get the datagram data
			if(fileTable) then
				local data = fileTable.file:read(packetSize)
				local sendPacket = {2,fileTable.filename, fileTable.currentPacket, fileTable.numPackets, data} --first entry (high level) is type of packet 1 = user, 2 = file, 3=command
				fileTable.currentPacket = fileTable.currentPacket+1
				if(data) then
					send(sendPacket,2)

				else
					--end of file
					table.remove(fileQueue,1)
					fileQueueNumber = fileQueueNumber-1
				end
			end
		for i,packet  in pairs(sendQueueHigh) do
			local count = HighPriorityCounters[i]
			if(UDPClient) then
				if(count) then
					if(count == 0) then
						HighPriorityCounters[i] = HighPriorityCount
						--resend packet
						packet[2][2]  = numMessagesRecieved -- control/acks
						packet[3] = HighPriorityRecieved --high priority acks						
						UDPClient:send( json.encode(packetTemplate) ) --send data entry
						sendCredits = sendCredits-1
					else
						HighPriorityCounters[i] = count - 1
					end
				end
			else
				--client dead, ACK
				sendQueueHigh[i] = nil
				HighPriorityCounters[i] = nil	
				if(sendQueueHighCallbacks[i]) then
					sendQueueHighCallbacks[i]({phase = "cancelled"})
				end					
			end
		end
	end
	---sending complete, recieve
	--heartbeat to send periodically a packet to ensure connection is alive
	if(heartbeatTimer==0) then
		if(UDPClient) then
			local packetTemplate = {}
			packetTemplate[1] = {0} --payload
			packetTemplate[2] ={0,numMessagesRecieved} --flow control/acks
			packetTemplate[3] = HighPriorityRecieved --high priority acks	
			numHighPriorityRecieved = 0 			
			HighPriorityRecieved = {0}			
			numMessagesRecieved = 0
			UDPClient:send( json.encode(packetTemplate) ) --send data entry
		end			
			heartbeatTimer = heartbeatTime		
	end
	heartbeatTimer = heartbeatTimer-1	
end
local sendPhase = true 

local function connectToServer()
	if(timers.failedToConnect == nil) then
		----print("create timers")
		timers.failedToConnect = timer.performWithDelay(connectionTimeout,failedConnection)--stop handshaking and fail
		timers.connectionAttempt = timer.performWithDelay(connectionAttemptTime,connectToServer,-1)--try to handshake
	end
	if(HandshakeClient == nil) then
		----print("creating handshake client")
		HandshakeClient = socketUDP()
		HandshakeClient:setsockname("*", 0) --bind on any availible port and localserver ip address.
		HandshakeClient:settimeout(0)
		tempClient = socketUDP() --need a temp client b/c loop is still running
		tempClient:setsockname("*", 0) --bind on any availible port and localserver ip address.
		tempClient:settimeout(0)		
		myIP, myPort = tempClient:getsockname()	
		handshakeTable[3] = myPort
		handshake = json.encode(handshakeTable)
	end
	--send a handshake packet telling the server to create a connection for us/ alternate b/w send and recieve
		HandshakeClient:sendto(handshake,serverIP,serverPort)
		--recieve a confirmation packet telling us all is good for transmission
		local message = HandshakeClient:receive()
		----print("handshake", message)
		while(message) do
			--------print("recieved broadcast,", message)	
			message = json.decode(message)
			if(message) then
				if(message[1] and message[1]=="CoronaMultiplayer" and message[2] == applicationName) then --this is the protocol id				
								
					HandshakeClient:close()		
					HandshakeClient	= nil
					

					tempClient:setpeername(serverIP, message[4])
					UDPClient,tempClient = 	tempClient,nil
				
					timer.cancel(timers.connectionAttempt)
					timers.connectionAttempt = nil
					timer.cancel(timers.failedToConnect)
					timers.failedToConnect = nil
					myClientID = message[5]
					------print("Connected!",serverIP, message[4]) --this is where we fire off connected event
					Runtime:dispatchEvent({name = "autolanConnected",  myClientID = myClientID, serverIP = serverIP, customBroadcast = availibleServers[serverIP].customBroadcast})					
					timeoutsLeft = timeoutPeriod
					--timer.performWithDelay(500,sendtest,-1)
					break
				end
			end
			message = HandshakeClient:receive()
		end		
end



local function stopListening() --we cant just listen forever or else we will have a huge buffer
	if(timers.scanTimer) then
		timer.cancel(timers.scanTimer)
		timers.scanTimer = nil
		if(broadcastListener) then
		broadcastListener:close()
		broadcastListener = nil
		end
		--here is where we would call the done scanning event listener
		----print("done scanning.")
		Runtime:dispatchEvent({name = "autolanDoneScanning",  servers = availibleServers})
	else
		------print("already not scanning...")
	end	
end

local function UDPBroadcastListen()
	if(broadcastListener) then
		local broadcastMessage, serverIP, serverPort 
		broadcastMessage,serverIP,serverPort = broadcastListener:receivefrom()
		local packets = 1
		while(broadcastMessage and type(broadcastMessage)=="string") do	
			packets = packets+1
			broadcastMessage = json.decode(broadcastMessage)
			if(broadcastMessage) then
				if(broadcastMessage[1] and broadcastMessage[1]=="CoronaMultiplayer" and broadcastMessage[2]==applicationName) then --this is the protocol id				
					if(availibleServers[serverIP] == nil) then
						availibleServers[serverIP] = {name = broadcastMessage[3], broadcastPort = serverPort, port = serverPort, customBroadcast = broadcastMessage[5]}
						Runtime:dispatchEvent({name = "autolanServerFound",  serverIP = serverIP, port = serverPort, customBroadcast = broadcastMessage[5], serverName = broadcastMessage[3]})				
						------print("found server adding...") --this is where we fire off server found event					
					end				
				end
			end
			if(broadcastListener) then
				broadcastMessage = nil
				broadcastMessage,serverIP,serverPort = broadcastListener:receivefrom()
			end
		end
	end
end

local function scanServers(scanTime)
	if(scanTimer) then
		------print("already scanning...")
	else
		if(broadcastListener==nil) then
			broadcastListener = socketUDP()
			broadcastListener:setsockname("*", 8080)
			broadcastListener:settimeout(0)
		end
		availibleServers = {}
		timers.scanTimer = timer.performWithDelay(listenTime,UDPBroadcastListen,-1)
			if(scanTime) then
				timers.scanStopTimer = timer.performWithDelay(scanTime,stopListening) --only scan for a certian amount of time and then stop and report what servers were found
			end
		end
end

local currentServer
local function connectToServerInternet()
	if(timers.scanTimerInternet) then
		timer.cancel(timers.scanTimerInternet)
		timers.scanTimerInternet = nil
		timers.connectTimerInternet = timer.performWithDelay(listenTime,connectToServerInternet,-1)
	end	
	if(pendingConnection == nil) then
		local udpclient = socketUDP()
		udpclient:setsockname("*", 0) --bind on any availible port and localserver ip address.
		udpclient:settimeout(0)	
		pendingConnection = udpclient
	end
--assumes a valid pending connection is established
	--print("establish connection")
	if(pendingConnection) then
		--print("internet Handshake at", serverIP)
		pendingConnection:sendto(json.encode{"CoronaAutoInternet",applicationName,"cc",serverIP},peerIP, peerPort+1) --send to server saying I am ready to connect, tell server to create socket, send the server(tcp) ip and port
		local msg,ip,port = pendingConnection:receivefrom()
		while(msg) do
		--print("udp", msg)
			local decoded = json.decode(msg)
			if(decoded and decoded[1]=="c") then
				pendingConnection:sendto(json.encode{"e"},decoded[2], decoded[3])		
			elseif(decoded and decoded[1]=="e") then
				--connection established event
				Runtime:dispatchEvent({name = "autolanConnected",  myClientID = decoded[1], serverIP = ip, customBroadcast = availibleServers[serverIP].customBroadcast})
				pendingConnection:setpeername(ip,port)
				UDPClient = pendingConnection
				pendingConnection = nil
				timer.cancel(timers.connectTimerInternet)
				timers.connectTimerInternet = nil
				return
			end
			msg,ip,port = pendingConnection:receivefrom()
		end
	end

	--print("sending", currentServer[1], currentServer[2])

		
end
-------------------------------------------INTERNET----------------------------------------------------
local function MatchmakerServerListen() --listens for a reponse from the matchmaker AND for response fromserverUDP

	local msg = matchmakerTCPclient:receive("*l")
	if(msg) then
		--print(msg)
		--resolve message type for the tcp it is only a list of servers.
		local decoded = json.decode(msg)
		if(decoded) then
			if(decoded[1] == "l") then
				--send connect request to matchmaker to send request to server for new sock
				for i=1,#decoded[2] do
					--add each to list
					currentServer = decoded[2][i]
					--print(currentServer[1].." added")
					local serverIP = currentServer[1]..currentServer[2] --this is the key we refer the internet server by
					availibleServers[serverIP] = {name = currentServer[2], port = currentServer[2], customBroadcast = currentServer[2], internet = true}
					Runtime:dispatchEvent({name = "autolanServerFound",  serverIP = serverIP, port = currentServer[2], customBroadcast = currentServer[4], serverName = currentServer[3], internet = true})				
				end			
			end
		end
	end
end
------------------------------------------INTERNET----------------------------------------------------

function client:scanServersInternet(scanTime)
	scanServers()
	--open a TCP connection to the matchmaking server
	matchmakerTCPclient = socketTCP()
	matchmakerTCPclient:settimeout(1) --this is the only blocking operation	
	local err = matchmakerTCPclient:connect(peerIP, peerPort) --bind on any availible port and localserver ip address.
	--print(err)
	if(err==nil) then
		--print("server timeout")
		return
	end
	matchmakerTCPclient:send(json.encode({"CoronaAutoInternet",applicationName,"c"}).."\n") --send client token
	matchmakerTCPclient:settimeout(0)
	timers.scanTimerInternet = timer.performWithDelay(listenTime,MatchmakerServerListen,-1)
end


-------------------------------------------INTERNET----------------------------------------------------


function client:setOptions(params)
	broadcastTime = params.broadcastTime or broadcastTime
	customBroadcast = params.customBroadcast or customBroadcast
	networkRate = params.networkRate or networkRate --feqnuency to run network loop
	connectTime = params.connectTime or connectTime --frequency to look for new clients
	timeoutTime = params.timeoutTime or timeoutTime --number of cycles to wait before client is DC
	maxCredits = params.maxCredits or maxCredits --number of packets to send w/o ACK
	rechargeRate = params.rechargeRate or rechargeRate --time to recharge credits
	rechargeAmount = params.rechargeAmount or rechargeAmount --time to recharge credits
	circularBufferSize = params.circularBufferSize or circularBufferSize --max number of elements in circular buffer, 2^n
	packetSize = params.packetSize or packetSize
	onUpdate = params.onUpdate or onUpdate
end
function client:stop()
	for i,t in pairs(timers) do
		timer.cancel(t)
		t = nil
	end
end
function client:send(message)
	send({1,message}, 1)
end
function client:sendPriority(message, params)
	params = params or {}
	send({1,message}, 2, params.callback)
end
function client:sendFile(filename, path, destFile)
	sendFile(filename, path, destFile)
end
function client:start()
timers.recharge = timer.performWithDelay(rechargeRate, function() addCredits(rechargeAmount) end)
timers.mainLoop = timer.performWithDelay(networkRate,mainLoop,-1)
--Runtime:addEventListener("enterFrame", mainLoop)
timers.receive = timer.performWithDelay(1,receive,-1)
end
function client:scanServers()
	scanServers()
end
client.RTT = nil
local RTTTime
local sendPing
local function pingListener(e)
	if(e.phase == "began") then
		RTTTime = system.getTimer()
	elseif(e.phase == "complete") then
		client.RTT = system.getTimer() - RTTTime
		--print("pingACK",client.RTT)
		sendPing()
	else

	end
end
sendPing = function ()
	send({3,0}, 2, pingListener )	
end
function client:autoRTT()
	--send a high priority message to the server and figure out how long it takes
	sendPing()
	
end
function client:connect(ip)
	--
	stopListening()
	serverIP,serverPort = ip,availibleServers[ip].port or 8080
	if(availibleServers[ip].internet) then
		connectToServerInternet()
	else
		connectToServer()
	end
	--stopListening()
end	
local function autoConnectListener(e)
	
	--print(e.serverIP)
	client:connect(e.serverIP)
	Runtime:removeEventListener("autolanServerFound",autoConnectListener)
end

function client:autoConnect()
	Runtime:addEventListener("autolanServerFound",autoConnectListener)
	scanServers()
end
function client:disconnect()
	--this connection has timed out so kill it
	if(UDPClient) then
		UDPClient:close()
		UDPClient = nil
		Runtime:dispatchEvent({name = "autolanDisconnected",  serverIP = serverIP,  message = "user disconnect"})	
	end
end
function client:stopScanning()
	stopListening()
end
function client:setMatchmakerURL(url,port)
	peerIP,  peerPort = socket.dns.toip(url),port
end
return client