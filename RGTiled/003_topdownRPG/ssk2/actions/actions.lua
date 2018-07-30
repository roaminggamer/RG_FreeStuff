-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local actions = {}

if( _G.ssk ) then
	_G.ssk.actions = actions
end

actions.face 	= require "ssk2.actions.face"
actions.move 	= require "ssk2.actions.move"
actions.movep 	= require "ssk2.actions.movep"
actions.scene 	= require "ssk2.actions.scene"
actions.target = require "ssk2.actions.target"

return actions