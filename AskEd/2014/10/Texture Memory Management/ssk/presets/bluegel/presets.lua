-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- Buttons Presets
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
local mgr = require "ssk.interfaces.buttons"
local imagePath = "ssk/presets/bluegel/images/"
local gameFont = gameFont or native.systemFont


-- ============================
-- ========= Push BUTTON
-- ============================
local default_params = 
{ 
	labelColor			= {1,1,1,1},
	labelSize			= 16,
	labelFont			= gameFont,
	labelOffset          = {0,1},
	unselImgSrc  		= imagePath .. "push.png",
	selImgSrc    		= imagePath .. "pushOver.png",
	emboss              = false,	
}
mgr:addButtonPreset( "bluegel", default_params )


-- ============================
-- ======= Check Box (Toggle Button)
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "check.png",
	selImgSrc    = imagePath .. "checkOver.png",
	labelOffset   = { 0, 35 },
}
mgr:addButtonPreset( "bluegelcheck", params )

-- ============================
-- ======= Radio Button 
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "radio.png",
	selImgSrc    = imagePath .. "radioOver.png",
	labelOffset   = { 0, 35 },
}
mgr:addButtonPreset( "bluegelradio", params )


-- ============================
-- ======= Horizontal Slider
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "trackHoriz.png",
	selImgSrc    = imagePath .. "trackHorizOver.png",
	unselKnobImg = imagePath .. "thumbHoriz.png",
	selKnobImg   = imagePath .. "thumbHorizOver.png",
	kw           = 29,
	kh           = 19,
}
mgr:addButtonPreset( "bluegelslider", params )

