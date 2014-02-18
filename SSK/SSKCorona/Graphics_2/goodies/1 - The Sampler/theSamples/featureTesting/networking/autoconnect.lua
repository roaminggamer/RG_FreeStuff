-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- Template #2
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

--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------

-- Variables
local myCC   -- Local reference to collisions Calculator
local layers -- Local reference to display layers 
local backImage
local thePlayer

-- Fake Screen Parameters (used to create visually uniform demos)
local screenWidth  = w
local screenHeight = h
local screenLeft   = centerX - screenWidth/2
local screenRight  = centerX + screenWidth/2
local screenTop    = centerY - screenHeight/2
local screenBot    = centerY + screenHeight/2

-- Local Function & Callback Declarations
local createCollisionCalculator
local createLayers
local addInterfaceElements

local onStartServer
local onStopServer

local onStartClient
local onStopClient
local onScan
local onConnectToServer

local serverStartButton
local serverStopButton

local clientStartButton
local clientStopButton

local serverIndicators = {}
local connectedClients = {}
local clientIndicators = {}

-- Server event handlers
local onClientJoined
local onMsgFromClient
local onClientDropped
local onServerStopped

-- Client event handlers
local serversFound = 0
local onConnectedToServer
local onServerFound
local onDoneScanningForServers
local onMsgFromServer
local onServerDropped
local onClientStopped

local gameLogic = {}

-- =======================
-- ====================== Initialization
-- =======================
function gameLogic:createScene( screenGroup )

	-- 1. Create collisions calculator and set up collision matrix
	createCollisionCalculator()

	-- 2. Set up any rendering layers we need
	createLayers( screenGroup )

	-- 3. Add Interface Elements to this demo (buttons, etc.)
	addInterfaceElements()

	-- 4. Set up gravity and physics debug (if wanted)
	physics.setGravity(0,0)
	--physics.setDrawMode( "hybrid" )
	screenGroup.isVisible=true

	-- 5. Set up GEMs
	-- Server EVENTS
	ssk.gem:add("CLIENT_JOINED", onClientJoined, "networkingTest" )
	ssk.gem:add("MSG_FROM_CLIENT", onMsgFromClient, "networkingTest" )
	ssk.gem:add("CLIENT_DROPPED", onClientDropped, "networkingTest" )
	ssk.gem:add("SERVER_STOPPED", onServerStopped, "networkingTest" )

	-- Client EVENTS
	ssk.gem:add("CONNECTED_TO_SERVER", onConnectedToServer, "networkingTest" )
	ssk.gem:add("SERVER_FOUND", onServerFound, "networkingTest" )
	ssk.gem:add("DONE_SCANNING_FOR_SERVERS", onDoneScanningForServers, "networkingTest" )
	ssk.gem:add("MSG_FROM_SERVER", onMsgFromServer, "networkingTest" )
	ssk.gem:add("SERVER_DROPPED", onServerDropped, "networkingTest" )
	ssk.gem:add("CLIENT_STOPPED", onClientStopped, "networkingTest" )

end

-- =======================
-- ====================== Cleanup
-- =======================
function gameLogic:destroyScene( screenGroup )
	-- 1. Clear all references to objects we (may have) created in 'createScene()'	

	layers:destroy()
	layers = nil
	myCC = nil
	thePlayer = nil

	-- 2. Clean up gravity and physics debug
	physics.setDrawMode( "normal" )
	physics.setGravity(0,0)
	screenGroup.isVisible=false

	-- 3. Stop all networking
	ssk.networking:stop()

	-- 4. Clean up gems from this test
	ssk.gem:removeGroup( "networkingTest" )

end

-- =======================
-- ====================== Local Function & Callback Definitions
-- =======================
createCollisionCalculator = function()
	--myCC = ssk.ccmgr:newCalculator()
	--myCC:addName("aSphere")
	--myCC:addName("aPoint")
	--myCC:dump()
end


createLayers = function( group )
	layers = ssk.display.quickLayers( group, 
		"background", 
		"content",
		"interfaces" )
end

