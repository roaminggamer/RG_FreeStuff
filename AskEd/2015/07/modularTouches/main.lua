-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

--[[
		The question that prompted this answer, was really asking "How do I put my touch code in a module and re-use it from level to level."		

		This answer will show three modules, each defining a specific touch listener.

		+ touchModule1.lua - Allow us to attach a listener to objects that will turn object 'RED' when touched.
		+ touchModule2.lua - Allow us to attach a listener to objects that will turn object 'GREEN' when touched.
		+ touchModule3.lua - Allow us to attach a listener to objects that will destroy the object when it is touched.

		Note: touchModule1 and + touchModule2 both use touchModule3.  i.e. The first touch will change an object's color.  Then the touch
		listener will be replaced with the one from touchModule3.

--]]



--
-- 1. Load our listener modules
local listenerModule1 = require "touchListener1"
local listenerModule2 = require "touchListener2"
local listenerModule3 = require "touchListener3"


--
-- 2. Draw some example objects and attach our listeners
local tmp = display.newImageRect( "yellow_round.png", 80, 80 )
tmp.x = display.contentCenterX - 200
tmp.y = display.contentCenterY
listenerModule1.attach( tmp )


local tmp = display.newImageRect( "yellow_round.png", 80, 80 )
tmp.x = display.contentCenterX 
tmp.y = display.contentCenterY
listenerModule2.attach( tmp )


local tmp = display.newImageRect( "yellow_round.png", 80, 80 )
tmp.x = display.contentCenterX + 200
tmp.y = display.contentCenterY
listenerModule3.attach( tmp )

		