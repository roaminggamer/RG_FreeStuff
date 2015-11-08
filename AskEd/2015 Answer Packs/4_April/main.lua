-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

_G.details = {}
details.installment = 1
details.week = 28
details.month = "April"
details.year = 2015
details.questions = 10

_G.gameFont = native.systemFont
_G.gameFont = "Abierta"

require "ssk.loadSSK"

require "presets.gel.presets"

local composer 	= require "composer" 

composer.gotoScene( "ifc.mainMenu" )
--composer.gotoScene( "ifc.splash" )

