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
local config_lua = {}

function config_lua.generate( fileName, currentProject )

	-- Discover any special build.settings choices the user may have set like plugins, etc.
	-- Later, we'll use this info to proper setup the config.lua file.
	local configDependencies = {}	
	for k,v in pairs(currentProject.plugins ) do
		if( v.id == "hockeyapp_plugin" ) then
			configDependencies.hockeyapp = true
		end
	end
	--table.dump(currentProject.plugins,nil,"plugins")
	--table.dump(configDependencies,nil,"configDependencies")

	genUtil.resetContent()
	local padLen = string.len("showRuntimeErrors") + 1

	--table.dump( currentProject.settings )
	local configurationChoices 	=  currentProject.settings
	local resolutionMethod 		= configurationChoices.resolution_selection_method
	

	-- Header	
	genUtil.add( 0, "-- =============================================================" )
	genUtil.add( 0, "-- " .. (currentProject.copyright_statement or "Your Copyright Statement Goes Here") )
	genUtil.add( 0, "-- =============================================================" )
	genUtil.add( 0, "--  " .. fileName )
	genUtil.add( 0, "-- =============================================================" )
	genUtil.add( 0, "-- https://docs.coronalabs.com/daily/guide/basics/configSettings/index.html" )
	genUtil.add( 0, "-- =============================================================" )
	genUtil.nl()

	if( resolutionMethod == "Smart Pixel" ) then
		genUtil.add( 0, '-- Smart Pixel Method by Sergey Lerg:' )
		genUtil.add( 0, '-- http://spiralcodestudio.com/corona-sdk-pro-tip-of-the-day-36/' )
		genUtil.nl()
		genUtil.add( 0, 'local w, h = display.pixelWidth, display.pixelHeight' )
		genUtil.nl()

		genUtil.add( 0, 'local modes = {1, 1.5, 2, 3, 4, 6, 8} -- Scaling factors to try' )
		--genUtil.add( 0, 'local contentW, contentH = 320, 480   -- Minimal size your content can fit in' )
		local contentW = configurationChoices.smartpixel_ideal_width
		local contentH = configurationChoices.smartpixel_ideal_height
		genUtil.add( 0, 'local contentW, contentH = ' .. contentW .. ', ' .. contentH .. '   -- Minimal size your content can fit in' )
		genUtil.nl()

		genUtil.add( 0, '-- Try each mode and find the best one' )
		genUtil.add( 0, 'local _w, _h, _m = w, h, 1' )
		genUtil.add( 0, 'for i = 1, #modes do' )
		genUtil.add( 1, 'local m = modes[i]' )
		genUtil.add( 1, 'local lw, lh = w / m, h / m' )
		genUtil.add( 1, 'if lw < contentW or lh < contentH then' )
		genUtil.add( 2, 'break' )
		genUtil.add( 1, 'else' )
		genUtil.add( 2, '_w, _h, _m = lw, lh, m' )
		genUtil.add( 1, 'end' )
		genUtil.add( 0, 'end  ' )
		genUtil.add( 0, '-- If scaling is not pixel perfect (between 1 and 2) - use letterbox' )
		genUtil.add( 0, 'if _m < 2 then' )
		genUtil.add( 1, 'local scale = math.max(contentW / w, contentH / h)' )
		genUtil.add( 1, '_w, _h = w * scale, h * scale' )
		genUtil.add( 0, 'end' )
		genUtil.nl()
	end

	-- Open application table
	genUtil.add( 0, "application = {" )

	-- Steam Works
	local steamWorksEn = false
	for k,v in pairs(currentProject.plugins ) do
		if( v.id == "util_steamworks_plugin" ) then
			steamWorksEn = true
		end
	end

	if( steamWorksEn ) then
		table.dump(currentProject)
		local appID = tostring( currentProject.settings.utilities_steamworks_appname )
		genUtil.add( 1, 'steamworks = { appId = "' .. appID .. '" },' )
		genUtil.nl()
	end


	-- Open content table
	genUtil.add( 1, "content = {" )
	
	if( resolutionMethod == "Common Resolutions" ) then
		--
		-- width / height
		local val = configurationChoices.commonResolution:split( " " )
		genUtil.decimal_param( 2, padLen, "width", val[1] or 640 )
		genUtil.decimal_param( 2, padLen, "height", val[3] or 960 )

	elseif( resolutionMethod == "Device List" ) then
		local resolutionByDevice = {}
		resolutionByDevice["iPhone 4"] 		= { 640, 960 }
		resolutionByDevice["iPhone 5"] 		= { 640, 1136 }
		resolutionByDevice["iPhone 6"] 		= { 750, 1334 }
		resolutionByDevice["iPhone 6+"] 	= { 1080, 1920 }
		resolutionByDevice["iPad Air"] 		= { 1536, 2048 }
		resolutionByDevice["iPad Pro"] 		= { 2048, 2732 }
		resolutionByDevice["Kindle Fire"] 	= { 800, 1280 }
		resolutionByDevice["OUYA"] 			= { 720, 1280 }
		resolutionByDevice["TV/Console"] 	= { 1080, 1920 }

		--
		-- width / height
		genUtil.decimal_param( 2, padLen, "width", resolutionByDevice[configurationChoices.deviceResolution][1] )
		genUtil.decimal_param( 2, padLen, "height", resolutionByDevice[configurationChoices.deviceResolution][2] )

	elseif( resolutionMethod == "User Defined" ) then
		--
		-- width / height
		genUtil.decimal_param( 2, padLen, "width", configurationChoices.resolution_width )
		genUtil.decimal_param( 2, padLen, "height", configurationChoices.resolution_height )
	elseif( resolutionMethod == "Smart Pixel" ) then
		genUtil.add( 2, 'width = _w,' )
		genUtil.add( 2, 'height = _h,' )
		genUtil.add( 2, 'scale = "letterbox",' )		
	end


	if( resolutionMethod ~= "Smart Pixel" ) then
		--	
		--
		-- scale mode
		genUtil.string_param( 2, padLen, "scale", configurationChoices.scaling )
		--
		-- fps mode
		genUtil.decimal_param( 2, padLen, "fps", configurationChoices.frame_rate )
		--
		-- x/y Align
		genUtil.string_param( 2, padLen, "xAlign", configurationChoices.x_align )
		genUtil.string_param( 2, padLen, "yAlign", configurationChoices.y_align )
		--
		-- DEBUG Show Runtime Errors
		if( configDependencies.hockeyapp ) then
			genUtil.bool_param( 2, padLen, "showRuntimeErrors", "true" )
		elseif( configurationChoices.show_runtime_errors ~= "auto" ) then
			genUtil.bool_param( 2, padLen, "showRuntimeErrors", configurationChoices.show_runtime_errors )
		end
		--
		-- Shader Precision
		if( configurationChoices.shader_precision ~= "auto" ) then
			genUtil.string_param( 2, padLen, "shaderPrecision", configurationChoices.shader_precision  )
		end

		--
		-- Suffix Table
		if( configurationChoices.dyanamic_image_scaling_en == "true" ) then -- EDOCHI -- MISSING
			genUtil.add( 2, "imageSuffix = {" )
			if( string.len(configurationChoices.image_scaling_2x) > 0 ) then
				genUtil.float_param( 3, 8, '["@2x"]', tostring(configurationChoices.image_scaling_2x) )
			end
			if( string.len(configurationChoices.image_scaling_3x) > 0 ) then
				genUtil.float_param( 3, 8, '["@3x"]', tostring(configurationChoices.image_scaling_3x) )
			end
			if( string.len(configurationChoices.image_scaling_4x) > 0 ) then
				genUtil.float_param( 3, 8, '["@4x"]', tostring(configurationChoices.image_scaling_4x) )
			end
			genUtil.cap( 2, true )
		end		
	else
		--
		-- Suffix Table
		if( configurationChoices.dyanamic_image_scaling_en == "true" ) then -- EDOCHI -- MISSING
			genUtil.add( 2, "imageSuffix = {" )
			if( string.len(configurationChoices.image_scaling_2x) > 0 ) then
				genUtil.float_param( 3, 8, '["@2x"]', tostring(configurationChoices.image_scaling_2x) )
			end
			if( string.len(configurationChoices.image_scaling_3x) > 0 ) then
				genUtil.float_param( 3, 8, '["@3x"]', tostring(configurationChoices.image_scaling_3x) )
			end
			if( string.len(configurationChoices.image_scaling_4x) > 0 ) then
				genUtil.float_param( 3, 8, '["@4x"]', tostring(configurationChoices.image_scaling_4x) )
			end
			genUtil.cap( 2, true )
		end
		--
		-- fps mode
		genUtil.decimal_param( 2, padLen, "fps", configurationChoices.frame_rate )
		--
		-- x/y Align
		genUtil.string_param( 2, padLen, "xAlign", configurationChoices.x_align )
		genUtil.string_param( 2, padLen, "yAlign", configurationChoices.y_align )

		--
		-- DEBUG Show Runtime Errors
		if( configDependencies.hockeyapp ) then
			genUtil.bool_param( 2, padLen, "showRuntimeErrors", "true" )
		elseif( configurationChoices.show_runtime_errors ~= "auto" ) then
			genUtil.bool_param( 2, padLen, "showRuntimeErrors", configurationChoices.show_runtime_errors )
		end
		--
		-- Shader Precision
		if( configurationChoices.shader_precision ~= "auto" ) then
			genUtil.string_param( 2, padLen, "shaderPrecision", configurationChoices.shader_precision  )
		end
	end

	-- Close currentContent table
	genUtil.cap( 1, true )


	--
	-- Licensing	-- EDOCHI -- MISSING
	--
	local licenseKey = "" --currentProject.interfaceChoices.noads_google_license_key or ""
	if( string.len(licenseKey) > 0 and licenseKey ~= "none" ) then
		genUtil.add( 1, 'license = {' )
		genUtil.add( 2, ' google = {' )
		genUtil.add( 3, 'key = "' .. licenseKey .. '",' )
		genUtil.add( 3, '--policy = "this is optional",' )
		genUtil.cap( 2, true, true )
		genUtil.cap( 1, true, true )
	end

	-- Close application table
	genUtil.cap( 0, true, true )

	-- ==========================================================
	return genUtil.getContent()

end

return config_lua