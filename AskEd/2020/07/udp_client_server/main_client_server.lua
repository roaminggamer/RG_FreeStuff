io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
-- =====================================================
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
--ssk.easyIFC.generateButtonPresets( nil, true )
-- =====================================================

-- =============================================================
-- Localizations
-- =============================================================
-- Commonly used Lua & Corona Functions
local getTimer = system.getTimer; local mRand = math.random
local mAbs = math.abs; local mFloor = math.floor; local mCeil = math.ceil
local strGSub = string.gsub; local strSub = string.sub
-- Common SSK Features
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers
local easyIFC = ssk.easyIFC;local persist = ssk.persist
local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
local normRot = math.normRot;local easyAlert = ssk.misc.easyAlert
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale
local RGTiled = ssk.tiled; local files = ssk.files
local factoryMgr = ssk.factoryMgr; local soundMgr = ssk.soundMgr
--if( ssk.misc.countLocals ) then ssk.misc.countLocals(1) end

-- == Uncomment following lines if you need  physics
--local physics = require "physics"
--physics.start()
--physics.setGravity(0,10)
--physics.setDrawMode("hybrid")

-- == Uncomment following line if you need widget library
--local widget = require "widget"
-- =====================================================
-- =====================================================
local back = newImageRect( nil, centerX, centerY, "protoBackX.png", 
									{ w = 720,  h = 1386, rotation = fullw>fullh and 90 } )

local p2p = require "scripts.p2p"

local buttonGroup = display.newGroup()

local function onServer()
	display.remove( buttonGroup )
	buttonGroup = nil
	--
	local server = require "scripts.UDPServer"
	server:start()

	--[[
	--
	local function onSend()
		client.sendMsg( "Message from peer @ " .. system.getTimer() )
	end
	easyIFC:presetPush( buttonGroup, "default", centerX, bottom - 150, 300, 40, "Send Msg To Peer", onSend )
	--
	local msg = display.newText( "", centerX, centerY + 50 )
	local msg2 = display.newText( "", centerX, centerY + 120 )
	local function onMsg( event )
		msg.text = event.msg
		msg2.text = "Received @ " .. system.getTimer()
	end; listen("onMsg", onMsg)
	--]]
end

local function onClient()
	display.remove( buttonGroup )
	buttonGroup = nil
	--
	local client = require "scripts.UDPClient"
	local ip,port = client.getIP()
	client:setAddress( ip )
	client:autoConnect()
	----[[
	--
	local function onSend()
		client:send( "yo", {} )
		--client.sendMsg( "Message from peer @ " .. system.getTimer() )
	end
	easyIFC:presetPush( buttonGroup, "default", centerX, bottom - 150, 300, 40, "Send Msg To Peer", onSend )
	--
	local msg = display.newText( "", centerX, centerY + 50 )
	local msg2 = display.newText( "", centerX, centerY + 120 )
	local function onMsg( event )
		msg.text = event.msg
		msg2.text = "Received @ " .. system.getTimer()
	end; listen("onMsg", onMsg)
	--]]
end


easyIFC:presetPush( buttonGroup, "default", centerX, bottom - 150, 200, 40, "INITIATE SERVER", onServer )
easyIFC:presetPush( buttonGroup, "default", centerX, bottom - 100, 200, 40, "INITIATE CLIENT", onClient )

