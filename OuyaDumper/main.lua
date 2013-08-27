require "ssk.globals"
require "ssk.loadSSK"


local knownFields = {}
local knownFields2 = {}

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

local genericFieldStripper
genericFieldStripper = function( kf, aTable, inTable )

	local inTable = inTable or ""

	if(string.len(inTable) > 0) then
		inTable = inTable .. " --> " 
	end

	for k,v in pairs(aTable) do
		print(k,v)
		if(type(v) == "table") then
			kf[inTable .. k] = type(v)
			genericFieldStripper( kf, v, k  )		
		
		elseif(type(v) == "userdata") then
			-- Ignore
		else
			kf[inTable .. k]  = type(v)
		end		
	end
end


genericFieldPrinter = function( group, kf, x, color  )
	local color = color or _WHITE_
	local x = x or 20
	local count = count or 1

	for k,v in pairs(kf) do
		tmp = display.newText( group, k .. " : " .. v,  0, 0, native.defaultFont, 10 )
		tmp:setReferencePoint( display.CenterLeftReferencePoint )
		tmp.x = x
		tmp.y = count * 12 + 10
		count = count + 1
		tmp:setTextColor(unpack(color))
	end
end


local function onGenericEvent( event )
	safeRemove( dg )
	dg = display.newGroup()
	
	genericEventPrinter(dg, event, 40, 1, _WHITE_)
	
	--genericFieldStripper( knownFields, event)
	--genericFieldPrinter( dg, knownFields, 40 )
	
	return true
end

local function onAxisEvent( event )
	safeRemove( dg2 )
	dg2 = display.newGroup()
	
	genericEventPrinter(dg2, event, 200, 1, _YELLOW_)
	
	--genericFieldStripper( knownFields2, event)
	--genericFieldPrinter(dg2, knownFields2, 200, _YELLOW_)

	return true
end

-- Add the key event listener.
timer.performWithDelay(100, 
	function()
		Runtime:addEventListener( "key", onGenericEvent )
		Runtime:addEventListener( "mouse", onGenericEvent )
		Runtime:addEventListener( "axis", onAxisEvent )

	end )

