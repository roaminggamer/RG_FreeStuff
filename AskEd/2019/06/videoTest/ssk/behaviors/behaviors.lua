-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- SSK behaviors
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
local behaviors = {}
if( _G.ssk ) then _G.ssk.behaviors = behaviors end

-- Prep Manager and Utils
behaviors.manager = require "ssk.behaviors.manager"
behaviors.utils   = require "ssk.behaviors.utils"
local bmgr        = behaviors.manager
local butils      = behaviors.utils

-- Load Behaviors
require "ssk.behaviors.collision.onCollisionBegan_ExecuteCallback"
require "ssk.behaviors.collision.onCollisionBegan_PrintMessage"
require "ssk.behaviors.collision.onCollisionEnded_ExecuteCallback"
require "ssk.behaviors.collision.onCollisionEnded_PrintMessage"
require "ssk.behaviors.collision.onPostCollision_PrintMessage"
require "ssk.behaviors.collision.onPreCollision_PrintMessage"
require "ssk.behaviors.movers.dragDrop"
require "ssk.behaviors.movers.faceTouch"
require "ssk.behaviors.movers.faceTouchFixedRate"
require "ssk.behaviors.movers.moveToTouch"
require "ssk.behaviors.movers.moveToTouchFixedRate"
require "ssk.behaviors.movers.onTouch_applyContinuousForce"
require "ssk.behaviors.movers.onTouch_applyForwardForce"
require "ssk.behaviors.movers.onTouch_applyTimedForce"
require "ssk.behaviors.physics.physics_hasForce"

return behaviors


