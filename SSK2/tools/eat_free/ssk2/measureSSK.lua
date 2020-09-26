-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local measure = {}
local function countGlobals()
	local count = 0
	for k,v in pairs(_G) do
		count = count+1
	end
	return count
end

local function round(val, n)
   if (n) then return math.floor( (val * 10^n) + 0.5) / (10^n); end
   return math.floor(val+0.5)
end
function string:lpad (len, char)
	local theStr = self
    if char == nil then char = ' ' end
    return string.rep(char, len - #theStr) .. theStr
end
function string:rpad(len, char)
	local theStr = self
    if char == nil then char = ' ' end
    return theStr .. string.rep(char, len - #theStr)
end
collectgarbage("collect")
local preMem = collectgarbage( "count" )
function measure.measure_require( path )
	local gCount1 = countGlobals()
	local gCount2

	collectgarbage("collect")
	local before = collectgarbage( "count" )
	local retVal = require( path )
	collectgarbage("collect")
	local after = collectgarbage( "count" )
	gCount2 = countGlobals()
	local extraG = gCount2 - gCount1
	if( extraG == 0 ) then
		print( string.rpad( path, 60 ) .. " : " .. string.lpad(round( after - before ) .. " KB", 10 ) )		
	else
		print( string.rpad( path, 60 ) .. " : " .. string.lpad(round( after - before ) .. " KB", 10 ) .. " : " .. tostring(extraG) .. " globals added." )
	end	
	return retVal
end
function measure.summary() 
	collectgarbage("collect")
	local postMem = collectgarbage( "count" )
	print(string.rep("-",74))
	print(  string.rpad( "SSK Total", 60 ) .. " : " .. string.lpad(round( (postMem - preMem), 2 ) .. " KB", 10) )
	print(string.rep("-",74))
end

return measure