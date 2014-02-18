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
local overlayImage
local thePlayer

local ignoreJoystick = false

local tileSize = 80/10 * 8
local playerW = 75/10 * 8
local playerH = 50/10 * 8



-- Local Function & Callback Declarations
local createCollisionCalculator
local createLayers
local addInterfaceElements

local createPlayer
local createBlade
local createPath

local onTurnRight
local onTurnLeft
local onForward
local onBack

local leftButton
local rightButton
local forwardButton
local backButton
local enableButtons
local disableButtons
local isOverBlock
local joystickCB

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

	local pathPoints = ssk.points:new( )

	-- Middle Row
	local aBlade = createBlade( centerX + tileSize * 2, centerY,  tileSize )

	--pathPoints:add( centerX + tileSize * 2 , centerY ) 
	pathPoints:add( centerX + tileSize  , centerY ) 
	pathPoints:add( centerX       , centerY ) 
	pathPoints:add( centerX - tileSize  , centerY ) 
	--pathPoints:add( centerX - tileSize * 2 , centerY ) 

	pathPoints:add( centerX + tileSize  , centerY + tileSize ) 
	pathPoints:add( centerX + tileSize * 2 , centerY + tileSize ) 
	pathPoints:add( centerX       , centerY + tileSize ) 
	pathPoints:add( centerX - tileSize  , centerY + tileSize ) 
	pathPoints:add( centerX - tileSize * 2 , centerY + tileSize ) 

	pathPoints:add( centerX + tileSize  , centerY - tileSize ) 
	pathPoints:add( centerX + tileSize * 2 , centerY - tileSize ) 
	pathPoints:add( centerX       , centerY - tileSize ) 
	pathPoints:add( centerX - tileSize  , centerY - tileSize ) 
	pathPoints:add( centerX - tileSize * 2 , centerY - tileSize ) 

	pathPoints:add( centerX + tileSize * 2 , centerY - tileSize * 2 ) 
	--pathPoints:add( centerX + tileSize  , centerY - tileSize * 2 ) 
	--pathPoints:add( centerX       , centerY - tileSize * 2 ) 
	--pathPoints:add( centerX - tileSize  , centerY - tileSize * 2 ) 
	pathPoints:add( centerX - tileSize * 2 , centerY - tileSize * 2 ) 

	pathPoints:add( centerX + tileSize * 2 , centerY + tileSize * 2 ) 
	--pathPoints:add( centerX + tileSize  , centerY + tileSize * 2 ) 
	--pathPoints:add( centerX       , centerY + tileSize * 2 ) 
	--pathPoints:add( centerX - tileSize  , centerY + tileSize * 2 ) 
	pathPoints:add( centerX - tileSize * 2 , centerY + tileSize * 2 ) 

	pathPoints:add( centerX + tileSize  , centerY - tileSize * 3 ) 
	pathPoints:add( centerX + tileSize * 2 , centerY - tileSize * 3 ) 
	pathPoints:add( centerX       , centerY - tileSize * 3 ) 
	pathPoints:add( centerX - tileSize  , centerY - tileSize * 3 ) 
	pathPoints:add( centerX - tileSize * 2 , centerY - tileSize * 3 ) 

	pathPoints:add( centerX + tileSize  , centerY + tileSize * 3 ) 
	pathPoints:add( centerX + tileSize * 2 , centerY + tileSize * 3 ) 
	pathPoints:add( centerX       , centerY + tileSize * 3 ) 
	pathPoints:add( centerX - tileSize  , centerY + tileSize * 3  )
	pathPoints:add( centerX - tileSize * 2 , centerY + tileSize * 3 ) 


--	pathPoints:add( centerX - tileSize  , centerY - tileSize * 2 ) 
--	pathPoints:add( centerX       , centerY - tileSize * 2 ) 
--	pathPoints:add( centerX       , centerY - tileSize ) 
--	pathPoints:add( centerX       , centerY + tileSize ) 

	createPath( centerX, centerY, tileSize, pathPoints )

	thePlayer = createPlayer( centerX, centerY, 40 )
	
	local rotit
	local rotit2
	
	rotit = function ()
		transition.to( aBlade, { rotation = -360, time = 600, onComplete = rotit2 } )
	end
	rotit2 = function ()
		aBlade.rotation  = 0
		rotit()
	end

	rotit()
	

	ssk.gem:add( "myJoystickEvent", joystickCB )

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
	thePath = nil
	backImage = nil
	overlayImage = nil

	-- 2. Clean up gravity and physics debug
	physics.setDrawMode( "normal" )
	physics.setGravity(0,0)
	screenGroup.isVisible=false

