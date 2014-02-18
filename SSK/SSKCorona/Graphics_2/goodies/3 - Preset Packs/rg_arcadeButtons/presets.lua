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
-- DO NOT MODIFY THIS FILE.  MODIFY "data/buttons.lua" instead.
--
-- =============================================================
--
-- labelsInit.lua - Create Label Presets
--
local mgr = ssk.buttons

local imagePath = "data/rg_arcadeButtons/"

local gameFont = gameFont or native.systemFont

local params = {}

params.buttonType = "push" -- Override on use if needed for toggle or radio button

-- ============================
-- ================ Green 
-- ============================
params.unselImgSrc = imagePath .. "arcade/green.png"
params.selImgSrc   = imagePath .. "arcade/greenOver.png"
mgr:addPreset( "arcade_green", params )
-- ============================
-- ================ Red
-- ============================
params.unselImgSrc = imagePath .. "arcade/red.png"
params.selImgSrc   = imagePath .. "arcade/redOver.png"
mgr:addPreset( "arcade_red", params )
-- ============================
-- ================ Yellow
-- ============================
params.unselImgSrc = imagePath .. "arcade/yellow.png"
params.selImgSrc   = imagePath .. "arcade/yellowOver.png"
mgr:addPreset( "arcade_yellow", params )
-- ============================
-- ================ Blue
-- ============================
params.unselImgSrc = imagePath .. "arcade/blue.png"
params.selImgSrc   = imagePath .. "arcade/blueOver.png"
mgr:addPreset( "arcade_blue", params )
-- ============================
-- ================ Orange
-- ============================
params.unselImgSrc = imagePath .. "arcade/orange.png"
params.selImgSrc   = imagePath .. "arcade/orangeOver.png"
mgr:addPreset( "arcade_orange", params )
-- ============================
-- ================ White
-- ============================
params.unselImgSrc = imagePath .. "arcade/white.png"
params.selImgSrc   = imagePath .. "arcade/whiteOver.png"
mgr:addPreset( "arcade_white", params )
