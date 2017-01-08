-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Eds Awesome Tool (a free SSK2 PRO co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
--   Last Updated: 06 JAN 2017
-- =============================================================
local RGFiles 	= ssk.files
local genUtil 	= require( "scripts.generation.genUtil" )
local pu 	  	= require( "scripts.generation.packageUtil" )


local curSettings
local curPlugins

local package = {}

-- ==
--		MAIN GENERATOR
-- ==
function package.generate( fileName, currentProject )
	local util = require "scripts.util"

	genUtil.resetContent()

	if( not currentProject ) then 
		curSettings = {}
		curPlugins = {}
	else
		--table.dump(curSettings,nil,"curSettings")
		curSettings = currentProject.settings
		curPlugins = currentProject.plugins
	end	

	-- Header	
	genUtil.add( 0, "-- =============================================================" )
	genUtil.add( 0, "-- " .. (currentProject.copyright_statement or "Your Copyright Statement Goes Here") )
	genUtil.add( 0, "-- =============================================================" )
	genUtil.add( 0, "--  " .. fileName )
	genUtil.add( 0, "-- =============================================================" )
	genUtil.add( 0, "-- https://gumroad.com/l/eatlean")
	genUtil.add( 0, "-- https://gumroad.com/l/EATFrameOneTime")
	genUtil.add( 0, "-- =============================================================" )
	genUtil.nl()
	
	-- Init
	genUtil.add( 0, '-- Ensure messages are displayed immediately instead of buffering.')
	genUtil.add( 0, 'io.output():setvbuf("no")')
	genUtil.nl()
	
	genUtil.add( 0, '-- Turn off the status bar on devices that supply one.' )
	genUtil.add( 0, '-- Most games and aps do this, so it is a defalt for EAT output.' )
	genUtil.add( 0, "display.setStatusBar(display.HiddenStatusBar)") 
	genUtil.nl()



	if( curSettings.composer_is_debug == "true" or
	    curSettings.composer_recycle_on_low_memory == "false" or
	    curSettings.composer_recycle_on_scene_change == "true" ) then
		genUtil.add( 0, '-- ========================================' )
		genUtil.add( 0, "-- Configure 'Debug' composer.* settings " )
		genUtil.add( 0, '-- ========================================' )
		if( curSettings.composer_is_debug == "true" ) then
			genUtil.add( 0, 'require("composer").isDebug = true ' )
		end
		if( curSettings.composer_recycle_on_low_memory == "false" ) then
			genUtil.add( 0, 'require("composer").recycleOnLowMemory = false' )
		end
		if( curSettings.composer_recycle_on_scene_change == "true" ) then
			genUtil.add( 0, 'require("composer").recycleOnSceneChange = true ' )
		end
		genUtil.nl()
	end


	-- ========================
	-- == ADS
	-- ========================
	if( util.usingMonetizers(currentProject) ) then
		genUtil.add( 0, '-- Initialize Ad Networks')
		--genUtil.add( 0, 'local eatMoney = require "scripts.eatMoney"')
		--genUtil.add( 0, 'eatMoney.init( 30 ) -- Init after 30 ms')
		--genUtil.nl()
	end

	--
	-- AdMob
	--
	if( curPlugins.monetization_admob_plugin )  then
		genUtil.add( 0, 'local admob_helpers = require "scripts.admob_helpers"')
		genUtil.add( 0, 'admob_helpers.init( 30 ) -- Init after 30 ms')
		genUtil.nl()		
	end

	--
	-- AppLovin
	--
	if( curPlugins.monetization_applovin_plugin )  then
		genUtil.add( 0, 'local applovin_helpers = require "scripts.applovin_helpers"')
		genUtil.add( 0, 'applovin_helpers.init( 30 ) -- Init after 30 ms')
		genUtil.nl()		
	end

	--
	-- inMobi
	--
	if( curPlugins.monetization_inmobi_plugin )  then
		genUtil.add( 0, 'local inmobi_helpers = require "scripts.inmobi_helpers"')
		genUtil.add( 0, 'inmobi_helpers.init( 30 ) -- Init after 30 ms')
		genUtil.nl()		
	end

	--
	-- mediaBrix
	--
	if( curPlugins.monetization_mediabrix_plugin )  then
		genUtil.add( 0, 'local mediabrix_helpers = require "scripts.mediabrix_helpers"')
		genUtil.add( 0, 'mediabrix_helpers.init( 30 ) -- Init after 30 ms')
		genUtil.nl()		
	end


	--
	-- RevMob
	--
	if( curPlugins.monetization_revmob_plugin )  then
		genUtil.add( 0, 'local revmob_helpers = require "scripts.revmob_helpers"')
		genUtil.add( 0, 'revmob_helpers.init( 30 ) -- Init after 30 ms')
		genUtil.nl()		
	end

	--
	-- Vungle
	--
	if( curPlugins.monetization_vungle_plugin )  then
		genUtil.add( 0, 'local vungle_helpers = require "scripts.vungle_helpers"')
		genUtil.add( 0, 'vungle_helpers.init( 30 ) -- Init after 30 ms')
		genUtil.nl()		
	end


	-- ========================
	-- == ANALYTICS
	-- ========================
	if( util.usingAnalytics(currentProject) ) then		
		genUtil.add( 0, '-- Initialize Analytics Providers')
		genUtil.add( 0, 'local eatAnalytics = require "scripts.eatAnalytics"')
		genUtil.add( 0, 'eatAnalytics.init( 30 ) -- Init after 30 ms')
		genUtil.nl()		
	end

	-- ========================
	-- == ATTRIBUTION
	-- ========================
	if( util.usingAttribution(currentProject) ) then
		genUtil.add( 0, '-- Initialize Attribution Providers')
		genUtil.add( 0, 'local eatAttribution = require "scripts.eatAttribution"')
		genUtil.add( 0, 'eatAttribution.init( 30 ) -- Init after 30 ms')
		genUtil.nl()
	end

	-- ========================
	-- == IAP
	-- ========================
	if( util.usingIAP(currentProject) ) then
		genUtil.add( 0, '-- Initialize IAP Networks')
		genUtil.add( 0, 'local eatIAP = require "scripts.eatIAP"')
		genUtil.add( 0, 'eatIAP.init( 30 ) -- Init after 30 ms')
		genUtil.nl()
	end

		
	-- ========================
	-- == MISC
	-- ========================
	if( util.usingUtils(currentProject) ) then
		genUtil.add( 0, '-- Initialize Various Utility Plugins')
		genUtil.add( 0, 'local eatSpecial = require "scripts.eatSpecial"')
		genUtil.add( 0, 'eatSpecial.init( 30 ) -- Init after 30 ms')
		genUtil.nl()
	end


--	genUtil.add( 0, '-- Load and Initialize SSK Libraries/Modules' )
--	genUtil.add( 0, 'require "com.roaminggamer.ssk.loadSSK"' )


	if( currentProject.projectType == "Frameworks" ) then
		if( currentProject.projectSubtype == "Standard Composer Framework" ) then
			genUtil.add( 0, '-- ========================================' )
			genUtil.add( 0, '-- Composer - Load the splash screen' )
			genUtil.add( 0, '-- ========================================' )
			genUtil.add( 0, 'local composer = require "composer"' )
			genUtil.add( 0, 'composer.gotoScene( "scenes.splash" )' )
			genUtil.add( 0, '--composer.gotoScene( "scenes.home" )' )
		
		elseif( currentProject.projectSubtype  == "Improved Composer Framework" ) then
			genUtil.add( 0, '-- ========================================' )
			genUtil.add( 0, '-- Composer - Load the splash screen' )
			genUtil.add( 0, '-- ========================================' )
			path = RGFiles.resource.getPath( "source/ImprovedComposer.json" )
			genUtil.add( 0, 'local composer = require "composer"' )
			genUtil.add( 0, 'composer.gotoScene( "scenes.splash" )' )
			genUtil.add( 0, '--composer.gotoScene( "scenes.home" )' )
		end

	end

	return genUtil.getContent()
end



return package


