-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The person who asked this question wanted to be able drag an object and drop it into an group.",
	"However, there was  wrinkle.  The group was offset and he was unclear on how to account for the",
	"group's offset when inserting.",
	"",
	"This example shows the wrong way and the right way to deal with this.",
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 18 )
	tmp.anchorX = 0
end


--
-- 1. Create two groups.  Offset one to the left and one to the right.
local leftGroup = display.newGroup()
local rightGroup = display.newGroup()

leftGroup.x = display.contentCenterX - 150
leftGroup.y = display.contentCenterY

rightGroup.x = display.contentCenterX + 150
rightGroup.y = display.contentCenterY

-- 2. Add a rectangle to each group so we can see where we want to drop to
--
local tmp = display.newRect( leftGroup, 0, 0, 200, 200 )
tmp:setFillColor( 1,0,0,0.2)
tmp.strokeWidth = 2

local tmp = display.newRect( rightGroup, 0, 0, 200, 200 )
tmp:setFillColor( 0,1,0,0.2)
tmp.strokeWidth = 2

-- 3. THE WRONG WAY TO DO IT
--
local note = display.newText( "(Wrong Way)", 
							   display.contentCenterX - 150, display.contentCenterY + 250, native.systemFont, 18 )

local instructions = display.newText( "Drag and drop red guy.", 
	                                  display.contentCenterX - 150, display.contentCenterY + 150, native.systemFont, 18 )

local dragObj = display.newImageRect( "yellow_round.png", 40, 40 )
dragObj:setFillColor( 1, 0.2, 0.2 )
dragObj.x = display.contentCenterX - 150
dragObj.y = display.contentCenterY + 200

-- Attach Drag-and-drop listener
dragObj.touch = function( self, event )
	local target 	= self
	local phase  	= event.phase
	local id 	 	= event.id
	local stage 	= display.getCurrentStage()
	
	if( phase == "began" ) then
		target.isFocus = true
		stage:setFocus( target, id )
	elseif( target.isFocus ) then
		target.x = event.x
		target.y = event.y

		if( phase == "ended" or phase == "cancelled" ) then
			stage:setFocus( target, nil )
			target.isFocus = false

			-- Wrong way to insert into offset group
			--
			leftGroup:insert( target )
			target:toFront()

		end
	end
	return true
end

dragObj:addEventListener( "touch" )


-- 4. THE WRONG WAY TO DO IT
--
local note = display.newText( "(Right Way)", 
							   display.contentCenterX + 150, display.contentCenterY + 250, native.systemFont, 18 )
local instructions = display.newText( "Drag and drop green guy.", 
	                                  display.contentCenterX + 150, display.contentCenterY + 150, native.systemFont, 18 )

local dragObj = display.newImageRect( "yellow_round.png", 40, 40 )
dragObj:setFillColor( 0.2, 1, 0.2 )
dragObj.x = display.contentCenterX + 150
dragObj.y = display.contentCenterY + 200

-- Attach Drag-and-drop listener
dragObj.touch = function( self, event )
	local target 	= self
	local phase  	= event.phase
	local id 	 	= event.id
	local stage 	= display.getCurrentStage()
	
	if( phase == "began" ) then
		target.isFocus = true
		stage:setFocus( target, id )

		-- Bring drag object back into currentStage for dragging
		--
		local x, y = stage:contentToLocal( event.x, event.y )
		stage:insert( target )
		target:toFront()
		target.x = x
		target.y = y

	elseif( target.isFocus ) then
		target.x = event.x
		target.y = event.y

		if( phase == "ended" or phase == "cancelled" ) then
			stage:setFocus( target, nil )
			target.isFocus = false

			-- Insert drag object into group, then...
			--
			-- Use 'contentToLocal()' to adjust our cooridnate system to 
			-- match the group and it's offset.
			--
			local x,y = rightGroup:contentToLocal( target.x, target.y )
			rightGroup:insert( target )
			target:toFront()
			target.x = x
			target.y = y			

		end
	end
	return true
end

dragObj:addEventListener( "touch" )
