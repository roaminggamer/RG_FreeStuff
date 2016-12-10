-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The person who asked this question wanted to make a 'harvesting' mechanic.",
	"He wanted to tap objects and 'harvest them', but if two objects overlapped,",
	"he only wanted to harvest one at a time.",
	"",
	"This example achieves that basic mechanic.",
	"",
	"1. Tap trees to harvest them. (There are 30)"
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


--
-- 1. Harvest Counter
local count = 0
local harvestLabel = display.newText( "Wood: " .. count, display.contentCenterX + 250, 250, native.systemFont, 22 )
harvestLabel.anchorX = 0

--
-- 2. Common harvest listener
local function onHarvest ( self, event )
	local target 	= self
	local phase  	= event.phase
	local id 	 	= event.id
	local stage 	= display.getCurrentStage()
	
	if( phase == "began" ) then
		target.isFocus = true
		stage:setFocus( target, id )
		target:setFillColor( 1,1,1 )
		target.xScale = 1.25
		target.yScale = 1.25
		target:toFront()

	elseif( target.isFocus ) then

		if( phase == "ended" or phase == "cancelled" ) then
			stage:setFocus( target, nil )
			target.isFocus = false

			-- Fly tree over to counter, the remove it
			--
			local function onComplete( self )
				count = count + 1
				harvestLabel.text = "Wood: " .. count
				display.remove(self)
			end
			transition.to( self, { x = harvestLabel.x, 
				                   y = harvestLabel.y, 
				                   xScale = 0.25,
				                   yScale = 0.25,
				                   alpha = 0.2,
				                   time = 250, onComplete = onComplete } )

			-- Ignore any more touches
			target:removeEventListener("touch")

		end
	end
	return true
end

--
-- 2. Randomly place 30 trees and ensure they overlapp a bit.
for i = 1, 30 do
	local treeNum = math.random(1,3)
	local tree 

	-- Make trees very distinct for example
	if( treeNum	== 1 ) then
		tree = display.newImageRect( "tree1.png", 100, 136 )
		tree:setFillColor(1,0,0)
	
	elseif( treeNum	== 2 ) then
		tree = display.newImageRect( "tree2.png", 98, 107 )
		tree:setFillColor(0,1,0)
	
	else
		tree = display.newImageRect( "tree3.png", 101, 115 )
		tree:setFillColor(0,0,1)
	end

	tree.x = display.contentCenterX + math.random( -150, 150 ) 
	tree.y = display.contentCenterY + math.random( -150, 150 ) + 150
	tree.touch = onHarvest
	tree:addEventListener( "touch" )
end


--[[
--
-- 1. Create a variable to track last tapped object.
local lastTapped

--
-- 2. Create a touch listener for the two objects
local onTouch = function( self, event )
	if( event.phase == "ended" ) then
		lastTapped = self
	end
	return true
end

-- 3. Create two objects
-- 
local tmp = display.newImageRect( "yellow_round.png", 40, 40 )
tmp.x = display.contentCenterX - 100
tmp.y = display.contentCenterY
tmp:setFillColor(1,0,0)
tmp.touch = onTouch
tmp:addEventListener( "touch" )

local tmp = display.newImageRect( "yellow_round.png", 40, 40 )
tmp.x = display.contentCenterX 
tmp.y = display.contentCenterY
tmp:setFillColor(0,1,0)
tmp.touch = onTouch
tmp:addEventListener( "touch" )

-- 4. A Runtime touch listener to do the moving
-- 
local function onMoveTouch( event )
	if( event.phase == "began" ) then
		if( lastTapped ) then 
			transition.to( lastTapped, { x = event.x, y = event.y, time = 1000 } )
			lastTapped = nil
		end
	end
	return true
end

Runtime:addEventListener( "touch", onMoveTouch )
--]]