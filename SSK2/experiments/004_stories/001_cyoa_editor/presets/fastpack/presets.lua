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
local imagePath = "presets/fastpack/images/"
local socialImagePath = "presets/fastpack/social/"
local gameFont = gameFont or native.systemFont


local unselImgFillColor = hexcolor("#A83439")
local selImgFillColor 	= hexcolor("#3D7A24")

local commonColor 		= _W_

-- ============================
-- ========= Push BUTTON
-- ============================
local default_params = 
{ 
	labelColor 			= hexcolor("#EBAE27"),
	selLabelColor 		= hexcolor("#EBAE27"),
	labelSize			= 12,
	labelFont			= gameFont,
	labelOffset         = {0,1},
	unselImgSrc  		= imagePath .. "push.png",
	selImgSrc    		= imagePath .. "pushOver.png",
	emboss              = false,
	unselImgFillColor	= unselImgFillColor,
	selImgFillColor		= selImgFillColor,
}
mgr:addButtonPreset( "fastpack_default", default_params )

-- ============================
-- ======= Check Box (Toggle Button)
-- ============================
local params = table.shallowCopy(default_params)
params.unselImgSrc 			= imagePath .. "check.png"
params.selImgSrc 			= imagePath .. "checkOver.png"
params.labelOffset			= { 0, 35 }
params.selLabelColor 		= _WHITE_
mgr:addButtonPreset( "fastpack_check", params )

-- ============================
-- ======= Radio Button 
-- ============================
local params = table.shallowCopy(default_params)
params.unselImgSrc 			= imagePath .. "radio.png"
params.selImgSrc 			= imagePath .. "radioOver.png"
params.labelOffset			= { 0, 35 }
params.selLabelColor 		= _WHITE_
mgr:addButtonPreset( "fastpack_radio", params )

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
mgr:addButtonPreset( "fastpack_toggle", params )

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
mgr:addButtonPreset( "fastpack_slider", params )


-- ============================
-- ======= Tap To Play 
-- ============================
local params = table.shallowCopy(default_params)
params.unselImgSrc 			= "images/fillT.png"
params.selImgSrc 			= "images/fillT.png"
--params.selLabelColor 		= _WHITE_
params.labelOffset			= { 0, -35 }
params.labelColor 			= commonColor
params.selLabelColor 		= commonColor

mgr:addButtonPreset( "fastpack_taptoplay", params )

-- ============================
-- ======= Home Button
-- ============================
local params = table.shallowCopy(default_params)
params.unselImgSrc 			= imagePath .. "home.png"
params.selImgSrc 			= imagePath .. "home.png"
mgr:addButtonPreset( "fastpack_home", params )

-- ============================
-- ======= Ads Button
-- ============================
local params = table.shallowCopy(default_params)
params.unselImgSrc 			= imagePath .. "ads.png"
params.selImgSrc 			= imagePath .. "ads.png"
mgr:addButtonPreset( "fastpack_ads", params )

-- ============================
-- ======= Music Button
-- ============================
local params = table.shallowCopy(default_params)
params.unselImgSrc 			= imagePath .. "inputs.png"
params.selImgSrc 			= imagePath .. "inputs.png"
mgr:addButtonPreset( "fastpack_inputs", params )


-- ============================
-- ======= Music Button
-- ============================
local params = table.shallowCopy(default_params)
params.unselImgSrc 			= imagePath .. "music.png"
params.selImgSrc 			= imagePath .. "music.png"
mgr:addButtonPreset( "fastpack_music", params )

-- ============================
-- ======= SFX Button
-- ============================
local params = table.shallowCopy(default_params)
params.unselImgSrc 			= imagePath .. "sound.png"
params.selImgSrc 			= imagePath .. "sound.png"
mgr:addButtonPreset( "fastpack_sfx", params )

-- ============================
-- ======= Achievements Button
-- ============================
local params = table.shallowCopy(default_params)
params.unselImgSrc 			= imagePath .. "achievements.png"
params.selImgSrc 			= imagePath .. "achievements.png"
mgr:addButtonPreset( "fastpack_achievements", params )

-- ============================
-- ======= Leaderboard
-- ============================
local params = table.shallowCopy(default_params)
params.unselImgSrc 			= imagePath .. "leaderboard.png"
params.selImgSrc 			= imagePath .. "leaderboard.png"
mgr:addButtonPreset( "fastpack_leaderboard", params )

-- ============================
-- ======= Blank
-- ============================
local params = table.shallowCopy(default_params)
params.unselImgSrc 			= imagePath .. "blank.png"
params.selImgSrc 			= imagePath .. "blank.png"
mgr:addButtonPreset( "fastpack_blank", params )



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
mgr:addButtonPreset( "fastpack_twitter", social_params )

-- ============================
-- ======= Facebook
-- ============================
local params = table.shallowCopy(social_params)
params.unselImgSrc 			= socialImagePath .. "facebook.png"
params.selImgSrc 			= socialImagePath .. "facebook.png"
mgr:addButtonPreset( "fastpack_facebook", params )

-- ============================
-- ======= Google +
-- ============================
local params = table.shallowCopy(social_params)
params.unselImgSrc 			= socialImagePath .. "google.png"
params.selImgSrc 			= socialImagePath .. "google.png"
mgr:addButtonPreset( "fastpack_google", params )

-- ============================
-- ======= Instagram
-- ============================
local params = table.shallowCopy(social_params)
params.unselImgSrc 			= socialImagePath .. "instagram.png"
params.selImgSrc 			= socialImagePath .. "instagram.png"
mgr:addButtonPreset( "fastpack_instagram", params )

-- ============================
-- ======= YouTube
-- ============================
local params = table.shallowCopy(social_params)
params.unselImgSrc 			= socialImagePath .. "youtube.png"
params.selImgSrc 			= socialImagePath .. "youtube.png"
mgr:addButtonPreset( "fastpack_youtube", params )

-- ============================
-- ======= Pintrest
-- ============================
local params = table.shallowCopy(social_params)
params.unselImgSrc 			= socialImagePath .. "pintrest.png"
params.selImgSrc 			= socialImagePath .. "pintrest.png"
mgr:addButtonPreset( "fastpack_pintrest", params )

-- ============================
-- ======= LinkedIn
-- ============================
local params = table.shallowCopy(social_params)
params.unselImgSrc 			= socialImagePath .. "linkedin.png"
params.selImgSrc 			= socialImagePath .. "linkedin.png"
mgr:addButtonPreset( "fastpack_linkedin", params )

-- ============================
-- ======= iOS GameCenter
-- ============================
local params = table.shallowCopy(social_params)
params.unselImgSrc 			= socialImagePath .. "iosgamecenter.png"
params.selImgSrc 			= socialImagePath .. "iosgamecenter.png"
mgr:addButtonPreset( "fastpack_iosgamecenter", params )

-- ============================
-- ======= Google Play GameCenter
-- ============================
local params = table.shallowCopy(social_params)
params.unselImgSrc 			= socialImagePath .. "googleplay.png"
params.selImgSrc 			= socialImagePath .. "googleplay.png"
mgr:addButtonPreset( "fastpack_googleplay", params )

-- ============================
-- ======= iOS GameCenter
-- ============================
local params = table.shallowCopy(social_params)
params.unselImgSrc 			= socialImagePath .. "rate.png"
params.selImgSrc 			= socialImagePath .. "rate.png"
mgr:addButtonPreset( "fastpack_rate", params )
