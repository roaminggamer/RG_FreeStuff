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
	"This example visually demonstrates tha frame to frame delta time varies.", 
	"If you read the post associated with this answer, you'll see I give code",
	"for smoothing this delta to make movement 'more' consistent.",
	"",
	"The red graph will fill then slide left.  Red lines that go higher than",
	"the pink line are frames that took longer than expectd for the currently set",
	"frame rate 'display.fps'.",
	"Bonus: Also shows other ways to measure delta times."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


--
-- Create a table to contain our delta times
local deltaTimes = {}

-- Create a sequence of 'bars' to show the frame to frame delta time.
--
local bars 		= {}
local barW 		= 5
local maxBars   = math.floor( (display.contentWidth - 20)/ barW)
local barH 		= 100
local startX 	= display.contentCenterX - maxBars * barW/2
local curX 		= startX
for i = 1, maxBars do
	local tmp = display.newRect( curX, display.contentCenterY + 200, barW-2, barH )
	tmp.anchorY = 1
	curX = curX + barW
	bars[i] = tmp
	tmp:setFillColor( 1, 0, 0 )
end

local tmp = display.newLine( 0, display.contentCenterY + 104, display.contentWidth, display.contentCenterY + 104 )
tmp:setStrokeColor( 1, 0, 1 )
tmp.strokeWidth = 8
tmp:toBack()

local tmp = display.newLine( 0, display.contentCenterY + 196, display.contentWidth, display.contentCenterY + 196 )
tmp:setStrokeColor( 0, 1, 1 )
tmp.strokeWidth = 8
tmp:toBack()

--
-- Every frame, adjust height of bars based on deltaTimes
local baseDeltaTime = 1000/display.fps
local function barAdjuster()
	-- First, hide all bars
	for i = 1, #bars do
		bars[i].isVisible = false
	end

	-- Second, iterate over deltaTimes and show + scale bars
	for i = 1, #deltaTimes do
		bars[i].isVisible = true
		bars[i].yScale = deltaTimes[i]/baseDeltaTime
	end
end
Runtime:addEventListener( "enterFrame", barAdjuster )


--
-- Every frame, accumulate deltas.  When the list is 'full', discard oldest delta
local socket = require "socket"
local lastTime = system.getTimer()
--local lastOSTime = os.time()
--local lastSocketTime = socket.gettime()
local function deltaAccumulator()
	local curTime = system.getTimer()
	local dt = curTime - lastTime

	--local curOSTime = os.time()
	--local dtOS = curOSTime - lastOSTime

	--local curSocketTime = socket.gettime()
	--local dtSocket = curSocketTime - lastSocketTime
	--dtSocket = dtSocket * 1000

	if( dt == 0 ) then return end

	deltaTimes[#deltaTimes+1] = dt

	lastTime = curTime
	
	--lastOSTime = curOSTime
	--lastSocketTime = curSocketTime
	--print(dtSocket, dt, round(dt-dtSocket, 6))

	while( #deltaTimes > #bars ) do
		table.remove( deltaTimes, 1 )
	end

end
Runtime:addEventListener( "enterFrame", deltaAccumulator )

