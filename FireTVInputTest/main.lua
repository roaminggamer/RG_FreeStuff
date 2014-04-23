io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

require "ssk.globals"
require "ssk.loadSSK"

local dg 	= display.newGroup()

local function purgeGroup( group )
	while (group.numChildren > 0 ) do
		display.remove(group[1])
	end
end

local lastValues = {}

local function printLastThree( code, obj )

	local x = obj.x + obj.contentHeight/2
	local y = obj.y - obj.contentWidth/2

	local values = lastValues[code] or {}
	local fontSize = 8
	local tweenY   = fontSize + 2
	local oy = 7

	for i = 1, 3 do
		local data = values[i] 
		local txt
		if( data == nil ) then
			txt = display.newText( dg, code .. " / please press / me", 0, 0, system.nativeFont, fontSize)
		else
			txt = display.newText( dg, data[1] .. " / " .. data[2] .. " / " .. data[3] , 0, 0, system.nativeFont, fontSize)
		end
		txt.anchorX = 0
		txt.x = x + 10
		txt.y = y + tweenY/2 + oy
		y = y + tweenY
	end

end

local function nc( obj )

	local x = obj.x + obj.contentHeight/2
	local y = obj.y

	local fontSize = 8
	local tweenY   = fontSize + 2
	local oy = 7

	local txt = display.newText( dg, "not catchable", 0, 0, system.nativeFont, fontSize)
	txt.anchorX = 0
	txt.x = x + 10
	txt.y = y
end

local function showResults()
	purgeGroup(dg)

	local tmp = display.newImageRect( dg, "images/voicesearch.png", 40, 40)
	tmp.anchorX = 0.5
	tmp.anchorY = 0.5
	tmp.x = 20
	tmp.y = 20
	nc( tmp )
	display.newLine( dg, 0, tmp.y + tmp.contentHeight/2, w, tmp.y + tmp.contentHeight/2)
	
	local tmp = display.newImageRect( dg, "images/back.png", 40, 40)
	tmp.x = 20
	tmp.y = 60
	printLastThree( 4, tmp )
	display.newLine( dg,0, tmp.y + tmp.contentHeight/2, w, tmp.y + tmp.contentHeight/2)

	local tmp = display.newImageRect( dg, "images/home.png", 40, 40)
	tmp.x = 20
	tmp.y = 100
	nc( tmp )
	display.newLine( dg,0, tmp.y + tmp.contentHeight/2, w, tmp.y + tmp.contentHeight/2)

	local tmp = display.newImageRect( dg, "images/menu.png", 40, 40)
	tmp.x = 20
	tmp.y = 140
	printLastThree( 82, tmp )
	display.newLine( dg,0, tmp.y + tmp.contentHeight/2, w, tmp.y + tmp.contentHeight/2)

	local tmp = display.newImageRect( dg, "images/play_pause.png", 40, 40)
	tmp.x = 20
	tmp.y = 180
	printLastThree( 85, tmp )
	display.newLine( dg,0, tmp.y + tmp.contentHeight/2, w, tmp.y + tmp.contentHeight/2)

	local tmp = display.newImageRect( dg, "images/rewind.png", 40, 40)
	tmp.x = 20
	tmp.y = 220
	printLastThree( 89, tmp )
	display.newLine( dg,0, tmp.y + tmp.contentHeight/2, w, tmp.y + tmp.contentHeight/2)

	display.newLine( dg, centerX - 10 , 0, centerX - 10, h)


	local tmp = display.newImageRect( dg, "images/fastforward.png", 40, 40)
	tmp.x = 250
	tmp.y = 20
	printLastThree( 90, tmp )

	local tmp = display.newImageRect( dg, "images/ringup.png", 50, 40)
	tmp.x = 255
	tmp.y = 60
	printLastThree( 19, tmp )

	local tmp = display.newImageRect( dg, "images/ringdown.png", 50, 40)
	tmp.x = 255
	tmp.y = 100
	printLastThree( 20, tmp )

	local tmp = display.newImageRect( dg, "images/ringleft.png", 50, 40)
	tmp.x = 255
	tmp.y = 140
	printLastThree( 21, tmp )

	local tmp = display.newImageRect( dg, "images/ringright.png", 50, 40)
	tmp.x = 255
	tmp.y = 180
	printLastThree( 22, tmp )

	local tmp = display.newImageRect( dg, "images/select.png", 50, 40)
	tmp.x = 255
	tmp.y = 220
	printLastThree( 23, tmp )

	local archInfo = system.getInfo ( "architectureInfo" )
	local model = system.getInfo ( "model" )

	local tmp = display.newText( dg, "Arch info: " .. archInfo, 0, 0, system.nativeFont, 12)
	tmp.anchorX = 0
	tmp.x = 10
	tmp.y = 250

	local tmp = display.newText( dg, "Mode: " .. model, 0, 0, system.nativeFont, 12)
	tmp.anchorX = 0
	tmp.x = 10
	tmp.y = 270

	local tmp = display.newText( dg, "Native Resolution: " .. display.pixelWidth .. " x " .. display.pixelHeight, 0, 0, system.nativeFont, 12)
	tmp.anchorX = 0
	tmp.x = 10
	tmp.y = 290

end

Runtime:addEventListener( "enterFrame", showResults)


local getTimer = system.getTimer
local minTime 	= 100
local floodTimer = getTimer()
local function onGenericEvent( event )
	local curTime = getTimer()
	if( (curTime - floodTimer) < minTime ) then return true end
	floodTime = curTime

	local nativeKeyCode = event.nativeKeyCode
	local values = lastValues[nativeKeyCode] or {}
	lastValues[nativeKeyCode] = values
	values[#values+1] = { event.nativeKeyCode, event.keyName, event.phase }
	--table.dump(event)
	--table.print_r(lastValues)
	print(nativeKeyCode)
	return true
end

local function onAxisEvent( event )
	local curTime = getTimer()
	if( (curTime - floodTimer) < minTime ) then return true end
	floodTime = curTime
	return true
end

-- Add the key event listener.
timer.performWithDelay(100, 
	function()
		Runtime:addEventListener( "key", onGenericEvent )
		--Runtime:addEventListener( "mouse", onGenericEvent )
		--Runtime:addEventListener( "axis", onAxisEvent )
	end )

