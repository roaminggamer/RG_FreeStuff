-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"",
	"This answer addresses the fact that random number generators are not very random", 
	"over a short period.  i.e. You only see an even distrubtion for long sequences. ",
	"Run this example for a bit and you'll see that some random numbers are selected ",
	"more frequently than others.",
	"",
	"Bonus: Demonstrates 'shuffle bag' technique for more even distrubtions.",
	"Tip: 'shuffle bags' can be even or weighted depending on how you fill them."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end

local function math_random()
	local group = display.newGroup()
	--
	-- 1. Create a table to contain our delta times
	local randomCounts = {}

	-- 2. Create a sequence of 'bars' to show the frame to frame delta time.
	--
	local bars 		= {}
	local barW 		= 5
	local maxNumbers   = 50
	local barH 		= 100
	local startX 	= display.contentCenterX - maxNumbers * barW/2
	local curX 		= startX
	for i = 1, maxNumbers do
		local tmp = display.newRect( group, curX, display.contentCenterY + 200, barW-2, barH )
		tmp.anchorY = 1
		curX = curX + barW
		bars[i] = tmp
		tmp:setFillColor( 1, 0, 0 )
	end

	local x1 = display.contentCenterX - (maxNumbers * barW)/2 - 10
	local x2 = display.contentCenterX + (maxNumbers * barW)/2 + 10
	local tmp = display.newLine( group, x1, display.contentCenterY + 204, x2, display.contentCenterY + 204 )
	tmp:setStrokeColor( 1, 1, 1 )
	tmp.strokeWidth = 4
	tmp:toBack()

	display.newText( group, "math.random()", display.contentCenterX, display.contentCenterY + 230, native.systemFont, 22 )

	--
	-- 3. Every frame, adjust height of bars based on randomCounts
	for i = 1, maxNumbers do
		randomCounts[i] = 0
	end

	local function barAdjuster()
		for i = 1, #bars do
			if( randomCounts[i] == 0 ) then			
				bars[i].isVisible = false
			else
				bars[i].isVisible = true
				bars[i].yScale = randomCounts[i]/barH
			end
		end
	end
	Runtime:addEventListener( "enterFrame", barAdjuster )

	--
	-- 4. Every 100 ms, choose 25 random numbers
	timer.performWithDelay( 100,
		function()
			for i = 1, 25 do
				local value = math.random(1,maxNumbers)
				randomCounts[value] = randomCounts[value] + 1
			end
		end, -1 )

	group.x = group.x - 150
end

local function shuffle_bag()

	local group = display.newGroup()
	--
	-- 1. Create a table to contain our delta times
	local randomCounts = {}

	-- 2. Create a sequence of 'bars' to show the frame to frame delta time.
	--
	local bars 		= {}
	local barW 		= 5
	local maxNumbers   = 50
	local barH 		= 100
	local startX 	= display.contentCenterX - maxNumbers * barW/2
	local curX 		= startX
	for i = 1, maxNumbers do
		local tmp = display.newRect( group, curX, display.contentCenterY + 200, barW-2, barH )
		tmp.anchorY = 1
		curX = curX + barW
		bars[i] = tmp
		tmp:setFillColor( 1, 0, 0 )
	end

	local x1 = display.contentCenterX - (maxNumbers * barW)/2 - 10
	local x2 = display.contentCenterX + (maxNumbers * barW)/2 + 10
	local tmp = display.newLine( group, x1, display.contentCenterY + 204, x2, display.contentCenterY + 204 )
	tmp:setStrokeColor( 1, 1, 1 )
	tmp.strokeWidth = 4
	tmp:toBack()

	display.newText( group, "shuffle bag", display.contentCenterX, display.contentCenterY + 230, native.systemFont, 22 )

	--
	-- 3. Every frame, adjust height of bars based on randomCounts
	for i = 1, maxNumbers do
		randomCounts[i] = 0
	end

	local function barAdjuster()
		for i = 1, #bars do
			if( randomCounts[i] == 0 ) then			
				bars[i].isVisible = false
			else
				bars[i].isVisible = true
				bars[i].yScale = randomCounts[i]/barH
			end
		end
	end
	Runtime:addEventListener( "enterFrame", barAdjuster )


	-- 4. Simple shuffle bag implementation
	local shuffleBag = require "shuffleBag"

	-- Fill the bag ONCE with values
	for i = 1, maxNumbers do
		shuffleBag.insert( i )
	end

	--
	-- 5. Every 100 ms, choose 25 random numbers
	timer.performWithDelay( 100,
		function()
			for i = 1, 25 do
				local value = shuffleBag.get()
				randomCounts[value] = randomCounts[value] + 1
			end
		end, -1 )

	group.x = group.x + 150
end

math_random()
shuffle_bag()