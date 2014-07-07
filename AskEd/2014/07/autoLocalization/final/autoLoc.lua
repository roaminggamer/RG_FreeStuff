-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- Auto Localizer
-- =============================================================
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
local mMin              = math.min
local mMax              = math.max

local getInfo           = system.getInfo
local getTimer          = system.getTimer
local strMatch          = string.match
local strFormat         = string.format
local pairs             = pairs

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

local function run()
    local i = 1
    repeat
        local k, v = debug.getlocal(2, i)
        if k then
            if v == nil then
                if not locals[k] then
                    print('No value for a local variable: ' .. k)
                else
                    debug.setlocal(2, i, locals[k])
                end
            end
            i = i + 1
        end
    until nil == k
end


-- =============================================================
-- Usage Dumping Code (Not Part of Auto Localization Mechansim)
-- =============================================================
function string:rpad(len, char) local theStr = self
    if char == nil then char = ' ' end
    return theStr .. string.rep(char, len - #theStr)
end
-- ==
--    table.dumpu( theTable [, padding ] ) - Dumps indexes and values inside single-level table (for debug) (UNSORTED)
-- ==
function table.dump(theTable, padding ) -- Sorted

    local theTable = theTable or  {}

    local function compare(a,b)
      return tostring(a) < tostring(b)
    end
    local tmp = {}
    for n in pairs(theTable) do table.insert(tmp, n) end
    table.sort(tmp,compare)

    local padding = padding or 30
    print("\Table Dump:")
    print("-----")
    if(#tmp > 0) then
        for i,n in ipairs(tmp) do       

            local key = tmp[i]
            local value = tostring(theTable[key])
            local keyType = type(key)
            local valueType = type(value)
            local keyString = tostring(key) .. " (" .. keyType .. ")"
            local valueString = tostring(value) .. " (" .. valueType .. ")" 

            keyString = keyString:rpad(padding)
            valueString = valueString:rpad(padding)

            print( keyString .. " == " .. valueString ) 
        end
    else
        print("empty")
    end
    print("-----\n")
end

-- Comment these lines out to hide usage message and dumps
-- Print all locals found above in alphabetic order
table.dump(locals)
print(usage .. ';require("autoLoc").run()') 

-- =============================================================
-- Package up the Module
-- =============================================================
local public = {}
public.run = run
return public