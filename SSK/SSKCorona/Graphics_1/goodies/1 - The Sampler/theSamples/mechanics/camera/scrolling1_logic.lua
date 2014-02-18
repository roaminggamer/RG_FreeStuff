-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- Multi-layer parallax background scrolling
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
local overlayImage 
local backImage
local thePlayer

-- Fake Screen Parameters (used to create visually uniform demos)
local screenWidth  = 320 -- smaller than actual to allow for overlay/frame
local screenHeight = 240 -- smaller than actual to allow for overlay/frame
local screenLeft   = centerX - screenWidth/2
local screenRight  = centerX + screenWidth/2
local screenTop    = centerY - screenHeight/2
local screenBot    = centerY + screenHeight/2

-- Image Paths
local groundImagePath = imagesDir .. "Lost Garden/PlanetCute/Grass Block.png"
local starImagePath   = imagesDir .. "Lost Garden/PlanetCute/Star.png"
local skyImagePath    = imagesDir .. "Lost Garden/SpaceCute/background.png"

local randomObjectImagePath = {}
randomObjectImagePath[1] = imagesDir .. "Lost Garden/PlanetCute/Tree Short.png"
randomObjectImagePath[2] = imagesDir .. "Lost Garden/PlanetCute/Tree Tall.png"
randomObjectImagePath[3] = imagesDir .. "Lost Garden/PlanetCute/Tree Ugly.png"
randomObjectImagePath[4] = imagesDir .. "Lost Garden/PlanetCute/Rock.png"

-- Local Function & Callback Declarations
local createCollisionCalculator
local createLayers
local addInterfaceElements

local createGroundBlock
local createRandomObject
local createSky
local createStar
local createTrigger

local triggerCallback

local onShowHide


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
	-- Create Spawner Trigger
	createTrigger( layers.content, screenRight + 20, centerY, 20, screenHeight, "theSpawner"  )

	-- Create Destroyer Trigger
	createTrigger( layers.content, screenLeft - 10, centerY, 20, screenHeight, "theDestroyer"  )

	-- Create Ground Blocks (nearest layer)
	for i = 1, 9 do
		createGroundBlock( screenLeft - 20 + i * 40, centerY + screenHeight/2 - 35, 
		                             layers.scroll1, -50 )	 
	end

	-- Create Tree/Rock Layer (mid layer)
	createRandomObject( screenLeft + 55,  screenBot - 80, layers.scroll2, -15, 4 )
	createRandomObject( screenLeft + 25,  screenBot - 80, layers.scroll2, -15, 2 )
	createRandomObject( screenLeft + 85,  screenBot - 80, layers.scroll2, -15, 1 )
	createRandomObject( screenLeft + 160, screenBot - 80, layers.scroll2, -15, 4 )
	createRandomObject( screenLeft + 200, screenBot - 80, layers.scroll2, -15, 3 )
	createRandomObject( screenLeft + 240, screenBot - 80, layers.scroll2, -15, 3 )
	createRandomObject( screenLeft + 320, screenBot - 80, layers.scroll2, -15, 4 )

	-- Create Star Layer (back layer)
	local starX = screenLeft + 20
	local starY = screenTop + math.random( 25, screenHeight - 150)
	createStar( starX, starY, layers.scroll3, -5 )

	for i = 1, 5 do
		starX = starX + math.random(65, 75)
		starY = screenTop + math.random( 25, screenHeight - 150)
		createStar( starX, starY, layers.scroll3, -5 )
	end

	-- Create Sky Background
	local theSky = createSky(centerX, centerY, 320, 240, layers.skylayer)
	theSky:toBack()

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
end

-- =======================
-- ====================== Local Function & Callback Definitions
-- =======================
createCollisionCalculator = function()
	myCC = ssk.ccmgr:newCalculator()
	myCC:addName("ground")
	myCC:addName("other")
	myCC:addName("trigger")
	myCC:collidesWith("trigger", "ground", "other" )
	myCC:dump()
end

createLayers = function( group )
	layers = ssk.display.quickLayers( group, 
		"background",
		"skylayer", 
		"scrollers", 
			{ "scroll3", "scroll2", "scroll1" },
		"content",
		"interfaces" )
end

addInterfaceElements = function()
	-- Add background and overlay
	
	backImage = ssk.display.backImage( layers.background, "protoBack.png")
	overlayImage = ssk.display.backImage( layers.interfaces, "protoOverlay.png") 
	overlayImage.isVisible = true

	-- Add the show/hide button for 'unveiling' hidden parts of scene/mechanics
	ssk.buttons:presetPush( layers.interfaces, "blueGradient", 64, 20 , 120, 30, "Show Details", onShowHide )
