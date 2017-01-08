-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Eds Awesome Tool (a free SSK2 PRO co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
--   Last Updated: 06 JAN 2017
-- =============================================================

----------------------------------------------------------------------
--								LOCALS								              --
----------------------------------------------------------------------
-- ==
--    Localizations
-- ==
-- Corona & Lua
--
local mAbs = math.abs;local mRand = math.random;local mDeg = math.deg;
local mRad = math.rad;local mCos = math.cos;local mSin = math.sin;
local mAcos = math.acos;local mAsin = math.asin;local mSqrt = math.sqrt;
local mCeil = math.ceil;local mFloor = math.floor;local mAtan2 = math.atan2;
local mPi = math.pi
local pairs = pairs;local getInfo = system.getInfo;local getTimer = system.getTimer
local strFind = string.find;local strFormat = string.format;local strFormat = string.format
local strGSub = string.gsub;local strMatch = string.match;local strSub = string.sub
--
-- Common SSK Display Object Builders
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers
--
-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist
--
-- Common SSK Helper Functions
local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
local normRot = ssk.misc.normRot;local easyAlert = ssk.misc.easyAlert
--
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale

-- Variables


-- Forward Declarations
local RGFiles = ssk.files
local genUtil = require( "scripts.generation.genUtil" )


-- Uncomment following line to count currently decalred locals (can't have more than 200)
--ssk.misc.countLocals(1)
----------------------------------------------------------------------
--	Module Begins
----------------------------------------------------------------------
local build_settings = {}
local padLen

local apple_phones 		= false
local apple_tablets 	= false	
local android_phones 	= false
local android_tablets 	= false
local win_phones 		= false
local osx_desktop 		= false
local win32_desktop 	= false
local android_tv 		= false
local apple_tv 			= false

local genDependencies 	= {} -- Flags set on the current 'generation' to simplify code generation dependencies

local android_permissions = {}
local android_intent_filters = {}
local applicationChildElements = {}
local plist = {}

-- Determine what devices have been selected for this project
-- and setup 'shorthand' variables for making decisions
function build_settings.configure_devices( currentProject )
	
	--[[
	-- Reset devices -- EDOCHI
	apple_phones 		= true
	apple_tablets 		= true	
	android_phones 		= true
	android_tablets 	= true
	win_phones 			= true
	osx_desktop 		= true
	win32_desktop 		= true
	android_tv 			= true
	apple_tv 			= true
	--]]

	----[[
	-- Reset devices
	apple_phones 		= false
	apple_tablets 		= false	
	android_phones 	= false
	android_tablets 	= false
	win_phones 			= false
	osx_desktop 		= false
	win32_desktop 		= false
	android_tv 			= false
	apple_tv 			= false
	--]]

	apple_phones 		= currentProject.settings.generate_ios == "true"
	apple_tablets 		= apple_phones
	android_phones 	= currentProject.settings.generate_android == "true"
	android_tablets 	= android_phones
	win_phones 			= false
	osx_desktop 		= currentProject.settings.generate_desktop_osx == "true"
	win32_desktop 		= currentProject.settings.generate_desktop_win32 == "true"
	android_tv 			= android_phones
	apple_tv 			= currentProject.settings.generate_apple_tv == "true"


	--[[
	table.dump(currentProject.settings)

	local td = currentProject.target_devices
	for i = 1, #td do
		--apple_phones = apple_phones or (td[i].id == "apple_phones")
		--apple_tablets = apple_tablets or (td[i].id == "apple_tablets")
		--android_phones = android_phones or (td[i].id == "android_phones")
		--android_tablets = android_tablets or (td[i].id == "android_tablets")
		--win_phones = win_phones or (td[i].id == "win_phones")
		--osx_desktop = osx_desktop or (td[i].id == "osx_desktop")
		--win32_desktop = win32_desktop or (td[i].id == "win32_desktop")
		--android_tv = android_tv or (td[i].id == "android_tv")
		--apple_tv = apple_tv or (td[i].id == "apple_tv")
		apple_phones = apple_phones or (td[i] == "apple_phones")
		apple_tablets = apple_tablets or (td[i] == "apple_tablets")
		android_phones = android_phones or (td[i] == "android_phones")
		android_tablets = android_tablets or (td[i] == "android_tablets")
		win_phones = win_phones or (td[i] == "win_phones")
		osx_desktop = osx_desktop or (td[i] == "osx_desktop")
		win32_desktop = win32_desktop or (td[i] == "win32_desktop")
		android_tv = android_tv or (td[i] == "android_tv")
		apple_tv = apple_tv or (td[i] == "apple_tv")
	end
	--]]
end

function build_settings.generate( fileName, currentProject )

	-- Clear generation dependencies 
	genDependencies 	= {}

	--table.dump( currentProject.configurationChoices )
	local configurationChoices 	=  currentProject.settings


	-- Initialize and prep
	--
	genUtil.resetContent()
	padLen = string.len("allowAppsReadOnlyAccessToFiles") + 1
	build_settings.configure_devices( currentProject )
	android_permissions = {}
	android_intent_filters = {}
	applicationChildElements = {}
	plist = {}

	-- Begin Generation
	--

	-- Header	
	genUtil.add( 0, "-- =============================================================" )
	genUtil.add( 0, "-- " .. (currentProject.copyright_statement or "Your Copyright Statement Goes Here") )
	genUtil.add( 0, "-- =============================================================" )
	genUtil.add( 0, "--  " .. fileName )
	genUtil.add( 0, "-- =============================================================" )
	genUtil.add( 0, "-- https://docs.coronalabs.com/daily/guide/distribution/buildSettings/index.html" )
	if( apple_tv ) then
		genUtil.add( 0, '-- https://docs.coronalabs.com/daily/guide/tvos/index.html')
	end
	if( win32_desktop ) then
		genUtil.add( 0, '-- https://docs.coronalabs.com/daily/guide/distribution/win32Build/index.html')
	end
	if( osx_desktop ) then
		genUtil.add( 0, '-- https://docs.coronalabs.com/daily/guide/distribution/osxBuild/index.html')
	end
	genUtil.add( 0, "-- =============================================================" )
	genUtil.nl()

	-- Open application table
	genUtil.add( 0, "settings = {" )

	--table.dump(currentProject)
	if( false ) then 
		genUtil.add( 0, "-- =============================================================" )
		return genUtil.getContent()
	end

	-- Scan plugins for specific choices
	local splashControlEnabled
	currentProject.plugins = currentProject.plugins or {}
	table.dump(currentProject.plugins,nil,"BOB")
	for k,v in pairs(currentProject.plugins ) do
		print(k,v.id)
		if( v.id =="utilities_corona_splash_control_plugin" ) then
			splashControlEnabled = true
		end
	end

	--
	-- Splash Screen Settings
	-- 
	if( splashControlEnabled ) then
		print("BOGART" .. tostring(configurationChoices.utilities_corona_splash_control_enable) .. "BOGIES")
		if( not configurationChoices.utilities_corona_splash_control_enable or 
			 string.len(configurationChoices.utilities_corona_splash_control_enable) == 0 ) then
			configurationChoices.utilities_corona_splash_control_enable = "false"
		end
		print("BOGART" .. tostring(configurationChoices.utilities_corona_splash_control_enable) .. "BOGIES")

		genUtil.add( 0, "-------------------------------------------------------------------------------" )
		genUtil.add( 0, "--  Splash Screen " )
		genUtil.add( 0, "-------------------------------------------------------------------------------" )
		genUtil.add( 1, "splashScreen = {" )
		genUtil.bool_param( 2, padLen, "enable", configurationChoices.utilities_corona_splash_control_enable )
		if( configurationChoices.utilities_corona_splash_control_image ) then
			genUtil.bool_param( 2, padLen, "image", configurationChoices.utilities_corona_splash_control_image )
		end			
		genUtil.cap(1)
		genUtil.nl()
	end

	--
	-- Debug Settings	
	-- 
	if( configurationChoices.never_strip_debug_info == "true" ) then
		genUtil.add( 0, "-------------------------------------------------------------------------------" )
		genUtil.add( 0, "--  Debug Settings " )
		genUtil.add( 0, "-------------------------------------------------------------------------------" )
		genUtil.add( 1, "build = {" )
		genUtil.bool_param( 2, padLen, "neverStripDebugInfo", configurationChoices.never_strip_debug_info )
		genUtil.cap(1)
		genUtil.nl()
	end


	-- EFM
	local default_orientation
	if( configurationChoices.orientation == "Portrait" ) then
		default_orientation = "portrait"
	else
		default_orientation = "landscapeRight"
	end


	--
	-- Orientation Settings	
	-- 
	genUtil.add( 0, "-------------------------------------------------------------------------------" )
	genUtil.add( 0, "--  Orientation Settings " )
	genUtil.add( 0, "-------------------------------------------------------------------------------" )
	genUtil.add( 1, "orientation = {" )	
	genUtil.string_param( 2, padLen, "default", default_orientation )

	local orientations = {}
	if( configurationChoices.orientation == "Portrait" ) then
		orientations[#orientations+1] = "portrait"
	end
	if( configurationChoices.orientation == "Portrait" and 
		(configurationChoices.allow_flipping  == "true") ) then
		orientations[#orientations+1] = "portraitUpsideDown"
	end
	if( configurationChoices.orientation == "Landscape" ) then
		orientations[#orientations+1] = "landscapeRight"
	end
	if( configurationChoices.orientation == "Landscape" and 
		(configurationChoices.allow_flipping  == "true") ) then
		orientations[#orientations+1] = "landscapeLeft"
	end
	genUtil.string_table_param( 2, padLen, "supported", orientations )
	genUtil.cap(1)
	genUtil.nl()

	--
	-- plugins
	-- 
	genUtil.add( 0, "-------------------------------------------------------------------------------" )
	genUtil.add( 0, "--  Plugins" )
	genUtil.add( 0, "-------------------------------------------------------------------------------" )
	genUtil.add( 1, "plugins = {" )
	build_settings.plugins( currentProject, 2 )	
	genUtil.cap(1)
	genUtil.nl()


	if( apple_phones or apple_tablets ) then
		--
		-- iOS Settings
		-- 
		genUtil.add( 0, "-------------------------------------------------------------------------------" )
		genUtil.add( 0, "--  iOS Settings" )
		genUtil.add( 0, "-------------------------------------------------------------------------------" )
		genUtil.add( 1, "iphone = {" )	

		genUtil.add( 2, "-- https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Introduction/Introduction.html#//apple_ref/doc/uid/TP40009248-SW1" )
		genUtil.add( 2, "plist = {" )	

		if( string.len(configurationChoices.ios_bundle_display_name ) > 0 ) then
			genUtil.string_param( 3, padLen, "CFBundleDisplayName", configurationChoices.ios_bundle_display_name )
		end

		if( string.len(configurationChoices.ios_bundle_name ) > 0 ) then
			genUtil.string_param( 3, padLen, "CFBundleName", configurationChoices.ios_bundle_name )
		end

		if( genDependencies.facebookv4 ) then
			genUtil.bool_param( 3, padLen, "UIApplicationExitsOnSuspend", "false" )
			if( configurationChoices.ios_exit_on_suspend == "true" ) then
				easyAlert( "Conflicting Settings!", 
					       "Warning:  You have selected the Facebook v4 plugin and also chosen 'UIApplicationExitsOnSuspend = true'.\n\n" ..
					       "'UIApplicationExitsOnSuspend' must be false for Facebook v4 to work properly.\n\n" ..
					       "Don't worry, I will generate the correct code for you.", {{"OK",nil}})
			end
		else
			genUtil.bool_param( 3, padLen, "UIApplicationExitsOnSuspend", configurationChoices.ios_exit_on_suspend )
		end

		genUtil.bool_param( 3, padLen, "UIPrerenderedIcon", configurationChoices.ios_icon_is_prerendered )

		genUtil.bool_param( 3, padLen, "UIStatusBarHidden", configurationChoices.ios_hide_status_bar )


		-- Adjust MinimumOSVersion based on plugins selected and other options
		local config_lua_ios_min_version = tonumber(configurationChoices.ios_min_version) or 6.0
		-- GAMEKIT PLUGIN >= 7.0 
		if( genDependencies.gamekit ) then
			config_lua_ios_min_version = (config_lua_ios_min_version >= 7.0) and config_lua_ios_min_version or 7.0
		end
		-- KIDOZ PLUGIN >= 8.0 
		if( genDependencies.kidoz ) then
			config_lua_ios_min_version = (config_lua_ios_min_version >= 8.0) and config_lua_ios_min_version or 8.0
		end
		if( genDependencies.gamekit or genDependencies.kidoz or string.len(configurationChoices.ios_min_version ) > 0 ) then
			config_lua_ios_min_version = string.format("%1.1f",config_lua_ios_min_version)
			genUtil.string_param( 3, padLen, "MinimumOSVersion", config_lua_ios_min_version )
		end

		genUtil.bool_param( 3, padLen, "skipPNGCrush", configurationChoices.ios_skip_png_crush )

		table.sort( plist )
		for i = 1, #plist do
			genUtil.add( 3, plist[i] .. "," )
		end

		genUtil.add( 3, "-- https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/iPhoneOSKeys.html#//apple_ref/doc/uid/TP40009252-SW3" )	
		genUtil.add( 3, "UIRequiredDeviceCapabilities = {" )
		-- EDOCHI	
		genUtil.cap( 3 )

		genUtil.add( 3, "CFBundleIconFiles = {" )
		genUtil.add( 4, '"Icon.png",' )
		genUtil.add( 4, '"Icon@2x.png",' )
		genUtil.add( 4, '"Icon-60.png",' )
		genUtil.add( 4, '"Icon-60@2x.png",' )
		genUtil.add( 4, '"Icon-60@3x.png",' )
		genUtil.add( 4, '"Icon-72.png",' )
		genUtil.add( 4, '"Icon-72@2x.png",' )
		genUtil.add( 4, '"Icon-76.png",' )
		genUtil.add( 4, '"Icon-76@2x.png",' )
		genUtil.add( 4, '"Icon-167.png",' )
		genUtil.add( 4, '"Icon-Small-40.png",' )
		genUtil.add( 4, '"Icon-Small-40@2x.png",' )
		genUtil.add( 4, '"Icon-Small-40@3x.png",' )
		genUtil.add( 4, '"Icon-Small-50.png",' )
		genUtil.add( 4, '"Icon-Small-50@2x.png",' )
		genUtil.add( 4, '"Icon-Small.png",' )
		genUtil.add( 4, '"Icon-Small@2x.png",' )
		genUtil.add( 4, '"Icon-Small@3x.png",' )			

		genUtil.cap( 3 )

		genUtil.add( 3, "UILaunchImages = {" )	

		if( configurationChoices.orientation == "Portrait" ) then
			genUtil.add( 4, '{  -- iPhone 4 Portrait' )
			genUtil.add( 5, '["UILaunchImageMinimumOSVersion"] = "7.0",' )
			genUtil.add( 5, '["UILaunchImageName"] = "Default",' )
			genUtil.add( 5, '["UILaunchImageOrientation"] = "Portrait",' )
			genUtil.add( 5, '["UILaunchImageSize"] = "{320, 480}"' )
			genUtil.add( 4, '},' )

			genUtil.add( 4, '{  -- iPhone 5 Portrait' )
			genUtil.add( 5, '["UILaunchImageMinimumOSVersion"] = "7.0",' )
			genUtil.add( 5, '["UILaunchImageName"] = "Default-568h",' )
			genUtil.add( 5, '["UILaunchImageOrientation"] = "Portrait",' )
			genUtil.add( 5, '["UILaunchImageSize"] = "{320, 568}"' )
			genUtil.add( 4, '},' )
			genUtil.add( 4, '{  -- iPad Portrait' )
			genUtil.add( 5, '["UILaunchImageMinimumOSVersion"] = "7.0",' )
			genUtil.add( 5, '["UILaunchImageName"] = "Default-Portrait",' )
			genUtil.add( 5, '["UILaunchImageOrientation"] = "Portrait",' )
			genUtil.add( 5, '["UILaunchImageSize"] = "{768, 1024}"' )
			genUtil.add( 4, '},' )
			genUtil.add( 4, '{  -- iPhone 6 Portrait' )
			genUtil.add( 5, '["UILaunchImageMinimumOSVersion"] = "8.0",' )
			genUtil.add( 5, '["UILaunchImageName"] = "Default-667h",' )
			genUtil.add( 5, '["UILaunchImageOrientation"] = "Portrait",' )
			genUtil.add( 5, '["UILaunchImageSize"] = "{375, 667}"' )
			genUtil.add( 4, '},' )
			genUtil.add( 4, '{  -- iPhone 6 Plus Portrait' )
			genUtil.add( 5, '["UILaunchImageMinimumOSVersion"] = "8.0",' )
			genUtil.add( 5, '["UILaunchImageName"] = "Default-736h",' )
			genUtil.add( 5, '["UILaunchImageOrientation"] = "Portrait",' )
			genUtil.add( 5, '["UILaunchImageSize"] = "{414, 736}"' )
			genUtil.add( 4, '},' )
			genUtil.add( 4, '{  -- iPad Pro Portrait' )
			genUtil.add( 5, '["UILaunchImageMinimumOSVersion"] = "9.0",' )
			genUtil.add( 5, '["UILaunchImageName"] = "Default-Portrait-1366",' )
			genUtil.add( 5, '["UILaunchImageOrientation"] = "Portrait",' )
			genUtil.add( 5, '["UILaunchImageSize"] = "{1024, 1366}"' )
			genUtil.add( 4, '},' )

		else

			genUtil.add( 4, '{  -- iPhone 4 LandscapeLeft' )
			genUtil.add( 5, '["UILaunchImageMinimumOSVersion"] = "7.0",' )
			genUtil.add( 5, '["UILaunchImageName"] = "Default",' )
			genUtil.add( 5, '["UILaunchImageOrientation"] = "LandscapeLeft",' )
			genUtil.add( 5, '["UILaunchImageSize"] = "{320, 480}"' )
			genUtil.add( 4, '},' )
			genUtil.add( 4, '{  -- iPhone 4 LandscapeRight' )
			genUtil.add( 5, '["UILaunchImageMinimumOSVersion"] = "7.0",' )
			genUtil.add( 5, '["UILaunchImageName"] = "Default",' )
			genUtil.add( 5, '["UILaunchImageOrientation"] = "LandscapeRight",' )
			genUtil.add( 5, '["UILaunchImageSize"] = "{320, 480}"' )
			genUtil.add( 4, '},' )
			genUtil.add( 4, '{  -- iPhone 5 LandscapeLeft' )
			genUtil.add( 5, '["UILaunchImageMinimumOSVersion"] = "7.0",' )
			genUtil.add( 5, '["UILaunchImageName"] = "Default-568h",' )
			genUtil.add( 5, '["UILaunchImageOrientation"] = "LandscapeLeft",' )
			genUtil.add( 5, '["UILaunchImageSize"] = "{320, 568}"' )
			genUtil.add( 4, '},' )
			genUtil.add( 4, '{  -- iPhone 5 LandscapeRight' )
			genUtil.add( 5, '["UILaunchImageMinimumOSVersion"] = "7.0",' )
			genUtil.add( 5, '["UILaunchImageName"] = "Default-568h",' )
			genUtil.add( 5, '["UILaunchImageOrientation"] = "LandscapeRight",' )
			genUtil.add( 5, '["UILaunchImageSize"] = "{320, 568}"' )
			genUtil.add( 4, '},' )
			genUtil.add( 4, '{  -- iPad LandscapeLeft' )
			genUtil.add( 5, '["UILaunchImageMinimumOSVersion"] = "7.0",' )
			genUtil.add( 5, '["UILaunchImageName"] = "Default-Landscape",' )
			genUtil.add( 5, '["UILaunchImageOrientation"] = "LandscapeLeft",' )
			genUtil.add( 5, '["UILaunchImageSize"] = "{768, 1024}"' )
			genUtil.add( 4, '},' )
			genUtil.add( 4, '{  -- iPad LandscapeRight' )
			genUtil.add( 5, '["UILaunchImageMinimumOSVersion"] = "7.0",' )
			genUtil.add( 5, '["UILaunchImageName"] = "Default-Landscape",' )
			genUtil.add( 5, '["UILaunchImageOrientation"] = "LandscapeRight",' )
			genUtil.add( 5, '["UILaunchImageSize"] = "{768, 1024}"' )
			genUtil.add( 4, '},' )
			genUtil.add( 4, '{  -- iPhone 6 LandscapeLeft' )
			genUtil.add( 5, '["UILaunchImageMinimumOSVersion"] = "8.0",' )
			genUtil.add( 5, '["UILaunchImageName"] = "Default-667h",' )
			genUtil.add( 5, '["UILaunchImageOrientation"] = "LandscapeLeft",' )
			genUtil.add( 5, '["UILaunchImageSize"] = "{375, 667}"' )
			genUtil.add( 4, '},' )
			genUtil.add( 4, '{  -- iPhone 6 LandscapeRight' )
			genUtil.add( 5, '["UILaunchImageMinimumOSVersion"] = "8.0",' )
			genUtil.add( 5, '["UILaunchImageName"] = "Default-667h",' )
			genUtil.add( 5, '["UILaunchImageOrientation"] = "LandscapeRight",' )
			genUtil.add( 5, '["UILaunchImageSize"] = "{375, 667}"' )
			genUtil.add( 4, '},' )
			genUtil.add( 4, '{  -- iPhone 6 Plus LandscapeLeft' )
			genUtil.add( 5, '["UILaunchImageMinimumOSVersion"] = "8.0",' )
			genUtil.add( 5, '["UILaunchImageName"] = "Default-Landscape-736h",' )
			genUtil.add( 5, '["UILaunchImageOrientation"] = "LandscapeLeft",' )
			genUtil.add( 5, '["UILaunchImageSize"] = "{414, 736}"' )
			genUtil.add( 4, '},' )
			genUtil.add( 4, '{  -- iPhone 6 Plus LandscapeRight' )
			genUtil.add( 5, '["UILaunchImageMinimumOSVersion"] = "8.0",' )
			genUtil.add( 5, '["UILaunchImageName"] = "Default-Landscape-736h",' )
			genUtil.add( 5, '["UILaunchImageOrientation"] = "LandscapeRight",' )
			genUtil.add( 5, '["UILaunchImageSize"] = "{414, 736}"' )
			genUtil.add( 4, '},' )
			genUtil.add( 4, '{  -- iPad Pro Landscape Right' )
			genUtil.add( 5, '["UILaunchImageMinimumOSVersion"] = "9.0",' )
			genUtil.add( 5, '["UILaunchImageName"] = "Default-Landscape-1366",' )
			genUtil.add( 5, '["UILaunchImageOrientation"] = "LandscapeRight",' )
			genUtil.add( 5, '["UILaunchImageSize"] = "{1024, 1366}"' )
			genUtil.add( 4, '},' )
			genUtil.add( 4, '{  -- iPad Pro Landscape Left' )
			genUtil.add( 5, '["UILaunchImageMinimumOSVersion"] = "9.0",' )
			genUtil.add( 5, '["UILaunchImageName"] = "Default-Landscape-1366",' )
			genUtil.add( 5, '["UILaunchImageOrientation"] = "LandscapeLeft",' )
			genUtil.add( 5, '["UILaunchImageSize"] = "{1024, 1366}"' )
			genUtil.add( 4, '},' )
		end
		genUtil.cap( 3 )

		--genUtil.add( 3, "NSAppTransportSecurity = {" )	
		--genUtil.bool_param( 4, padLen, "NSAllowsArbitraryLoads", true )	
		-- EDOCHI
		--genUtil.cap( 3, true )

		genUtil.cap( 2, true )
		genUtil.cap( 1 )

	end


	--
	-- iCloud Settings
	-- 
	if( genDependencies.icloud ) then
		if( genDependencies.ondemandresources  ) then
			genUtil.add( 0, "-------------------------------------------------------------------------------" )
			genUtil.add( 0, "--  iCloud & On-Demand Resources Settings" )
			genUtil.add( 0, "-------------------------------------------------------------------------------" )		
		else
			genUtil.add( 0, "-------------------------------------------------------------------------------" )
			genUtil.add( 0, "--  iCloud Settings" )
			genUtil.add( 0, "-------------------------------------------------------------------------------" )		
		end

		genUtil.add( 0, "-- https://docs.coronalabs.com/daily/plugin/iCloud/index.html#overview")
		genUtil.add( 0, "-- https://docs.coronalabs.com/daily/plugin/iCloud/index.html#sharing-data")
		genUtil.add( 0, "-------------------------------------------------------------------------------" )
		genUtil.add( 1, "-- non-KVS" )
		genUtil.add( 1, "iphone = { iCloud = true, }," )	
		genUtil.add( 1, "-- " )
		genUtil.add( 1, "-- KVS (Fill in the proper reverse-URL details)" )
		genUtil.add( 1, '--iphone = { iCloud = { ["kvstore-identifier"] = "com.example.shared_KVS" }, },' )	
		genUtil.nl()
		if( genDependencies.ondemandresources  ) then
			genUtil.add( 1, "tvos = { " )
			genUtil.add( 2, "iCloud = true, " )
			genUtil.nl()
			genUtil.add( 2, ' -- These are just examples, fill in your own details using these as a guideline:' )
			genUtil.add( 2, '{ tag="introMusic", resource="intro.mp4", type="prefetch" }, ' )
			genUtil.add( 2, '{ tag="imgTutorial", resource="img/tutorial", type="install" }, ' )
			genUtil.add( 2, '{ tag="imgL1", resource="img/level1" }, ' )
			genUtil.add( 1, "}," )	
		else
			genUtil.add( 1, "tvos = { iCloud = true, }," )	
		end		 
		genUtil.nl()
	end

	if( not genDependencies.icloud and genDependencies.ondemandresources ) then
		genUtil.add( 0, "-------------------------------------------------------------------------------" )
		genUtil.add( 0, "--  On-Demand Resources" )
		genUtil.add( 0, "-------------------------------------------------------------------------------" )		
		genUtil.add( 1, "tvos = { " )
		genUtil.add( 2, ' -- These are just examples, fill in your own details using these as a guideline:' )
		genUtil.add( 2, '{ tag="introMusic", resource="intro.mp4", type="prefetch" }, ' )
		genUtil.add( 2, '{ tag="imgTutorial", resource="img/tutorial", type="install" }, ' )
		genUtil.add( 2, '{ tag="imgL1", resource="img/level1" }, ' )
		genUtil.add( 1, "}," )	
	end


	if( android_phones == true or android_tablets == true or android_tv == true ) then
		--
		-- Android Settings	
		-- 
		genUtil.add( 0, "-------------------------------------------------------------------------------" )
		genUtil.add( 0, "--  Android Settings " )
		genUtil.add( 0, "-------------------------------------------------------------------------------" )
		genUtil.add( 1, "android = {" )	

		if( configurationChoices.android_version_code and string.len(configurationChoices.android_version_code) > 0 ) then
			genUtil.string_param( 2, padLen, "versionCode", configurationChoices.android_version_code )
		end
		
		genUtil.bool_param( 2, padLen, "largeHeap", configurationChoices.android_large_heap )

		genUtil.bool_param( 2, padLen, "usesExpansionFile", configurationChoices.android_uses_expansion_files )

		genUtil.bool_param( 2, padLen, "supportsTV", (android_tv == true) )

		genUtil.bool_param( 2, padLen, "isGame", configurationChoices.android_is_game )

		if( configurationChoices.android_readonly_file_access and configurationChoices.android_readonly_file_access == "false" ) then
			genUtil.bool_param( 2, padLen, "allowAppsReadOnlyAccessToFiles", configurationChoices.android_readonly_file_access )
		end

		if( string.len(configurationChoices.android_min_sdk ) > 0 ) then
			local minSdkVersion = tonumber(configurationChoices.android_min_sdk) or 14			
			if( genDependencies.kidoz or genDependencies.adColony ) then
				if( minSdkVersion < 14 ) then
					genUtil.add( 2, "-- Using Kidoz or AdColony plugin.  minSdkVersion version was forced to 14 " )
				end
				minSdkVersion = (minSdkVersion >= 14) and minSdkVersion or 14
			end

			genUtil.string_param( 2, padLen, "minSdkVersion", minSdkVersion )
		end

		genUtil.add( 2, "mainIntentFilter = {" )	
		table.sort( android_intent_filters )
		for i = 1, #android_intent_filters do
			genUtil.add( 3, android_intent_filters[i] .. "," )
		end
		genUtil.cap(2)

		genUtil.add( 2, "usesPermissions = {" )	
		table.sort( android_permissions )
		for i = 1, #android_permissions do
			genUtil.add( 3, android_permissions[i] .. "," )
		end
		genUtil.cap(2)

		genUtil.add( 2, "applicationChildElements  = {" )	
		table.sort( applicationChildElements )
		for i = 1, #applicationChildElements do
			genUtil.add( 3, applicationChildElements[i] .. "," )
		end
		genUtil.cap(2)

		genUtil.add( 2, "usesFeatures = {" )	
		-- EDOCHI
		genUtil.cap(2)

		if( configurationChoices.android_supports_small_screens ~= "auto" or
			configurationChoices.android_supports_normal_screens ~= "auto" or
			configurationChoices.android_supports_large_screens  ~= "auto" or
			configurationChoices.android_supports_xlarge_screens  ~= "auto" ) then
			genUtil.add( 2, "supportsScreens = {" )	
				if( configurationChoices.android_supports_small_screens  == "true" ) then
					genUtil.add( 3, 'smallScreens = true,' )	
				elseif( configurationChoices.android_supports_small_screens  == "false" ) then				
					genUtil.add( 3, 'smallScreens = false,' )	
				end
				if( configurationChoices.android_supports_normal_screens  == "true" ) then
					genUtil.add( 3, 'normalScreens = true,' )	
				elseif( configurationChoices.android_supports_normal_screens  == "false" ) then				
					genUtil.add( 3, 'normalScreens = false,' )	
				end
				if( configurationChoices.android_supports_large_screens  == "true" ) then
					genUtil.add( 3, 'largeScreens = true,' )	
				elseif( configurationChoices.android_supports_large_screens  == "false" ) then				
					genUtil.add( 3, 'largeScreens = false,' )	
				end
				if( configurationChoices.android_supports_xlarge_screens  == "true" ) then
					genUtil.add( 3, 'xlargeScreens = true,' )	
				elseif( configurationChoices.android_supports_xlarge_screens  == "false" ) then				
					genUtil.add( 3, 'xlargeScreens = false,' )	
				end
			genUtil.cap( 2, true )
		end

		genUtil.cap( 1 )
	end

	if( win32_desktop == true or osx_desktop == true ) then
		--
		-- Desktop Settings	
		-- 
		genUtil.add( 0, "-------------------------------------------------------------------------------" )
		genUtil.add( 0, "--  Desktop Settings " )
		genUtil.add( 0, "-------------------------------------------------------------------------------" )
		genUtil.add( 1, "window = {" )	

		genUtil.string_param( 2, padLen, "defaultMode", configurationChoices.desktop_default_mode )
		
		genUtil.bool_param( 2, padLen, "resizable", configurationChoices.desktop_resizable )
		genUtil.bool_param( 2, padLen, "enableCloseButton", configurationChoices.desktop_enable_close_button )
		genUtil.bool_param( 2, padLen, "suspendWhenMinimized", configurationChoices.desktop_enable_minimize_button )
		genUtil.bool_param( 2, padLen, "enableMaximizeButton", configurationChoices.desktop_enable_maximize_button )

		genUtil.decimal_param( 2, padLen, "defaultViewWidth", configurationChoices.desktop_default_width )  
		genUtil.decimal_param( 2, padLen, "defaultViewHeight", configurationChoices.desktop_default_height )
		genUtil.decimal_param( 2, padLen, "minViewWidth", configurationChoices.desktop_min_width )  
		genUtil.decimal_param( 2, padLen, "minViewHeight", configurationChoices.desktop_min_height )

		genUtil.add( 2, "titleText = {" )	
		genUtil.string_param( 3, 8, "default", configurationChoices.desktop_title_text )
		genUtil.string_param( 3, 8, '["en‐us"]', configurationChoices.desktop_title_text .. " (English‐USA)" ) -- EDOCHI
		genUtil.string_param( 3, 8, '["en‐gb"]', configurationChoices.desktop_title_text .. " (English‐UK)" ) -- EDOCHI
		genUtil.string_param( 3, 8, '["en"]', configurationChoices.desktop_title_text .. " (English)" ) -- EDOCHI
		genUtil.string_param( 3, 8, '["fr"]', configurationChoices.desktop_title_text .. " (French)" ) -- EDOCHI
		genUtil.string_param( 3, 8, '["es"]', configurationChoices.desktop_title_text .. " (Spanish)" ) -- EDOCHI
		genUtil.cap( 2, true )		
		genUtil.cap(1)
		genUtil.nl()
	end


	if( apple_tv == true ) then
		--
		-- Desktop Settings	
		-- 
		genUtil.add( 0, "-------------------------------------------------------------------------------" )
		genUtil.add( 0, "--  TV OS Settings " )
		genUtil.add( 0, "-------------------------------------------------------------------------------" )
		genUtil.add( 1, "tvos = {" )	
		genUtil.add( 2, '-- Apple TV app icons consist of multiple "layers" in both small and large sizes' )
		genUtil.add( 2, 'icon =' )
		genUtil.add( 2, '{' )
		genUtil.add( 3, '-- A collection of 400x240 images, in order from top to bottom' )
		genUtil.add( 3, 'small =' )
		genUtil.add( 3, '{' )
		genUtil.add( 4, '"Icon-tvOS-Small-4.png",' )
		genUtil.add( 4, '"Icon-tvOS-Small-3.png",' )
		genUtil.add( 4, '"Icon-tvOS-Small-2.png",' )
		genUtil.add( 4, '"Icon-tvOS-Small-1.png",' )
		genUtil.cap(3)

		genUtil.add( 3, '-- A collection of 1280x768 images, in order from top to bottom' )
		genUtil.add( 3, 'large =' )
		genUtil.add( 3, '{' )
		genUtil.add( 4, '"Icon-tvOS-Large-4.png",' )
		genUtil.add( 4, '"Icon-tvOS-Large-3.png",' )
		genUtil.add( 4, '"Icon-tvOS-Large-2.png",' )
		genUtil.add( 4, '"Icon-tvOS-Large-1.png",' )
		genUtil.cap(3,true)
		genUtil.cap(2,true)
		genUtil.cap(1)		
	end


	--
	-- File Exclusions -- EDOCHI
	-- 	
	local function toExclusionTable( info )
		if( not info ) then return {} end
		local result = {}
		if( string.len( info ) > 0 )  then
			local parts = string.split( info, "," )
			--table.dump( parts, nil, tostring(info) )
			for i = 1, #parts do
				result[i] = tostring(parts[i])
			end
		end
		return result

	end

	genUtil.add( 0, "-------------------------------------------------------------------------------" )
	genUtil.add( 0, "--  File Exclusions " )
	genUtil.add( 0, "-------------------------------------------------------------------------------" )
	genUtil.add( 1, "excludeFiles = {" )
	
	local exclude_all = toExclusionTable( configurationChoices.exclude_all )
	genUtil.string_table_param( 2, 8, "all", exclude_all )	
	
	if( apple_phones == true or apple_tablets == true ) then
		local exclude_iphone = toExclusionTable( configurationChoices.exclude_ios )
		genUtil.string_table_param( 2, 8, "iphone", exclude_iphone )	
	end

	if( android_phones == true or android_tablets == true or android_tv == true ) then
		local exclude_android = toExclusionTable( configurationChoices.exclude_android )
		genUtil.string_table_param( 2, 8, "android", exclude_android )	
	end

	if( apple_tv == true ) then	
		local exclude_apple_tv = toExclusionTable( configurationChoices.exclude_tvos )
		genUtil.string_table_param( 2, 8, "tvos", exclude_apple_tv )	
	end

	if( osx_desktop == true ) then
		local exclude_osx = toExclusionTable( configurationChoices.exclude_osx )
		genUtil.string_table_param( 2, 8, "osx", exclude_osx )		
	end

	if( win32_desktop == true ) then
		local exclude_win32 = toExclusionTable( configurationChoices.exclude_win )
		genUtil.string_table_param( 2, 8, "win32", exclude_win32 )	
	end

	genUtil.cap( 1, true )
	genUtil.cap( 0, true, true )

	genUtil.add( 0, "return settings" )	
	
	-- ==========================================================
	return genUtil.getContent()
end


function build_settings.plugins( currentProject, indent )
	--print("********************************** assembling plugins build.settings code")
	--print("********************************** assembling plugins build.settings code")
	--print("********************************** assembling plugins build.settings code")

	local function getSupportedPlatforms( params )	
		--[[
		params = params or {}
		--table.dump(params)
		local iphone 	= fnn( params.iphone, apple_phones, apple_tablets )
		local android 	= fnn( params.android, android_phones, android_tablets, android_tv )
		local appletvos = fnn( params.appletvos, apple_tv )
		local osx 		= fnn( params.osx, osx_desktop )
		local win32 	= fnn( params.win32, win32_desktop )
		local kindle 	= fnn( params.kindle, android ) -- EFM EDOCHI refine this later
		local iphonesim = fnn( params.iphonesim, true )
		--]]
		local supportedPlatforms = '{'
		if( params.iphone ) 	then supportedPlatforms = supportedPlatforms .. ' iphone = true,' end
		if( params.android ) 	then supportedPlatforms = supportedPlatforms .. ' android = true,' end
		if( params.appletvos ) 	then supportedPlatforms = supportedPlatforms .. ' appletvos = true,' end
		if( params.osx ) 		then supportedPlatforms = supportedPlatforms .. ' osx = true,' end
		--if( params.win32 ) 		then supportedPlatforms = supportedPlatforms .. ' win-32 = true,' end  -- EDOCHI (win32 or win-32)
		if( params.win32 ) 		then supportedPlatforms = supportedPlatforms .. ' ["win-32"] = true,' end  -- EDOCHI (win32 or win-32)
		if( params.kindle ) 	then supportedPlatforms = supportedPlatforms .. ' ["android-kindle"] = true,' end
		if( params.iphonesim ) 	then supportedPlatforms = supportedPlatforms .. ' ["iphone-sim"] = true,' end
		supportedPlatforms = supportedPlatforms .. " }, "

		return supportedPlatforms
	end

	local google_play_services_added = false
	local google_game_network_added = false
	
	currentProject.plugins = currentProject.plugins or {}
	for k,v in pairs(currentProject.plugins ) do
		--print(k,v)
		--table.dump(v)

		-- Ads / Monetization
		if( v.id =="monetization_admob_plugin" ) then
			if( not google_play_services_added ) then
				genUtil.add( indent, '-- ' .. v.name .. ' & Google Play Services' )
				genUtil.add( indent, '["plugin.google.play.services"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, kindle = true } ) .. ' },' )
				genUtil.nl()
				android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_NETWORK_STATE"',} )
				google_play_services_added = true
			end

		elseif( v.id =="monetization_appodeal_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.appodeal"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, appletvos=true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_NETWORK_STATE"', '"android.permission.ACCESS_COARSE_LOCATION"', '"android.permission.WRITE_EXTERNAL_STORAGE"' } )
			plist = table.combineUnique_i( plist, { "NSAppTransportSecurity = { NSAllowsArbitraryLoads = true }" } )
			if( not google_play_services_added ) then
				google_play_services_added = true
				genUtil.add( indent, '-- Google Play Services & AdMob' )
				genUtil.add( indent, '["plugin.google.play.services"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, kindle = true } ) .. ' },' )
				genUtil.nl()
				android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
			end

		
		elseif( v.id =="monetization_appnext_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.appnext"] = { publisherId = "com.appnext", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_NETWORK_STATE"' } )
			plist = table.combineUnique_i( plist, { "NSAppTransportSecurity = { NSAllowsArbitraryLoads = true }" } )

			if( not google_play_services_added ) then
				google_play_services_added = true
				genUtil.add( indent, '-- Google Play Services & AdMob' )
				genUtil.add( indent, '["plugin.google.play.services"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, kindle = true } ) .. ' },' )
				genUtil.nl()
				android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
			end

		elseif( v.id =="monetization_applovin_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.applovin"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, appletvos = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_NETWORK_STATE"','"android.permission.WRITE_EXTERNAL_STORAGE"'} )

			if( not google_play_services_added ) then
				google_play_services_added = true
				genUtil.add( indent, '-- Google Play Services & AdMob' )
				genUtil.add( indent, '["plugin.google.play.services"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, kindle = true } ) .. ' },' )
				genUtil.nl()
				android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
			end

		elseif( v.id =="monetization_adbuddiz_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.adbuddiz"] = { publisherId = "com.adbuddiz", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_NETWORK_STATE"',} )

		elseif( v.id =="monetization_adcolony_plugin" ) then
			genDependencies.adColony = true
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.adcolony"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_NETWORK_STATE"',} )
			plist = table.combineUnique_i( plist, { "NSAppTransportSecurity = { NSAllowsArbitraryLoads = true }" } )
			if( not google_play_services_added ) then
				google_play_services_added = true
				genUtil.add( indent, '-- Google Play Services & AdMob' )
				genUtil.add( indent, '["plugin.google.play.services"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, kindle = true } ) .. ' },' )
				genUtil.nl()
				android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
			end

		elseif( v.id =="monetization_appsaholic_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.combre"] = { publisherId = "com.appsaholic", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_NETWORK_STATE"','"android.permission.ACCESS_COARSE_LOCATION"','"android.permission.ACCESS_FINE_LOCATION"','"android.permission.READ_PHONE_STATE"','"android.permission.WRITE_EXERNAL_STORAGE"','"com.google.android.providers.gsf.permissions.READ_GSERVICES"'} )
			plist = table.combineUnique_i( plist, { "NSAppTransportSecurity = { NSAllowsArbitraryLoads = true }" } )

		elseif( v.id =="monetization_chartboost_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.chartboost"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_NETWORK_STATE"',} )
			plist = table.combineUnique_i( plist, { "NSAppTransportSecurity = { NSAllowsArbitraryLoads = true }" } )
			if( not google_play_services_added ) then
				google_play_services_added = true
				genUtil.add( indent, '-- Google Play Services & AdMob' )
				genUtil.add( indent, '["plugin.google.play.services"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, kindle = true } ) .. ' },' )
				genUtil.nl()
				android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_NETWORK_STATE"','"android.permission.WRITE_EXTERNAL_STORAGE"',} )
			end
		
		elseif( v.id =="monetization_corona_ads_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.coronaAds"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
			genUtil.add( indent, '-- Android Social Sharing'  )
			genUtil.add( indent, '["shared.android.support.v4""] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_COARSE_LOCATION"','"android.permission.ACCESS_FINE_LOCATION"','"android.permission.ACCESS_NETWORK_STATE"','"com.google.android.providers.gsf.permissions.READ_GSERVICES"'} )
			plist = table.combineUnique_i( plist, { "NSAppTransportSecurity = { NSAllowsArbitraryLoads = true }" } )
			plist = table.combineUnique_i( plist, { 'NSLocationAlwaysUsageDescription = { "" }' } )
			plist = table.combineUnique_i( plist, { 'NSLocationWhenInUseUsageDescription  = { "" }' } )
			applicationChildElements = table.combineUnique_i( applicationChildElements, { '[[<activity android:name="com.facebook.ads.InterstitialAdActivity" android:configChanges="keyboardHidden|orientation|screenSize"/>]]' } )
			
			if( not google_play_services_added ) then
				google_play_services_added = true
				genUtil.add( indent, '-- Google Play Services' )
				genUtil.add( indent, '["plugin.google.play.services"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, kindle = true } ) .. ' },' )
				genUtil.nl()
				android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
			end

		elseif( v.id =="monetization_fan_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.fbAudienceNetwork"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_WIFI_STATE"'} )
			if( not google_play_services_added ) then
				google_play_services_added = true
				genUtil.add( indent, '-- Google Play Services' )
				genUtil.add( indent, '["plugin.google.play.services"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, kindle = true } ) .. ' },' )
				genUtil.nl()
				android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
			end

		elseif( v.id =="monetization_inmobi_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.inMobi"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"',} )
			if( not google_play_services_added ) then
				google_play_services_added = true
				genUtil.add( indent, '-- Google Play Services' )
				genUtil.add( indent, '["plugin.google.play.services"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, kindle = true } ) .. ' },' )
				genUtil.nl()
				android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
			end
				
		elseif( v.id =="monetization_iads_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["CoronaProvider.ads.iads"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { iphone = true } ) .. ' },' )
			genUtil.nl()

		elseif( v.id =="monetization_kidoz_plugin" ) then
			genDependencies.kidoz = true
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.kidoz"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
			if( not google_play_services_added ) then
				google_play_services_added = true
				genUtil.add( indent, '-- Google Play Services' )
				genUtil.add( indent, '["plugin.google.play.services"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, kindle = true } ) .. ' },' )
				genUtil.nl()
				android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
			end

		elseif( v.id =="monetization_mediabrix_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.mediaBrix"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_NETWORK_STATE"','"android.permission.WRITE_EXTERNAL_STORAGE"'} )
			if( not google_play_services_added ) then
				google_play_services_added = true
				genUtil.add( indent, '-- Google Play Services' )
				genUtil.add( indent, '["plugin.google.play.services"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, kindle = true } ) .. ' },' )
				genUtil.nl()
				android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
			end


		elseif( v.id =="monetization_peanuts_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.peanutlabs"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"' } )
			plist = table.combineUnique_i( plist, { "NSAppTransportSecurity = { NSAllowsArbitraryLoads = true }" } )

			if( not google_play_services_added ) then
				google_play_services_added = true
				genUtil.add( indent, '-- Google Play Services & AdMob' )
				genUtil.add( indent, '["plugin.google.play.services"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, kindle = true } ) .. ' },' )
				genUtil.nl()
				android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
			end

		elseif( v.id =="monetization_pollfish_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.pollfish"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_WIFI_STATE"','"android.permission.READ_PHONE_STATE"','"android.permission.ACCESS_NETWORK_STATE"','"android.permission.ACCESS_FINE_LOCATION"'} )
			plist = table.combineUnique_i( plist, { "NSAppTransportSecurity = { NSAllowsArbitraryLoads = true }" } )



		elseif( v.id =="monetization_personaly_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.personaly"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
			if( not google_play_services_added ) then
				google_play_services_added = true
				genUtil.add( indent, '-- Google Play Services' )
				genUtil.add( indent, '["plugin.google.play.services"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, kindle = true } ) .. ' },' )
				genUtil.nl()
				android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
			end


		elseif( v.id =="monetization_revmob_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.revmob"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()

			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
			plist = table.combineUnique_i( plist, { "NSAppTransportSecurity = { NSAllowsArbitraryLoads = true }" } )
			applicationChildElements = table.combineUnique_i( applicationChildElements, { '[[<activity android:name="com.facebook.ads.InterstitialAdActivity" android:configChanges="keyboardHidden|orientation|screenSize"/>]]' } )
			
			if( not google_play_services_added ) then
				google_play_services_added = true
				genUtil.add( indent, '-- Google Play Services' )
				genUtil.add( indent, '["plugin.google.play.services"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, kindle = true } ) .. ' },' )
				genUtil.nl()
				android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
			end

		
		elseif( v.id =="monetization_stripe_plugin" ) then
			genUtil.add( indent, '-- @schroederapps Stripe plugin:' )
			genUtil.add( indent, '["plugin.stripe"] = { publisherId = "com.jasonschroeder", supportedPlatforms = ' .. getSupportedPlatforms( { iphone = true, android = true, osx = true, win32 = true } ) .. ' },' )
			genUtil.nl()


		elseif( v.id =="monetization_superawesome_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.superawesome"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_NETWORK_STATE"',} )
			if( not google_play_services_added ) then
				google_play_services_added = true
				genUtil.add( indent, '-- Google Play Services' )
				genUtil.add( indent, '["plugin.google.play.services"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, kindle = true } ) .. ' },' )
				genUtil.nl()
				android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
			end

		elseif( v.id =="monetization_supersonic_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.supersonic"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
			if( not google_play_services_added ) then
				google_play_services_added = true
				genUtil.add( indent, '-- Google Play Services' )
				genUtil.add( indent, '["plugin.google.play.services"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, kindle = true } ) .. ' },' )
				genUtil.nl()
				android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
			end

		elseif( v.id =="monetization_trial_pay_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.trialPay"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"', '"android.permission.ACCESS_NETWORK_STATE"', '"android.permission.READ_PHONE_STATE"', '"android.permission.WRITE_EXTERNAL_STORAGE"', '"android.permission.ACCESS_WIFI_STATE"'} )
			plist = table.combineUnique_i( plist, { "NSAppTransportSecurity = { NSAllowsArbitraryLoads = true }" } )
			
			if( not google_play_services_added ) then
				google_play_services_added = true
				genUtil.add( indent, '-- Google Play Services' )
				genUtil.add( indent, '["plugin.google.play.services"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, kindle = true } ) .. ' },' )
				genUtil.nl()
				android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"', } )
			end			


		elseif( v.id =="monetization_vungle_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["CoronaProvider.ads.vungle"] = { publisherId = "com.vungle", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.WRITE_EXTERNAL_STORAGE"','"android.permission.ACCESS_NETWORK_STATE"',} )
			if( not google_play_services_added ) then
				google_play_services_added = true
				genUtil.add( indent, '-- Google Play Services' )
				genUtil.add( indent, '["plugin.google.play.services"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, kindle = true } ) .. ' },' )
				genUtil.nl()
				android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
			end

		-- Analytics
		elseif( v.id =="flurry_plugin_legacy" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.flurry.analytics"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
			if( not google_play_services_added ) then
				google_play_services_added = true
				genUtil.add( indent, '-- Google Play Services' )
				genUtil.add( indent, '["plugin.google.play.services"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, kindle = true } ) .. ' },' )
				genUtil.nl()
	 			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_NETWORK_STATE"',} )
			end

		elseif( v.id =="flurry_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.flurry.analytics"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
			if( not google_game_network_added ) then
				google_game_network_added = true
				genUtil.add( indent, '-- Google Play Game Services' )
				genUtil.add( indent, '["CoronaProvider.gameNetwork.google"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true } ) .. ' },' )
				genUtil.nl()
	 			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
			end
		
		elseif( v.id =="google_analytics_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.googleAnalytics"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_NETWORK_STATE"',} )


		elseif( v.id =="parse_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.parse"] = { publisherId = "com.develephant", },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )

		-- Attribution
		elseif( v.id =="kochava_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.kochava"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, iphonesim = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_NETWORK_STATE"',} )
			if( not google_play_services_added ) then
				google_play_services_added = true
				genUtil.add( indent, '-- Google Play Services' )
				genUtil.add( indent, '["plugin.google.play.services"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, kindle = true } ) .. ' },' )
				genUtil.nl()
	 			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_NETWORK_STATE"',} )
			end
		
		-- Gaming
		elseif( v.id =="gaming_amazon_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.gamecircle"] = { publisherId = "COM_INNOVATIVELEISURE", supportedPlatforms = ' .. getSupportedPlatforms( { kindle = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_NETWORK_STATE"',} )

		elseif( v.id =="gaming_apple_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["CoronaProvider.gameNetwork.apple"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { iphone = true } ) .. ' },' )
			genUtil.nl()
		
		elseif( v.id =="gaming_dreamlo_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.dreamlo"] = { publisherId = "com.scottrules44", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, iphonesim = true, kindle = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"',} )

		elseif( v.id =="gaming_gamekit_plugin" ) then
			genDependencies.gamekit = true
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.gamekit"] = { publisherId = "com.animonger", supportedPlatforms = ' .. getSupportedPlatforms( { iphone = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"',} )

		elseif( v.id =="gaming_google_plugin" ) then			
			if( not google_game_network_added ) then
				google_game_network_added = true
				genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
				genUtil.add( indent, '["CoronaProvider.gameNetwork.google"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true } ) .. ' },' )
				genUtil.nl()
	 			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
			end
			
		elseif( v.id =="gaming_one_signal_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			--genUtil.add( indent, '["plugin.onesignal"] = { publisherId = "com.onesignal", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, iphonesim = true, kindle = true } ) .. ' },' )
			genUtil.add( indent, '["plugin.OneSignal"] = { publisherId = "com.onesignal" },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_NETWORK_STATE"',} )
			if( not google_play_services_added ) then
				google_play_services_added = true
				genUtil.add( indent, '-- Google Play Services' )
				genUtil.add( indent, '["plugin.google.play.services"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, kindle = true } ) .. ' },' )
				genUtil.nl()
	 			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_NETWORK_STATE"',} )
			end
			plist = table.combineUnique_i( plist, { 'UIBackgroundModes = {"remote-notification"}' } )


		elseif( v.id =="gaming_ouya_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.ouya"] = { publisherId = "tv.ouya", supportedPlatforms = ' .. getSupportedPlatforms( { android = true,  } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"',} )
			android_intent_filters = table.combineUnique_i( android_intent_filters, {'categories = { "tv.ouya.intent.category.GAME" }',} )

		elseif( v.id =="gaming_photon_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.photon"] = { publisherId = "com.exitgames", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, iphonesim = true, } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
		
		-- In-App Purchasing
		elseif( v.id =="iap_badger_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.iap_badger"] = { publisherId = "uk.co.happymongoose", supportedPlatforms = ' .. getSupportedPlatforms( { iphone = true, android = true, osx = true, win32 = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )

		elseif( v.id =="iap_google_plugin" ) then
			
			genUtil.add( indent, '["plugin.google.iap.v3"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"com.android.vending.BILLING"','"android.permission.INTERNET"',} )
		
		elseif( v.id =="iap_amazon_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.amazon.iap"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { kindle = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
		
		elseif( v.id =="iap_fortumo_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.fortumo"] = { publisherId = "com.fortumo", supportedPlatforms = ' .. getSupportedPlatforms( { android = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
		
		-- Social Media
		elseif( v.id =="social_facebookv4_plugin" ) then
			local FacebookAppID = "XXXXXXXXXX"
			if(currentProject.settings.social_facebook_v4_app_id) then
				FacebookAppID = tostring( currentProject.settings.social_facebook_v4_app_id )
			end
			
			genDependencies.facebookv4 = true
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.facebook.v4"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { iphone = true, android = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
			plist = table.combineUnique_i( plist, { 'FacebookAppID = "' .. FacebookAppID .. '"' } )
			plist = table.combineUnique_i( plist, { 'CFBundleURLTypes ={ { CFBundleURLSchemes = { "fb' .. FacebookAppID .. '", } } }' } )
		
		elseif( v.id =="social_popup_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["CoronaProvider.native.popup.social"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
		
		elseif( v.id =="social_twitter_plugin" ) then
			genUtil.add( indent, '-- @schroederapps Twitter  plugin:' )
			genUtil.add( indent, '["plugin.twitter"] = { publisherId = "com.jasonschroeder", supportedPlatforms = ' .. getSupportedPlatforms( { iphone = true, android = true, osx = true, win32 = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
		
		-- Business
		elseif( v.id =="business_address_book_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["CoronaProvider.native.popup.addressbook"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { iphone = true } ) .. ' },' )
			genUtil.nl()
		
		elseif( v.id =="business_pasteboard_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.pasteboard"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { iphone = true } ) .. ' },' )
			genUtil.nl()
		
		elseif( v.id =="business_quicklook_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["CoronaProvider.native.popup.quickLook"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { iphone = true } ) .. ' },' )
			genUtil.nl()
		
		-- Miscellaneous
		elseif( v.id =="util_awcolor_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.awcolor"] = { publisherId = "com.aaronsserver" },' )
			genUtil.nl()

		elseif( v.id =="util_activity_popup_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["CoronaProvider.native.popup.activity"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { iphone = true } ) .. ' },' )
			genUtil.nl()
		
		elseif( v.id =="util_advertising_id_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.advertisingId"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
		
		elseif( v.id =="util_bit_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.bit"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, osx = true, win32 = true } ) .. ' },' )
			genUtil.nl()

		elseif( v.id =="util_bbbthermometer_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.bonbonbearThermometer""] = { publisherId = "com.deleurapps", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()

		elseif( v.id =="util_cc_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.cc"] = { publisherId = "com.roaminggamer" },' )
			genUtil.nl()

		elseif( v.id =="utilities_corona_splash_control_plugin" ) then
			genDependencies.splashControlEnabled = true
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.CoronaSplashControl"] = { publisherId = "com.coronalabs" },' )
			genUtil.nl()

		elseif( v.id =="util_flashlight_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.flashlight"] = { publisherId = "com.spiralcodestudio" },' )
			genUtil.nl()

		elseif( v.id =="util_gbcdatacabinet_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.GBCDataCabinet"] = { publisherId = "com.gamesbycandlelight" },' )
			genUtil.nl()

		elseif( v.id =="util_gbclanguagecabinetr_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.GBCLanguageCabinet"] = { publisherId = "com.gamesbycandlelight" },' )
			genUtil.nl()

		elseif( v.id =="util_googledrive_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.googleDrive"] = { publisherId = "com.scottrules44" },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )

		elseif( v.id =="hockeyapp_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.hockey"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
 			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"', '"android.permission.WRITE_EXTERNAL_STORAGE"'} )

		elseif( v.id =="hockeyapp_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.hockey"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
 			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET", "android.permission.WRITE_EXTERNAL_STORAGE"'} )
			
		elseif( v.id =="util_icloud_plugin" ) then
			genDependencies.icloud = true
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.iCloud"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { iphone = true, appletvos = true, osx = true } ) .. ' },' )
			genUtil.nl()

		elseif( v.id =="util_math2d_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.math2d"] = { publisherId = "com.roaminggamer" },' )
			genUtil.nl()

		elseif( v.id =="util_memorybitmap_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.memoryBitmap"] = { publisherId = "com.coronalabs" },' )
			genUtil.nl()


		elseif( v.id =="util_mwc_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.mwc"] = { publisherId = "com.xibalbastudios" },' )
			genUtil.nl()

		elseif( v.id =="util_nfc_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.nfc"] = { publisherId = "com.spiralcodestudio" },' )
			genUtil.nl()

		
		elseif( v.id =="util_notifications_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.notifications"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
 			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
		

		elseif( v.id =="util_ondemandresources_plugin" ) then
			genDependencies.ondemandresources = true
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.onDemandResources"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { apple_tv = true } ) .. ' },' )
			genUtil.nl()
		
		elseif( v.id =="util_openudid_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.openudid"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { iphone = true } ) .. ' },' )
			genUtil.nl()

		elseif( v.id =="util_pagecurl_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.pagecurl"] = { publisherId = "com.xibalbastudios" },' )
			genUtil.nl()

		elseif( v.id =="util_photolibplus_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.photoLibPlus"] = { publisherId = "com.deleurapps" },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.READ_EXTERNAL_STORAGE"'} )
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.WRITE_EXTERNAL_STORAGE"'} )

		elseif( v.id =="util_physicsbodyeditor_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.physicsBodyEditor"] = { publisherId = "com.scottrules44" },' )
			genUtil.nl()
 			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )

		elseif( v.id =="util_qrscanner_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.qrscanner"] = { publisherId = "com.spiralcodestudio" },' )
			genUtil.nl()

		elseif( v.id =="util_quaternion_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.quaternion"] = { publisherId = "com.xibalbastudios" },' )
			genUtil.nl()

		elseif( v.id =="util_safari_view_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["CoronaProvider.native.popup.safariView"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { iphone = true } ) .. ' },' )			
			genUtil.nl()

		elseif( v.id =="util_stablearray_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.stablearray"] = { publisherId = "com.xibalbastudios" },' )
			genUtil.nl()

		elseif( v.id =="util_steamworks_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.steamworks""] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { osx = true, win32 = true } ) .. ' },' )
			genUtil.nl()
			
		
		elseif( v.id =="util_textospeech_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.texttospeech"] = { publisherId = "com.spiralcodestudio" },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )

		elseif( v.id =="util_toast_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.toast"] = { publisherId = "com.spiralcodestudio" },' )
			genUtil.nl()

		elseif( v.id =="util_tweentrain_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.tweentrain"] = { publisherId = "com.erinylin" },' )
			genUtil.nl()

		elseif( v.id =="util_twilio_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.twilio"] = { publisherId = "com.deleurapps" },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )

		elseif( v.id =="util_utf8_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.utf8"] = { publisherId = "com.coronalabs" },' )
			genUtil.nl()

		elseif( v.id =="util_vibrator_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.vibrator"] = { publisherId = "com.spiralcodestudio" },' )
			genUtil.nl()

		elseif( v.id =="util_vk_plugin" ) then
			genDependencies.vk = true
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.vk"] = { publisherId = "com.spiralcodestudio" },' )
			genUtil.nl()

		elseif( v.id =="util_zip_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.zip"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, osx = true, win32 = true } ) .. ' },' )
			genUtil.nl()
		

		elseif( v.id =="other_itunes_media_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.iTunes"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { iphone = true } ) .. ' },' )
			genUtil.nl()
		
		elseif( v.id =="other_openssl_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.openssl"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, osx = true, win32 = true} ) .. ' },' )
			genUtil.nl()

		-- Added in release 2017.019
		elseif( v.id =="unityads_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.unityads"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. 
				getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
		elseif( v.id =="ga_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.gameanalytics_v2"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. 
				getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_NETWORK_STATE"',} )
		elseif( v.id =="tenjin_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.tenjin"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. 
				getSupportedPlatforms( { android = true, iphone = true, iphonesim = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_NETWORK_STATE"',} )
			if( not google_play_services_added ) then
				google_play_services_added = true
				genUtil.add( indent, '-- Google Play Services & AdMob' )
				genUtil.add( indent, '["plugin.google.play.services"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, kindle = true } ) .. ' },' )
				genUtil.nl()
				android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
			end
		elseif( v.id =="tune_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.tune"] = { publisherId = "com.tune", supportedPlatforms = ' .. 
				getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_NETWORK_STATE"',} )
			if( not google_play_services_added ) then
				google_play_services_added = true
				genUtil.add( indent, '-- Google Play Services & AdMob' )
				genUtil.add( indent, '["plugin.google.play.services"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, kindle = true } ) .. ' },' )
				genUtil.nl()
				android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"'} )
			end
			genUtil.add( indent, '["shared.android.support.v4""] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true } ) .. ' },' )
			genUtil.nl()
		elseif( v.id =="storekit_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.storeKit"] = { publisherId = "com.scottrules44" },' )
			genUtil.nl()
		elseif( v.id =="kiip_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.kiip"] = { publisherId = "me.kiip", supportedPlatforms = ' .. 
				getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_NETWORK_STATE"','"android.permission.ACCESS_COARSE_LOCATION"','"android.permission.ACCESS_FINE_LOCATION"',} )
			plist = table.combineUnique_i( plist, { "NSAppTransportSecurity = { NSAllowsArbitraryLoads = true }" } )
		elseif( v.id =="storeview_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.storeView"] = { publisherId = "com.infusedreams" },' )
			genUtil.nl()
		elseif( v.id =="razerstore_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.razerStore"] = { publisherId = "com.razerzone" },' )
			genUtil.nl()
		elseif( v.id =="facebookanalytics_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.facebookAnalytics"] = { publisherId = "com.scottrules44", supportedPlatforms = ' .. 
				getSupportedPlatforms( { android = true, iphone = true, kindle = true } ) .. ' },' )
			genUtil.nl()
		elseif( v.id =="kochava_faa_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.kochava.faa"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. getSupportedPlatforms( { android = true, iphone = true, iphonesim = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_NETWORK_STATE"',} )
			if( not google_play_services_added ) then
				google_play_services_added = true
				genUtil.add( indent, '-- Google Play Services' )
				genUtil.add( indent, '["plugin.google.play.services"] = { publisherId = "com.coronalabs", supportedPlatforms = ' .. 
					getSupportedPlatforms( { android = true, iphone = true, iphonesim = true } ) .. ' },' )
				genUtil.nl()
	 			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.ACCESS_NETWORK_STATE"',} )
			end
		elseif( v.id =="airprint_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.airprint"] = { publisherId = "com.scotth" },' )
			genUtil.nl()
		elseif( v.id =="screenrecorder_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.screenRecorder"] = { publisherId = "com.scotth" },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.CAPTURE_VIDEO_OUTPUT"','"android.permission.RECORD_AUDIO"',} )
			plist = table.combineUnique_i( plist, { 'NSMicrophoneUsageDescription =  "Used for recording audio"' } )
		elseif( v.id =="proximitysensor_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.proximitySensor"] = { publisherId = "com.scottrules44", supportedPlatforms = ' .. 
					getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
		elseif( v.id =="textbelt_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.textbelt"] = { publisherId = "com.scottrules44" },' )
			genUtil.nl()
		elseif( v.id =="quickaction_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.quickAction"] = { publisherId = "com.scottrules44", supportedPlatforms = ' .. 
					getSupportedPlatforms( { iphone = true } ) .. ' },' )
			genUtil.nl()
		elseif( v.id =="volumecontrol_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.volumeControl"] = { publisherId = "com.scottrules44", supportedPlatforms = ' .. 
					getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
		elseif( v.id =="gamecenter_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.gamecenter"] = { publisherId = "com.scottrules44" },' )
			genUtil.nl()
		elseif( v.id =="voicetotext_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.voiceToText"] = { publisherId = "com.scottrules44", supportedPlatforms = ' .. 
					getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, {'"android.permission.INTERNET"','"android.permission.RECORD_AUDIO"',} )
			plist = table.combineUnique_i( plist, { 'NSMicrophoneUsageDescription =  "Used for recording audio"' } )
			plist = table.combineUnique_i( plist, { 'NSSpeechRecognitionUsageDescription =  "Speech recognition will be used to determine which words you speak into this devices microphone."' } )
		elseif( v.id =="pebble_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.pebble"] = { publisherId = "com.scottrules44", supportedPlatforms = ' .. 
					getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
		elseif( v.id =="musicstreaming_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.musicStreaming"] = { publisherId = "com.scottrules44" },' )
			genUtil.nl()
		elseif( v.id =="moreinfo_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.moreInfo"] = { publisherId = "com.scottrules44" },' )
			genUtil.nl()
		elseif( v.id =="tapticengine_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.tapticEngine"] = { publisherId = "com.scottrules44" },' )
			genUtil.nl()
		elseif( v.id =="replaykit_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.replayKit"] = { publisherId = "com.scottrules44" },' )
			genUtil.nl()
		elseif( v.id =="onepasswd_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.onePassword"] = { publisherId = "com.scottrules44" },' )
			genUtil.nl()
		elseif( v.id =="touchid_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.touchId"] = { publisherId = "com.scottrules44" },' )
			genUtil.nl()
		elseif( v.id =="firebase_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.firebase"] = { publisherId = "com.scottrules44" },' )
			genUtil.nl()
			android_permissions = table.combineUnique_i( android_permissions, 
				{'"android.permission.INTERNET"',
				 '"android.permission.GET_ACCOUNTS"',
				 '"android.permission.RECEIVE_BOOT_COMPLETED"',
				 '"com.google.android.c2dm.permission.RECEIVE"',
				 '".permission.C2D_MESSAGE"', } )
		elseif( v.id =="contacts_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.contacts"] = { publisherId = "com.scottrules44", supportedPlatforms = ' .. 
					getSupportedPlatforms( { android = true, iphone = true } ) .. ' },' )
			genUtil.nl()
		elseif( v.id =="paypal_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.paypal"] = { publisherId = "com.scottrules44" },' )
			genUtil.nl()

		elseif( v.id =="playfab_client_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.playfab.client"] = { publisherId = "com.playfab" },' )
			genUtil.nl()
		elseif( v.id =="playfab_server_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.playfab.server"] = { publisherId = "com.playfab" },' )
			genUtil.nl()
		elseif( v.id =="playfab_combo_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.playfab.combo"] = { publisherId = "com.playfab" },' )
			genUtil.nl()
		elseif( v.id =="bluetooth_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.bluetooth"] = { publisherId = "com.spiralcodestudio" },' )
			genUtil.nl()
		elseif( v.id =="rokomobi_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.rokomobi"] = { publisherId = "com.rokolabs" },' )
			genUtil.nl()
		elseif( v.id =="facedetector_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.faceDetector"] = { publisherId = "net.shakebrowser" },' )
			genUtil.nl()
		elseif( v.id =="uiframework_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.ui_framework"] = { publisherId = "com.skyjoy" },' )
			genUtil.nl()
		elseif( v.id =="mousecursor_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.mousecursor"] = { publisherId = "com.spiralcodestudio" },' )
			genUtil.nl()
		elseif( v.id =="luaproc_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.luaproc"] = { publisherId = "com.xibalbastudios" },' )
			genUtil.nl()
		elseif( v.id =="deltatime_plugin" ) then
			genUtil.add( indent, '-- ' .. (v.name or v.id or v.content_name) )
			genUtil.add( indent, '["plugin.deltatime"] = { publisherId = "com.julianvidal" },' )
			genUtil.nl()
		
		-- EDOCHI
		--elseif( v.id =="EFM" ) then
			--genUtil.add( indent, 'EFM' )
			--genUtil.add( indent, '["plugin.google.play.services"] = { publisherId = "com.coronalabs", supportedPlatforms =  android = true, iphone = true, kindle = true } ) .. ' },' )
			--genUtil.nl()
			--android_permissions = table.combineUnique_i( android_permissions, {EFM} )
		end
	end
end

return build_settings