-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
--   Last Updated: 29 NOV 2016
-- Last Validated: 29 NOV 2016
-- =============================================================
local measure = {}

local function round(val, n)
   if (n) then return math.floor( (val * 10^n) + 0.5) / (10^n)
   else return math.floor(val+0.5)
   end
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
	collectgarbage("collect")
	local before = collectgarbage( "count" )
	local retVal = require( path )
	collectgarbage("collect")
	local after = collectgarbage( "count" )
	print( string.rpad( path, 60 ) .. " : " .. string.lpad(round( after - before ) .. " KB", 10 ) )
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