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
local theGrid

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

local touchCallback
local createTouchGrid
local createLegend

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
	
	-- 5. Add demo/sample content
	theGrid = createTouchGrid( layers.content, centerX, centerY+20, 1400, 120, 30 )
	createLegend(layers.content, centerX, 70, 30)

end

-- =======================
-- ====================== Cleanup
-- =======================
function gameLogic:destroyScene( screenGroup )
	-- 1. Clear all references to objects we (may have) created in 'createScene()'	
	layers:destroy()
	layers = nil
	myCC = nil
	theGrid = nil

	-- 2. Clean up gravity and physics debug
	physics.setDrawMode( "normal" )
	physics.setGravity(0,0)
	screenGroup.isVisible=false

--	ssk.gem:remove("myHorizSnapEvent", joystickListener)
end


-- =======================
-- ====================== Local Function & Callback Definitions
-- =======================
createCollisionCalculator = function()
	myCC = ssk.ccmgr:newCalculator()
	myCC:addName("player")
	myCC:addName("wrapTrigger")
	myCC:collidesWith("player", "wrapTrigger")
	myCC:dump()
end


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


touchCallback = function( self, event )

	local phase = event.phase
	local target = event.target
	local currentStage = display.getCurrentStage()
	local lastTarget = currentStage.lastTarget

	if(lastTarget and lastTarget ~= target) then
		event.target = lastTarget
		event.phase = "ended"
		currentStage.lastTarget = nil
		lastTarget:touch( event )
	end

	print(phase, target)
	if( phase == "began" ) then
		self:setFillColor( unpack( _BLUE_ ) )
		currentStage.lastTarget = target
		return true

	elseif( phase == "moved" ) then
		self:setFillColor( unpack( _GREEN_ ) )
		currentStage.lastTarget = target
		return true

	elseif( phase == "ended" ) then
		self:setFillColor( unpack( _RED_ ) )
		return true
		
	elseif( phase == "cancelled" ) then
		self:setFillColor( unpack( _BLACK_ ) )
		currentStage.lastTarget = nil
		return true

	else
		self:setFillColor( unpack( _ORANGE_ ) )
		return true
	end
end

createTouchGrid = function ( parentGroup, x, y, width, height, blockSize )
	local gridGroup = display.newGroup()
	parentGroup:insert( gridGroup )

	local i,j = 0,0
	while(i < width) do
		j = 0
		while(j < height) do
			local block = display.newRect(gridGroup, i,j,blockSize,blockSize)
			block:setFillColor( unpack( _DARKGREY_ ) )
			block:setStrokeColor( unpack( _WHITE_ ) )
			block.strokeWidth = 1

			block.touch = touchCallback
			block:addEventListener( "touch", block )

			j = j + blockSize
		end
		i = i + blockSize
	end

	gridGroup:setReferencePoint(display.CenterReferencePoint)
	gridGroup.x,gridGroup.y = x,y

	return gridGroup
end

createLegend = function( parentGroup, x, y, blockSize ) 
	local legendGroup = display.newGroup()
	parentGroup:insert( legendGroup )

	local eventNames = { "began", "moved", "ended", "cancelled", "other" }
	local eventColors = { _BLUE_, _GREEN_, _RED_, _BLACK_, _ORANGE_ }

	for i = 1, #eventNames do
		local block = display.newRect(legendGroup, (i-1) * blockSize * 2.5, 0 ,blockSize,blockSize)
		block:setFillColor( unpack( eventColors[i] ) )
		block:setStrokeColor( unpack( _WHITE_ ) )
		block.strokeWidth = 1

		local text = display.newText(legendGroup, eventNames[i], 0, 0, native.systemFont, 14)
		text:setReferencePoint(display.CenterReferencePoint)
		text.x = (i-1) * blockSize * 2.5 + text.width/2
		text.y = blockSize + 15

	end


	legendGroup:setReferencePoint(display.CenterReferencePoint)
	legendGroup.x,legendGroup.y = x,y
	

	return legendGroup
end

createSky = function ( x, y, width, height  )
	local sky  = ssk.display.imageRect( layers.background, x, y, imagesDir .. "starBack_320_240.png",
		{ w = width, h = height, myName = "theSky" } )
	return sky
end


return gameLogic