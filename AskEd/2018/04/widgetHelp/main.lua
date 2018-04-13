io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================


-- =====================================================
-- YOUR CODE BELOW
-- =====================================================
local widget = require "widget"

-- https://marketplace.coronalabs.com/corona-plugins/flashlight
local flashlight = require('plugin.flashlight')

-- This event is dispatched to the global Runtime object by "didLoadMain:" in MyCoronaDelegate.mm
local function delegateListener( event )
	native.showAlert(  "Event dispatched from 'didLoadMain:'",
						   "of type: " .. tostring( event.name ),
							{ "OK" } )
	end
	Runtime:addEventListener( "delegate", delegateListener )

local function listener( event )
	print( "Received event from Flashlight plugin (" .. event.name .. "): ", event.message )
end

local lightState = "off"

local function handleButtonEvent( event )
    if ( lightState == "off" ) then
        --flashlight.on()
        lightState = "on"
        event.target:setLabel( "Turn Off" )
    else
        --flashlight.off()
        lightState = "off"
        event.target:setLabel( "Turn On" )
    end
    return true
end 

local onOffSwitch = widget.newButton( 
{
	x = display.contentCenterX,
	y = display.contentCenterY,
	label = "Turn On",
	onRelease = handleButtonEvent
} )

-- http://spiralcodestudio.com/plugin-flashlight/
-- Doesn't have an INIT function
--flashlight.init( listener )

-- =====================================================
-- YOUR CODE ABOVE
-- =====================================================


