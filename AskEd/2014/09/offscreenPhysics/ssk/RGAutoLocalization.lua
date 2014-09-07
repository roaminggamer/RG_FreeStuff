-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- Auto Localizer
-- =============================================================
--[[ 
    Usage (requires SSK already be loaded):

    At the very top of the file you wish to localize in:
    
    local mMin,mMax,mSqrt,pairs, ... etc. 
    ssk.al()
    ...

--]]
-- =============================================================
local newCircle         = ssk.display.circle
local newRect           = ssk.display.rect
local newImageRect      = ssk.display.imageRect
local easyIFC           = ssk.easyIFC
local ternary           = _G.ternary
local quickLayers       = ssk.display.quickLayers
local isDisplayObject   = _G.isDisplayObject
local easyPushButton    = ssk.easyPush.easyPushButton
local isInBounds        = ssk.easyIFC.isInBounds

local angle2Vector      = ssk.math2d.angle2Vector
local vector2Angle      = ssk.math2d.vector2Angle
local scaleVec          = ssk.math2d.scale
local addVec            = ssk.math2d.add
local subVec            = ssk.math2d.sub
local getNormals        = ssk.math2d.normals
local lenVec            = ssk.math2d.length
local lenVec2            = ssk.math2d.length2
local normVec           = ssk.math2d.normalize

-- Lua and Corona
local mAbs              = math.abs
local mRand             = math.random
local mDeg              = math.deg
local mRad              = math.rad
local mCos              = math.cos
local mSin              = math.sin
local mAcos             = math.acos
local mAsin             = math.asin
local mSqrt             = math.sqrt
local mCeil             = math.ceil
local mFloor            = math.floor
local mAtan2            = math.atan2
local mPi               = math.pi

local getInfo           = system.getInfo
local getTimer          = system.getTimer
local strMatch          = string.match
local strFormat         = string.format
local pairs             = pairs
local fnn               = fnn

local usage
local locals = {}
local i = 1
repeat
    local k, v = debug.getlocal(1, i)
    --print(k,v)
    if( k ~= "i" and 
        k ~= "locals" and 
        k ~= "usage") then

        if(k~=nil) then locals[k]=v end

        if(usage == nil and k ~= nil) then 
            usage = "local " .. k 
        elseif(k ~= nil) then
            usage = usage .. "," .. k
        end        
    end
    i=i+1

until nil == k
--table.dump(locals)
print(usage .. ";ssk.al.run()") 

local function run()
    local i = 1
    repeat
        local k, v = debug.getlocal(2, i)
        if k then
            if v == nil then
                if not locals[k] then
                    --print('No value for a local variable: ' .. k)
                else
                    debug.setlocal(2, i, locals[k])
                end
            end
            i = i + 1
        end
    until nil == k
end
local public = {}
public.run = run


if( not _G.ssk ) then
    _G.ssk = {}
end
_G.ssk.al = public

return public