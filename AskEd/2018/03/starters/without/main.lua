-- =============================================================
-- Minimalistic 'starter' main.lua
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
local common 		= require "scripts.common"
local game 			= require "scripts.game"


game.create( nil )


