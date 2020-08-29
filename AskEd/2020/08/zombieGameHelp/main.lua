io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================

local helpers 	= require "scripts.helpers"
local common 	= require "scripts.common"
local game 		= require "scripts.game"

local group = display.newGroup()

game.create( group )

-- Uncomment next line for easy way to test that destroying is safe and nothing breaks.
-- timer.performWithDelay( 1000, function() game.destroy() end )

