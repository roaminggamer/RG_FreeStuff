require "ssk.globals"
require "ssk.loadSSK"

--[[
local  w = display.contentWidth
local  h = display.contentHeight
local  centerX = w/2
local  centerY = h/2
--]]

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


local inputObj = display.newText("", 0, 0, native.defaultFont, 24 )
inputObj.x = centerX
inputObj.y = centerY

local dg = ""


-- Called when a key event has been received.
local function onKeyEvent( event )

--[[
	local key = event.keyName
	local keyCode = event.nativeKeyCode
	local isCtrlDown = event.isCtrlDown
	local isAltDown = event.isAltDown
	local isShiftDown = event.isShiftDown
	local phase = event.phase

--]]
	safeRemove( dg )

	dg = display.newGroup()

	local count = 1
	for k,v in pairs(event) do
		local tmp = display.newText( dg, tostring(k) .. " : " .. tostring(v),  0, 0, native.defaultFont, 14 )
		tmp.x = centerX
		tmp.y = count * 24
		count = count + 1
	end



end

-- Add the key event listener.
timer.performWithDelay(100, 
	function()
		Runtime:addEventListener( "key", onKeyEvent );
		Runtime:addEventListener( "mouse", onKeyEvent )
		Runtime:addEventListener( "joystick", onKeyEvent )
	end )


