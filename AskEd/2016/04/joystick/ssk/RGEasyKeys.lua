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
local getTimer  = system.getTimer

local debugLevel = 0
local onOSX = system.getInfo("platformName") == "Mac OS X"
local onWin = system.getInfo("platformName") == "Win"

if( not table.dump ) then
	function string:rpad(len, char)
		local theStr = self
	    if char == nil then char = ' ' end
	    return theStr .. string.rep(char, len - #theStr)
	end

	function table.dump(theTable, padding ) -- Sorted

		local theTable = theTable or  {}

		local tmp = {}
		for n in pairs(theTable) do table.insert(tmp, n) end
		table.sort(tmp)

		local padding = padding or 30
		print("\nTable Dump:")
		print("-----")
		if(#tmp > 0) then
			for i,n in ipairs(tmp) do 		

				local key = tostring(tmp[i])
				local value = tostring(theTable[key])
				local keyType = type(key)
				local valueType = type(value)
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
end

local function keyCleaner( event )
	if( onWin ) then 
		return event 
 	end

 	local code = event.nativeKeyCode

 	local codes = {}
 	codes[122] = 'f1'
 	codes[120] = 'f2'
 	codes[99] = 'f3'
 	codes[118] = 'f4'
 	codes[96] = 'f5'
 	codes[97] = 'f6'
 	codes[98] = 'f7'
 	codes[100] = 'f8'
 	codes[101] = 'f9'   -- NOT SURE; OFF LIMITS (SPECIAL USE ON OSX)
 	codes[102] = 'f10'  -- NOT SURE; OFF LIMITS (SPECIAL USE ON OSX)
 	codes[103] = 'f11'  -- NOT SURE; OFF LIMITS (SPECIAL USE ON OSX)
 	codes[104] = 'f12'  -- NOT SURE; OFF LIMITS (SPECIAL USE ON OSX)
 	codes[124] = 'right'
 	codes[123] = 'left'
 	codes[126] = 'up'
 	codes[125] = 'down'
 	codes[115] = 'home'
 	codes[116] = 'pageUp'
 	codes[121] = 'pageDown'
 	codes[119] = 'end'
 	codes[114] = 'insert'
 	codes[117] = 'deleteForward'
 	codes[51] = 'deleteBack'
 	codes[48] = 'tab'
 	codes[53] = 'escape'
 	codes[36] = 'enter'
 	codes[76] = 'enter' -- DUPLICATED
 	codes[49] = 'space' 
 	
 	if( codes[code] ) then
 		event.keyName = codes[code]
 	end

	return event 
end

local onKey 

-- =======================
-- onKey() - Event listener for keyboard inputs.
-- =======================
onKey = function( event )

	local event = keyCleaner( event )

	local key = event.keyName
	local keyCode = event.nativeKeyCode
	local isCtrlDown = event.isCtrlDown
	local isAltDown = event.isAltDown
	local isShiftDown = event.isShiftDown
	local phase = event.phase

	if( debugLevel >= 1) then
		print( tostring(key) .. " :" .. tostring(keyCode) .. " :" .. tostring(phase) )
	end

	event.name = nil

	if( debugLevel >= 2 ) then
		print("BOOYA")
		post( "ON_KEY", event, 2 )
	else
		post( "ON_KEY", event)
	end

    return false
end

timer.performWithDelay(100, function() Runtime:addEventListener( "key", onKey ) end )
