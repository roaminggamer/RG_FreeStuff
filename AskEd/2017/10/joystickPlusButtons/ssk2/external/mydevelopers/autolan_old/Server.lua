-- MODIFIED TO SUPPORT IPV6 (see https://github.com/roaminggamer/AutoLan-IPv6)
--[[
Corona® AutoLAN v 1.2
Author: M.Y. Developers
Copyright (C) 2011 M.Y. Developers All Rights Reserved
Support: mydevelopergames@gmail.com
Website: http://www.mygamedevelopers.com/Corona--Profiler.html
License: Many hours of genuine hard work have gone into this project and we kindly ask you not to redistribute or illegally sell this package. 
We are constantly developing this software to provide you with a better development experience and any suggestions are welcome. Thanks for you support.

-- IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.
--]]
local socket = require "socket"

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

local UDPServer = socketUDP()
UDPServer:setsockname("*", 0) --bind on any availible port and localserver ip address.

local myIP, myPort = UDPServer:getsockname()

local UDPBroadcaster = socketUDP()
UDPBroadcaster:setoption("broadcast", true)
UDPBroadcaster:setsockname("*", 0) --bind on any availible port and localserver ip address.
UDPBroadcaster:settimeout(0)

local json = require "json"
local applicationName = "Default"
local deviceName = system.getInfo("name") 
local customBroadcast = 1
local broadcastTable = {"CoronaMultiplayer", applicationName, deviceName, myPort, customBroadcast} --broadcast frame = protocol name, app name, port to server (not broadcaster)  
local handshakeTable = {"CoronaMultiplayer", applicationName, deviceName, 1}
local broadcast = json.encode(broadcastTable)
local broadcastTime = 1000 --in ms, frequency to send broadcast for network discovery
local networkRate = 30 --in ms, frequency to recieve for main loop = 20 packets/second max
local connectTime = 1000
local timers = {}
local availibleClients = {} ---key = ip
local clientsInfo = {} --key = number for speed
local UDPClients = {} --key = number for spee
local numClients = 0
local timeoutTime = 150
local heartbeatTime = 40
local maxCredits = 9999 --num packets to send before waiting for a reply
local sendCredits = maxCredits --each time we send one, we deduct a credit, each ACK we add credit
local rechargeRate = 500 --in ms
local rechargeAmount = 10 --if no response by rechargeRate then slowly fill up credits
local ipv6 = true
local function addCredits(credit)
	sendCredits = sendCredits+rechargeAmount
	if(sendCredits > maxCredits) then
		sendCredits = maxCredits
	end
end


local HighPriorityCounters = {}
local HighPriorityCount = 50 --num cycles to wait before resending
----------------
--common client/server --takes care of the send queue/priority system
local circularBufferSize = 64
local bufferIndexLow = 1
local bufferIndexLowSend = 1 --last index looked at by send routine
local bufferIndexHigh = 1
local bufferIndexHighSend = 1 --last index looked at by send routine
local sendQueueLow = {} --will be a circular buffer
local sendQueueHigh = {} --will be an associative array
local sendQueueHighCallbacks = {}
local sendQueueLowClients = {}
local sendQueueHighClients = {}
local fileQueue = {}
local fileQueueClients = {}
local fileQueueNumber = 0
local packetSize = 2000 ---in bytes
local pendingFiles = {}

----internet code
local peerIP,  peerPort, matchmakerTCPclient;
local pendingConnections = {}

local function send(input, player, priority, onComplete) --adds to send buffer and assigns priority
	if(priority == 1) then
		--add to sendBuffer
	--	sendQueueLow[bufferIndexLow] = input
	--	sendQueueLowClients[bufferIndexLow] = player
	--	bufferIndexLow = bufferIndexLow+1
	--	if(bufferIndexLow == circularBufferSize) then
	--		bufferIndexLow = 1 --wrap
	--	end
	local clientInfo = clientsInfo[player]
	if(clientInfo ~= nil) then--this means the connection is dead
		local UDPClient = UDPClients[player]
		clientInfo.heartbeatTimer = heartbeatTime
		local packetTemplate = {}		
		packetTemplate[1] = input --payload
		packetTemplate[2] = {1,clientInfo.numMessages} --prioroty level and # ACKS
		clientInfo.numMessages = 0
		packetTemplate[3] = clientInfo.HighPriorityRecieved --high priority acks	
		clientInfo.numHighPriorityRecieved = 0
		clientInfo.HighPriorityRecieved = {0}	
		UDPClient:send(json.encode(packetTemplate)) --send data entry
		sendCredits = sendCredits-1
	end
	--		bufferIndexLowSend = bufferIndexLowSend+1
	--		if(bufferIndexLowSend == circularBufferSize) then
	--			bufferIndexLowSend=1
	--		end
	--		clientInfo.bufferIndexLowSend = bufferIndexLowSend
			
			
	else
		--high priority

		sendQueueHighClients[bufferIndexHigh] = player
		sendQueueHighCallbacks[bufferIndexHigh] = onComplete

		

			local clientInfo = clientsInfo[player]
			if(clientInfo ~= nil) then
				local UDPClient = UDPClients[player]	
				numMessagesRecieved = 0
				clientInfo.heartbeatTimer = heartbeatTime 
				local packetTemplate = {}
				packetTemplate[1] = input --payload
				packetTemplate[2] ={2,clientInfo.numMessages,bufferIndexHigh} -- control/acks
				packetTemplate[3] = clientInfo.HighPriorityRecieved --high priority acks	
				clientInfo.numHighPriorityRecieved = 0
				clientInfo.HighPriorityRecieved = {0}	
				
				HighPriorityCounters[bufferIndexHigh] = HighPriorityCount --controls when to resend
				sendQueueHigh[bufferIndexHigh] = packetTemplate --to prevent reencoding upon resend
				if(sendQueueHighCallbacks[bufferIndexHigh]) then
					sendQueueHighCallbacks[bufferIndexHigh]({phase = "began"})
				end
				UDPClient:send( json.encode(packetTemplate) ) --send data entry
				sendCredits = sendCredits-1
				bufferIndexHigh = bufferIndexHigh+1
				if(bufferIndexHigh == circularBufferSize) then
					bufferIndexHigh = 1 --wrap
				end		
			end	
		
		
	end
end
local function sendFile(filename, path, player, destFile)
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
		fileQueueClients[fileQueueNumber] = player
		file:seek("set",0) -- reset to beginning of file
	end
end
local function UDPBroadcast()
	--local broadcast = json.encode(broadcastTable)
	UDPBroadcaster:sendto(broadcast, "255.255.255.255", 8080)
	----print("broadcast")
end
--Runtime:addEventListener("enterFrame", UDPBroadcaster)

local function connectClients() --checks to see if any new clients wish to connect
	local message, clientIP, clientPort 

	message,clientIP,clientPort = UDPBroadcaster:receivefrom() --from handshake client (local)
	while(message) do
		message = json.decode(message)
		------print("adding clients",message[1], message["1"] )
		if(message) then
			if(message[1] and message[1]=="CoronaMultiplayer" and message[2]==applicationName) then --this is the protocol id				
				if(availibleClients[clientIP] == nil) then
					numClients = numClients+1
					local UDPClient = socketUDP()
					UDPClient:setsockname("*", 0) --bind on any availible port, we cant bind to server port
					local ip, port = UDPClient:getsockname()

					availibleClients[clientIP] = {name = message[3], port = port, timeoutTime = timeoutTime, ip = clientIP}
					clientsInfo[numClients] = availibleClients[clientIP] 
					
					local clientInfo = clientsInfo[numClients]
					clientInfo.numMessages = 0
					clientInfo.heartbeatTimer = heartbeatTime
					clientInfo.numHighPriorityRecieved = 0
					clientInfo.HighPriorityRecieved = {0}
					clientInfo.ip = clientIP
					handshakeTable[4] = port
					handshakeTable[5] = numClients
					UDPClient:setpeername(clientIP, message[3]) 
					UDPBroadcaster:sendto(json.encode(handshakeTable),clientIP,clientPort )
					UDPClient:settimeout(0)
					UDPClients[numClients] = UDPClient					
					------print("client connected", clientIP,clientPort)
					--create convenience player object
					local newPlayer = {}
					newPlayer.clientID = numClients
					clientInfo.clientObject = newPlayer
					function newPlayer:send(input)
						send({1,input}, self.clientID, 1)
					end
					function newPlayer:sendPriority(input, params)
						params = params or {}
						send({1,input}, self.clientID, 2,params.callback)
					end	
					function newPlayer:sendFile(filename, directory, destination)
						sendFile(filename, directory, self.clientID, destination)
					end	
					function newPlayer:disconnect()
						UDPClients[self.clientID] :close()
						UDPClients[self.clientID] = nil
						local clientInfo = clientsInfo[self.clientID]
						availibleClients[clientInfo.ip] = nil
					
						--numClients = numClients-1
							--now cycle through any pending files and clear the memory
							for c,file in pairs(pendingFiles) do
								if(file.id == self.clientID) then
									pendingFile[self.clientID] = nil
								end
							end					
						Runtime:dispatchEvent({name = "autolanPlayerDropped", client = clientInfo.clientObject, clientID = self.clientID, message = "user disconnect"})		
						clientsInfo[self.clientID] = nil
					end
					Runtime:dispatchEvent({name = "autolanPlayerJoined",  clientID = numClients, client = newPlayer})
					--timer.performWithDelay(50,sendtest,-1)------------
					
				end				
			else
				--we are getting another handshake, probably b/c the previous was not recieved
				--find the client by IP
				for i = 1, numClients do
					if( clientsInfo[i].ip == clientIP) then
						handshakeTable[4] = clientsInfo[i].port
						handshakeTable[5] = i
						UDPClient:send(json.encode(handshakeTable),clientIP,clientPort)						
					end
				end
			end
		end
		message,serverIP,serverPort = UDPBroadcaster:receivefrom()
	end
	----------------------------------INTERNET CODE-----------------------------------------------
	--first check for any new connection requests
	if(matchmakerTCPclient) then
		local msg= matchmakerTCPclient:receive("*l")
		--print("tcp",msg)
		if(msg) then
			--print(msg)
			--resolve message type
			local decoded = json.decode(msg)
			if(decoded) then
				if(decoded[1] == "n") then
					--here we create a new socket and connect back to the matchmaker
					if(pendingConnections[decoded[2]..decoded[3]] == nil and availibleClients[decoded[2]..decoded[3]]==nil) then
						--timer.performWithDelay(2000, networkSend,-1) --need to keep sending to keep the NAT stable
						local UDPClient = socketUDP()
						UDPClient:setsockname("*", 0) --bind on any availible port and localserver ip address.
						UDPClient:settimeout(0)
						--print("switch to UDP on server",decoded[2], decoded[3],myIP, myPort)
						local pendingConnection = {}
						pendingConnection.pendingIP, pendingConnection.pendingPort = decoded[2], decoded[3] --this is where we fire the player connected event
						pendingConnection.UDPClient = UDPClient
						pendingConnections[decoded[2]..decoded[3]] = pendingConnection
					end
				end				
			end
		end		
		for i,pendingConnection in pairs(pendingConnections) do
			--print("pending list", i, pendingConnection)
			local UDPClient = pendingConnection.UDPClient
			local pendingIP = pendingConnection.pendingIP
			local pendingPort = pendingConnection.pendingPort
			--send 2 packets, one to the server and one to the client to make sure they get receieved. must send to both because the server must inform the client of our address behind NAT
			UDPClient:sendto(json.encode{"CoronaAutoInternet",applicationName,"cs",pendingIP,pendingPort},peerIP, peerPort+1) --send udp saying I want to connect to this client, the connection is open	
			UDPClient:sendto(json.encode{"e"},pendingIP, pendingPort) --send udp saying I want to connect to this client, the connection is open	
			local msg,clientIP,port = UDPClient:receivefrom()
			----print("from clien", msg)

			if(msg and clientIP==pendingIP and port == pendingPort) then --make sure the packet arrives from the right place
				local message = json.decode(msg)
				if(message and message[1] == "e") then	
					numClients = numClients+1
					clientIP = clientIP..port --for internet, the unique id is the ip+port
					pendingConnections[clientIP] = nil --remove from the list of pending connections
					availibleClients[clientIP] = {name = message[1], port = port, timeoutTime = timeoutTime, ip = clientIP}
					clientsInfo[numClients] = availibleClients[clientIP] 
					local clientInfo = clientsInfo[numClients]
					clientInfo.numMessages = 0
					clientInfo.heartbeatTimer = heartbeatTime
					clientInfo.numHighPriorityRecieved = 0
					clientInfo.HighPriorityRecieved = {0}
					clientInfo.ip = clientIP
					UDPClient:setpeername(pendingIP, pendingPort)
					UDPClients[numClients] = UDPClient					
					------print("client connected", clientIP,clientPort)
					--create convenience player object
					local newPlayer = {}
					--create convenience player object
					local newPlayer = {}
					newPlayer.clientID = numClients
					clientInfo.clientObject = newPlayer
					function newPlayer:send(input)
						send({1,input}, self.clientID, 1)
					end
					function newPlayer:sendPriority(input, params)
						params = params or {}
						send({1,input}, self.clientID, 2,params.callback)
					end	
					function newPlayer:sendFile(filename, directory, destination)
						sendFile(filename, directory, self.clientID, destination)
					end	
					function newPlayer:disconnect()
						UDPClients[self.clientID] :close()
						UDPClients[self.clientID] = nil
						local clientInfo = clientsInfo[self.clientID]
						availibleClients[clientInfo.ip] = nil
						--numClients = numClients-1
							--now cycle through any pending files and clear the memory
							for c,file in pairs(pendingFiles) do
								if(file.id == self.clientID) then
									pendingFile[self.clientID] = nil
								end
							end					
						Runtime:dispatchEvent({name = "autolanPlayerDropped", client = clientInfo.clientObject, clientID = self.clientID, message = "user disconnect"})		
						clientsInfo[self.clientID] = nil
					end
					Runtime:dispatchEvent({name = "autolanPlayerJoined",  clientID = numClients, client = newPlayer, internet= true})
				end
			end
		end		
	--end of internet loop	
	end
end

local prevoiuspacket = 1
local function receive()
	local message,error
	for i = 1, numClients do
	local UDPClient =  UDPClients[i]
	if(UDPClient~= nil) then
		local clientInfo = clientsInfo[i]
					
			message,error = UDPClient:receive()
			
			local noError = false
			while(message) do
				noError=true
		------print("recieved", #message)
				message = json.decode(message)
				if(message[1] == "e") then
					return
				end
	--			prevoiuspacket = message[1][2]
				if(message) then
					------transport layer ---------------------------------------------------
					clientInfo.numMessages = clientInfo.numMessages+1
					if(message[2][1]==2) then
						---simulate bad connection

						--high priority,record ack to send
						local numHighPriorityRecieved = clientInfo.numHighPriorityRecieved 
						clientInfo.numHighPriorityRecieved = numHighPriorityRecieved+1
						clientInfo.HighPriorityRecieved[numHighPriorityRecieved+1] = message[2][3] --log to send ack in a future packet (pooling)
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
					------print("credits", sendCredits,message[2][2])					
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
							pendingFile.id = i
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
							Runtime:dispatchEvent({name = "autolanFileReceived", filename = filename, clientID = i})
							pendingFile.file:close()
							pendingFiles[filename]	 = nil
						end
					elseif(userMessage[1]==1) then 
						Runtime:dispatchEvent({name = "autolanReceived",  clientID = numClients, message = userMessage[2], client = clientInfo.clientObject })
					elseif(userMessage[1]==3) then
						--message type ping
						send({0}, i, 1) 	
													
					end
				end
				message,error = UDPClient:receive()
			end
			
			
			if error and not noError then
				if error == "timeout" then
					local timeouts = clientInfo.timeoutTime
					clientInfo.timeoutTime = timeouts-1 --clients responsibility to send alive packets
					if(timeouts == 0) then
						--this connection has timed out so kill it
						UDPClient:close()
						UDPClients[i] = nil
						--table.remove(UDPClients,i)
						availibleClients[clientInfo.ip] = nil
						
						--table.remove(clientsInfo,i)
						--numClients = numClients-1
						--now cycle through any pending files and clear the memory
						for c,file in pairs(pendingFiles) do
							if(file.id == i) then
								pendingFile[i] = nil
							end
						end
						------print("connection timeout") --------send player dropped event
						Runtime:dispatchEvent({name = "autolanPlayerDropped",   client = clientsInfo[i].clientObject, clientID = i, message = "timeout"})
						clientsInfo[i] = nil
					end
				elseif error == "closed" then
					--this connection has timed out so kill it
					UDPClient:close()
					UDPClients[i] = nil
					availibleClients[clientInfo.ip] = nil
				
					--numClients = numClients-1
						--now cycle through any pending files and clear the memory
						for c,file in pairs(pendingFiles) do
							if(file.id == i) then
								pendingFile[i] = nil
							end
						end					
					Runtime:dispatchEvent({name = "autolanPlayerDropped",  client = clientsInfo[i].clientObject, clientID = i,message = "closed"})
					clientsInfo[i] = nil
					----print("closed")
				end
			else
				clientInfo.timeoutTime = timeoutTime --reset timeouts
			end

		--heartbeat to send periodically a packet to ensure connection is alive
		local heartbeatTimer = clientInfo.heartbeatTimer
		clientInfo.heartbeatTimer = heartbeatTimer-1
			if(heartbeatTimer==0) then
				------print("sendHearbeat")
				send({0}, i, 1) 	
				
			end
				
		end		
	end	
end
local function mainLoop() --handles both data transfer, ACKS, disconnecting clients
	if(sendCredits>0) then
	-------------------------files	
			local fileTable = fileQueue[1]
			--get the datagram data
		if(fileTable) then	
			local data = fileTable.file:read(packetSize)
			local sendPacket = {2,fileTable.filename, fileTable.currentPacket, fileTable.numPackets, data} --first entry (high level) is type of packet 1 = user, 2 = file, 3=command
			fileTable.currentPacket = fileTable.currentPacket+1
			if(data) then
				send(sendPacket,fileQueueClients[1],2)
			else
				--end of file
				table.remove(fileQueue,1)
				table.remove(fileQueueClients,1)
				fileQueueNumber = fileQueueNumber-1
			end
		end	
	end
	
	--check if any high priority messages must be resent
	--decrement counters
	for i,packet in pairs(sendQueueHigh) do

		local count = HighPriorityCounters[i]
		local clientIndex = sendQueueHighClients[i] --ie player number
		local clientInfo = clientsInfo[clientIndex]
		if(clientInfo~= nil) then
			local UDPClient = UDPClients[clientIndex]			
			if(count) then
				if(count == 0) then
					HighPriorityCounters[i] = HighPriorityCount
						--resend packet
						packet[2][2]  = clientInfo.numMessages -- control/acks
						packet[3] = clientInfo.HighPriorityRecieved  --high priority acks						
						UDPClient:send( json.encode(packet) ) --send data entry
						sendCredits = sendCredits-1
	--					HighPriorityCounters[i]= nil
	--					sendQueueHigh[i] = nil
					------print("resending", packet)
				else
					HighPriorityCounters[i] = count - 1
				end
			end
		else
			--client is dead, ACK the request
			sendQueueHigh[i] = nil
			HighPriorityCounters[i] = nil
			if(sendQueueHighCallbacks[i]) then
				sendQueueHighCallbacks[i]({phase = "cancelled"})
			end			
		end
	end	
end


local server = {}
function server:setOptions(params)
	broadcastTime = params.broadcastTime or broadcastTime
	applicationName = params.applicationName or applicationName
	customBroadcast = params.customBroadcast or customBroadcast
	networkRate = params.networkRate or networkRate --feqnuency to run network loop
	connectTime = params.connectTime or connectTime --frequency to look for new clients
	timeoutTime = params.timeoutTime or timeoutTime --number of cycles to wait before client is DC
	maxCredits = params.maxCredits or maxCredits --number of packets to send w/o ACK
	rechargeRate = params.rechargeRate or rechargeRate --time to recharge credits
	rechargeAmount = params.rechargeAmount or rechargeAmount --time to recharge credits
	circularBufferSize = params.circularBufferSize or circularBufferSize --max number of elements in circular buffer, 2^n
	packetSize = params.packetSize or packetSize
end
function server:setCustomBroadcast(input)
	customBroadcast = input or customBroadcast
	broadcastTable = {"CoronaMultiplayer", applicationName, deviceName, myPort, customBroadcast} --broadcast frame = protocol name, app name, port to server (not broadcaster)  
	broadcast = json.encode(broadcastTable)	
	--if we are connected to the internet we must update our state
	if(matchmakerTCPclient) then
		matchmakerTCPclient:send(json.encode({"CoronaAutoInternet",applicationName,"s",deviceName,customBroadcast}).."\n") --first is protocolID, next position is conneciton type (s=server, c = client), next is application type (step 1)
	end
end
function server:start()
timers.recharge = timer.performWithDelay(rechargeRate, function() addCredits(rechargeAmount) end)
timers.broadcast = timer.performWithDelay(broadcastTime,UDPBroadcast,-1)
timers.connect = timer.performWithDelay(connectTime,connectClients,-1)
--Runtime:addEventListener("enterFrame", mainLoop)
timers.mainLoop = timer.performWithDelay(networkRate,mainLoop,-1)
timers.receive = timer.performWithDelay(1,receive,-1)
end
function server:startInternet()
	if(matchmakerTCPclient == nil) then
		server:start()
		--establish a TCP connection with the matchmaker server
		if(peerIP == nil) then
			local s = socketUDP()
    		s:setpeername( "google.com", 54613 )
    		peerIP, peerPort = s:getsockname(), 54613
		end

		matchmakerTCPclient = socketTCP()
		matchmakerTCPclient:settimeout(0) --this is the only blocking operation	
		matchmakerTCPclient:connect(peerIP, peerPort) --bind on any availible port and localserver ip address.
		timers.connectMatchmaker = timer.performWithDelay(500, server.startInternet,-1)
	end
	local readable, writable, timeout = socket.select(nil,{matchmakerTCPclient},0); --poll the TCP conneciton to ensure it is ready
	if(timeout == nil) then
		if(timers.connectMatchmaker) then
			timer.cancel(timers.connectMatchmaker)
		end
		matchmakerTCPclient:send(json.encode({"CoronaAutoInternet",applicationName,"s",deviceName,customBroadcast}).."\n") --first is protocolID, next position is conneciton type (s=server, c = client), next is application type (step 1)
	end
end
function server:setMatchmakerURL(url, port)
	local serverName = "ipv6.test-ipv6.com"
	local addr_info, mesg = socket.dns.getaddrinfo( url )
	 peerIP,  peerPort = addr_info[1].addr,port
end
function server:startLocal()
	server:start()
end
function server:stop()
	for i,t in pairs(timers) do
		timer.cancel(t)
		t = nil
	end
	if(matchmakerTCPclient) then
		matchmakerTCPclient:close()
		matchmakerTCPclient = nil
	end
end
function server:disconnect()
--kills all clients
	for i = 1, numClients do
		if(UDPClients[i]) then
			UDPClients[i] :close()
			UDPClients[i] = nil
			local clientInfo = clientsInfo[i]
			availibleClients[clientInfo.ip] = nil
			--numClients = numClients-1
				--now cycle through any pending files and clear the memory
				for c,file in pairs(pendingFiles) do
					if(file.id == i) then
						pendingFile[i] = nil
					end
				end					
			Runtime:dispatchEvent({name = "autolanPlayerDropped", client = clientInfo.clientObject, clientID = i, message = "user disconnect"})		
			clientsInfo[i] = nil

		end
	end
end
return server