io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "scripts.globals"
-- =====================================================
local easyButton 	= require "scripts.easyButton"
local soundMgr 	= require "scripts.soundMgr"
-- =====================================================

-- Initialize sound manager.
soundMgr.addMusic( "soundtrack", "sounds/music/Kick Shock.mp3" )

soundMgr.addEffect( "count_1", "sounds/sfx/counting/count_1.mp3" )
soundMgr.addEffect( "count_2", "sounds/sfx/counting/count_2.mp3" )
soundMgr.addEffect( "count_3", "sounds/sfx/counting/count_3.mp3" )
soundMgr.addEffect( "count_4", "sounds/sfx/counting/count_4.mp3" )
soundMgr.addEffect( "count_5", "sounds/sfx/counting/count_5.mp3" )
soundMgr.addEffect( "count_6", "sounds/sfx/counting/count_6.mp3" )
soundMgr.addEffect( "count_7", "sounds/sfx/counting/count_7.mp3" )
soundMgr.addEffect( "count_8", "sounds/sfx/counting/count_8.mp3" )
soundMgr.addEffect( "count_9", "sounds/sfx/counting/count_9.mp3" )


-- Set Music Volume Low
soundMgr.setVolume( "music", 0.25 )

-- Print current volumes
print( "Global volume: ", soundMgr.getVolume() )
print( "Effect volume: ", soundMgr.getVolume( "effect" ) )
print( "Music volume: ", soundMgr.getVolume( "music" ) )


-- Start Soundtrack
soundMgr.play( "soundtrack", { loops = -1, fadein = 3000 } )



-- Create some buttons that play sound effects when clicked
local curX = centerX - 100
local curY = centerY - 100
for i = 1, 9 do
	local button = display.newImageRect( "images/" .. i .. ".png", 80,  80)
	button.x = curX
	button.y = curY

	curX = curX + 100

	if( i == 3 or i == 6 ) then
		curX = centerX - 100
		curY = curY + 100
	end

	easyButton.easyPush( button, 
		function() 
			print( "Pressed ", i )
			soundMgr.play( "count_" .. i ) 
		end )
end




