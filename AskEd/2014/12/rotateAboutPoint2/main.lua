-- =============================================================
-- main.lua
-- =============================================================
local w 			= display.contentWidth
local h 			= display.contentHeight
local centerX 		= display.contentCenterX
local centerY 		= display.contentCenterY
local actualWidth	= display.actualContentWidth 
local actualHeight	= display.actualContentHeight
local unusedWidth	= actualWidth - w
local unusedHeight	= actualHeight - h
local left			= -unusedWidth/2
local top 			= -unusedHeight/2
local right 		= w + unusedWidth/2
local bottom 		= h + unusedHeight/2
local fullw			= w + unusedWidth
local fullh 		= h + unusedHeight

local rotateAbout = require "rotateAbout"

local tmp = display.newCircle( 0, 0 , 5 )

----[[
-- Loop 3 times (with 1/2 second initial delay)
tmp.myLoops = 3
local function onComplete( self )
	tmp.myLoops = tmp.myLoops - 1
	if( tmp.myLoops > 0 ) then
		rotateAbout( self, centerX, centerY, { onComplete = onComplete } )
	end
end
rotateAbout( tmp, centerX, centerY, { delay = 500, debugEn = true, onComplete = onComplete } )
--]]


--[[
-- Loop forever (with 1/2 second initial delay)
local function onComplete( self )
	rotateAbout( self, centerX, centerY, { onComplete = onComplete } )
end
rotateAbout( tmp, centerX, centerY, { delay = 500, debugEn = true, onComplete = onComplete } )
--]]

-- More variations below

--rotateAbout( tmp, centerX, centerY )

--rotateAbout( tmp, centerX, centerY, { radius = 50, time = 2000, debugEn = true } )

-- ==============================
-- Only for attempt 3 code ==> 
-- ==============================
--rotateAbout( tmp )
--rotateAbout( tmp, centerX, centerY, { debugEn = true } )

--[[
rotateAbout( tmp, centerX, centerY, 
	           { time = 10000, myEasing = easing.outElastic, 
	             debugEn = true } )
--]]


--[[
rotateAbout( tmp, centerX, centerY,
	           { time = 6000, startA = 270, endA = 90, 
	             myEasing = easing.outBounce, 
	             debugEn = true } )
--]]


