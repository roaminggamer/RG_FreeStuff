-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The user wanted to know if it was possible to get a parabolic curve using transition.", 
	"",
	"Answer: Yes, and more... just get creative with easings."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


-- 
-- Helper function to draw trails
local function addTrailDrawer( self )
	self.enterFrame = function( self )
		if( not self or self.removeSelf == nil ) then
			Runtime:removeEventListener( "enterFrame", self )
			return
		end
    	local tmp = display.newRect( self.parent, self.x, self.y, 5, 5 )
    	tmp.alpha = 0.8
    	tmp:toBack()
    end
    Runtime:addEventListener( "enterFrame", self )
end

-- Create objects to transtion
-- 
local obj1 = display.newImageRect( "yellow_round.png", 40, 40 )
obj1.x = display.contentCenterX - 300
obj1.y = display.contentCenterY + 50
addTrailDrawer( obj1 )

local obj2 = display.newImageRect( "yellow_round.png", 40, 40 )
obj2.x = display.contentCenterX - 300
obj2.y = display.contentCenterY + 100
addTrailDrawer( obj2 )


local obj3 = display.newImageRect( "yellow_round.png", 40, 40 )
obj3.x = display.contentCenterX - 300
obj3.y = display.contentCenterY + 150
addTrailDrawer( obj3 )

-- Transition them
-- 
local startX = obj1.x
local startY = obj1.y
local function onComplete( self )
	transition.to( self, { y = startY, 
		                   transition = easing.inCirc, 
		                   time = 2000, 
		                   onComplete = display.remove } )	
end

transition.to( obj1, { x = startX + 500, delay = 1000, time = 4000 } )
transition.to( obj1, { y = obj1.y - 200, 
	                   transition = easing.outCirc, 
	                   delay = 1000, 
	                   time = 2000, 
	                   onComplete = onComplete } )


local startX2 = obj2.x
local startY2 = obj2.y
local function onComplete( self )
	transition.to( self, { y = startY2, 
		                   transition = easing.outCirc, 
		                   time = 2000, 
		                   onComplete = display.remove } )	
end

transition.to( obj2, { x = startX2 + 500, delay = 1000, time = 4000 } )
transition.to( obj2, { y = obj2.y - 200, 
	                   transition = easing.inCirc, 
	                   delay = 1000, 
	                   time = 2000, 
	                   onComplete = onComplete } )


local startX3 = obj3.x
local startY3 = obj3.y
local function onComplete( self )
	transition.to( self, { y = startY3, 
		                   transition = easing.inCirc, 
		                   time = 2000, 
		                   onComplete = display.remove } )	
end

transition.to( obj3, { x = startX3 + 500, delay = 1000, time = 4000 } )
transition.to( obj3, { y = obj1.y + 200, 
	                   transition = easing.outCirc, 
	                   delay = 1000, 
	                   time = 2000, 
	                   onComplete = onComplete } )
