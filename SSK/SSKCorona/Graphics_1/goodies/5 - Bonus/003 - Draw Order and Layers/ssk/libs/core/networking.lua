-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Networking Utilities - NOT READY FOR USE (EFM)
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
-- Docs: https://github.com/roaminggamer/SSKCorona/wiki
-- =============================================================
--local debugLevel = 2 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print


--EFM remove game specific code from this
---------------------------------------------------------------------------------
--
-- u_networking:lua
--
---------------------------------------------------------------------------------
--module(..., package.seeall)

local networking = {}

local networking

if( not _G.ssk.networking ) then
	_G.ssk.networking = {}
end

networking = _G.ssk.networking

----------------------------------------------------------------------
--						REQUIRES									--
----------------------------------------------------------------------
local storyboard  = require( "storyboard" )
local json        = require "json"
local gem         = ssk.gem
local clientClass = require( "ssk.libs.external.mydevelopergames.Client" ) -- Client (External: http://www.mydevelopersgames.com/AutoLAN/)
local serverClass = require( "ssk.libs.external.mydevelopergames.Server" ) -- Server (External: http://www.mydevelopersgames.com/AutoLAN/)

----------------------------------------------------------------------
--						LOCALS										--
----------------------------------------------------------------------
-- Variables
networking.connectedToServer = false
networking.clients = {} 
networking.numClients = 0

networking.serverRunning = false
networking.clientRunning = false

-- Special Variables
networking.myName  = "invalid"
networking.myFinalScore = "invalid"
networking.myDataTable  = invalid

-- Callbacks/Functions
-- COMMON
local dataReceived 

-- SERVER
local host_handleDataReceived
local server_PlayerJoined
local server_PlayerDropped

-- CLIENT
local client_handleDataReceived
local client_DoneScanning
local client_ServerFound
local client_ConnectedToServer
local client_Disconnected
local client_ConnectionFailed


----------------------------------------------------------------------
--						GLOBAL FUNCTIONS							--
----------------------------------------------------------------------

--[[
h ssk.networking:isNetworking
d Checks if the server and/or client running.
s ssk.networking:isNetworking()
r true if the client and/or the server is running, false otherwise.
--]]
function networking:isNetworking()
	return (self.serverRunning or self.clientRunning )
end

--[[
h ssk.networking:msgServer
d Send a named message to the server. (CLIENT ONLY)
s ssk.networking:msgServer( msg, data ) 
s * msg - A string containing the message name.
s * data - A table of data.  All tables and depths of table accepted.
r None.
--]]
function networking:msgServer( msg, data ) 
	local msg  = msg
	local data = data or {}
	data.msgType = msg	

	clientClass:send( json.encode(data) )
end

--[[
h ssk.networking:msgClient
d Send a named message to a specific client. (SERVER ONLY)
s ssk.networking:msgClient( aClient, msg, data  )
s * aClient - A numeric ID specifying the target client.
s * msg - A string containing the message name.
s * data - A table of data.  All tables and depths of table accepted.
r None.
--]]
function networking:msgClient( aClient, msg, data  )
	local msg  = msg
	local data = data or {}
	data.msgType = msg			

	aClient:send( json.encode(data) )
end

--[[
h ssk.networking:msgClients
d Send a named message to all connected clients. (SERVER ONLY)
s ssk.networking:msgClients( msg, data ) 
s * msg - A string containing the message name.
s * data - A table of data.  All tables and depths of table accepted.
r None.
--]]
function networking:msgClients( msg, data )
	local msg  = msg
	local data = data or {}
	data.msgType = msg			

	for key,aClient in pairs(self.clients) do
		aClient:send( json.encode(data) )
	end
end

--[[
h ssk.networking:getNumClients
d Get number of currently connected clients.
s ssk.networking:getNumClients() (SERVER ONLY)
r Returns the number of currently connected clients: [0, N].
--]]
function networking:getNumClients(  )
	return self.numClients
end

--[[
h ssk.networking:getClientsTable
d Get the (actual) clients table.  This table contains the IDs of all currently connected clients.
d <br>Warning: This is not a copy.  Modifying this table may break functionality, so be careful.
s ssk.networking:getClientsTable() (SERVER ONLY)
r Returns a reference to the actual clients table.
--]]
function networking:getClientsTable(  )
	return self.clients
end

--[[
h ssk.networking:startServer
d Start the server.
s ssk.networking:startServer()
r None.
--]]
function networking:startServer( )
	if( self.serverRunning ) then
		return
	end

	serverClass:start() 
	self.serverRunning = true
end

--[[
h ssk.networking:startClient
d Start the client.
s ssk.networking:startClient()
r None.
--]]
function networking:startClient( )
	if( self.clientRunning ) then
		return
	end

	clientClass:start() 	
	self.clientRunning = true
end


--[[
h ssk.networking:scanServers
d Scan for active servers matching the client specifications. 
s ssk.networking:scanServers( [ durationMS ] ) (CLIENT ONLY)
s * durationMS - (optional) Number of milliseconds to scan before giving up. If not specified, the client will scan forever until scanning is forcefully stopped, until a connection is established, or until the client is stopped.
r None.
--]]
function networking:scanServers( durationMS )
	if( not self.clientRunning ) then
		clientClass:start() 
		self.clientRunning = true
	end
	clientClass:scanServers( durationMS )
end

--[[
h ssk.networking:stopScanning
d Stop any currently active scan for servers.
s ssk.networking:stopScanning()  (CLIENT ONLY)
r None.
--]]
function networking:stopScanning( )
	if( not self.clientRunning ) then
		return
	end
	clientClass:stopScanning( )
end

--[[
h ssk.networking:setCustomBroadcast
d EFM
s ssk.networking:setCustomBroadcast( newBroadcast ) (SERVER ONLY)
s * newBroadcast - A string containing the customBroadcast message servers should provide when they are scanned by clients.
r None.
--]]
function networking:setCustomBroadcast( newBroadcast ) 
	serverClass:setOptions({customBroadcast = newBroadcast})
	serverClass:setCustomBroadcast()
end

--[[
h ssk.networking:autoconnectToHost
d Automatically scan for servers and connect to the first one found.
s ssk.networking:autoconnectToHost() (CLIENT ONLY)
r None.
--]]
function networking:autoconnectToHost( )
	dprint(1,"autoconnectToHost()")
	if( not self.clientRunning ) then
		clientClass:start() 		
		self.clientRunning = true
	end
	clientClass:autoConnect( )
end

--[[
h ssk.networking:connectToSpecificHost
d Connect to a specific server at a known address.
s ssk.networking:connectToSpecificHost( hostIP )
s * hostIP - A string containing a server address of the form "AAA.BBB.CCC.DDD", where A/B/C/D are numbers.
r None.
--]]
function networking:connectToSpecificHost( hostIP )
	dprint(1,"connectToSpecificHost( " .. hostIP .. " )")
	if( not self.clientRunning ) then
		clientClass:start() 
		self.clientRunning = true
	end
	clientClass:connect(hostIP)
end

--[[
h ssk.networking:stop
d Stop all server and client networking.
s ssk.networking:stop()
r None.
--]]
function networking:stop()
	dprint(1,"stopNetworking()")
	if( self.numClients > 0) then
		serverClass:disconnect()
		for k,v in pairs(self.clients) do 
			local client = self.clients[k]
			clients[k] = nil
			self.numClients = self.numClients - 1	
			client:removeSelf() --EFM BUG?? shouldn't it stop?
		end
		self.numClients = 0
	end

	if( self.connectedToServer == true) then
		clientClass:disconnect()
		self.connectedToServer = false
	end

	serverClass:stop()
	clientClass:stop()

	self.serverRunning = false
	self.clientRunning = false

	self.myName  = "invalid"
	self.myFinalScore = "invalid"
	self.myDataTable  = invalid

	gem:post("CLIENT_STOPPED")
	gem:post("SERVER_STOPPED")
end

--[[
h ssk.networking:stopClient
d Stop just the client.
s ssk.networking:stopClient()
r None.
--]]
function networking:stopClient()
	dprint(1,"stopClient()")

	if( self.connectedToServer == true) then
		clientClass:disconnect()
		self.connectedToServer = false
	end

	clientClass:stop()
	self.clientRunning = false
	gem:post("CLIENT_STOPPED")
end

--[[
h ssk.networking:stopServer
d Stop just the client.
s ssk.networking:stopServer()
r None.
--]]
function networking:stopServer()
	dprint(1,"stopServer()")
	if( self.numClients > 0) then
		serverClass:disconnect()
		for k,v in pairs(self.clients) do 
			local client = self.clients[k]
			clients[k] = nil
			self.numClients = self.numClients - 1	
			client:removeSelf() --EFM BUG?? shouldn't it stop?
		end
		self.numClients = 0
	end

	serverClass:stop()
	self.serverRunning = false

	self.myName  = "invalid"
	self.myFinalScore = "invalid"
	self.myDataTable  = invalid

	gem:post("SERVER_STOPPED")
end


-- ==
-- EFM: Remove me when dependencies are removed
-- ==
function networking:getClientByKey( key )
	return self.clients[key]
end

-- ==
-- EFM: Remove me when dependencies are removed
-- ==
function networking:setClient( client )
	self.clients[client] = client
end


--[[
h ssk.networking:isConnectedToServer
d Check to see if this client is connected to a server.
s ssk.networking:isConnectedToServer() (CLIENT ONLY)
r true if this client is connected to a server, false otherwise.
--]]
function networking:isConnectedToServer()
	return (self.connectedToServer == true)
end

--[[
h ssk.networking:isServerRunning
d Check to see if the server is running.
s ssk.networking:isServerRunning() 
r true if the server is running,, false otherwise.
--]]
function networking:isServerRunning()
	return (self.serverRunning == true)
end


--[[
h ssk.networking:isClientRunning
d Check to see if the client is running.
s ssk.networking:isClientRunning() 
r true if the client is running,, false otherwise.
--]]
function networking:isClientRunning()
	return (self.clientRunning == true)
end


--- Networking: Check Util
--[[
h ssk.networking:isConnectedToWWW
d Checks network connectivity by attempting to connect to an optionally specified URL.
s ssk.networking:isConnectedToWWW( [ url ] )
s * url - (optional) A string containing an IP address or a named url.  Defaults to "www.google.com"
r true if the device could connect to the specified URL, false otherwise.
--]]
function networking:isConnectedToWWW( url )
	local url = url or "www.google.com" 
	local hostFound = true
	local con = socket.tcp()
	con:settimeout( 2 ) -- Timeout connection attempt after 2 seconds
                
	-- Check if socket connection is open
	if con:connect(url, 80) == nil then 
		hostFound = false
		dprint(1, "URL Not Found: " .. url )
	else
		dprint(1, "URL Found: " .. url )
	end

	return hostFound
end

----------------------------------------------------------------------
--	Special Utilities: Player Name, Score, Data					--
----------------------------------------------------------------------

--[[
h ssk.networking:setMyName
d Set the current player's name. (Part of the special networking utilities set.)
d <br>If this is a client, the name is sent to the currently connected server.
s ssk.networking:setMyName( name )
s * name - A string containing the name of the current player.
r None.
--]]
function networking:setMyName( name  )
	if(self.serverRunning) then -- I am the server
		networking.myName = name
	elseif(self.clientRunning) then -- I am a client
		self:msgServer( "_RG_SETNAME_RG_" , { myName = name } )
	end
end

--[[
h ssk.networking:setMyFinalScore
d Set the current player's final score. (Part of the special networking utilities set.)
d <br>If this is a client, the score is sent to the currently connected server.
s ssk.networking:setMyFinalScore( finalScore )
s * finalScore - A number containing the final score of the current player.
r None.
--]]
function networking:setMyFinalScore( finalScore  )
	if(self.serverRunning) then -- I am the server
		networking.myFinalScore = finalScore
	elseif(self.clientRunning) then -- I am a client
		self:msgServer( "_RG_SETFINALSCORE_RG_" , { myFinalScore = finalScore } )
	end
end

--[[
h ssk.networking:setMyData
d Set the current player's data table. (Part of the special networking utilities set.)
d <br>If this is a client, the data table is sent to the currently connected server.
s ssk.networking:setMyData( dataTable )
s * dataTable - A table containg free-form data for the current player.  
r None.
--]]
function networking:setMyData( dataTable  )
	if(self.serverRunning) then -- I am the server
		networking.myDataTable = dataTable
	elseif(self.clientRunning) then -- I am a client
		self:msgServer( "_RG_SETDATA_RG_" , { myDataTable = dataTable } )
	end
end


-- Server ONLY
--[[
h ssk.networking:clearMyName
d Clears all known current player names.  (Only the server can do this.)
s ssk.networking:clearMyName( ) (SERVER ONLY)
r None.
--]]
function networking:clearMyName( )
	if(self.serverRunning) then -- I am the server
		networking.myName = "invalid"
		for k,v in pairs(networking.clients) do
			v.myName = "invalid"
		end
	end
end

--[[
h ssk.networking:clearMyFinalScore
d Clears all known current final scores.  (Only the server can do this.)
s ssk.networking:clearMyFinalScore( ) (SERVER ONLY)
r None.
--]]
function networking:clearMyFinalScore( )
	if(self.serverRunning) then -- I am the server
		networking.myFinalScore = "invalid"

		for k,v in pairs(networking.clients) do
			v.myFinalScore = "invalid"
		end
	end
end

--[[
h ssk.networking:clearMyData
d Clears all known current data tables.  (Only the server can do this.)
s ssk.networking:clearMyData( ) (SERVER ONLY)
r None.
--]]
function networking:clearMyData( )
	if(self.serverRunning) then -- I am the server
		networking.myDataTable = "invalid"

		for k,v in pairs(networking.clients) do
			v.myDataTable = "invalid"
		end
	end
end


-- ONLY FOR SERVER
-- Returns 'nil' if one or more names is missing
--
-- Because this returns 'nil' if all the names are not present, it 
-- makes POLLING for names/final-scores very easy.  
--[[
h ssk.networking:getNames
d Gets a table of all current player names, or nil if one or more names is missing.  This function is designed to making polling for complete data sets easy.
s ssk.networking:getNames( ) (SERVER ONLY)
r A table of names for the server and all connected clients, or nil if the server or one of the clients has not yet registered its name with setMyName().
--]]
function networking:getNames( )  
	if(self.serverRunning) then -- I am the server
		local tmpTable =  {}
		local allFound = true
		
		if( self.myName == "invalid" ) then
			allFound = false
		else
			tmpTable[#tmpTable+1] = self.myName
		end		
		
		for key,aClient in pairs(self.clients) do
			if( aClient.myName == "invalid" ) then
				allFound = false
			else
				tmpTable[#tmpTable+1] = aClient.myName
			end
		end

		if( allFound ) then
			return tmpTable
		end
	end

	return nil
end

-- ONLY FOR SERVER
-- Returns 'nil' if one or more names or final-scores is missing
--
-- Because this returns 'nil' if all the names/final-scores are not present, it 
-- makes POLLING for names very easy.  
--[[
h ssk.networking:getFinalScores
d Gets a table of all current player names and their finals scores, or nil if one or more names/scores is missing.  This function is designed to making polling for complete data sets easy.
s ssk.networking:getFinalScores( ) (SERVER ONLY)
r A table of names and scores for the server and all connected clients, or nil if the server or one of the clients has not yet registered its name with setMyName() and its final score with setMyFinalScore().
--]]
function networking:getFinalScores( )  
	if(self.serverRunning) then -- I am the server
		local tmpTable =  {}
		local allFound = true
		
		if( self.myName == "invalid" or self.myFinalScore == "invalid") then
			allFound = false
		else
			tmpTable[#tmpTable+1] = { name = self.myName, finalScore = self.myFinalScore }
		end		
		
		for key,aClient in pairs(self.clients) do
			if( aClient.myName == "invalid" or aClient.myFinalScore == "invalid") then
				allFound = false
			else
				tmpTable[#tmpTable+1] = { name = aClient.myName, finalScore = aClient.myFinalScore }
			end
		end

		if( allFound ) then
			return tmpTable
		end
	end

	return nil
end

-- ONLY FOR SERVER
-- Returns 'nil' if one or more names or data is missing
--
-- Because this returns 'nil' if all the names/data are not present, it 
-- makes POLLING for names/data very easy.  
--[[
h ssk.networking:getData
d Gets a table of all current player names and their data tables, or nil if one or more names/dataTables is missing.  This function is designed to making polling for complete data sets easy.
s ssk.networking:getData( ) (SERVER ONLY)
r A table of names and data tables for the server and all connected clients, or nil if the server or one of the clients has not yet registered its name with setMyName() and its dataTable with setMyData().
--]]
function networking:getData( )  
	if(self.serverRunning) then -- I am the server
		local tmpTable =  {}
		local allFound = true
		
		if( self.myName == "invalid" or self.myDataTable == "invalid") then
			allFound = false
		else
			tmpTable[#tmpTable+1] = { name = self.myName, data = self.myDataTable }
		end		
		
		for key,aClient in pairs(self.clients) do
			if( aClient.myName == "invalid" or aClient.myDataTable == "invalid") then
				allFound = false
			else
				tmpTable[#tmpTable+1] = { name = aClient.myName, data = aClient.myDataTable }
			end
		end

		if( allFound ) then
			return tmpTable
		end
	end

	return nil
end


--[[
function networking:setClientPlayerScore( aClient, score  )
	aClient.playerScore = score
end

function networking:getClientPlayerScore( aClient  )
	return aClient.playerScore
end

function networking:getClientPlayerScores( aClient  ) -- EFM THIS IS WRONG
	local tmpTable =  {}
	for key,aClient in pairs(self.clients) do
		tmpTable[#tmpTable+1] = { aClient.playerName, aClient.playerScore }
		--tmpTable[aClient.playerScore] =  aClient.playerName
	end
	return tmpTable
end

function networking:clearClientPlayerScores( aClient  )
	for key,aClient in pairs(self.clients) do
		aClient.playerScore = 0
		aClient.gameOver = false
	end
end
--]]

--[[
h ssk.networking.globalEvents
d The ssk.networking utilities produce these global (Runtime) events:
d <br>
d <br> SERVER EVENTS:
d  * CLIENT_JOINED - A new client has connected to the server.  event == { clientID }
d  * CLIENT_DROPPED - A client disconnected or got dropped  event == { clientID, dropReason }
d  * MSG_FROM_CLIENT - The server received a message from a client. event == { clientID, msgTable}
d  * SERVER_STOPPED - The server stopped.
d <br> CLIENT EVENTS:
d  * DONE_SCANNING_FOR_SERVERS - The client has finished scanning for clients. event == { servers = { { serverName, serverIP, port, customBroadcast } , ... } }
d  * SERVER_FOUND - A single server was found (issued once for each server found during a scan). event == { serverName, serverIP, port, customBroadcast }
d  * CONNECTED_TO_SERVER - The client connected to a specific server. event == { serverIP, customBroadcast, myClientID }
d  * MSG_FROM_SERVER - The server sent a message to this client. event == { clientID, msgTable }
d  * SERVER_DROPPED - The server discconected from this client. event = { serverIP, dropReason, message }
--]]



----------------------------------------------------------------------
--						CALLBACK DEFINITIONS						--
----------------------------------------------------------------------

function networking:registerCallbacks()
	dprint(2,"ssk.networking - registerCallbacks()")

	-- SERVER
	Runtime:addEventListener("autolanPlayerJoined", server_PlayerJoined)
	Runtime:addEventListener("autolanPlayerDropped", server_PlayerDropped)

	-- CLIENT
	
	Runtime:addEventListener("autolanDoneScanning", client_DoneScanning)
	Runtime:addEventListener("autolanServerFound", client_ServerFound)
	Runtime:addEventListener("autolanConnected", client_ConnectedToServer)
	Runtime:addEventListener("autolanDisconnected", client_Disconnected)
	Runtime:addEventListener("autolanConnectionFailed", client_ConnectionFailed)

	-- BOTH
	Runtime:addEventListener("autolanReceived", dataReceived)

end


---- COMMON
dataReceived = function (event)	
	dprint(2,"Received message")

	if(networking.connectedToServer) then   --- I AM A CLIENT
		client_handleDataReceived(event)	

	else                         --- I AM THE SERVER		
		host_handleDataReceived(event)
	end

	return false -- Let others catch this too
end

---- SERVER
host_handleDataReceived = function (event)
	dprint(2,"host_handleDataReceived()")

	local client = event.client
	local msg = json.decode( event.message )

	-- Handle SPECIAL MESSAGES without fowarding
	-- _RG_SETNAME_RG_, _RG_SETFINALSCORE_RG_, _RG_SETDATA_RG_
	--
	if(msg.msgType == "_RG_SETNAME_RG_") then
		client.myName = msg.myName
	
	elseif(msg.msgType == "_RG_SETFINALSCORE_RG_") then
		client.myFinalScore = msg.myFinalScore

	elseif(msg.msgType == "_RG_SETDATA_RG_") then 
		client.myDataTable = msg.myDataTable
	
	else
		gem:post("MSG_FROM_CLIENT", { clientID = client, msgTable = msg } )

	end

	return true -- Do not let others catch this too
end

server_PlayerJoined = function (event)
	dprint(1,"server_PlayerJoined()" )

	local client = event.client

	client.myName  = "invalid"
	client.myFinalScore = "invalid"
	client.myDataTable  = invalid

	networking.clients[client] = client
	networking.numClients = networking.numClients + 1
	client.myJoinTime = system.getTimer() 
	gem:post("CLIENT_JOINED", { clientID = client } )

	return true -- Do not let others catch this too
end

server_PlayerDropped = function (event)
	dprint(1,"server_PlayerDropped()")

	local client = event.client

	dprint(2,"HOST - server_PlayerDropped() - " .. 
	" Dropped b/c " .. event.message .. 
	" connection was active for " .. system.getTimer() - networking.clients[client].myJoinTime .. " ms" )

	-- Immediately decrement client count
	networking.numClients = networking.numClients - 1	

	-- Post drop event to listeners with client info
	gem:post("CLIENT_DROPPED", { clientID = client, dropReason = event.message } )

	-- Finally, clear the client info
	-- Take player out of game and remove their name
	client.myName  = nil
	client.myFinalScore = nil
	client.myDataTable  = nil

	networking.clients[client] = nil --clear references to prevent memory leaks


	return true -- Do not let others catch this too
end

------ CLIENT
client_handleDataReceived = function (event)
	dprint(1,"client_handleDataReceived() " .. event.message)

	local theServer = event.client
	local msg = json.decode( event.message )

	gem:post("MSG_FROM_SERVER", { clientID = client, msgTable = msg } )

	return true -- Do not let others catch this too
end

client_DoneScanning = function (event)
	dprint(1,"client_DoneScanning()" )

	local myEvent = event
	gem:post("DONE_SCANNING_FOR_SERVERS", myEvent )

	return true -- Do not let others catch this too
end


client_ServerFound = function (event)
	dprint(1,"client_ServerFound()")
	dprint(2,"JOIN - client_ServerFound() - event.serverName == " .. event.serverName )
	dprint(2,"                            - event.serverIP   == " .. event.serverIP )

	local myEvent = event
	gem:post("SERVER_FOUND", myEvent )

	return true -- Do not let others catch this too
end

client_ConnectedToServer = function (event)
	dprint(1,"client_ConnectedToServer()")
	dprint(2,"JOIN - client_ConnectedToServer() - event.serverIP == " .. event.serverIP )

	networking.connectedToServer = true
	local myEvent = event
	gem:post( "CONNECTED_TO_SERVER",  myEvent )

	return true -- Do not let others catch this too
end

client_Disconnected = function (event)
	dprint(1,"client_Disconnected()")
	dprint(2,"JOIN - client_Disconnected() - event.message  == " .. event.message )
	dprint(2,"                             - event.serverIP == " .. event.serverIP )

	networking.connectedToServer = false
	local myEvent = event
	myEvent.dropReason = "Disconnected"
	gem:post( "SERVER_DROPPED",  myEvent )

	return true -- Do not let others catch this too
end

client_ConnectionFailed = function (event)
	dprint(1,"client_ConnectionFailed()")
	dprint(2,"JOIN - client_ConnectionFailed() - event.serverIP == " .. event.serverIP )

	networking.connectedToServer = false
	local myEvent = event
	myEvent.dropReason = "Dropped"
	gem:post("SERVER_DROPPED" ,  myEvent )

	return true -- Do not let others catch this too
end

ssk.networking:registerCallbacks()