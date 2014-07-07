
-- ==
--    string:rpad( len, char ) - Places padding on right side of a string, such that the new string is at least len characters long.
-- ==
function string:rpad(len, char)
	local theStr = self
    if char == nil then char = ' ' end
    return theStr .. string.rep(char, len - #theStr)
end



-- ==
--    table.dump( theTable [, padding ] ) - Dumps indexes and values inside single-level table (for debug)
-- ==
function table.dump(theTable, padding )
	local padding = padding or 30
	print("\Table Dump:")
	print("-----")
	if(theTable) then
		for k,v in pairs(theTable) do 
			local key = tostring(k)
			local value = tostring(v)
			local keyType = type(k)
			local valueType = type(v)
			local keyString = key .. " (" .. keyType .. ")"
			local valueString = value .. " (" .. valueType .. ")" 

			keyString = keyString:rpad(padding)
			valueString = valueString:rpad(padding)

			print( keyString .. " == " .. valueString ) 
		end
	else
		print("empty")
	end
	print("-----\n")
end


local bench = require "simpleBench"
local round = bench.round


--[[ Fail!
local function import( aName, ... ) 
  local aModule = require( aName ) 
  local aFunction = debug.getinfo( 2, 'f' ).func 
  local _, env = debug.getupvalue( aFunction, 1 ) 

  for anIndex = 1, select( '#', ... ) do 
    local aName = select( anIndex, ... ) 
    print(aName)
    env[ aName ] = aModule[ aName ] 
  end 
end 

import( 'math', 'min', 'max' ) 

print( min, min( 1, 2 ) ) 
print( max, max( 1, 2 ) ) 
print( math ) 
--]]

local localize = require "localize1"

local bob = 10

local min,max,sqrt; localize.doit3( "math" )

print( min, min( 1, 2 ) ) 
print( max, max( 1, 2 ) ) 


local function edo( test )
	test = 1
	return test
end

--[[
local bob = 10
local name,value = debug.getlocal(1,5)
print(name,value)
print(bob)
debug.setlocal(1,4,20)
print(bob)
--]]

--debug.setlocal()

--table.dump( debug.getfenv( math.sqrt ) )


--[[ works! 
local function import( aName ) 
  local aModule = require( aName ) 
  local anIndex = 0 
  local aList = {} 

  while true do 
    anIndex = anIndex + 1 

    if debug.getlocal( 2, anIndex ) == nil then 
      break 
    end 
  end 

  for anIndex = anIndex - 1, 1, -1 do 
    local aName, aValue = debug.getlocal( 2, anIndex ) 

    if aModule[ aName ] == nil or aValue ~= nil then 
      break 
    end 

    debug.setlocal( 2, anIndex, aModule[ aName ] ) 
  end 
end 

local min, max, sqrt = nil; import( 'math' ); 

print( min, min( 1, 2 ) ) 
print( max, max( 1, 2 ) ) 
--]]





--[[
--
-- Test math.sqrt vs localized function.
-- 
local mSqrt = math.sqrt

-- Slow version
local function test1( iter)
	for i = 1, 100000 do
		--math.sqrt( i )
		--mSqrt( i )
		sqrt( i )
	end
end

-- Faster Version

local function test2()
	for i = 1, 100000 do
		mSqrt( i )
		
	end
end

-- Measuring attempt 1 (one iteration per test)
--
local time1,time2,delta,speedup = bench.measureABTime( test1, test2, 100 )
print( "\nSingle run 100,000 calculations.")
print( "Test 1: " .. round(time1/1000,2) .. " seconds.")
print( "Test 2: " .. round(time2/1000,2) .. " seconds.")
print( "Test 2 is " .. speedup .. " percent faster .")
if( speedup == 0 ) then
	print( "Tests may have run too fast to measure appreciable speedup.")
end
--]]