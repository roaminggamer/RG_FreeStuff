
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


local currentObjects = {}

local w             = display.contentWidth
local h             = display.contentHeight
local centerX       = w/2
local centerY       = h/2
local minX          = 25
local maxX          = w - minX
local minY          = 25
local maxY          = h - minX

local maxPieces     = 50
local objRadius     = 20
local offset        = 4
local safeRadius    = (objRadius + offset) * 2
local safeRadius2   = safeRadius * safeRadius
local maxIter       = 150


local function safelyPlaceCircle()
    local tx = mRand( minX, maxX )
    local ty = mRand( minY, maxY)

    local iter = 0
    local isSafe = false    

    while( isSafe == false ) do
        iter = iter + 1
        if( iter > maxIter ) then
            print("Failed Iter Test")
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
    return tmp
end


-- Make one randomly placed circle at a time
--
for i = 1, maxPieces do
    local tmp = safelyPlaceCircle()
    if(tmp) then
        tmp:setFillColor( mRand(0,100)/100,  mRand(0,100)/100, mRand(0,100)/100 )
    end
end
