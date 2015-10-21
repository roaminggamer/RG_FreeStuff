display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
io.output():setvbuf("no") -- Don't use buffer for console messages

local common			= require "common"


local enableAutoFocus = true
local defocusFirst = common.oniOS

local maxFields = math.floor(common.fullh / 60)

local fields = {}
for i = 1, maxFields do
	local tmp = native.newTextField( common.centerX, common.bottom - 20 - (i-1) * 60, common.fullw - 120, 40  )	
	local label = display.newText( i, common.left + 10, tmp.y, native.systemFont, 32 )
	label.anchorX = 0
	fields[#fields+1] = tmp
end

if( enableAutoFocus ) then
	native.setKeyboardFocus( nil )
	local currentField  = 1
	local waitTime = 300
	native.setKeyboardFocus( fields[currentField] )

	local moveFocusUp
	local moveFocusDown
	
	moveFocusUp = function()
		if( currentField == #fields ) then
			moveFocusDown()
			return			
		end
		currentField = currentField + 1
		if( defocusFirst ) then
			native.setKeyboardFocus( nil )
		end
		native.setKeyboardFocus( fields[currentField] )
		timer.performWithDelay( waitTime, moveFocusUp )
	end

	moveFocusDown = function()
		if( currentField == 1 ) then
			moveFocusUp()
			return			
		end
		currentField = currentField - 1
		if( defocusFirst ) then
			native.setKeyboardFocus( nil )
		end
		native.setKeyboardFocus( fields[currentField] )
		timer.performWithDelay( waitTime, moveFocusDown )
	end
	timer.performWithDelay( 1000, moveFocusUp )
end

