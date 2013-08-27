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
	--genericEventPrinter(dg, event, 40, 1, _WHITE_)
	genericFieldStripper( knownFields, event)
	genericFieldPrinter( dg, knownFields, 20 )
	return true
end

local function onAxisEvent( event )
	safeRemove( dg2 )
	dg2 = display.newGroup()
	--genericEventPrinter(dg2, event, 160, 1, _YELLOW_)
	
	genericFieldStripper( knownFields2, event)
	genericFieldPrinter(dg2, knownFields2, centerX + 40, _YELLOW_)

	return true
end
--[[

-- Add the key event listener.
timer.performWithDelay(100, 
	function()
		Runtime:addEventListener( "key", onGenericEvent )
		Runtime:addEventListener( "mouse", onGenericEvent )
		Runtime:addEventListener( "axis", onAxisEvent )

	end )

--]]


-- DID NOTHING ?
--[[
local function onInputDeviceStatusChanged( event )
    table.dump(event)
end

-- Add the input device status event listener.
Runtime:addEventListener( "inputDeviceStatus", onInputDeviceStatusChanged )
--]]


-- Not Really useful, returns array of 'userdata'
--[[
-- Fetch all input devices currently connected to the system.
local inputDevices = system.getInputDevices()

-- Print all of the input devices found to the log.
if #inputDevices > 0 then
    print("Input Devices Found:")
    for index = 1, #inputDevices do
        print("- " .. inputDevices[index].displayName)
		print(type(inputDevices[index]))
		if(type(inputDevices[index]) ==  "table" ) then
			table.dump(inputDevices[index])
		end
    end
else
    print("No input devices found.")
end

--]]


--[[

-- Fetch all input devices currently connected to the system.
local inputDevices = system.getInputDevices()

-- Traverse all input devices.
for deviceIndex = 1, #inputDevices do
    -- Fetch the input device's axes.
    local inputAxes = inputDevices[deviceIndex]:getAxes()
    if #inputAxes > 0 then
        -- Print all available axes to the log.
        for axisIndex = 1, #inputAxes do
            print(inputAxes[axisIndex].descriptor)
        end
    else
        -- Device does not have any axes.
        print(inputDevices[deviceIndex].descriptor .. ": No axes found.")
    end
end
--]]


local group
joystickAxesPrinter = function(  )

	if(group) then group:removeSelf() end

	group = display.newGroup()

	local inputDevices = system.getInputDevices()

	local count = 1

	for deviceIndex = 1, #inputDevices do
		-- Fetch the input device's axes.
		local inputAxes = inputDevices[deviceIndex]:getAxes()
		if #inputAxes > 0 then
			-- Print all available axes to the log.
			for axisIndex = 1, #inputAxes do
				local str = inputAxes[axisIndex].descriptor .. " || " .. 
				inputAxes[axisIndex].type .. " || " .. 
				inputAxes[axisIndex].minValue .. " || " .. 
				inputAxes[axisIndex].maxValue .. " || " .. 
				inputAxes[axisIndex].number
				local tmp = display.newText( group,str,  0, 0, native.defaultFont, 10 )
				tmp:setReferencePoint( display.CenterLeftReferencePoint )
				tmp.x = 20
				tmp.y = count * 12 + 10
				count = count + 1
			end
		end
	end
end

Runtime:addEventListener( "enterFrame", joystickAxesPrinter )


