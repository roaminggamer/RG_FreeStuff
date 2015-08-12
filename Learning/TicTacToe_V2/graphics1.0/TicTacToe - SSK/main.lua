-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2012 
-- =============================================================
-- main.lua
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
-- =============================================================

----------------------------------------------------------------------
--	1. Requires
----------------------------------------------------------------------
require( "ssk.globals" )
require( "ssk.loadSSK" )
local soundsInit = require("ssk.presets.sounds")
local labelsInit = require("ssk.presets.labels")
local buttonsInit = require("ssk.presets.buttons")

----------------------------------------------------------------------
--	2. Initialization
----------------------------------------------------------------------
io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

----------------------------------------------------------------------
-- 3. Declarations
----------------------------------------------------------------------

-- Locals
local layers                 -- A collection of display groups used to visually order rendering
local currentTurn    = "boy"   -- String variable used to track whose turn it is.  X always starts.
local theBoardData   = {}    -- Table used to store the status (“”, “X”, or “O”)  the board rows and columns.
local theBoardPieces = {}    -- Table use store references to the board pieces.
local gameIsRunning  = true  -- Boolean variable used to track whether game is running or over.

-- Labels & Buttons
local currentTurnMsg         -- Empty variable that will be used to store the handle to a text object 
                             -- representing the “whose turn” marker.

local currentTurnMarker      -- Empty variable that will be used to store the handle to a text object 
                             -- representing the “whose turn” marker image.

local gameStatusMsg          -- Empty variable that will be used to store the handle to a text object 
                             -- representing the game status message.

local gameStatusMarker       -- Empty variable that will be used to store the handle to a text object 
                             -- representing the game status marker image.

local resetGameButton        -- Empty variable that will be used to store the handle to a rectangle 
                             -- object that will be used as the game reset button.
							  
-- Function Declarations
local initBoardData         -- Function to initialize the board data (theBoardData).

local createLayers          -- Function to create rendering layers mechanism

local drawBoard             -- Function to draw the game board.

local checkForWinner        -- Function to check the board data (theBoardData) grid for a winner.
local boardIsFull           -- Function to check if board is completely full (no blank spaces).  Used for stalemate testing.

-- Listener Declarations
local onTouchPiece          -- Listener to handle touches on board pieces.
local onTouchResetButton    -- Listener to handle touches on the reset button (resetGameButton).

----------------------------------------------------------------------
-- 4. Definitions
----------------------------------------------------------------------

--==
-- ================================= FUNCTION DEFINITIONS
--==

-- ==
--    initBoardData() - Creates an table containing three empty tables, representing columns 
--                      on the board.
-- ==
initBoardData = function()
	theBoardData = {}
	for i = 1, 3 do
		theBoardData[i] = { "", "", "" } 
	end
end

-- ==
--    createLayers() - Creates and sorts rendering layers.
-- ==
createLayers = function( )
	layers = ssk.display.quickLayers( display.currentStage, 
		"background",  -- Bottom
		"tiles",       -- Middle
		"interfaces" ) -- Top
end

