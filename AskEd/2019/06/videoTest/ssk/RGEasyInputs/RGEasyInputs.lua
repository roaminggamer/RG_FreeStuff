-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- 								License
-- =============================================================
--[[
	> SSK is free to use.
	> SSK is free to edit.
	> SSK is free to use in a free or commercial game.
	> SSK is free to use in a free or commercial non-game app.
	> SSK is free to use without crediting the author (credits are still appreciated).
	> SSK is free to use without crediting the project (credits are still appreciated).
	> SSK is NOT free to sell for anything.
	> SSK is NOT free to credit yourself with.
]]
-- =============================================================
local easyInputs = {}
_G.ssk.easyInputs = easyInputs
easyInputs.joystick 		= require("ssk.RGEasyInputs.joystick")
easyInputs.cornerButtons 	= require("ssk.RGEasyInputs.cornerButtons")
easyInputs.oneTouch 		= require("ssk.RGEasyInputs.oneTouch")
easyInputs.twoTouch 		= require("ssk.RGEasyInputs.twoTouch")
easyInputs.oneStick 		= require("ssk.RGEasyInputs.oneStick")
easyInputs.twoStick 		= require("ssk.RGEasyInputs.twoStick")
easyInputs.oneStickOneTouch = require("ssk.RGEasyInputs.oneStickOneTouch")
--table.dump(easyInputs)
return easyInputs