--	ssk.gem:remove("myHorizSnapEvent", joystickListener)

	ssk.gem:remove( "myJoystickEvent", joystickCB )
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
		"pathRotator", 
			{ "path" },		
		"characters", 
		"interfaces" )	
end

addInterfaceElements = function()
	-- Add background 
	backImage = ssk.display.backImage( layers.background, "backImage.jpg") 
	overlayImage = ssk.display.backImage( layers.interfaces, "protoOverlay2.png") 

	leftButton = ssk.buttons:presetPush( layers.interfaces, "default", 60, h - 30, 100, 40, "turn left", onTurnLeft )
	forwardButton = ssk.buttons:presetPush( layers.interfaces, "default", centerX-60, h - 30, 100, 40, "forward", onForward )
	backButton = ssk.buttons:presetPush( layers.interfaces, "default", centerX+60, h - 30, 100, 40, "backward", onBack )
	rightButton = ssk.buttons:presetPush( layers.interfaces, "default", w- 60, h - 30, 100, 40, "turn right", onTurnRight )
	
	leftButton.isVisible = false
	forwardButton.isVisible = false
	backButton.isVisible = false
	rightButton.isVisible = false


	ssk.inputs:createJoystick( layers.interfaces, centerX, centerY,							   
	                           { eventName = "myJoystickEvent",  inputObj = backImage,
								 inUseAlpha = 1, notInUseAlpha = 0.05, useAlphaFadeTime = 250,
							     outerStrokeColor = _WHITE_, outerAlpha = 0.5,
							     stickImg = "images/interface/dpad.png", stickRadius = 65 } )


end	

