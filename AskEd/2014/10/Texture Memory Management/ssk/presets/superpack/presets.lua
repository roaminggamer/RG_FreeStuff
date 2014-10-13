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
local imagePath = "ssk/presets/superpack/images/"
local socialImagePath = "ssk/presets/superpack/social/"
local gameFont = gameFont or native.systemFont


-- ============================
-- ========= Push BUTTON
-- ============================
local default_params = 
{ 
	labelColor 			= _WHITE_,
	selLabelColor 		= _BLACK_,
	labelSize			= 12,
	labelFont			= gameFont,
	labelOffset         = {0,1},
	unselImgSrc  		= imagePath .. "push.png",
	selImgSrc    		= imagePath .. "pushOver.png",
	emboss              = false,
	unselImgFillColor	= hexcolor("FFFFFF88"),
	selImgFillColor		= hexcolor("00FFFF"),
}
mgr:addButtonPreset( "superpack_default", default_params )

-- ============================
-- ======= Check Box (Toggle Button)
-- ============================
local params = table.shallowCopy(default_params)
params.unselImgSrc 			= imagePath .. "check.png"
params.selImgSrc 			= imagePath .. "checkOver.png"
params.labelOffset			= { 0, 35 }
params.selLabelColor 		= _WHITE_
mgr:addButtonPreset( "superpack_check", params )

-- ============================
-- ======= Radio Button 
-- ============================
local params = table.shallowCopy(default_params)
params.unselImgSrc 			= imagePath .. "radio.png"
params.selImgSrc 			= imagePath .. "radioOver.png"
params.labelOffset			= { 0, 35 }
params.selLabelColor 		= _WHITE_
mgr:addButtonPreset( "superpack_radio", params )

-- ============================
-- ======= Toggle
-- ============================
local params = table.shallowCopy(default_params)
params.unselImgSrc 			= imagePath .. "toggleOff.png"
params.selImgSrc 			= imagePath .. "toggleOn.png"
params.selLabelColor 		= _BLACK_
params.labelColor 			= _BLACK_
params.unselImgFillColor	= _WHITE_
params.selText				= "ON"
params.unselText			= "OFF"
mgr:addButtonPreset( "superpack_toggle", params )

-- ============================
-- ======= Horizontal Slider
-- ============================
local params = table.shallowCopy(default_params)
params.unselImgSrc  = imagePath .. "trackHoriz.png"
params.selImgSrc    = imagePath .. "trackHorizOver.png"
params.unselKnobImg = imagePath .. "thumbHoriz.png"
params.selKnobImg   = imagePath .. "thumbHorizOver.png"
params.kw           = 29
params.kh           = 19
mgr:addButtonPreset( "superpack_slider", params )

-- ============================
-- ======= SFX Button
-- ============================
local params = table.shallowCopy(default_params)
params.unselImgSrc 			= imagePath .. "sfx_off.png"
params.selImgSrc 			= imagePath .. "sfx_on.png"
mgr:addButtonPreset( "superpack_sfx", params )


-- ============================
-- ======= Music Button
-- ============================
local params = table.shallowCopy(default_params)
params.unselImgSrc 			= imagePath .. "music_off.png"
params.selImgSrc 			= imagePath .. "music_on.png"
mgr:addButtonPreset( "superpack_music", params )

-- ============================
-- ======= SFX Button
-- ============================
local params = table.shallowCopy(default_params)
params.unselImgSrc 			= imagePath .. "sfx_off2.png"
params.selImgSrc 			= imagePath .. "sfx_on2.png"
mgr:addButtonPreset( "superpack_sfx2", params )


-- ============================
-- ========= Social 
-- ============================
local social_params = 
{ 
	labelColor 			= _WHITE_,
	selLabelColor 		= _LIGHTGREY_,
	labelSize			= 12,
	labelFont			= gameFont,
	labelOffset         = {0,1},
	unselImgSrc  		= socialImagePath .. "twitter.png",
	selImgSrc    		= socialImagePath .. "twitter.png",
	emboss              = false,
	unselImgFillColor	= _LIGHTGREY_,
	selImgFillColor		= _WHITE_,
}
mgr:addButtonPreset( "superpack_twitter", social_params )

-- ============================
-- ======= Facebook
-- ============================
local params = table.shallowCopy(social_params)
params.unselImgSrc 			= socialImagePath .. "facebook.png"
params.selImgSrc 			= socialImagePath .. "facebook.png"
mgr:addButtonPreset( "superpack_facebook", params )

-- ============================
-- ======= Google +
-- ============================
local params = table.shallowCopy(social_params)
params.unselImgSrc 			= socialImagePath .. "google.png"
params.selImgSrc 			= socialImagePath .. "google.png"
mgr:addButtonPreset( "superpack_google", params )

-- ============================
-- ======= Instagram
-- ============================
local params = table.shallowCopy(social_params)
params.unselImgSrc 			= socialImagePath .. "instagram.png"
params.selImgSrc 			= socialImagePath .. "instagram.png"
mgr:addButtonPreset( "superpack_instagram", params )

-- ============================
-- ======= YouTube
-- ============================
local params = table.shallowCopy(social_params)
params.unselImgSrc 			= socialImagePath .. "youtube.png"
params.selImgSrc 			= socialImagePath .. "youtube.png"
mgr:addButtonPreset( "superpack_youtube", params )

-- ============================
-- ======= Pintrest
-- ============================
local params = table.shallowCopy(social_params)
params.unselImgSrc 			= socialImagePath .. "pintrest.png"
params.selImgSrc 			= socialImagePath .. "pintrest.png"
mgr:addButtonPreset( "superpack_pintrest", params )

-- ============================
-- ======= LinkedIn
-- ============================
local params = table.shallowCopy(social_params)
params.unselImgSrc 			= socialImagePath .. "linkedin.png"
params.selImgSrc 			= socialImagePath .. "linkedin.png"
mgr:addButtonPreset( "superpack_linkedin", params )

-- ============================
-- ======= iOS GameCenter
-- ============================
local params = table.shallowCopy(social_params)
params.unselImgSrc 			= socialImagePath .. "iosgamecenter.png"
params.selImgSrc 			= socialImagePath .. "iosgamecenter.png"
mgr:addButtonPreset( "superpack_iosgamecenter", params )

-- ============================
-- ======= Google Play GameCenter
-- ============================
local params = table.shallowCopy(social_params)
params.unselImgSrc 			= socialImagePath .. "googleplay.png"
params.selImgSrc 			= socialImagePath .. "googleplay.png"
mgr:addButtonPreset( "superpack_googleplay", params )

-- ============================
-- ======= iOS GameCenter
-- ============================
local params = table.shallowCopy(social_params)
params.unselImgSrc 			= socialImagePath .. "rate.png"
params.selImgSrc 			= socialImagePath .. "rate.png"
mgr:addButtonPreset( "superpack_rate", params )
