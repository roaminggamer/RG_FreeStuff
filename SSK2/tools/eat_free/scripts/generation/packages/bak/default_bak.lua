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
function package.getVersion() return 1 end

function package.generate( generatedData, currentProject )
	local util = require "scripts.util"


	if( not currentProject ) then 
		curSettings = {}
		curPlugins = {}
	else
		--table.dump(curSettings,nil,"curSettings")
		curSettings = currentProject.settings
		curPlugins = currentProject.plugins
	end	


	-- EFM - Q: Put code here to force required plugins?

	local srcbase	= "documents" -- "resource" or "documents"
	--local content 	= "sources/templates/default/"
	local content 	= "sources/"
	local comSrc 	= "sources/com"


	-- 1. Specify any folders (directories) that should be created.
	--
	local createdScripts = false
	if( util.usingMonetizers(currentProject) or
	    util.usingAnalytics(currentProject) or 
	    util.usingAttribution(currentProject) or 
	    util.usingIAP(currentProject) or 
	    util.usingSocial(currentProject) or 
	    util.usingUtils(currentProject) ) then

		pu.createFolder( generatedData, "scripts")
		createdScripts = true
	end
--	pu.createFolder( generatedData, "com")
--	pu.createFolder( generatedData, "ifc")
--	pu.createFolder( generatedData, "sounds")
--	pu.createFolder( generatedData, "sounds/music")


	-- 2. Specify folders to clone
	--
	--pu.cloneFolder( generatedData, srcbase, content .. "defaultIcons_ios/" , "/"  )
--	pu.cloneFolder( generatedData, srcbase, comSrc , "com"  )
--	pu.cloneFolder( generatedData, srcbase, content .. "common/images", "images"  )
--	pu.cloneFolder( generatedData, srcbase, content .. "common/sounds/sfx", "sounds/sfx"  )
--	pu.cloneFolder( generatedData, srcbase, content .. "common/scripts", "scripts"  )

	-- 3. Specify files to clone
	--
