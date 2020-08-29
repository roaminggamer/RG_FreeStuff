io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { launchArgs       = ..., 
                gameFont        = "Raleway-Light.ttf",
                measure         = true,
                debugLevel      = 0,
                logic = { "puzzle.grid" } } )
-- =====================================================
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================
--if( ssk.misc.countLocals ) then ssk.misc.countLocals(1) end

-- Global used in game this example to turn on/off debug settings.
_G.enableDebugSettings = false

local game = require "scripts.game"

local group = display.newGroup() 

local curPuzzle = 1

game.create( group, curPuzzle )

local function onSolved()
	curPuzzle = curPuzzle + 1
	if(curPuzzle>10) then
		curPuzzle = 1
	end
	
	game.destroy()
	
	game.create( group, curPuzzle )
end
listen( 'onSolved', onSolved )


