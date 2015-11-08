-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The person who asked this question was trying to make a drag-n-drop editor using a grid.", 
	"While he was using widgets, the problem he encountered was fundamental.",
	"I in this example I will demonstrate a very simple drag-n-drop grid mechanic.", 
	"",
	"1. Click on a smiley and drag over the grid, then release it.",
	"2. Notice that it snaps to the center of the grid entry you're over."

}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end

-- 1. Locals
--
local dragObj 			-- Current object we a dragging
local editorGrid = {}	-- Table to store grid markers in


--
-- 2. Grid Listener
local function gridListener( self, event )
	local target 	= self
	local phase  	= event.phase
	local id 	 	= event.id
	local stage 	= display.getCurrentStage()

	if( phase == "ended" ) then
		if( dragObj ) then
			dragObj.x = target.x
			dragObj.y = target.y
			dragObj = nil			
		end

		target.alpha = 1
		transition.cancel( target )
		transition.to( target, { alpha = 0.2, delay = 500, time = 0 } )

	else
		target.alpha = 1
		transition.cancel( target )
		transition.to( target, { alpha = 0.2, delay = 50, time = 0 } )
	end

	return false

end

--
-- 3. Drag listener
local function dragListener( self, event )
	local target 	= self
	local phase  	= event.phase
	local id 	 	= event.id
	local stage 	= display.getCurrentStage()

	if( dragObj and target ~= dragObj ) then
		return false
	end

	target.x = event.x
	target.y = event.y
	target:toFront()
	
	if( phase == "began" ) then
		-- start tracking the current drag object
		dragObj = target
	end
	return false
end

--
-- 4. Create a grid
local rows = 8
local cols = 8
local gridSize = 50
local startX = display.contentCenterX - rows/2 * gridSize - gridSize/2
local startY = display.contentCenterY - cols/2 * gridSize - gridSize/2 + 100
for row = 1, rows do
	for col = 1, cols do
		local grid = display.newRect( 0, 0, gridSize, gridSize )
		grid.x = col * gridSize + startX
		grid.y = row * gridSize + startY
		grid.strokeWidth = 1
		grid:setStrokeColor(1,0,0)

		grid.alpha = 0.2
		grid.touch = gridListener
		grid:addEventListener("touch")
		editorGrid[#editorGrid+1] = grid
	end
end

--
-- 5. Create two random drag objects and place them at a random grid location.
--
-- Warning: Not sophisticated.  May occasionally place on same grid.
--
for i = 1, 2 do
	local obj = display.newImageRect( "yellow_round.png", 40, 40 )
	obj.touch = dragListener
	obj:addEventListener("touch")

	local gridNum = math.random(1, #editorGrid )
	obj.x = editorGrid[gridNum].x
	obj.y = editorGrid[gridNum].y
end
