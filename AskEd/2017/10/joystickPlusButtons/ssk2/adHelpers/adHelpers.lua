-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
-- admob_helpers.lua
-- =============================================================
--[[
--]]
-- =============================================================
-- =============================================================
-- Ad Helpers - Loaders (PRO ONLY)
-- =============================================================
-----------------------------------------------------------------
------------------|adMob|appLovin|inMobi|mediaBrix|revMob|vungle|
------------------|-----|--------|------|---------|------|------|
---        banner:|  X  |        |  X   |         |  X   |      |
---  interstitial:|  X  |   X    |  X   |    X    |  X   |      |
---         video:|     |   X    |      |    X    |  X   |  X   |
---rewarded video:|     |   X    |      |    X    |  X   |  X   |
-----------------------------------------------------------------
-- =============================================================

local adHelpers = {}
_G.ssk.adHelpers = adHelpers

function adHelpers.load( name )
   print("loading ", name)
   if( adHelpers[name] ) then return true end
   if( name == "admob" ) then
      _G.ssk.adHelpers[name] = require "ssk2.adHelpers.admob_helpers"
   end 
   if( name == "applovin" ) then
      _G.ssk.adHelpers[name] = require "ssk2.adHelpers.applovin_helpers"
   end 
   if( name == "houseAd" ) then
      _G.ssk.adHelpers[name] = require "ssk2.adHelpers.houseAd_helpers"
   end 
   if( name == "inmobi" ) then
      _G.ssk.adHelpers[name] = require "ssk2.adHelpers.inmobi_helpers"
   end 
   if( name == "mediabrix" ) then
      _G.ssk.adHelpers[name] = require "ssk2.adHelpers.mediabrix_helpers"
   end 
   if( name == "revmob" ) then
      _G.ssk.adHelpers[name] = require "ssk2.adHelpers.revmob_helpers"
   end 
   if( name == "vungle" ) then
      _G.ssk.adHelpers[name] = require "ssk2.adHelpers.vungle_helpers"
   end 
   --[[           
      adHelpers.admob = local_require "ssk2.adHelpers.admob_helpers"
      adHelpers.applovin = local_require "ssk2.adHelpers.applovin_helpers"
      adHelpers.houseAd = local_require "ssk2.adHelpers.houseAd_helpers"
      adHelpers.inmobi = local_require "ssk2.adHelpers.inmobi_helpers"
      adHelpers.mediabrix = local_require "ssk2.adHelpers.mediabrix_helpers"
      adHelpers.revmob = local_require "ssk2.adHelpers.revmob_helpers"
      adHelpers.vungle = local_require "ssk2.adHelpers.vungle_helpers"
   --]]
end
return adHelpers