--	pu.cloneFile( generatedData, srcbase, content .. "common/readMe.txt",  "readMe.txt" )

	if( currentProject.settings.provide_icons == "yes") then
		if( currentProject.settings.generate_ios == "true" ) then
			local imagesPath = RGFiles.documents.getPath( content .. "/targets/ios/icons" )
			local images =  RGFiles.util.getFilesInFolder(imagesPath)
			for i = 1, #images do
				pu.cloneFile( generatedData, srcbase, content .. "targets/ios/icons/" .. images[i],  images[i] )
			end
		end

		if( currentProject.settings.generate_android == "true" ) then
			local imagesPath = RGFiles.documents.getPath( content .. "/targets/android/icons" )
			local images =  RGFiles.util.getFilesInFolder(imagesPath)
			for i = 1, #images do
				pu.cloneFile( generatedData, srcbase, content .. "targets/android/icons/" .. images[i],  images[i] )
			end
		end

		if( currentProject.settings.generate_desktop_osx == "true" ) then
			local imagesPath = RGFiles.documents.getPath( content .. "/targets/desktop_osx" )
			local images =  RGFiles.util.getFilesInFolder(imagesPath)
			for i = 1, #images do
				pu.cloneFile( generatedData, srcbase, content .. "targets/desktop_osx/" .. images[i],  images[i] )
			end
		end
		
		if( currentProject.settings.generate_desktop_win32 == "true" ) then
			local imagesPath = RGFiles.documents.getPath( content .. "/targets/desktop_win32" )
			local images =  RGFiles.util.getFilesInFolder(imagesPath)
			for i = 1, #images do
				pu.cloneFile( generatedData, srcbase, content .. "targets/desktop_win32/" .. images[i],  images[i] )
			end
		end
	end

	if( currentProject.settings.provide_launch_images == "yes") then
		if( currentProject.settings.generate_android == "true" ) then
			local imagesPath = RGFiles.documents.getPath( content .. "/targets/android/banners" )
			local images =  RGFiles.util.getFilesInFolder(imagesPath)
			for i = 1, #images do
				pu.cloneFile( generatedData, srcbase, content .. "targets/android/banners/" .. images[i],  images[i] )
			end
		end

		if( currentProject.settings.generate_ios == "true" ) then
			if( currentProject.settings.orientation == "Portrait" ) then
				local imagesPath = RGFiles.documents.getPath( content .. "/targets/ios/launchPortrait" )
				local images =  RGFiles.util.getFilesInFolder(imagesPath)
				for i = 1, #images do
					pu.cloneFile( generatedData, srcbase, content .. "targets/ios/launchPortrait/" .. images[i],  images[i] )
				end
			else
				local imagesPath = RGFiles.documents.getPath( content .. "/targets/ios/launchLandscape" )
				local images =  RGFiles.util.getFilesInFolder(imagesPath)
				for i = 1, #images do
					pu.cloneFile( generatedData, srcbase, content .. "targets/ios/launchLandscape/" .. images[i],  images[i] )
				end
			end
		end
		--[[
		if( currentProject.settings.generate_apple_tv == "true" ) then
			local imagesPath = RGFiles.documents.getPath( content .. "/targets/ios/icons" )
			local images =  RGFiles.util.getFilesInFolder(imagesPath)
			for i = 1, #images do
				pu.cloneFile( generatedData, srcbase, content .. "targets/apple_tv/??" .. images[i],  images[i] )
			end
		end
		--]]
	end


	-- 4. Add specific generated content to generatedData table
	--
	local generate_config_lua  		=  require("scripts.generation.gen_config_lua").generate
	local generate_build_settings 	=  require("scripts.generation.gen_build_settings").generate

	pu.addGC( generatedData, generate_config_lua( "config.lua", currentProject ), "config.lua"  )
	pu.addGC( generatedData, generate_build_settings( "build.settings", currentProject ), "build.settings"  )

	local package_default_main = require "scripts.generation.packages.default_main"
	pu.addGC( generatedData, package_default_main.generate( "main.lua", currentProject ), "main.lua" )

	--[[
	local package_default_eatMoney = require "scripts.generation.packages.default_eatMoney"
	if( package_default_eatMoney.shouldRun( currentProject ) ) then
		pu.addGC( generatedData, package_default_eatMoney.generate( "eatMoney.lua", currentProject ), "scripts/eatMoney.lua" )
	end
	--]]
	-- ========================
	-- == Ads
	-- ========================
	--
	-- AdMob
	--
	if( curPlugins.monetization_admob_plugin )  then
		local path = RGFiles.documents.getPath( "sources/admob_helpers.json" )					
		local contentName = "admob_helpers"
		local specialContent

		if( path ) then
			specialContent = RGFiles.util.loadTable( path )
		end

		local code = specialContent.admob_helpers.source.scripts['admob_helpers.lua']		
		code = string.gsub( code, 'ANDROID_BANNER_ID', '"' .. curSettings.ads_android_admob_banner_app_id .. '"' )		
		code = string.gsub( code, 'ANDROID_INTERSTITIAL_ID', '"' .. curSettings.ads_android_admob_interstitial_app_id .. '"' )		
		code = string.gsub( code, 'IOS_BANNER_ID', '"' .. curSettings.ads_ios_admob_banner_app_id .. '"' )		
		code = string.gsub( code, 'IOS_INTERSTITIAL_ID', '"' .. curSettings.ads_ios_admob_interstitial_app_id .. '"' )		
		specialContent.admob_helpers.source.scripts['admob_helpers.lua'] = code

		local generator = require "scripts.generation.generator"
		generator.parseSpecial( generatedData, specialContent[contentName] )
	end

	--
	-- AppLovin
	--
	if( curPlugins.monetization_applovin_plugin )  then
		local path = RGFiles.documents.getPath( "sources/applovin_helpers.json" )					
		local contentName = "applovin_helpers"
		local specialContent

		if( path ) then
			specialContent = RGFiles.util.loadTable( path )
		end

		----[[
		local code = specialContent.applovin_helpers.source.scripts['applovin_helpers.lua']		
		code = string.gsub( code, 'ANDROID_ID', '"' .. curSettings.ads_android_applovin_sdk_key .. '"' )		
		code = string.gsub( code, 'APPLE_TV_ID', '"' .. curSettings.ads_apple_tv_applovin_sdk_key .. '"' )		
		code = string.gsub( code, 'IOS_ID', '"' .. curSettings.ads_ios_applovin_sdk_key .. '"' )		
		specialContent.applovin_helpers.source.scripts['applovin_helpers.lua'] = code
		--]]

		local generator = require "scripts.generation.generator"
		generator.parseSpecial( generatedData, specialContent[contentName] )
	end

	--
	-- InMobi
	--
	if( curPlugins.monetization_inmobi_plugin )  then
		local path = RGFiles.documents.getPath( "sources/inmobi_helpers.json" )					
		local contentName = "inmobi_helpers"
		local specialContent

		if( path ) then
			specialContent = RGFiles.util.loadTable( path )
		end

		----[[
		local code = specialContent.inmobi_helpers.source.scripts['inmobi_helpers.lua']		
		code = string.gsub( code, 'ANDROID_BANNER_ID', '"' .. curSettings.ads_android_inmobi_banner_id .. '"' )
		code = string.gsub( code, 'ANDROID_INTERSTITIAL_ID', '"' .. curSettings.ads_android_inmobi_interstitial_id .. '"' )
		code = string.gsub( code, 'IOS_BANNER_ID', '"' .. curSettings.ads_ios_inmobi_banner_id .. '"' )
		code = string.gsub( code, 'IOS_INTERSTITIAL_ID', '"' .. curSettings.ads_ios_inmobi_interstitial_id .. '"' )
		specialContent.inmobi_helpers.source.scripts['inmobi_helpers.lua'] = code
		--]]

		local generator = require "scripts.generation.generator"
		generator.parseSpecial( generatedData, specialContent[contentName] )
	end


	--
	-- MediaBrix
	--
	if( curPlugins.monetization_mediabrix_plugin )  then
		local path = RGFiles.documents.getPath( "sources/mediabrix_helpers.json" )					
		local contentName = "mediabrix_helpers"
		local specialContent

		if( path ) then
			specialContent = RGFiles.util.loadTable( path )
		end

		----[[
		local code = specialContent.mediabrix_helpers.source.scripts['mediabrix_helpers.lua']		
		code = string.gsub( code, 'ANDROID_ID', '"' .. curSettings.ads_android_mediabrix_app_id .. '"' )
		code = string.gsub( code, 'IOS_ID', '"' .. curSettings.ads_ios_mediabrix_app_id .. '"' )
		specialContent.mediabrix_helpers.source.scripts['mediabrix_helpers.lua'] = code
		--]]

		local generator = require "scripts.generation.generator"
		generator.parseSpecial( generatedData, specialContent[contentName] )
	end


	--
	-- RevMob
	--
	if( curPlugins.monetization_revmob_plugin )  then
		local path = RGFiles.documents.getPath( "sources/revmob_helpers.json" )					
		local contentName = "revmob_helpers"
		local specialContent

		if( path ) then
			specialContent = RGFiles.util.loadTable( path )
		end

		----[[
		local code = specialContent.revmob_helpers.source.scripts['revmob_helpers.lua']		
		code = string.gsub( code, 'ANDROID_BANNER_ID', '"' .. curSettings.ads_android_revmob_app_id .. '"' )		
		code = string.gsub( code, 'ANDROID_INTERSTITIAL_ID', '"' .. curSettings.ads_android_revmob_app_id .. '"' )		
		code = string.gsub( code, 'ANDROID_VIDEO_ID', '"' .. curSettings.ads_android_revmob_app_id .. '"' )		
		code = string.gsub( code, 'ANDROID_REWARDED_ID', '"' .. curSettings.ads_android_revmob_app_id .. '"' )		


		code = string.gsub( code, 'IOS_BANNER_ID', '"' .. curSettings.ads_ios_revmob_app_id .. '"' )		
		code = string.gsub( code, 'IOS_INTERSTITIAL_ID', '"' .. curSettings.ads_ios_revmob_app_id .. '"' )		
		code = string.gsub( code, 'IOS_VIDEO_ID', '"' .. curSettings.ads_ios_revmob_app_id .. '"' )		
		code = string.gsub( code, 'IOS_REWARDED_ID', '"' .. curSettings.ads_ios_revmob_app_id .. '"' )		

		specialContent.revmob_helpers.source.scripts['revmob_helpers.lua'] = code
		--]]

		local generator = require "scripts.generation.generator"
		generator.parseSpecial( generatedData, specialContent[contentName] )
	end

	--
	-- Vungle
	--
	if( curPlugins.monetization_vungle_plugin )  then
		local path = RGFiles.documents.getPath( "sources/vungle_helpers.json" )					
		local contentName = "vungle_helpers"
		local specialContent

		if( path ) then
			specialContent = RGFiles.util.loadTable( path )
		end

		----[[
		local code = specialContent.vungle_helpers.source.scripts['vungle_helpers.lua']		
		code = string.gsub( code, 'ANDROID_ID', '"' .. curSettings.ads_android_vungle_app_key .. '"' )		
		code = string.gsub( code, 'IOS_ID', '"' .. curSettings.ads_ios_vungle_app_key .. '"' )		
		specialContent.vungle_helpers.source.scripts['vungle_helpers.lua'] = code
		--]]

		local generator = require "scripts.generation.generator"
		generator.parseSpecial( generatedData, specialContent[contentName] )
	end


	local package_default_eatAnalytics = require "scripts.generation.packages.default_eatAnalytics"
	if( package_default_eatAnalytics.shouldRun( currentProject ) ) then
		pu.addGC( generatedData, package_default_eatAnalytics.generate( "eatAnalytics.lua", currentProject ), "scripts/eatAnalytics.lua" )
	end

	local package_default_eatAttribution = require "scripts.generation.packages.default_eatAttribution"
	if( package_default_eatAttribution.shouldRun( currentProject ) ) then
		pu.addGC( generatedData, package_default_eatAttribution.generate( "eatAttribution.lua", currentProject ), "scripts/eatAttribution.lua" )
	end

	local package_default_eatIAP = require "scripts.generation.packages.default_eatIAP"
	if( package_default_eatIAP.shouldRun( currentProject ) ) then
		pu.addGC( generatedData, package_default_eatIAP.generate( "eatIAP.lua", currentProject ), "scripts/eatIAP.lua" )
	end

	local package_default_eatSpecial = require "scripts.generation.packages.default_eatSpecial"
	if( package_default_eatSpecial.shouldRun( currentProject ) ) then
		pu.addGC( generatedData, package_default_eatSpecial.generate( "eatSpecial.lua", currentProject ), "scripts/eatSpecial.lua" )
	end

	
	--pu.addGC( generatedData, package.main( "main.lua", currentProject ), "main.lua"  )
	--pu.addGC( generatedData, package.mod_iap( "mod_iap.lua", currentProject ), "scripts/mod_iap.lua"  )
	-- EFM generate individual files designed by user here.

	--local package_default_ui = require "scripts.generation.packages.default_ui"
	--package_default_ui.generate( generatedData, currentProject )
	
	-- 5. Add special content from Frameworks, Ask Ed, etc.
	--

	
	local specialContent
	if( currentProject.projectType == "Frameworks" ) then

		local path
		local contentName 

		if( currentProject.projectSubtype == "Standard Composer Framework" ) then
			path = RGFiles.documents.getPath( "sources/StandardComposer.json" )					
			contentName = "StandardComposer"
		
		elseif( currentProject.projectSubtype  == "Improved Composer Framework" ) then
			path = RGFiles.documents.getPath( "sources/ImprovedComposer.json" )			
			contentName = "ImprovedComposer"
		end

		if( path ) then
			specialContent = RGFiles.util.loadTable( path )
			--table.dump( specialContent )
		end

		if( specialContent ) then
			local generator = require "scripts.generation.generator"
			generator.parseSpecial( generatedData, specialContent[contentName] )
			--table.dump( generatedData )
		end
	end

end


return package


