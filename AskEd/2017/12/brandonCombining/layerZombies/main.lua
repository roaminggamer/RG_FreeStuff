-- =============================================================
-- Your Copyright Statement Here
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================


local game = require "scripts.game"

local group = display.newGroup()

game.create( group )

game.start()
