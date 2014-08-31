local _print = print
local strFind = string.find
local appRoot = "defendergame" -- The root folder of your game, exactly as it is spelled, including case.  Will be different on devices, so careful.

local showPath = true -- If set to true, will print path so you can discover appRoot string.


-- DO NOT MODIFY BELOW HERE
-- DO NOT MODIFY BELOW HERE
-- DO NOT MODIFY BELOW HERE
local printFuncFile = function( level ) 
	level = level or 2
	local info = debug.getinfo(level,'S')
	if(showPath) then print(info.source); end
	local start = strFind( info.source, appRoot)
	local source = string.sub( info.source, start )
	local printString = source .. " : " .. debug.getinfo( level ).name .. "() @ " .. info.linedefined
	print(  printString )
	return printString
end

local getFuncFile = function( level ) 
	level = level or 2
	local info = debug.getinfo(level,'S')
	if(showPath) then print(info.source); end
	local start = strFind( info.source, appRoot)
	local source = string.sub( info.source, start )
	local printString = source .. " : " .. debug.getinfo( level ).name .. "() @ " .. info.linedefined
	return printString
end

local getFuncFileAuto = function( level ) 
	level = level or 10 -- increase if need be but this is pretty deep recursion
	while( level > 2 and (debug.getinfo( level ) == nil or debug.getinfo( level ).name == nil) ) do
		level = level - 1
	end
	print("**********************************", level)
	print("**********************************", level)
	print("**********************************", level)
	print("**********************************", level)
	return
	local info = debug.getinfo(level,'S')
	if(showPath) then print(info.source); end
	local start = strFind( info.source, appRoot)
	local source = string.sub( info.source, start )
	if(level == 2) then source = "appRoot/main.lua" end
	local printString = source .. " : " .. debug.getinfo( level ).name .. "() @ " .. info.linedefined
	return printString
end
-- DO NOT MODIFY ABOVE HERE
-- DO NOT MODIFY ABOVE HERE
-- DO NOT MODIFY ABOVE HERE

--
-- Global replacement for math.min with debugified version here:
-- 

_G.mathMin = function( ... )
	local from = getFuncFileAuto( 10 )
	print("Calling math min from: ", from)
	print("With arguments: ", unpack(arg) )
	--return math.min( unpack(arg) )
	return 1
end
