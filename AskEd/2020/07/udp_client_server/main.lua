io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
--[[
-- =====================================================
-- =====================================================
!!WARNING!! ** THIS EXAMPLE USES SSK BELOW ** !!WARNING!!
!!WARNING!! ** THIS EXAMPLE USES SSK BELOW ** !!WARNING!!
!!WARNING!! ** THIS EXAMPLE USES SSK BELOW ** !!WARNING!!
-- =====================================================
-- =====================================================
--]]

--
-- Require and initialize SSK
--
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )

--
-- Create group to hold 'initiation' buttons buttons
--
local buttonGroup = display.newGroup()

--
-- Listener For 'Initiate Server' button
--
local function onServer()
	-- Destroy group containing 'initiate' buttons
	display.remove( buttonGroup )
	buttonGroup = nil
	
	-- Require Server Module
	local server = require "scripts.UDPServer"
	server:start()

	-- Listener for 'send' button
	local function onSend()
		server:msgClients( "say", { body = "Hello from server" } )
	end

	-- Create 'send' button
	ssk.easyIFC:presetPush( buttonGroup, "default", centerX, bottom - 150, 300, 40, "Send Msg To Peer", onSend )
	
	-- Labels for 'received messages'
	local msg = display.newText( "", centerX, centerY + 50 )
	local msg2 = display.newText( "", centerX, centerY + 120 )

	-- Listener for messages received from server
	local function CLIENT_MSG( event )
		table.dump(event)
		msg.text = event.msg.body
		msg2.text = "Received @ " .. system.getTimer()
	end; listen("CLIENT_MSG", CLIENT_MSG)
end

--
-- Listener For 'Initiate Client' button
--
local function onClient()
	-- Destroy group containing 'initiate' buttons
	display.remove( buttonGroup )
	buttonGroup = nil
	
	-- Require Client Module
	local client = require "scripts.UDPClient"

	-- Initialize Client and start 'auto-connect' loop
	--local ip,port = client.getIP()
	--client:setAddress( ip )
	client:setAddress( "localhost" )
	client:autoConnect()


	-- Listener for 'send' button
	local function onSend()
		client:send( "say", { body = "Hello from client" } )
	end

	-- Create 'send' button
	ssk.easyIFC:presetPush( buttonGroup, "default", centerX, bottom - 150, 300, 40, "Send Msg To Peer", onSend )
	
	-- Labels for 'received messages'
	local msg = display.newText( "", centerX, centerY + 50 )
	local msg2 = display.newText( "", centerX, centerY + 120 )

	-- Listener for messages received from server
	local function SERVER_MSG( event )
		msg.text = event.msg.body
		msg2.text = "Received @ " .. system.getTimer()
	end; listen("SERVER_MSG", SERVER_MSG)
end


--
-- Create two buttons allowing user to 'initiate' either server or client on this instance.
--
ssk.easyIFC:presetPush( buttonGroup, "default", centerX, bottom - 150, 200, 40, "INITIATE SERVER", onServer )
ssk.easyIFC:presetPush( buttonGroup, "default", centerX, bottom - 100, 200, 40, "INITIATE CLIENT", onClient )

