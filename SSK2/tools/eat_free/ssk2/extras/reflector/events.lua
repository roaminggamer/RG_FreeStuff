--This is a useful file to use as a template. All event listeners are here, you may copy and paste the ones that you need.

----------------------------------------------------------------------------------------------------------
----------------------------Client Specific Listeners-----------------------------------------------------
----------------------------------------------------------------------------------------------------------
local function autolanConnected(event)
	print("broadcast", event.customBroadcast) --this is the user defined broadcast recieved from the server, it tells us about the server state.
	print("serverIP," ,event.serverIP) --this is the user defined broadcast recieved from the server, it tells us about the server state.
	print("connection established")

	table.dump(event,nil,"autolanConnected")
end
Runtime:addEventListener("autolanConnected", autolanConnected)

local function autolanServerFound(event)
	print("broadcast", event.customBroadcast) --this is the user defined broadcast recieved from the server, it tells us about the server state.
	print("server name," ,event.serverName) --this is the name of the server device (from system.getInfo()). if you need more details just put whatever you need in the customBrodcast
	print("server IP:", event.serverIP) --this is the server IP, you must store this in an external table to connect to it later
	print("autolanServerFound")
	table.dump(event,nil,"autolanServerFound")
end
Runtime:addEventListener("autolanServerFound", autolanServerFound)

local function autolanDisconnected(event)
	print("disconnected b/c ", event.message) --this can be "closed", "timeout", or "user disonnect"
	print("serverIP ", event.serverIP) --this can be "closed", "timeout", or "user disonnect"
	print("autolanDisconnected") 
end
Runtime:addEventListener("autolanDisconnected", autolanDisconnected)

local function autolanReceived(event)
	print("message = ", event.message) --this is the message we recieved from the server
	print("autolanReceived")
	table.dump(event,nil,"autolanReceived")
	table.print_r(event)
end
Runtime:addEventListener("autolanReceived", autolanReceived)

local function autolanFileReceived(event)
	print("filename = ", event.filename) --this is the filename in the system.documents directory
	print("autolanFileReceived")
	table.dump(event,nil,"autolanFileReceived")
end
Runtime:addEventListener("autolanFileReceived", autolanFileReceived)

local function autolanConnectionFailed(event)
	print("serverIP = ", event.serverIP) --this indicates that the server went offline between discovery and connection. the serverIP is returned so you can remove it form your list
	print("autolanConnectionFailed")
	table.dump(event,nil,"autolanConnectionFailed")
end
Runtime:addEventListener("autolanConnectionFailed", autolanConnectionFailed)

----------------------------------------------------------------------------------------------------------
----------------------------Server Specific Listeners-----------------------------------------------------
----------------------------------------------------------------------------------------------------------
local function autolanPlayerJoined(event)
	print("client object: ", event.client) --this represents the connection to the client. you can use this to send messages and files to the client. You should save this in a table somewhere.
	print("autolanPlayerJoined") 
	table.dump(event,nil,"autolanPlayerJoined")
end
Runtime:addEventListener("autolanPlayerJoined", autolanPlayerJoined)

local function autolanPlayerDropped(event)
	print("client object ", event.client) --this is the reference to the client object you use to send messages to the client, you can use this to findout who dropped and react accordingly
	print("dropped b/c ," ,event.message) --this is the user defined broadcast recieved from the server, it tells us about the server state.
	print("autolanPlayerDropped")
	table.dump(event,nil,"autolanPlayerDropped")
end
Runtime:addEventListener("autolanPlayerDropped", autolanPlayerDropped)

local function autolanReceived(event)
	print("broadcast", event.client) --this is the object representing the connection. This is the same object given during the playerJoined event and you can use this to find out which client this is coming from
	print("message," ,event.message) --this is the message from the client. You must use event.client to find out who it came from.
	print("autolanReceived")
	table.dump(event,nil,"autolanReceived")
end
Runtime:addEventListener("autolanReceived", autolanReceived)

local function autolanFileReceived(event)
	print("filename = ", event.filename) --this is the filename in the system.documents directory
	print("autolanFileReceived")
	table.dump(event,nil,"autolanFileReceived")
end
Runtime:addEventListener("autolanFileReceived", autolanFileReceived)