end	


createGroundBlock = function ( x, y, scrollLayer, scrollSpeed )
	local collisionShape = { -20, -14, 
	                          20, -14, 
							  20,  35, 
							 -20,  35 }

	local block  = ssk.display.imageRect( scrollLayer, x, y, groundImagePath,
		{ w = 40, h = 70, myName = "aGroundBlock" },
		{ bodyType = "kinematic", shape = collisionShape, colliderName = "ground", calculator= myCC, friction = 0.0, bounce = 0.0  } )

	block:setLinearVelocity( scrollSpeed, 0)
	return block
end

createRandomObject = function ( x, y, scrollLayer, scrollSpeed, imageNum )
	if(scrollLayer == nil) then return end			
	local obj  = ssk.display.imageRect( scrollLayer, x, y, randomObjectImagePath[imageNum],
		{ w = 50, h = 85, myName = "aRandomObject" },
		{ bodyType = "kinematic",  colliderName = "other", calculator= myCC, friction = 0.0, bounce = 0.0  } )

	obj:setLinearVelocity( scrollSpeed, 0)

	return obj
end

createSky = function ( x, y, width, height, contentLayer  )
	local sky  = ssk.display.imageRect( contentLayer, x, y, skyImagePath,
		{ w = width, h = height, myName = "theSky" } )
	return sky
end


createStar = function ( x, y, scrollLayer, scrollSpeed )
	local obj  = ssk.display.imageRect( scrollLayer, x, y, starImagePath,
		{ w = 50, h = 85, myName = "aStar" },
		{ bodyType = "kinematic",  colliderName = "other", calculator= myCC, friction = 0.0, bounce = 0.0  } )

	obj:setLinearVelocity( scrollSpeed, 0)
	return obj
end

createTrigger = function ( contentLayer, x, y, width, height, myName  )

	local fill = _GREEN_

	if(myName == "theDestroyer") then
		fill = _RED_
	end

	local aTrigger  = ssk.display.rect( contentLayer, x, y,
		{ fill = fill, w = width, h = height, myName = myName },
		{ isSensor=true, colliderName = "trigger", calculator= myCC  }, 
		{ 
			{"onCollisionEnded_ExecuteCallback", { callback = triggerCallback } },
		} )

	aTrigger.alpha = 0.3
	return aTrigger
end

triggerCallback = function( theTrigger, theCollider )
	local triggerName  = theTrigger.myName
	local colliderName = theCollider.myName

	dprint(2, triggerName,colliderName)

	if(triggerName == "theSpawner" and colliderName == "aGroundBlock") then
		local vx,vy  = theCollider:getLinearVelocity()
		local width  = theCollider.width
		local height = theCollider.height


		-- Note: By attaching the timer listener to 'theCollider', we 
		-- get a free event cancellation if 'theCollider' is removed/
		-- destroyed before the lister executes.
		theCollider.timer = function(self,event)
			if(not self.x) then return end 
			createGroundBlock( self.x + width, self.y, self.parent, vx ) 
		end
		timer.performWithDelay( 0, theCollider )

	elseif(triggerName == "theDestroyer" and colliderName == "aGroundBlock") then
		theCollider:removeSelf()
	
	elseif(triggerName == "theDestroyer" and colliderName == "aRandomObject") then
		local vx,vy  = theCollider:getLinearVelocity()

		-- Note: By attaching the timer listener to 'theCollider', we 
		-- get a free event cancellation if 'theCollider' is removed/
		-- destroyed before the lister executes.
		theCollider.timer = function(self,event)
			if(not self.x) then return end 
			createRandomObject( self.x + screenWidth + 100, self.y, self.parent, vx, math.random(1,4)) 
			self:removeSelf()
		end
		timer.performWithDelay( 0, theCollider )

	elseif(triggerName == "theDestroyer" and colliderName == "aStar") then
		local vx,vy  = theCollider:getLinearVelocity()

		-- Note: By attaching the timer listener to 'theCollider', we 
		-- get a free event cancellation if 'theCollider' is removed/
		-- destroyed before the lister executes.
		theCollider.timer = function(self,event)
			if(not self.x) then return end 
			local starY = screenTop + math.random( 25, screenHeight - 150)
			createStar( self.x + screenWidth + 100, starY, self.parent, vx)
			self:removeSelf()
		end
		timer.performWithDelay( 0, theCollider )
	end

end

onShowHide = function ( event )
	local target = event.target
	if(event.target:getText() == "Hide Details") then
		overlayImage.isVisible = true
		event.target:setText( "Show Details" )
	else
		overlayImage.isVisible = false
		event.target:setText( "Hide Details" )
	end	
end




return gameLogic