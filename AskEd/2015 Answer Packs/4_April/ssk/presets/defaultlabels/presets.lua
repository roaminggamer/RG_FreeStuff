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
--
-- DO NOT MODIFY THIS FILE.  MODIFY "data/labels.lua" instead.
--
-- =============================================================

--
-- labelsInit.lua - Create Label Presets
--
local mgr = require "ssk.interfaces.labels" 

-- ============================
-- =============== DEFAULT
-- ============================
local params = 
{ 
	font      = native.systemFont,
	fontSize  = 12,
	textColor = { 255,255,255, 255 },
}
mgr:addLabelPreset( "default", params )
