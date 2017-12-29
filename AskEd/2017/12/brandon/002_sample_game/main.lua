-- =============================================================
-- Your Copyright Statement Here
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================


local game = require "scripts.game"

local group = display.newGroup()

game.create( group )
timer.performWithDelay( 4000, function() game.start() end )
timer.performWithDelay( 8000, function() game.stop() end )
timer.performWithDelay( 12000, function() game.destroy() end )
