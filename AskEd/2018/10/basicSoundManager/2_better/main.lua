io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "scripts.globals"
local soundMgr 	= require "scripts.soundMgr"
local easyButton 	= require "scripts.easyButton"
-- =====================================================

-- Run initialization script
require "scripts.init"


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
			post( "onSound", { sound = "count_" .. i } ) 
		end )
end




