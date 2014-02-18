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
end	

createPuzzle = function ( )

	local offsetX = centerX - 106
	local offsetY = centerY - 80 

	puzzleTable = {}

	for x = 1, 3 do
		for y = 1, 3 do
			local piece   = display.newImageRect( layers.content, imagesDir .. "forumHelp/puzzle/puzzleBase_" .. y .. "x" .. x .. ".jpg", 106, 80)
			local outline = display.newRect( layers.content, 0, 0, 106, 80) 

			piece.myOutline = outline

			piece.x = (x - 1) * 106 + offsetX
			piece.y = (y - 1) * 80 + offsetY 

			piece.startX = piece.x
			piece.startY = piece.y

			piece.lastX = piece.x
			piece.lastY = piece.y
			
			outline.x = piece.x
			outline.y = piece.y
			outline:setFillColor(0,0,0,0)
			outline.strokeWidth = 3
			outline:setStrokeColor(255,255,255)

			function piece:touch( event )
				local target = event.target

				if( event.phase == "began" ) then
					target:toFront()
					target.myOutline:toFront()
					currentDragPiece = target
					return true

				elseif( event.phase == "moved" and target == currentDragPiece ) then
					currentDragPiece.x = event.x - event.xStart + currentDragPiece.lastX
					currentDragPiece.y = event.y - event.yStart + currentDragPiece.lastY
					currentDragPiece.myOutline.x = currentDragPiece.x
					currentDragPiece.myOutline.y = currentDragPiece.y
					return true

				elseif( event.phase == "ended" and  target == currentDragPiece ) then
					doDrop( target, 20 )
					testCompleted()
				end

			end

			piece:addEventListener( "touch", piece )
			
			puzzleTable[#puzzleTable+1] = piece
		end
	end
end

doDrop = function ( curPiece, snapDist )

	local snapDistSquared = snapDist * snapDist

	for i = 1, #puzzleTable do
		local piece = puzzleTable[i]

		if(piece ~= curPiece) then

			local dx = piece.x - curPiece.x
			local dy = piece.y - curPiece.y

			local lengthSquared = dx * dx + dy * dy

			print(lengthSquared, snapDistSquared)

			if( lengthSquared <= snapDistSquared ) then
				curPiece.x = piece.x
				curPiece.y = piece.y

				piece.x = curPiece.lastX
				piece.y = curPiece.lastY

				curPiece.lastX = curPiece.x
				curPiece.lastY = curPiece.y

				piece.lastX = piece.x
				piece.lastY = piece.y

				curPiece.myOutline.x = curPiece.x
				curPiece.myOutline.y = curPiece.y

				piece.myOutline.x = piece.x
				piece.myOutline.y = piece.y

				return true
			end

		end
	end

	curPiece.x = curPiece.lastX
	curPiece.y = curPiece.lastY

	curPiece.myOutline.x = curPiece.x
	curPiece.myOutline.y = curPiece.y

end


swizzlePuzzle = function ( )

	for i = 1, 100 do
		local pieceA = puzzleTable[ math.random(1, #puzzleTable) ]
		local pieceB = puzzleTable[ math.random(1, #puzzleTable) ]

		if(pieceB ~= pieceA) then

			pieceA.x = pieceB.x
			pieceA.y = pieceB.y

			pieceB.x = pieceA.lastX
			pieceB.y = pieceA.lastY

			pieceA.lastX = pieceA.x
			pieceA.lastY = pieceA.y

			pieceB.lastX = pieceB.x
			pieceB.lastY = pieceB.y

			pieceA.myOutline.x = pieceA.x
			pieceA.myOutline.y = pieceA.y

			pieceB.myOutline.x = pieceB.x
			pieceB.myOutline.y = pieceB.y

		end
	end

end

testCompleted = function ()

	for i = 1, #puzzleTable do
		local piece = puzzleTable[i]
		if( piece.x ~= piece.startX or piece.y ~= piece.startY ) then
			return false
		end
	end

	for i = 1, #puzzleTable do
		local piece = puzzleTable[i]
		piece.myOutline.isVisible = false
		piece:removeEventListener( "touch", piece.touch )
	end

	return true
end

createSky = function ( x, y, width, height  )
	local sky  = ssk.display.imageRect( layers.background, x, y, imagesDir .. "starBack_320_240.png",
		{ w = width, h = height, myName = "theSky" } )
	return sky
end


return gameLogic