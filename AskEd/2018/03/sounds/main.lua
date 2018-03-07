io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- Using SSK to make my life easier (buttons, etc.)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( )
-- =====================================================
local sound1 = audio.loadSound( "dashboard-alarm-bpm.mp3" )
local sound2 = audio.loadSound( "dashboard-alarm-pipikaka.mp3" )

local channel1 = audio.findFreeChannel( )
local channel2 = audio.findFreeChannel( channel1 + 1 )

local function onSound1( event )
	local target = event.target
	if( target:pressed() ) then
		audio.play( sound1, { channel = channel1 } )
	else
		audio.stop( channel1 )
	end
end

local function onSound2( event )
	local target = event.target
	if( target:pressed() ) then
		audio.play( sound2, { channel = channel2 } )
	else
		audio.stop( channel2 )
	end
end

ssk.easyIFC:presetToggle( nil, "default", centerX, centerY - 50, 200, 40, "alarm-bpm", onSound1 )

ssk.easyIFC:presetToggle( nil, "default", centerX, centerY + 50, 200, 40, "alarm-pip ...", onSound2 )