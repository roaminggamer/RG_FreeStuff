-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
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
-- labelsInit.lua - Create Label Presets
--

-- If you're using the old 320 x 480 magic recipe uncomment the following line
--local oldMagic = true

local mgr = ssk.buttons

local imagePath = "ssk/defaultPresets/buttons/images/"

local gameFont = gameFont or native.systemFont


-- ============================
-- ========= DEFAULT BUTTON
-- ============================
local default_params = 
{ 
	font				= gameFont,
	textColor			= _WHITE_,
	fontSize			= 40,
	textFont			= native.systemFontBold,
	unselRectFillColor	= _DARKGREY_,
	selRectFillColor	= _GREY_,
	strokeWidth         = 1,
    strokeColor         = {1,1,1,128},
	textOffset          = {0,1},
	emboss              = false,	
}
if( oldMagic ) then 
	default_params.fontSize = 16
end
mgr:addPreset( "default", default_params )


-- ============================
-- ======= Default Check Box (Toggle Button)
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "check.png",
	selImgSrc    = imagePath .. "checkOver.png",
	strokeWidth  = 1,
    strokeColor  = {1,1,1,128},
}
mgr:addPreset( "defaultcheck", params )

-- ============================
-- ======= Default Radio Button 
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "radio.png",
	selImgSrc    = imagePath .. "radioOver.png",
	strokeWidth  = 0,
    strokeColor  = {0,0,0,0},
}
mgr:addPreset( "defaultradio", params )


-- ============================
-- ======= Default Horizontal Slider
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "trackHoriz.png",
	selImgSrc    = imagePath .. "trackHorizOver.png",
	unselKnobImg = imagePath .. "thumbHoriz.png",
	selKnobImg   = imagePath .. "thumbHorizOver.png",
	kw           = 72,
	kh           = 48,
	strokeWidth  = 0,
    strokeColor  = {0,0,0,0},
}
if( oldMagic ) then 
	params.kw = 29
	params.kh = 19
end
mgr:addPreset( "defaultslider", params )

-- ============================
-- ================== RG BUTTON
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "rg.png",
	selImgSrc    = imagePath .. "rg.png",
}
mgr:addPreset( "RGButton", params )

-- ============================
-- ======= Corona  BADGE/BUTTON 150 x 144
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "Built_with_Corona_SM.png",
	selImgSrc    = imagePath .. "Built_with_Corona_SM.png",
}
mgr:addPreset( "CoronaButton", params )