addInterfaceElements = function()

	ssk.display.line2( layers.interfaces, centerX, -80, 180, h+160, { color = _WHITE_ , w = 4, style="dashed", dashLen = 10, gapLen = 10} )

	ssk.labels:presetLabel( layers.interfaces, "default", "SERVER", 
	                                   centerX - w/4 , 20, 
									   { fontSize = 22 }  )

	ssk.labels:presetLabel( layers.interfaces, "default", "CLIENT", 
	                                   centerX + w/4 , 20, 
									   { fontSize = 22 }  )


	-- Server Elements (on left)
	serverStartButton = ssk.buttons:presetPush( layers.interfaces, "greenGradient", 
	                                     70, h - 80, 
										 80, 30, 
										 "Start", onStartServer )

	serverStopButton = ssk.buttons:presetPush( layers.interfaces, "redGradient", 
	                                     centerX - 70, h - 80, 
										 80, 30, 
										 "Stop", onStopServer )
	serverStopButton:disable()

	-- Running Indicator
	ssk.labels:presetLabel( layers.interfaces, "rightLabel", "Running", 
	                                   w/4 - 15, 80, 
									   { fontSize = 20 }  )
	serverIndicators["running"] = ssk.display.circle( layers.interfaces, w/4 + 20, 80, { radius = 8, fill = _RED_, stroke = _LIGHTGREY_, strokeWidth = 2} )

	-- Connected Clients Indicator
	ssk.labels:presetLabel( layers.interfaces, "rightLabel", "Clients", 
	                                   w/4 - 15, 110, 
									   { fontSize = 20 }  )
	
	connectedClients[1] = ssk.display.circle( layers.interfaces, w/4 + 20, 110, { radius = 8, fill = _RED_, stroke = _LIGHTGREY_, strokeWidth = 2} )
	connectedClients[2] = ssk.display.circle( layers.interfaces, w/4 + 45, 110, { radius = 8, fill = _RED_, stroke = _LIGHTGREY_, strokeWidth = 2} )
	connectedClients[3] = ssk.display.circle( layers.interfaces, w/4 + 70, 110, { radius = 8, fill = _RED_, stroke = _LIGHTGREY_, strokeWidth = 2} )
	connectedClients[4] = ssk.display.circle( layers.interfaces, w/4 + 95, 110, { radius = 8, fill = _RED_, stroke = _LIGHTGREY_, strokeWidth = 2} )


	-- Client Elements (on right)
	clientStartButton = ssk.buttons:presetPush( layers.interfaces, "greenGradient", 
	                                     centerX + 70, h - 80, 
										 80, 30, 
										 "Auto", onStartClient )

	clientStopButton = ssk.buttons:presetPush( layers.interfaces, "redGradient", 
	                                     w - 70, h - 80, 
										 80, 30, 
										 "Stop", onStopClient )
	clientStopButton:disable()


	-- Running Indicator
	ssk.labels:presetLabel( layers.interfaces, "rightLabel", "Running", 
	                                   centerX + w/4 - 15, 80, 
									   { fontSize = 20 }  )
	clientIndicators["running"] = ssk.display.circle( layers.interfaces, centerX + w/4 + 20, 80, { radius = 8, fill = _RED_, stroke = _LIGHTGREY_, strokeWidth = 2} )

	-- Scanning Indicator
	ssk.labels:presetLabel( layers.interfaces, "rightLabel", "Scanning", 
	                                   centerX + w/4 - 15, 110, 
									   { fontSize = 20 }  )
	
	clientIndicators["scanning"] = ssk.display.circle( layers.interfaces, centerX + w/4 + 20, 110, { radius = 8, fill = _RED_, stroke = _LIGHTGREY_, strokeWidth = 2} )


	-- Scanning Indicator
	ssk.labels:presetLabel( layers.interfaces, "rightLabel", "Connected", 
	                                   centerX + w/4 - 15, 140, 
									   { fontSize = 20 }  )
	
	clientIndicators["connected"] = ssk.display.circle( layers.interfaces, centerX + w/4 + 20, 140, { radius = 8, fill = _RED_, stroke = _LIGHTGREY_, strokeWidth = 2} )




--[[
	hostMsg1 = ssk.labels:presetLabel( layers.interfaces, "default", "ABCDEFGHIJKLMNOP", 
	                                   centerX - w/4 , centerY + 60, 
									   { fontSize = 20 }  )

	hostMsg2 = ssk.labels:presetLabel( layers.interfaces, "default", "QRSTUVWXYZ012345", 
	                                   centerX - w/4 , centerY + 100, 
									   { fontSize = 20 }  )

	-- Join Elements (on right)
	joinButton = ssk.buttons:presetPush( layers.interfaces, "yellowGradient", 
	                                     centerX + w/4 , centerY - h/5, 
										 200, 60, 
										 "Auto-connect", onClientPress )

	joinMsg1 = ssk.labels:presetLabel( layers.interfaces, "default", "ABCDEFGHIJKLMNOP", 
	                                   centerX + w/4 , centerY + 60, 
									   { fontSize = 20 }  )

	joinMsg2 = ssk.labels:presetLabel( layers.interfaces, "default", "QRSTUVWXYZ012345", 
	                                   centerX + w/4 , centerY + 100, 
									   { fontSize = 20 }  )
--]]	
end	


