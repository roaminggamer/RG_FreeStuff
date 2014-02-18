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

local solvedX
local solvedY

local solvedLabel 

local isSolved = false

-- Local Function & Callback Declarations
local createCollisionCalculator
local createLayers
local addInterfaceElements

local puzzleTable
local currentDragPiece

local createPuzzle
local doDrop
local swizzlePuzzle
local testCompleted



local gameLogic = {}

-- =======================
-- ====================== Initialization
-- =======================
function gameLogic:createScene( screenGroup )

	isSolved = false

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
	createPuzzle()
	swizzlePuzzle()


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

	solvedLabel = ssk.labels:presetLabel( layers.content, "default", "Solved!", w - 160, centerY, { fontSize = 32, textColor = _YELLOW_ } )
	solvedLabel.isVisible = false

end	

createPuzzle = function ( )

	local puzzleWidth = 200
	local puzzleHeight = 200

	local puzzleX = 150
	local puzzleY = centerY

	-- This will be used for dropping pieces later
	-- A piece is in the right position if it has been dropped at solvedX/solvedY (or within 'snapDist' pixels of that point)
	solvedX = puzzleX 
	solvedY = puzzleY 
	
	-- These are the original mask images' width and heights
	local maskWidth = 320 
	local maskHeight = 320

	-- Later we will need to scale the masks (this saves calculations since they are all the same size and thus scaling factor)
	local maskScaleX =  puzzleWidth / maskWidth
	local maskScaleY = puzzleHeight / maskHeight 


	-- ==
	--    #1 Create a 'outline' as a hint of where the puzzle pieces go
	-- ==
	local puzzleOutline = display.newImageRect( layers.content, imagesDir .. "forumHelp/puzzle/clown_grey.png", puzzleWidth, puzzleHeight)
	puzzleOutline.x = puzzleX
	puzzleOutline.y = puzzleY

	-- ==
	--    #2 Now place all off the pieces in the 'solved' positions.
	-- ==
	puzzleTable = {}

	for pieces = 1, 4 do
		
		-- A. Create a piece using the whole image and place it at the 'solved position'
		local piece   = display.newImageRect( layers.content, imagesDir .. "forumHelp/puzzle/clown.png", puzzleWidth, puzzleHeight)
		piece.x = solvedX
		piece.y = solvedY

		piece.lastX = piece.x
		piece.lastY = piece.y

		-- B. Load a mask for the the piece
		local mask = graphics.newMask( imagesDir .. "forumHelp/puzzle/clown_mask" .. pieces .. ".png")
		

		-- C. Apply the mask, positions it, and scale it.
		piece:setMask( mask )

		piece.maskScaleX  = maskScaleX
		piece.maskScaleY  = maskScaleY
			
		function piece:touch( event )
			local target = event.target

			-- Don't allow dragging if solved
			if( isSolved ) then 
				return true 
			end

			if( event.phase == "began" ) then
				target:toFront()
				currentDragPiece = target
				return true

			elseif( event.phase == "moved" and target == currentDragPiece ) then
				currentDragPiece.x = event.x - event.xStart + currentDragPiece.lastX
				currentDragPiece.y = event.y - event.yStart + currentDragPiece.lastY
				return true

			elseif( event.phase == "ended" and  target == currentDragPiece ) then
				doDrop( target, 40 )
				testCompleted()
			end

		end

		piece:addEventListener( "touch", piece )
			
		puzzleTable[pieces] = piece
		
	end


end


swizzlePuzzle = function ( )

	-- This a very horrible way to do this, but easy for just four puzzle pieces and for this
	-- sample.  This is by no means a polished final version or algorithm.

	local newX = { 320, 380, 380, 380}
	local newY = { 120, 280, 80, 180}

	for i = 1, 4 do
		local piece = puzzleTable[ i ]

		piece.x = newX[i]
		piece.y = newY[i]

		piece.lastX = piece.x
		piece.lastY = piece.y

	end

end


doDrop = function ( curPiece, snapDist )

	-- Determine if this piece was dropped close enough to the 'solved' position

	local dx = curPiece.x - solvedX
	local dy = curPiece.y - solvedY
	
	local distance = math.sqrt(dx * dx + dy * dy)
	
	print( "  Drop <x,y> == ", curPiece.x, curPiece.y )
	print( "Solved <x,y> == ", solvedX, solvedY )
	
	print( " Distance between drop <x,y> and solved <x,y> == ", round(distance,2) )

	-- If it was close enought, snap it in place. 
	if( distance <= snapDist ) then
	
		curPiece.x = solvedX
		curPiece.y = solvedY
	
	-- If not, send it back to the position it was in before the drag-n-drop.
	else

		curPiece.x = curPiece.lastX
		curPiece.y = curPiece.lastY

	end

	
	return true
end


testCompleted = function ()

	for i = 1, #puzzleTable do
		local piece = puzzleTable[i]
		if( piece.x ~= solvedX or piece.y ~= solvedY ) then
			return false
		end
	end

	for i = 1, #puzzleTable do
		local piece = puzzleTable[i]
		piece:removeEventListener( "touch", piece.touch )
	end

	solvedLabel.isVisible = true
	isSolved = true

	return true
end

createSky = function ( x, y, width, height  )
	local sky  = ssk.display.imageRect( layers.background, x, y, imagesDir .. "starBack_320_240.png",
		{ w = width, h = height, myName = "theSky" } )
	return sky
end


return gameLogic