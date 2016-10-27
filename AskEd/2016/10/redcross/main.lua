-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
require("ssk_core.globals.variables")
require("ssk_core.globals.functions")
require("ssk_core.extensions.display")
require("ssk_core.extensions.io")
require("ssk_core.extensions.math")
require("ssk_core.extensions.string")
require("ssk_core.extensions.table")
require("ssk_core.extensions.transition_color")
-- =============================================================
-- Above adds variables and functions I often use in answers.
-- =============================================================

local physics = require "physics"
physics.start()
physics.setGravity(0,10)
physics.setDrawMode( "hybrid" )

local composer = require "composer"
composer.gotoScene( "scenes.scene1" )
