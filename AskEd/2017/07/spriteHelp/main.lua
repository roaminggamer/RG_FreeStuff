-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- main.lua
-- =============================================================
--require "ssk2.loadSSK"
--_G.ssk.init( )

local centerX = display.contentCenterX
local centerY = display.contentCenterY


local function run( source, x, y )
	local info    = require( source .. ".demo")
	local sheet = graphics.newImageSheet( source .."/demo.png", info:getSheet() )
	local sequenceData = 
	{
		{
			name 			= "idle",
			start 		= info:getFrameIndex("Idle__000"),
			count 		= 10,
	    	time			= 1000,
	    	loopCount 	= 0, 
		},
		{
			name 			= "dead",
			start 		= info:getFrameIndex("Dead__000"),
			count 		= 10,
	    	time			= 1000,
	    	loopCount 	= 0, 
		},
		{
			name 			= "climb",
			start 		= info:getFrameIndex("Climb__000"),
			count 		= 10,
	    	time			= 1000,
	    	loopCount 	= 0, 
		},
	}


	local anim = display.newSprite( sheet, sequenceData )
	anim.x = x
	anim.y = y
	anim:play()
	anim:scale(2,2)

	-- Swap sequences in a loop forever
	--
	local curAnim = 1
	local animNames = { "idle", "climb", "dead" }
	timer.performWithDelay( 2000,
		function()
			anim:pause()
			curAnim = curAnim + 1
			if( curAnim > #animNames ) then 
				curAnim = 1
			end
			anim:setSequence( animNames[curAnim] )
			anim:play()
		end, -1 )

end

run("orig", centerX, centerY)

