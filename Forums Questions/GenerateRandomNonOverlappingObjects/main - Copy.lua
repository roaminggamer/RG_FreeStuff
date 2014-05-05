
local mRand = math.random
local mSqrt = math.sqrt 
local mRad = math.rad
local mCos = math.cos 
local mSin = math.sin

local function subVec( x0, y0, x1, y1 )
    return { x = x1 - x0, y = y1 - y1 }
end

local function lenVec( vec )
    return mSqrt(vec.x * vec.x + vec.y * vec.y)
end

local function len2Vec( vec )
    return vec.x * vec.x + vec.y * vec.y
end

local function angle2Vec( angle )
    local screenAngle = mRad(-(angle+90))
    local x = mCos(screenAngle) 
    local y = mSin(screenAngle) 

    return { x=-x, y=y }
end

local function scaleVec( vec, scale ) 
    local x,y = vec.x * scale, vec.y * scale
    return { x=x, y=y }
end