onStartServer = function( event )
	print("onStartServer")

	serverStartButton:disable()
	serverStopButton:enable()

	serverIndicators["running"]:setFillColor(unpack(_GREEN_))

	ssk.networking:setCustomBroadcast( "Networking Test" )
	ssk.networking:startServer()
end

onStopServer = function( event )
	print("onStartServer")

	serverStartButton:enable()
	serverStopButton:disable()
	serverIndicators["running"]:setFillColor(unpack(_RED_))
	connectedClients[1]:setFillColor(unpack(_RED_))
	connectedClients[2]:setFillColor(unpack(_RED_))
	connectedClients[3]:setFillColor(unpack(_RED_))
	connectedClients[4]:setFillColor(unpack(_RED_))

	ssk.networking:stopServer()
end

onStartClient = function( event )
	print("onStartClient")

	clientStartButton:disable()
	clientStopButton:enable()
	
	clientIndicators["running"]:setFillColor(unpack(_GREEN_))
	clientIndicators["scanning"]:setFillColor(unpack(_GREEN_))


	ssk.networking:autoconnectToHost()
end

onStopClient = function( event )
	print("onStopClient")

	clientStartButton:enable()
	clientStopButton:disable()
			
	clientIndicators["running"]:setFillColor(unpack(_RED_))
	clientIndicators["connected"]:setFillColor(unpack(_RED_))
	clientIndicators["scanning"]:setFillColor(unpack(_RED_))

	ssk.networking:stopScanning()
	ssk.networking:stopClient()
end

onScan = function( event )
	print("onScan")
	ssk.networking:scanServers( 2000 )
end

onConnectToServer = function( event )
	ssk.networking:connectToSpecificHost( event.target.serverIP )
end

-- Networking Event Handlers
-- Server 
onClientJoined = function( event )
	table.dump(event) 
	connectedClients[1]:setFillColor(unpack(_RED_))
	connectedClients[2]:setFillColor(unpack(_RED_))
	connectedClients[3]:setFillColor(unpack(_RED_))
	connectedClients[4]:setFillColor(unpack(_RED_))

	local numClients = ssk.networking:getNumClients()

	if(numClients > 4) then 
		numClients = 4
	end

	while(numClients > 0) do
		connectedClients[numClients]:setFillColor(unpack(_GREEN_))
		numClients = numClients - 1
	end

end

onMsgFromClient = function( event )	table.dump(event) end

onClientDropped = function( event )
	table.dump(event) 
	connectedClients[1]:setFillColor(unpack(_RED_))
	connectedClients[2]:setFillColor(unpack(_RED_))
	connectedClients[3]:setFillColor(unpack(_RED_))
	connectedClients[4]:setFillColor(unpack(_RED_))

	local numClients = ssk.networking:getNumClients()

	print(numClients)

	if(numClients > 4) then 
		numClients = 4
	end

	while(numClients > 0) do
		connectedClients[numClients]:setFillColor(unpack(_GREEN_))
		numClients = numClients - 1
	end

end

onServerStopped = function( event )
	table.dump(event) 
	connectedClients[1]:setFillColor(unpack(_RED_))
	connectedClients[2]:setFillColor(unpack(_RED_))
	connectedClients[3]:setFillColor(unpack(_RED_))
	connectedClients[4]:setFillColor(unpack(_RED_))
end

-- Client 
onConnectedToServer = function( event )
	table.dump(event) 
	clientIndicators["connected"]:setFillColor(unpack(_GREEN_))
end

onServerFound = function( event )
	table.dump(event) 
end

onDoneScanningForServers = function( event )
	clientIndicators["scanning"]:setFillColor(unpack(_RED_))
	table.dump(event) 
end

onMsgFromServer = function( event )	table.dump(event) end

onServerDropped = function( event )
	table.dump(event) 
	clientIndicators["connected"]:setFillColor(unpack(_RED_))	
	clientIndicators["scanning"]:setFillColor(unpack(_RED_))

	onStopClient() -- force a stop of everything else (and reset buttons)
end

onClientStopped = function( event )
	print("onClientStopped")
	table.dump(event) 
end

return gameLogic
