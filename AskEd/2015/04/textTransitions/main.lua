-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The asker wanted to make some text shrink then grow.  This example", 
	"shows a variety of transtions applied to text.",
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end

--
-- 1. Load SSK
--require "ssk.loadSSK"

--
-- 2. Some examples

-- Sample 1
local tmp = display.newText( "Sample 1", 0, 200, native.systemFont, 42 )
tmp.anchorX = 0
tmp.x = display.contentCenterX - tmp.contentWidth/2
local shrink1 -- forward declare
local grow1   -- forward declare
shrink1 = function( obj )
	transition.to( obj, { xScale = 0.005, delay = 1000, time = 500, onComplete = grow1 } )
end
grow1 = function( obj )
	transition.to( obj, { xScale = 1, delay = 250, time = 500, onComplete = shrink1 } )
end
shrink1( tmp )

-- Sample 2
local tmp = display.newText( "Sample 2", 0, tmp.y + 50, native.systemFont, 42 )
tmp.anchorX = 0
tmp.x = display.contentCenterX - tmp.contentWidth/2
local shrink2 -- forward declare
local grow2   -- forward declare
shrink2 = function( obj )
	transition.to( obj, { xScale = -1, delay = 1000, time = 500, onComplete = grow2 } )
end
grow2 = function( obj )
	transition.to( obj, { xScale = 1, delay = 250, time = 500, onComplete = shrink2 } )
end
shrink2( tmp )


-- Sample 3
local tmp = display.newText( "Sample 3", 0, tmp.y + 50, native.systemFont, 42 )
tmp.anchorX = 1
tmp.x = display.contentCenterX + tmp.contentWidth/2
local shrink3-- forward declare
local grow3   -- forward declare
shrink3 = function( obj )
	transition.to( obj, { xScale = 0.005, delay = 1000, time = 500, onComplete = grow3 } )
end
grow3 = function( obj )
	transition.to( obj, { xScale = 1, delay = 250, time = 500, onComplete = shrink3 } )
end
shrink3( tmp )

-- Sample 4
local tmp = display.newText( "Sample 4", 0, tmp.y + 50, native.systemFont, 42 )
tmp.anchorX = 1
tmp.x = display.contentCenterX + tmp.contentWidth/2
local shrink4 -- forward declare
local grow4   -- forward declare
shrink4 = function( obj )
	transition.to( obj, { xScale = -1, delay = 1000, time = 500, onComplete = grow4 } )
end
grow4 = function( obj )
	transition.to( obj, { xScale = 1, delay = 250, time = 500, onComplete = shrink4 } )
end
shrink4( tmp )



-- Sample 5
local tmp = display.newText( "Sample 5", 0, tmp.y + 50, native.systemFont, 42 )
tmp.x = display.contentCenterX 
local shrink5-- forward declare
local grow5   -- forward declare
shrink5 = function( obj )
	transition.to( obj, { xScale = 0.005, delay = 1000, time = 500, onComplete = grow5 } )
end
grow5 = function( obj )
	transition.to( obj, { xScale = 1, delay = 250, time = 500, onComplete = shrink5 } )
end
shrink5( tmp )

-- Sample 6
local tmp = display.newText( "Sample 6", 0, tmp.y + 50, native.systemFont, 42 )
tmp.x = display.contentCenterX
local shrink6 -- forward declare
local grow6   -- forward declare
shrink6 = function( obj )
	transition.to( obj, { xScale = -1, delay = 1000, time = 500, onComplete = grow6 } )
end
grow6 = function( obj )
	transition.to( obj, { xScale = 1, delay = 250, time = 500, onComplete = shrink6 } )
end
shrink6( tmp )

-- Sample 7
local tmp = display.newText( "Sample 7", 0, tmp.y + 50, native.systemFont, 42 )
tmp.x = display.contentCenterX
tmp.fill.effect = "filter.linearWipe"
tmp.fill.effect.direction = { -1, -1 }
tmp.fill.effect.smoothness = 1
tmp.fill.effect.progress = 0.0

local swipeA -- forward declare
local swipeB   -- forward declare
swipeA = function( effect )
	transition.to( effect, { progress = 1, time = 2000, onComplete = swipeB })
end
swipeB = function( effect )
	transition.to( effect, { progress = 0, time = 2000, onComplete = swipeA })
end
swipeA( tmp.fill.effect )


-- Sample 8
local tmp = display.newText( "Sample 8", 0, tmp.y + 50, native.systemFont, 42 )
tmp.x = display.contentCenterX
tmp.fill.effect = "filter.linearWipe"
tmp.fill.effect.direction = { 1, 0 }
tmp.fill.effect.smoothness = 1
tmp.fill.effect.progress = 0.0

local swipeC -- forward declare
local swipeD   -- forward declare
swipeC = function( effect )
	transition.to( effect, { progress = 1, time = 2000, onComplete = swipeD })
end
swipeD = function( effect )
	transition.to( effect, { progress = 0, time = 2000, onComplete = swipeC })
end
swipeC( tmp.fill.effect )

