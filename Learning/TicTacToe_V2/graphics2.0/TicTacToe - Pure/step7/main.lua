-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- main.lua
-- =============================================================

----------------------------------------------------------------------
--	1. Requires
----------------------------------------------------------------------

----------------------------------------------------------------------
--	2. Initialization
----------------------------------------------------------------------
io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

----------------------------------------------------------------------
-- 3. Declarations
----------------------------------------------------------------------

-- Locals
local pieceSize		= 65	
local currentTurn	= "X"   -- String variable used to track whose turn it is.  X always starts.
local theBoard		= {}     -- Table used to store the board pieces

-- Screen Centers
local centerX = display.contentWidth/2  
local centerY = display.contentHeight/2

-- Labels & Buttons

-- Function Declarations
local createPiece
local createBoard             -- Function to draw the game board.

local checkForWinner        -- Function to check the board data (theBoard) grid for a winner.

-- Listener Declarations
local onTouchPiece          -- Listener to handle touches on board pieces.

----------------------------------------------------------------------
-- 4. Definitions
----------------------------------------------------------------------

--==
-- ================================= FUNCTION DEFINITIONS
--==

-- ==
--    createPiece() - Draws a single tic-tac-toe game piece (tile).
-- ==
createPiece = function( x , y, size )
	-- 
	-- A. Create the rectangle first (so it is displayed on the bottom)
	--
	local piece =  display.newRect( 0, 0, size, size )
			
	-- Move the piece (The default position was <0,0>)			
	piece.x = x
	piece.y = y

	-- Change the color of this 'piece' to be dark grey with a 2-pixel wide light grey border
	piece:setFillColor( 0.125,0.125,0.125,1.0 )
	piece:setStrokeColor( 0.5,0.5,0.5,1.0 )
	piece.strokeWidth = 2
	-- 
	-- B. Create the text object 'label' second so it is displayed on top of the rectangle
	--

	-- Attach the label to the grid piece (rectangle object).  This is an easy way to track which text object goes with which rectangle.
	-- Why we do this will become more clear below in the touch handler.

	piece.label =  display.newText( "", 0, 0, native.systemFont, 48 ) -- Tip: Change "" to "X" to quickly test how your labels look and are positioned.

	-- Position this label over the existing piece.
	piece.label.x = piece.x
	piece.label.y = piece.y

	-- Tip: I created the above text object at position <0,0> and then positioned it.  Why?  Because you have no way of knowing the exact width/height
	-- of a text object till it is created.  So, trying to position it during creation will end up placing it by the upper-left coordinates.
	-- However, after the text object is created, it changes to a center reference point.  So, by waiting to set the position, we get the result we really wanted.

	-- Change the text color to light grey
	piece.label:setFillColor( 0.5,0.5,0.5,1.0 )

	-- Add a "touch" listener to the grid piece (rectangle object). 
	piece:addEventListener( "touch", onTouchPiece )

	return piece
end


-- ==
--    createBoard() - Draws the tic-tac-toe game board.
-- ==
createBoard = function()

	local startX    = centerX - pieceSize  -- Column 1 starts once-piece width left of center
	local startY    = centerY - pieceSize  -- Row 1 starts once-piece height above center

	--
	-- 1. Draw the board (3-by-3 grid of text objects over rectangles).
	--
	for row = 1, 3 do
		local y = startY + (row - 1) * pieceSize
		theBoard[row] = { {}, {}, {} } 

		for col = 1, 3 do
			local x = startX + (col - 1) * pieceSize

			local piece =  createPiece( x, y, pieceSize )

			-- Store this boardPiece in our generic table of pieces
			theBoard[row][col] = piece

		end
	end		
		
end

-- Naive/Brute Force way to testing for a winner.
-- ==
--    checkForWinner() - This function checks to see if either "X" or "O" has won the game.
--                       It does this using a naive/brute force approach. i.e. It explicitly checks
--                       each win cases.  This is OK for a 3-by-3 grid, but if the game and board
--                       used more grids, we would need to come up with an algorithmic check.
--
--  Tip: See MAGS #2: 4-in-a-row for an example of algorithmic win testing for grid based games.
-- ==
checkForWinner = function( turn )

	local bd = theBoard

	if(bd[1][1].label.text == turn and  bd[1][2].label.text == turn and bd[1][3].label.text == turn) then -- COL 1
		return true
	
	elseif(bd[2][1].label.text == turn and  bd[2][2].label.text == turn and bd[2][3].label.text == turn) then -- COL 2
		return true
	
	elseif(bd[3][1].label.text == turn and  bd[3][2].label.text == turn and bd[3][3].label.text == turn) then -- COL 3
		return true

	elseif(bd[1][1].label.text == turn and  bd[2][1].label.text == turn and bd[3][1].label.text == turn) then -- ROW 1
		return true
	
	elseif(bd[1][2].label.text == turn and  bd[2][2].label.text == turn and bd[3][2].label.text == turn) then -- ROW 2
		return true
	
	elseif(bd[1][3].label.text == turn and  bd[2][3].label.text == turn and bd[3][3].label.text == turn) then -- ROW 3
		return true

	elseif(bd[1][1].label.text == turn and  bd[2][2].label.text == turn and bd[3][3].label.text == turn) then -- DIAGONAL 1 (top-to-bottom)
		return true

	elseif(bd[1][3].label.text == turn and  bd[2][2].label.text == turn and bd[3][1].label.text == turn) then -- DIAGONAL 2 (bottom-to-top)
		return true
	
	end 

	return false
end

--==
-- ================================= LISTENER DEFINITIONS
--==


-- ==
--    onTouchPiece() - Touch listener function.  
-- ==
onTouchPiece = function( event )
	
	-- Tip: For all but the simplest cases, it is best to extract the values you need from 'event' into local variables.
	local phase  = event.phase  
	local target = event.target

	-- Don't do anything unless this is the "ended" phase, 
	-- meaning the player touched a piece and then lifted their finger.
	if( phase == "ended" ) then
		
		-- Is the marker for this piece empty?
		-- Tip: Remember, when we created the board piece, we added a reference to the text object
		--      to our rectangle.  That allowed us to use the rectangle as the touch object, and 
		--      yet still know the proper text object to check.
		-- 

		if( target.label.text == "" ) then

			-- The maker was empty, so set it to "X" or "O" (whoever's turn it is now).
			target.label.text = currentTurn

			-- Now that we've updated the data table, check to see if we have a winner
			if( checkForWinner( currentTurn ) ) then
				print("Winner is: " .. currentTurn )
			end


			if( currentTurn == "X" ) then
				currentTurn = "O"
			else
				currentTurn = "X"
			end

		end
	end

	return true
end

----------------------------------------------------------------------
-- 5. Execution
----------------------------------------------------------------------
createBoard( )
