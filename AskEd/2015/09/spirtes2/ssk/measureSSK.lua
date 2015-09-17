-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- 								License
-- =============================================================
--[[
	> SSK is free to use.
	> SSK is free to edit.
	> SSK is free to use in a free or commercial game.
	> SSK is free to use in a free or commercial non-game app.
	> SSK is free to use without crediting the author (credits are still appreciated).
	> SSK is free to use without crediting the project (credits are still appreciated).
	> SSK is NOT free to sell for anything.
	> SSK is NOT free to credit yourself with.
]]
-- =============================================================

local measure = {}

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
	print( string.rpad( path, 35 ) .. " : " .. string.lpad(round( after - before ) .. " KB", 10 ) )
	return retVal
end
function measure.summary() 
	collectgarbage("collect")
	local postMem = collectgarbage( "count" )
	print("---------------------------------------")
	print(  string.rpad( "SSK Total", 25 ) .. " : " .. string.lpad(round( (postMem - preMem), 2 ) .. " KB", 10) )
	print("---------------------------------------")
end

return measure