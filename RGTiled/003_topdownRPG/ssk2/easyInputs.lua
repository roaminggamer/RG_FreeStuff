-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Easy Inputs Loader
-- =============================================================
local easyInputs = {}
_G.ssk.easyInputs = easyInputs
easyInputs.joystick 		= require("ssk2.easyInputs.joystick")
easyInputs.oneTouch 		= require("ssk2.easyInputs.oneTouch")
easyInputs.twoTouch 		= require("ssk2.easyInputs.twoTouch")
easyInputs.oneStick 		= require("ssk2.easyInputs.oneStick")
easyInputs.twoStick 		= require("ssk2.easyInputs.twoStick")
easyInputs.oneStickOneTouch = require("ssk2.easyInputs.oneStickOneTouch")
return easyInputs