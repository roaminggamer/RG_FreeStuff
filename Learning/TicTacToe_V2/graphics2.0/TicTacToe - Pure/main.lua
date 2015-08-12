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
local theBoard		= {}	-- Table used to store the board pieces
local gameIsRunning	= true  -- Boolean variable used to track whether game is running or over.

-- Screen Centers
local centerX = display.contentWidth/2  
local centerY = display.contentHeight/2

-- Labels & Buttons
local currentTurnMsg        -- Empty variable that will be used to store the handle to a text object 
                            -- representing the “whose turn” marker.

local gameStatusMsg         -- Empty variable that will be used to store the handle to a text object 
                            -- representing the game status message.

local resetGameButton       -- Empty variable that will be used to store the handle to a rectangle 
                            -- object that will be used as the game reset button.
							  
local resetGameButtonText   -- Empty variable that will be used to store the handle to a text object 
                            -- that will be used as the game reset button label. 


-- Function Declarations
local createPiece
local createBoard             -- Function to draw the game board.

local checkForWinner        -- Function to check the board data (theBoard) grid for a winner.
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
	piece:setFillColor( 32,32,32,1.0 )
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

	--
	-- 2. Add a current turn marker (text object).
	--
	currentTurnMsg = display.newText( "Current Turn: " .. currentTurn , 0, 0, native.systemFont, 24 )
	currentTurnMsg.x = centerX
	currentTurnMsg.y = centerY - 2 * pieceSize

	--
	-- 3. Add a winner indicator (text object).
	--
	gameStatusMsg = display.newText( "No winner yet..." , 0, 0, native.systemFont, 24 )
	gameStatusMsg.x = centerX
	gameStatusMsg.y = centerY + 2 * pieceSize -- Spaced two piece heights below center.

	--
	-- 4. Add a button to reset the game (text object over a rectangle).
	--

	--
	-- A. Create the rectangle base first.
	-- 
	resetGameButton = display.newRect( 0, 0, currentTurnMsg.width, currentTurnMsg.height) 

	-- Again, change reference point of rectangle, then position it.
	resetGameButton.x = centerX
	resetGameButton.y = centerY - 2 * pieceSize -- Spaced two piece heights above center.

	-- Use same color scheme as the board pieces
	resetGameButton:setFillColor( 32,32,32,1.0 )
	resetGameButton:setStrokeColor( 0.5,0.5,0.5,1.0 )
	resetGameButton.strokeWidth = 1

	-- Add a different listener unique to just this button (rectangle)
	resetGameButton:addEventListener( "touch", onTouchResetButton )

	-- Hide the button (rectangle) for now.
	resetGameButton.isVisible = false

	--
	-- B. Create the text label second.
	--
	-- Again, create the text object, then position it to get the results we want.
	resetGameButtonText =  display.newText( "Reset Game", 0, 0, native.systemFont, 24 )
	resetGameButtonText.x = centerX
	resetGameButtonText.y = centerY - 2 * pieceSize -- Spaced two piece heights above center.

	resetGameButtonText:setFillColor( 0.5,0.5,0.5,1.0 )

	-- Hide the label (text object)
	resetGameButtonText.isVisible = false	
			
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


-- ==
--    boardIsFull() - Checks to see if all grids are marked.  Returns false if one or more grids are blank.
-- ==
boardIsFull = function( )

	local bd = theBoard

	for i = 1, 3 do
		for j = 1, 3 do
			-- Is the grid entry empty?
			if( bd[i][j].label.text == "" ) then 
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
onTouchPiece = function( event )
	
	-- Tip: For all but the simplest cases, it is best to extract the values you need from 'event' into local variables.
	local phase  = event.phase  
	local target = event.target

	-- If the game is over, then ignore this touch
	if( not gameIsRunning ) then
		return true
	end

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
			-- or a stalemate (no winner with full board).

			if( checkForWinner( currentTurn ) ) then
				print("Winner is: " .. currentTurn )

				-- We have a winner.  Update the message, set the game as 'over', and
				-- reveal the reset button and its label.
				--
				gameStatusMsg.text = currentTurn .. " wins!"
				currentTurnMsg.isVisible = false
				gameIsRunning = false

				resetGameButton.isVisible = true
				resetGameButtonText.isVisible = true


			elseif( boardIsFull() ) then
				print("No winner!  We have a stalemate")

				-- We have a stalemate.  Update the message, set the game as 'over', and
				-- reveal the reset button and its label.
				--
				gameStatusMsg.text = "Stalemate!"
				currentTurnMsg.isVisible = false
				gameIsRunning = false

				resetGameButton.isVisible = true
				resetGameButtonText.isVisible = true

			end
			
			if( currentTurn == "X" ) then
				currentTurn = "O"
			else
				currentTurn = "X"
			end

			currentTurnMsg.text = "Current Turn: " .. currentTurn

		end
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
	for row = 1, 3 do
		for col = 1, 3 do
			-- Clear the board text for this piece
			theBoard[row][col].label.text = ""
		end
	end

	-- Reset the current turn to "X"
	currentTurn = "X"

	-- Reset the messages to their initial values.
	currentTurnMsg.text = "Current Turn: " .. currentTurn
	currentTurnMsg.isVisible = true
	gameStatusMsg.text = "No winner yet..."

	-- Enable the game
	gameIsRunning = true

	-- Hide the reset button
	resetGameButton.isVisible = false
	resetGameButtonText.isVisible = false

	return true
end

----------------------------------------------------------------------
-- 5. Execution
----------------------------------------------------------------------
createBoard( )
