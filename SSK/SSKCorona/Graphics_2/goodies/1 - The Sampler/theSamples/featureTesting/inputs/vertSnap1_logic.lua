-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- Normal Vertical Snap Input Test
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
local layers -- Local reference to display layers 
local backImage

local labelNames = {"vx", "vy", "nx", "ny", "percent", "phase", "state", "angle", "direction" }

-- Fake Screen Parameters (used to create visually uniform demos)
local screenWidth  = w
local screenHeight = h
local screenLeft   = centerX - screenWidth/2
local screenRight  = centerX + screenWidth/2
local screenTop    = centerY - screenHeight/2
local screenBot    = centerY + screenHeight/2

-- Local Function & Callback Declarations
local createLayers
local addInterfaceElements

local vertSnapListener

local gameLogic = {}

-- =======================
-- ====================== Initialization
-- =======================
function gameLogic:createScene( screenGroup )

	-- 1. Set up any rendering layers we need
	createLayers( screenGroup )

	-- 2. Add Interface Elements to this demo (buttons, etc.)
	addInterfaceElements()

	-- 3. Set up gravity and physics debug (if wanted)
	physics.setGravity(0,0)
	--physics.setDrawMode( "hybrid" )
	screenGroup.isVisible=true
	
	-- 4. Add demo/sample content
	-- Static Labels
	local curX = screenLeft + 120
	local curY = screenTop + 30

--EFM G2	local extraParams = { referencePoint = display.CenterRightReferencePoint, fontSize = 24, color = _WHITE_ }
	local extraParams = { fontSize = 24, color = _WHITE_ }

	for k,v in ipairs( labelNames ) do
		local tmp = ssk.labels:presetLabel( layers.interfaces, "default", v ..":", curX , curY, extraParams )
		curY = curY + 30
	end

	-- Dynamic Labels
	curX = screenLeft + 140
	curY = screenTop + 30
--EFM G2	extraParams = { referencePoint = display.CenterLeftReferencePoint, fontSize = 24, color = _WHITE_ }
	extraParams = { fontSize = 24, color = _WHITE_ }

	for k,v in ipairs( labelNames ) do
		gameLogic[v] = ssk.labels:presetLabel( layers.interfaces, "default", "-", curX , curY, extraParams )
		gameLogic[v].origX = curX
		curY = curY + 30
	end

	ssk.gem:add("myVertSnapEvent", vertSnapListener)

	ssk.inputs:createVerticalSnap( centerX+140, centerY, 40, 140, 20, 10, "myVertSnapEvent", screenGroup )
end

-- =======================
-- ====================== Cleanup
-- =======================
function gameLogic:destroyScene( screenGroup )
	-- 1. Clear all references to objects we (may have) created in 'createScene()'	
	layers:destroy()
	layers = nil
	
	-- 2. Clean up gravity and physics debug
	physics.setDrawMode( "normal" )
	physics.setGravity(0,0)
	screenGroup.isVisible=false

	ssk.gem:remove("myVertSnapEvent", vertSnapListener)
end


-- =======================
-- ====================== Local Function & Callback Definitions
-- =======================

createLayers = function( group )
	layers = ssk.display.quickLayers( group, 
		"background", 
		"content",
		"interfaces" )
end

addInterfaceElements = function()
	-- Add background 
	backImage = ssk.display.backImage( layers.background, "starBack_380_570.png") 
end	


vertSnapListener = function( event )
	for k,v in ipairs( labelNames ) do
		gameLogic[v]:setText(event[v] or "-")
--EFM G2		gameLogic[v]:setReferencePoint(display.CenterLeftReferencePoint)
		gameLogic[v].x = gameLogic[v].origX
	end
end

return gameLogic