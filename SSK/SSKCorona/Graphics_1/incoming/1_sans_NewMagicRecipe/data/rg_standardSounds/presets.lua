-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Sound Presets
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
-- soundsInit.lua - Initialize Game Sounds
--
local mgr = ssk.sounds

local soundsPath = "data/rg_standardSounds/sounds/"

mgr:addEffect("good", soundsPath .. "good.wav")
mgr:addEffect("bad", soundsPath .. "bad.wav")
mgr:addMusic("Soundtrack", soundsPath .. "bouncing.mp3", nil, 1500)
