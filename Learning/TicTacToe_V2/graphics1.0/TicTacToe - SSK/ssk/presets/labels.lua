-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Labels Presets
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
--
-- DO NOT MODIFY THIS FILE.  MODIFY "data/labels.lua" instead.
--
-- =============================================================

--
-- labelsInit.lua - Create Label Presets
--
local mgr = ssk.labels

-- ============================
-- =============== DEFAULT
-- ============================
local params = 
{ 
	font      = native.systemFont,
	fontSize  = 12,
	textColor     = { 255,255,255, 255 },
}
mgr:addPreset( "default", params )