-- ==
--    drawBoard() - Draws the tic-tac-toe grid, some labels, and a button.
-- ==
drawBoard = function()

	local pieceSize = 65 -- Width and height of pieces
	local startX    = centerX - pieceSize  -- Column 1 starts once-piece width left of center
	local startY    = centerY - pieceSize  -- Row 1 starts once-piece height above center

	local imagePaths = {}
	imagePaths["blank"]       = imagesDir .. "blanktile.png"
	imagePaths["boy"]         = imagesDir .. "boytile.png"
	imagePaths["girl"]        = imagesDir .. "girltile.png"
	imagePaths["boyMarker"]   = imagesDir .. "boymarker.png"
	imagePaths["girlMarker"]  = imagesDir .. "girlmarker.png"

	local params = 	{
		w = 65, 
		h = 65,
		onBegan = nil,
		onMoved = nil,
		onEnded = onTouchPiece,
		dragEnabled = false,
		baseEn = false,
		imagePaths = imagePaths,
	}

	--
	-- 1. Draw the board (3-by-3 grid of text objects over rectangles).
	--
	for col = 1, 3 do
		local x = startX + (col - 1) * pieceSize
		
		for row = 1, 3 do
			local y = startY + (row - 1) * pieceSize

			-- 
			-- A. Create the rectangle first (so it is displayed on the bottom)
			--
			local boardPiece = ssk.gamepiece:new( layers.tiles, x, y, params )
			boardPiece:showImage("blank")

			-- Tell the grid piece its row/column location.
			-- This is used later in the touch listener to allow us to mark the right entry in our data table.
			boardPiece.row = row
			boardPiece.col = col

			-- Add a "touch" listener to the grid piece (rectangle object). 
			--boardPiece:addEventListener( "touch", onTouchPiece )

			-- Store this boardPiece in our generic table of pieces
			theBoardPieces[#theBoardPieces + 1] = boardPiece
		end
	end		
	
	--
	-- 2. Add a current turn marker (text object).
	--
	currentTurnMsg = display.newText( layers.interfaces, "Current Turn: " , 0, 0, native.systemFont, 24 )
	currentTurnMsg.x = centerX - 30
	currentTurnMsg.y = centerY - 2 * pieceSize

	currentTurnMarker = ssk.gamepiece:new( layers.interfaces, 
	                                       currentTurnMsg.x + currentTurnMsg.contentWidth/2 + 30, 
										   currentTurnMsg.y, params )
	currentTurnMarker:showImage(currentTurn .. "Marker")

	--
	-- 3. Add a winner indicator (text object).
	--
	gameStatusMsg = display.newText( layers.interfaces, "No winner yet..." , 0, 0, native.systemFont, 24 )
	gameStatusMsg.x = centerX
	gameStatusMsg.y = centerY + 2 * pieceSize -- Spaced two piece heights below center.

	gameStatusMarker = ssk.gamepiece:new( layers.interfaces, 
	                                      gameStatusMsg.x - 45, 
										  gameStatusMsg.y, params )


	--
	-- 4. Add an SSK button to reset the game.
	--

	local params = 
	{ 
		unselImgSrc  = imagesDir .. "buttonBack.png",
		selImgSrc    = imagesDir .. "buttonBack.png",
		x            = centerX,
		y            = centerY - 2 * pieceSize,
		onRelease    = onTouchResetButton,
		w            = 65 * 3,
		h            = 40,
		text         = "Reset Game",
		textColor    = _BLACK_,
		fontSize     = 28,
		emboss       = true,
		touchOffset  = { 1, 2 },
	}

	resetGameButton = ssk.buttons:new( layers.interfaces, params )

	-- Hide the button for now.
	resetGameButton.isVisible = false

	--
	-- 5. Add an image for the background
	--
	ssk.display.backImage( layers.background, "backImage.png") 
		
end

-- Naive/Brute Force way to testing for a winner.
-- ==
--    checkForWinner() - This function checks to see if either "boy" or "girl" has won the game.
--                       It does this using a naive/brute force approach. i.e. It explicitly checks
--                       each win cases.  This is OK for a 3-by-3 grid, but if the game and board
--                       used more grids, we would need to come up with an algorithmic check.
--
--  Tip: See MAGS #2: 4-in-a-row for an example of algorithmic win testing for grid based games.
-- ==
checkForWinner = function( marker )

	local bd = theBoardData

	if(bd[1][1] == marker and  bd[1][2] == marker and bd[1][3] == marker) then -- COL 1
		return true
	
	elseif(bd[2][1] == marker and  bd[2][2] == marker and bd[2][3] == marker) then -- COL 2
		return true
	
	elseif(bd[3][1] == marker and  bd[3][2] == marker and bd[3][3] == marker) then -- COL 3
		return true

	elseif(bd[1][1] == marker and  bd[2][1] == marker and bd[3][1] == marker) then -- ROW 1
		return true
	
	elseif(bd[1][2] == marker and  bd[2][2] == marker and bd[3][2] == marker) then -- ROW 2
		return true
	
	elseif(bd[1][3] == marker and  bd[2][3] == marker and bd[3][3] == marker) then -- ROW 3
		return true

	elseif(bd[1][1] == marker and  bd[2][2] == marker and bd[3][3] == marker) then -- DIAGONAL 1 (top-to-bottom)
		return true

	elseif(bd[1][3] == marker and  bd[2][2] == marker and bd[3][1] == marker) then -- DIAGONAL 2 (bottom-to-top)
		return true
	
	end 

	return false
end

-- Naive/Brute Force way to testing for a winner.
-- ==
--    boardIsFull() - Checks to see if all grids are marked.  Returns false if one or more grids are blank.
-- ==
boardIsFull = function( )

	local bd = theBoardData

	for i = 1, 3 do
		for j = 1, 3 do
			-- Grid entry is empty if it is not marked with an X or an O
			if(bd[i][j] ~= "boy" and bd[i][j] ~= "girl") then 
				return false 
			end
		end
	end

	return true
end


--==
-- ================================= LISTENER DEFINITIONS
--==

-- ==
--    onTouchPiece() - Touch listener function.  
-- ==
onTouchPiece = function( target )

	-- If the game is over, then ignore this touch
	if( not gameIsRunning ) then
		return true
	end
		
	-- Is the marker for this piece empty?
	-- Tip: Remember, when we created the board piece, we added a reference to the text object
	--      to our rectangle.  That allowed us to use the rectangle as the touch object, and 
	--      yet still know the proper text object to check.
	-- 
	print(theBoardData[target.col][target.row])
	table.print_r(theBoardData[target.col][target.row])
	if( theBoardData[target.col][target.row] == "" ) then

		-- The maker was empty, so set it to "boy" or "girl" (whoever's turn it is now).
		target:showImage(currentTurn)

		-- Don't forget to mark the data table too.
		theBoardData[target.col][target.row] = currentTurn

		-- Now that we've updated the data table, check to see if we have a winner
		-- or a stalemate (no winner with full board).
		if( checkForWinner( currentTurn ) ) then

			-- We have a winner.  Update the message, set the game as 'over', and
			-- reveal the reset button and its label.
			--
			gameStatusMarker.isVisible = true
			gameStatusMarker:showImage(currentTurn .. "Marker")
			gameStatusMsg.text =  "    wins!"
			currentTurnMsg.isVisible = false
			currentTurnMarker.isVisible = false
			resetGameButton.isVisible = true
			gameIsRunning = false

		elseif( boardIsFull() ) then
			-- We have a stalemate.  Update the message, set the game as 'over', and
			-- reveal the reset button and its label.
			--
			gameStatusMarker.isVisible = false
			gameStatusMsg.text = "Stalemate!"
			currentTurnMsg.isVisible = false
			currentTurnMarker.isVisible = false
			resetGameButton.isVisible = true
			gameIsRunning = false
		end

		-- Lastly, swap turns, and update the marker specifying whose turn it is.
		if(currentTurn == "boy") then
			currentTurn = "girl"
		else
			currentTurn = "boy"
		end

		currentTurnMarker:showImage(currentTurn .. "Marker")

	end

	return true
end

-- ==
--    onTouchResetButton() - Touch handler function for the reset button.
-- ==
onTouchResetButton = function( event )
	local phase  = event.phase
	local target = event.target

	-- Reset the board markers and board data. i.e. Clear them.
	for k,v in ipairs( theBoardPieces ) do

		-- Set the marker to blank tile image.
		v:showImage("blank")

		-- Clear the board data for this piece
		theBoardData[v.col][v.row] = ""
	end

	-- Reset the current turn to "boy"
	currentTurn = "boy"

	-- Reset the messages to their initial values.
	currentTurnMsg.text = "Current Turn:"
	currentTurnMsg.isVisible = true
	currentTurnMarker:showImage(currentTurn .. "Marker")
	currentTurnMarker.isVisible = true
	
	gameStatusMarker.isVisible = false
	gameStatusMsg.text = "No winner yet..."

	-- Enable the game
	gameIsRunning = true

	-- Hide the reset button
	resetGameButton.isVisible = false

	return true
end

----------------------------------------------------------------------
-- 5. Execution
----------------------------------------------------------------------
initBoardData()
createLayers()
drawBoard()

