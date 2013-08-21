require "ssk.globals"
require "ssk.loadSSK"

local dg
local dg2 

local genericEventPrinter
genericEventPrinter = function( group, aTable, xOffset, count, color  )
	local color = color or _WHITE_
	local xOffset = xOffset or 0
	local count = count or 1
	for k,v in pairs(aTable) do
		local tmp 
		if(tonumber(v) ~= nil) then
			tmp = display.newText( group, tostring(k) .. " : " .. round(tonumber(v),4),  0, 0, native.defaultFont, 10 )
			tmp.x = centerX + xOffset
			tmp.y = count * 24 + 40
			count = count + 1
			tmp:setTextColor(unpack(color))

		elseif(type(v) == "table") then
			tmp = display.newText( group, tostring(k) .. " : " .. tostring(v),  0, 0, native.defaultFont, 10 )
			tmp.x = centerX + xOffset
			tmp.y = count * 24 + 40
			count = count + 1
			tmp:setTextColor(unpack(color))
			
			count = genericEventPrinter( v, count)
		else 
			tmp = display.newText( group, tostring(k) .. " : " .. tostring(v),  0, 0, native.defaultFont, 10 )
			tmp.x = centerX + xOffset
			tmp.y = count * 24 + 40
			count = count + 1
			tmp:setTextColor(unpack(color))
		end		
	end
	return count
end


local function onGenericEvent( event )
	safeRemove( dg )
	dg = display.newGroup()
	genericEventPrinter(dg, event, -160, 1, _WHITE_)
	return true
end

local function onAxisEvent( event )
	safeRemove( dg2 )
	dg2 = display.newGroup()
	genericEventPrinter(dg2, event, 160, 1, _YELLOW_)
	return true
end


-- Add the key event listener.
timer.performWithDelay(100, 
	function()
		Runtime:addEventListener( "key", onGenericEvent )
		Runtime:addEventListener( "mouse", onGenericEvent )
		Runtime:addEventListener( "axis", onAxisEvent )

	end )


