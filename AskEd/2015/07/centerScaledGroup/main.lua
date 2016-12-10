-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The person who wrote this question wanted to learn how to center scaled group",
    "on the screen",
	"",
	"This example demonstrates how do do this. (Hint: One line of code makes it possible.)",
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end

--
-- 1. Some variables for the example
local w             = display.contentWidth
local h             = display.contentHeight
local centerX       = w/2
local centerY       = h/2
local minX          = -200
local maxX          = 600
local minY          = -200
local maxY          = 600

local circlesPerAdd = 25
local objRadius     = 20


-- 2. Our Group
--
local group = display.newGroup()

--
--
-- 3. A circle generator
local function randomlyPlaceCircle( )
    local tx = math.random( minX, maxX )
    local ty = math.random( minY, maxY)
    local tmp = display.newCircle( group, tx, ty, objRadius )
    return tmp
end

-- 4. Function to add circles
local function addCircles( )
    for i = 1, circlesPerAdd do
    	timer.performWithDelay( i * 30, 
    		function() 
    			local tmp = randomlyPlaceCircle( )
    			if(tmp) then
    			    tmp:setFillColor( math.random(0,100)/100,  math.random(0,100)/100, math.random(0,100)/100 )
    			end
    		end )
    end
end

--
-- 5. Functions to scale the group up and down, as well as to re-center it
local function scaleDown()
    group:scale(0.8,0.8)
end

local function scaleUp()
    group:scale(1.25,1.25)
end

local function centerGroup()
    group.anchorChildren = true -- The magic is in this one line.  
                                -- Try setting it to false to see the difference
    group.x = centerX
    group.y = centerY
end


--
-- 6. Make buttons to play sounds
local onTouch = function( self, event )
    if( event.phase == "ended" ) then
        self.myCallback()
    end
    return true
end

local buttonNames       = { "Add Circles", "Scale Down", "Scale Up", "Center Group" }
local buttonCallbacks   = { addCircles, scaleDown, scaleUp, centerGroup }

local currentY = display.contentCenterY - 150 
for i = 1, #buttonNames do

        local button = display.newRect( 0, 0, 300, 30 )
        button.x = display.contentCenterX + 300
        button.y = currentY 
        button:setFillColor( 0.2, 0.2, 0.2 )
        button.touch = onTouch
        button:addEventListener("touch")
        button.myCallback = buttonCallbacks[i]
        currentY = currentY + 35

        display.newText( buttonNames[i], button.x, button.y , native.systemFont, 22 )
end
