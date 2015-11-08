-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The person who wrote this question wanted to learn how to check",
	"if objects are overlapping.",
	"",
	"This example generates a number of objects while ensuring none overlaps.",
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


--
-- 1. Some variables for the example
local currentObjects = {}

local w             = display.contentWidth
local h             = display.contentHeight
local centerX       = w/2
local centerY       = h/2
local minX          = 25
local maxX          = w - minX
local minY          = 200
local maxY          = h - minX

local maxPieces     = 150
local objRadius     = 20
local offset        = 4
local buffer 		= -6
local safeRadius    = (objRadius + offset) * 2 + buffer
local safeRadius2   = safeRadius * safeRadius
local maxIter       = 150


--
-- 2. Some math functions we'll need
local mRand = math.random
local mSqrt = math.sqrt 
local mRad = math.rad
local mCos = math.cos 
local mSin = math.sin

local function subVec( x0, y0, x1, y1 )
    return { x = x1 - x0, y = y1 - y0 }
end

local function lenVec( vec )
    return mSqrt(vec.x * vec.x + vec.y * vec.y)
end

local function len2Vec( vec )
    return vec.x * vec.x + vec.y * vec.y
end

--
-- 3. A circle generator
local function safelyPlaceCircle()
    local tx = mRand( minX, maxX )
    local ty = mRand( minY, maxY)

    local iter = 0
    local isSafe = false    

    while( isSafe == false ) do
        iter = iter + 1
        if( iter > maxIter ) then
            print("Failed Iter Test and Gave Up @ " .. system.getTimer())
            return
        end

        isSafe = true
        for i = 1, #currentObjects do
            local obj = currentObjects[i]
            local vec = subVec( tx, ty, obj.x, obj.y )
            local len2 = len2Vec( vec )
            if( len2 < safeRadius2 ) then
                isSafe = false
                tx = mRand( minX, maxX )
                ty = mRand( minY, maxY )
            end
        end
    end

    local tmp = display.newCircle( tx, ty, objRadius )
    currentObjects[#currentObjects+1] = tmp
    print("Created in iterations ", iter)
    print("Total objects: ", #currentObjects )
    return tmp
end

--
-- 4. Generate circles after a short delay
-- Make one randomly placed circle at a time
--
for i = 1, maxPieces do
	timer.performWithDelay( i * 30, 
		function() 
			local tmp = safelyPlaceCircle()
			if(tmp) then
			    tmp:setFillColor( mRand(0,100)/100,  mRand(0,100)/100, mRand(0,100)/100 )
			end
		end )
end
