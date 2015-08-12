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
local pieceSize = 65

-- Screen Centers
local centerX = display.contentWidth/2  
local centerY = display.contentHeight/2

-- Labels & Buttons

-- Function Declarations
local createPiece

-- Listener Declarations

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
	piece:setFillColor( 32,32,32,255 )
	piece:setStrokeColor( 128,128,128,255 )
	piece.strokeWidth = 2

	-- 
	-- B. Create the text object 'label' second so it is displayed on top of the rectangle
	--

	-- Attach the label to the grid piece (rectangle object).  This is an easy way to track which text object goes with which rectangle.
	-- Why we do this will become more clear below in the touch handler.

	--piece.label =  display.newText( "", 0, 0, native.systemFont, 48 ) -- Tip: Change "" to "X" to quickly test how your labels look and are positioned.
	piece.label =  display.newText( "X", 0, 0, native.systemFont, 48 ) -- Tip: Change "" to "X" to quickly test how your labels look and are positioned.

	-- Position this label over the existing piece.
	piece.label.x = piece.x
	piece.label.y = piece.y

	-- Tip: I created the above text object at position <0,0> and then positioned it.  Why?  Because you have no way of knowing the exact width/height
	-- of a text object till it is created.  So, trying to position it during creation will end up placing it by the upper-left coordinates.
	-- However, after the text object is created, it changes to a center reference point.  So, by waiting to set the position, we get the result we really wanted.

	-- Change the text color to light grey
	piece.label:setFillColor( 0.5,0.5,0.5,255 )

	return piece
end


--==
-- ================================= LISTENER DEFINITIONS
--==


----------------------------------------------------------------------
-- 5. Execution
----------------------------------------------------------------------
createPiece( centerX, centerY, pieceSize )

