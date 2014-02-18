-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2012 
-- =============================================================
-- User Buttons Presets
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
-- =============================================================
--
-- labelsInit.lua - Create Label Presets
--
local mgr			= require( "ssk.factories.f_buttons" )    -- Buttons, Sliders

-- ============================
-- ========= DEFAULT BUTTON
-- ============================
local default_params = 
{ 
	textColor		   = _WHITE_,
	fontSize           = 16,
	textFont           = native.systemFontBold,
	unselRectGradient  = graphics.newGradient ( { 170, 170, 170, 255  }, { 64, 64, 64, 255 }, "down" ),
	selRectGradient    = graphics.newGradient ( { 200, 200, 200, 255  }, { 94, 94, 94, 255 }, "down" ),
	strokeWidth        = 1,
    strokeColor        = {1,1,1,128},
	textOffset         = {0,1},
	emboss             = false,
}
mgr:addPreset( "user_default", default_params )
