require "ssk.globals"
require "ssk.loadSSK"


local knownFields = {}
local knownFields2 = {}

local dg 	= display.newGroup()
local dg2  = display.newGroup()

local function purgeGroup( group )
	while (group.numChildren > 0 ) do
		display.remove(group[1])
	end
end

local genericEventPrinter
genericEventPrinter = function( group, aTable, x, count, color  )
	local color = color or _WHITE_
	local x = x or 0 
	local count = count or 1
	local tweenY = 16 
	local fontSize = 14

	for k,v in pairs(aTable) do
		print(k,v)
		local tmp 
		if(type(v) == "table") then
			tmp = display.newText( group, tostring(k) .. " : " .. tostring(v),  0, 0, native.defaultFont, fontSize )
			tmp:setReferencePoint( display.CenterLeftReferencePoint )
			tmp.x = x
			tmp.y = count * tweenY 
			count = count + 1
			tmp:setFillColor(unpack(color))	
			count = genericEventPrinter( group, v, x + 20, count, color  )
		
		elseif(tonumber(v) ~= nil) then
			tmp = display.newText( group, tostring(k) .. " : " .. round(tonumber(v),4),  0, 0, native.defaultFont, fontSize )
			tmp:setReferencePoint( display.CenterLeftReferencePoint )
			tmp.x = x
			tmp.y = count * tweenY 
			count = count + 1
			tmp:setFillColor(unpack(color))

		else 
			tmp = display.newText( group, tostring(k) .. " : " .. tostring(v),  0, 0, native.defaultFont, fontSize )
			tmp:setReferencePoint( display.CenterLeftReferencePoint )
			tmp.x = x
			tmp.y = count * tweenY 
			count = count + 1
			tmp:setFillColor(unpack(color))
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
		tmp:setFillColor(unpack(color))
	end
end


local getTimer = system.getTimer
local minTime 	= 100
local floodTimer = getTimer()

local function onGenericEvent( event )
	local curTime = getTimer()
	if( (curTime - floodTimer) < minTime ) then return true end
	floodTime = curTime

	purgeGroup( dg )

	genericEventPrinter(dg, event, 10-unusedWidth/2, 1, _WHITE_)

	--genericFieldStripper( knownFields, event)
	--genericFieldPrinter( dg, knownFields, 40 )
	
	return true
end

local function onAxisEvent( event )
	local curTime = getTimer()
	if( (curTime - floodTimer) < minTime ) then return true end
	floodTime = curTime

	purgeGroup( dg2 )
	
	genericEventPrinter(dg2, event, 240 + unusedWidth/2, 1, _YELLOW_)
	
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

