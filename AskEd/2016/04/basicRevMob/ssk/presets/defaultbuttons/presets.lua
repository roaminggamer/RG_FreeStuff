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
-- labelsInit.lua - Create Label Presets
--
local mgr = require "ssk.interfaces.buttons"
local imagePath = "ssk/presets/defaultbuttons/images/"
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
	unselRectFillColor	= { 0.25,  0.25,  0.25, 1},
	selRectFillColor	= {0.5, 0.5, 0.5, 1},
	strokeWidth         = 1,
    strokeColor         = {1,1,1,0.5},
	emboss              = false,	
}
mgr:addButtonPreset( "default", default_params )

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
mgr:addButtonPreset( "edgeless", params )

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
mgr:addButtonPreset( "edgeless2", params )


-- ============================
-- ======= Default Check Box (Toggle Button)
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "check.png",
	selImgSrc    = imagePath .. "checkOver.png",
	strokeWidth  = 1,
    strokeColor  = {1,1,1,0.5},
    labelOffset   = { 0, 35 },
}
mgr:addButtonPreset( "defaultcheck", params )

-- ============================
-- ======= Default Check Box (Toggle Button)
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "check2.png",
	selImgSrc    = imagePath .. "checkOver2.png",
	strokeWidth   = 1,
    strokeColor   = {1,1,1,0.5},
    labelOffset   = { 0, 35 },
}
mgr:addButtonPreset( "defaultcheck2", params )

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
mgr:addButtonPreset( "defaultradio", params )


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
mgr:addButtonPreset( "defaultslider", params )

-- ============================
-- ================== RG BUTTON
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "rg.png",
	selImgSrc    = imagePath .. "rg.png",
}
mgr:addButtonPreset( "RGButton", params )

-- ============================
-- ======= Corona  BADGE/BUTTON 150 x 144
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "Built_with_Corona_SM.png",
	selImgSrc    = imagePath .. "Built_with_Corona_SM.png",
}
mgr:addButtonPreset( "CoronaButton", params )
