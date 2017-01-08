-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Eds Awesome Tool (a free SSK2 PRO co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
--   Last Updated: 06 JAN 2017
-- =============================================================
--
-- labelsInit.lua - Create Label Presets
--
local mgr = require "ssk2.interfaces.buttons"
local imagePath = "presets/eat/images/"
local gameFont = gameFont or native.systemFontBold

-- ============================
-- ========= DEFAULT BUTTON
-- ============================
local default_params = 
{ 
	labelColor			= {1,1,1,1},
	labelSize			= 16,
	labelFont			= gameFont,
	labelOffset         = {0,1},
	selRectFillColor	= hexcolor("#00aeef"),
	unselRectFillColor	= hexcolor("#00703c"),
	--strokeColor         = hexcolor("#00703c"), 
	-- orange hexcolor("#f8a25d")
	strokeWidth         = 1,
    strokeColor         = {0.5,0.5,0.5,0.5},
    --strokeColor         = _K_,
    touchOffset         = {1,1},
    
	emboss              = false,	
}
mgr:addButtonPreset( "default", default_params )
--[[

-- ============================
-- ======= Edgeless Buttons
-- ============================
local params = 
{ 
	labelColor			= {1,1,1,1},
	labelSize			= 24,
	labelFont			= gameFont,
	labelOffset         = {0,-1},
	unselRectFillColor	= { 0.25,  0.25,  0.25, 0.0},
	selRectFillColor	= { 0.25,  0.25,  0.25, 0.0},
	strokeWidth         = 0,
    --strokeColor         = {1,1,1,0.5},
	emboss              = false,
	touchOffset         = {1,2},
}
mgr:addButtonPreset( "default_edgeless", params )

local params = 
{ 
	labelColor			= {1,1,1,1},
	labelSize			= 24,
	labelFont			= gameFont,
	labelOffset         = {0,-1},
	unselRectFillColor	= { 0.25,  0.25,  0.25, 0.0},
	selRectFillColor	= { 0.25,  0.25,  0.25, 0.0},
	strokeWidth         = 0,
    --strokeColor         = {1,1,1,0.5},
	emboss              = false,
}
mgr:addButtonPreset( "default_edgeless2", params )


-- ============================
-- ======= Check Box (Toggle Button)
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "check.png",
	selImgSrc    = imagePath .. "checkOver.png",
	strokeWidth  = 1,
    strokeColor  = {1,1,1,0.5},
    labelOffset   = { 0, 35 },
}
mgr:addButtonPreset( "default_check", params )

-- ============================
-- ======= Check Box 2 (Toggle Button)
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "check2.png",
	selImgSrc    = imagePath .. "checkOver2.png",
	strokeWidth   = 1,
    strokeColor   = {1,1,1,0.5},
    labelOffset   = { 0, 35 },
}
mgr:addButtonPreset( "default_check2", params )

-- ============================
-- ======= Default Radio Button 
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "radio.png",
	selImgSrc    = imagePath .. "radioOver.png",
	strokeWidth  = 0,
    strokeColor  = {0,0,0,0},
    labelOffset   = { 0, 35 },
}
mgr:addButtonPreset( "default_radio", params )


-- ============================
-- ======= Default Horizontal Slider
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "trackHoriz.png",
	selImgSrc    = imagePath .. "trackHorizOver.png",
	unselKnobImg = imagePath .. "thumbHoriz.png",
	selKnobImg   = imagePath .. "thumbHorizOver.png",
	kw           = 29,
	kh           = 19,
	strokeWidth  = 0,
    strokeColor  = {0,0,0,0},
}
mgr:addButtonPreset( "default_slider", params )

-- ============================
-- ================== RG BUTTON
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "rg.png",
	selImgSrc    = imagePath .. "rg.png",
	touchOffset  = {1,2},
}
mgr:addButtonPreset( "default_rg", params )

-- ============================
-- ======= Built With Corona  BADGE/BUTTON 150 x 144
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "Built_with_Corona_SM.png",
	selImgSrc    = imagePath .. "Built_with_Corona_SM.png",
	touchOffset  = {1,2},
}
mgr:addButtonPreset( "default_corona", params )

-- ============================
-- ======= Built With Corona  BADGE/BUTTON 150 x 144
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "corona.png",
	selImgSrc    = imagePath .. "corona.png",
	touchOffset  = {1,2},
}
mgr:addButtonPreset( "default_corona2", params )


-- ============================
-- ======= Play Button
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "play.png",
	selImgSrc    = imagePath .. "play.png",
	w 			 = 100,
	h 			 = 100,
	touchOffset  = {1,2},
}
mgr:addButtonPreset( "default_play", params )

-- ============================
-- ======= Back Button
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "arrowLeft.png",
	selImgSrc    = imagePath .. "arrowLeft.png",
	w 			 = 100,
	h 			 = 100,
	touchOffset  = {1,2},
}
mgr:addButtonPreset( "default_back", params )



-- ============================
-- ======= Audio Button
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "soundOff.png",
	selImgSrc    = imagePath .. "soundOn.png",
	w 			 = 100,
	h 			 = 100,
	touchOffset  = {1,2},
}
mgr:addButtonPreset( "default_sound", params )



-- ============================
-- ======= Event Button
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "arrowUp.png",
	selImgSrc    = imagePath .. "arrowUp.png",
	w 			 = 100,
	h 			 = 100,
	touchOffset  = {1,2},
}
mgr:addButtonPreset( "default_event", params )

-- ============================
-- ======= Rate Button
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "rate.png",
	selImgSrc    = imagePath .. "rate.png",
	w 			 = 100,
	h 			 = 100,
	touchOffset  = {1,2},
}
mgr:addButtonPreset( "default_rate", params )

-- ============================
-- ======= Share Button
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "share.png",
	selImgSrc    = imagePath .. "share.png",
	w 			 = 100,
	h 			 = 100,
	touchOffset  = {1,2},
}
mgr:addButtonPreset( "default_share", params )

-- ============================
-- ======= URL Button
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "url.png",
	selImgSrc    = imagePath .. "url.png",
	w 			 = 100,
	h 			 = 100,
	touchOffset  = {1,2},
}
mgr:addButtonPreset( "default_url", params )


-- ============================
-- ======= Buy Button
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "question.png",
	selImgSrc    = imagePath .. "question.png",
	w 			 = 100,
	h 			 = 100,
	touchOffset  = {1,2},
}
mgr:addButtonPreset( "default_buy", params )


-- ============================
-- ======= Twitter Button
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "twitter.png",
	selImgSrc    = imagePath .. "twitter.png",
	w 			 = 100,
	h 			 = 100,
	touchOffset  = {1,2},
}
mgr:addButtonPreset( "default_twitter", params )


-- ============================
-- ======= Facebook Button
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "facebook.png",
	selImgSrc    = imagePath .. "facebook.png",
	w 			 = 100,
	h 			 = 100,
	touchOffset  = {1,2},
}
mgr:addButtonPreset( "default_facebook", params )



-- ============================
-- ======= Home Button
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "home.png",
	selImgSrc    = imagePath .. "home.png",
	w 			 = 100,
	h 			 = 100,
	touchOffset  = {1,2},
}
mgr:addButtonPreset( "default_home", params )
--]]