createPlayer = function ( x, y, size )
	--local player  = ssk.display.imageRect( layers.characters, x, y, imagesDir .. "rg/boxman.png",
	local player  = ssk.display.imageRect( layers.path, x, y, imagesDir .. "rg/boxman.png",
		                                   { w=playerW, h=playerH } ) 
	return player
end

createBlade = function ( x, y, size )
	local blade  = ssk.display.imageRect( layers.path, x, y, imagesDir .. "blade.png", { size = size, fill = _RED_ } ) 
	return blade
end

createPath = function ( x, y, size, positions )

	--table.dump(positions)

	local rotBounds = ssk.display.rect( layers.pathRotator, x, y, { size = 10000 } )
	rotBounds.x = centerX
	rotBounds.y = centerY
	rotBounds.alpha = 0

	for i = 1, #positions do
		local x = positions[i].x
		local y = positions[i].y

		local block = ssk.display.imageRect( layers.path, x, y, imagesDir .. "rg/bricks128.png", { size = size } )
	end
end

onTurnRight = function( event )
	local pathRotator = layers.pathRotator

--EFM G2	pathRotator:setReferencePoint( display.CenterReferencePoint )
	transition.to( pathRotator, { rotation = pathRotator.rotation - 90, time = 250 } )
	transition.to( thePlayer, { rotation = thePlayer.rotation + 90, time = 250 } )

	disableButtons()
	timer.performWithDelay( 250, enableButtons )
end

onTurnLeft = function( event )
	local pathRotator = layers.pathRotator
--EFM G2	pathRotator:setReferencePoint( display.CenterReferencePoint )
	transition.to( pathRotator, { rotation = pathRotator.rotation + 90, time = 250 } )
	transition.to( thePlayer, { rotation = thePlayer.rotation - 90, time = 250 } )

	disableButtons()
	timer.performWithDelay( 250, enableButtons )
end

onForward = function( event )
	local pathRotator = layers.pathRotator
	local path = layers.path

	if(pathRotator.rotation < 0 ) then
		pathRotator.rotation = pathRotator.rotation + 360
	elseif(pathRotator.rotation >= 360 ) then
		pathRotator.rotation = pathRotator.rotation - 360
	end

--EFM G2	path:setReferencePoint( display.CenterReferencePoint )

	if(pathRotator.rotation == 0 ) then
		transition.to( path, { y = path.y + tileSize, time = 250 } )
		transition.to( thePlayer, { y = thePlayer.y - tileSize, time = 250 } )
	
	elseif(pathRotator.rotation == 90 ) then
		transition.to( path, { x = path.x + tileSize, time = 250 } )
		transition.to( thePlayer, { x = thePlayer.x - tileSize, time = 250 } )

	elseif(pathRotator.rotation == 180 ) then
		transition.to( path, { y = path.y - tileSize, time = 250 } )
		transition.to( thePlayer, { y = thePlayer.y + tileSize, time = 250 } )

	elseif(pathRotator.rotation == 270 ) then
		transition.to( path, { x = path.x - tileSize, time = 250 } )
		transition.to( thePlayer, { x = thePlayer.x + tileSize, time = 250 } )	
	end	

	local theBlock = path[1]

	print(string.lpad("Player x,y ", 30), layers.characters.x, layers.characters.y )
	print(string.lpad("Path Block x,y ", 30), theBlock.x, theBlock.y )
	print(string.lpad("Path x,y ", 30), path.x, path.y )
	print(string.lpad("Path Rotator x,y ", 30), pathRotator.x, pathRotator.y)
	print("======================" )

	disableButtons()
	timer.performWithDelay( 250, enableButtons )
	timer.performWithDelay( 250, isOverBlock )
end

onBack = function( event )
	local pathRotator = layers.pathRotator
	local path = layers.path

	if(pathRotator.rotation < 0 ) then
		pathRotator.rotation = pathRotator.rotation + 360
	elseif(pathRotator.rotation >= 360 ) then
		pathRotator.rotation = pathRotator.rotation - 360
	end

--EFM G2	path:setReferencePoint( display.CenterReferencePoint )

	if(pathRotator.rotation == 0 ) then
		transition.to( path, { y = path.y - tileSize, time = 250 } )
		transition.to( thePlayer, { y = thePlayer.y + tileSize, time = 250 } )
	
	elseif(pathRotator.rotation == 90 ) then
		transition.to( path, { x = path.x - tileSize, time = 250 } )
		transition.to( thePlayer, { x = thePlayer.x + tileSize, time = 250 } )

	elseif(pathRotator.rotation == 180 ) then
		transition.to( path, { y = path.y + tileSize, time = 250 } )
		transition.to( thePlayer, { y = thePlayer.y - tileSize, time = 250 } )	

	elseif(pathRotator.rotation == 270 ) then
		transition.to( path, { x = path.x + tileSize, time = 250 } )
		transition.to( thePlayer, { x = thePlayer.x - tileSize, time = 250 } )	
	end	

	local theBlock = path[1]

	print(string.lpad("Player x,y ", 30), layers.characters.x, layers.characters.y )
	print(string.lpad("Path Block x,y ", 30), theBlock.x, theBlock.y )
	print(string.lpad("Path x,y ", 30), path.x, path.y )
	print(string.lpad("Path Rotator x,y ", 30), pathRotator.x, pathRotator.y)
	print("======================" )

	disableButtons()
	timer.performWithDelay( 250, enableButtons )
	timer.performWithDelay( 250, isOverBlock )
end


enableButtons = function (event )
	leftButton:enable()
	rightButton:enable()
	forwardButton:enable()
	backButton:enable()
	ignoreJoystick = false
end

disableButtons = function (event )
	leftButton:disable()
	rightButton:disable()
	forwardButton:disable()
	backButton:disable()
	ignoreJoystick = true
end


isOverBlock = function()
	--s math.pointInRect( pointX, pointY, left, top, width, height )
	local numBlocks = layers.path.numChildren-1
	local path = layers.path
	print("Player: ", thePlayer.x, thePlayer.y)
	for i = 1, numBlocks do
		local block = path[i]
		--print("Block: ", block.x, block.y)

		if( math.pointInRect( thePlayer.x, thePlayer.y, block.x - block.width/2, block.y - block.height/2, block.width, block.height) ) then
			print("Over block")

			 block:setFillColor( unpack( _PINK_ ) )
			timer.performWithDelay( 200, function() block:setFillColor( unpack( _WHITE_) ) end)

			return true
		end
	end

	print("Not over block")
	return false
end

local lastMove = "none"
local curMove = "none"
joystickCB = function( event )

	if( ignoreJoystick ) then
		return true
	end

	local angle = event.angle
	if( angle < 0 ) then 
		angle = angle + 360
	elseif( angle >= 360 ) then 
		angle = angle - 360
	end

	curMove = "none"
	if(event.state == "on" and tonumber(event.percent) > 50 ) then
		if(angle >= 315) then
			curMove = "forward"
		elseif(angle >= 225) then
			curMove = "turnleft"
		elseif(angle >= 135) then
			curMove = "backward"
		elseif(angle >= 45) then
			curMove = "turnright"
		else
			curMove = "forward"
		end
	end

	if( curMove ~= "none" and curMove ~= lastMove ) then
		if(curMove == "forward") then
			onForward()
		elseif(curMove == "backward") then
			onBack()
		elseif(curMove == "turnleft") then
			onTurnLeft()
		else
			onTurnRight()
		end

		print("Angle:", angle)
	end
	lastMove = curMove

	return true
end




return gameLogic