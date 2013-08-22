require "ssk.globals"
require "ssk.loadSSK"

local dg
local dg2 

local genericEventPrinter
genericEventPrinter = function( group, aTable, x, count, color  )
	local color = color or _WHITE_
	local x = x or 0
	local count = count or 1

	for k,v in pairs(aTable) do
		print(k,v)
		local tmp 
		if(type(v) == "table") then
			tmp = display.newText( group, tostring(k) .. " : " .. tostring(v),  0, 0, native.defaultFont, 10 )
			tmp:setReferencePoint( display.CenterLeftReferencePoint )
			tmp.x = x
			tmp.y = count * 24 + 20
			count = count + 1
			tmp:setTextColor(unpack(color))	
			count = genericEventPrinter( group, v, x + 20, count, color  )
		
		elseif(tonumber(v) ~= nil) then
			tmp = display.newText( group, tostring(k) .. " : " .. round(tonumber(v),4),  0, 0, native.defaultFont, 10 )
			tmp:setReferencePoint( display.CenterLeftReferencePoint )
			tmp.x = x
			tmp.y = count * 24 + 20
			count = count + 1
			tmp:setTextColor(unpack(color))

		else 
			tmp = display.newText( group, tostring(k) .. " : " .. tostring(v),  0, 0, native.defaultFont, 10 )
			tmp:setReferencePoint( display.CenterLeftReferencePoint )
			tmp.x = x
			tmp.y = count * 24 + 20
			count = count + 1
			tmp:setTextColor(unpack(color))
		end		
	end
	return count
end


local function onGenericEvent( event )
	safeRemove( dg )
	dg = display.newGroup()
	genericEventPrinter(dg, event, 40, 1, _WHITE_)
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


