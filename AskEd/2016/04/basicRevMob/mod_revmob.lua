-- EFM "PLACEMENT_ID" -- Used to identify when shown for analysis later 

-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2016
-- =============================================================
-- EAT RevMob Module (Proprietary Paid Content)
-- =============================================================
--
-- This module is proprietary paid content, that is  ONLY available 
-- through the EAT Framwork Tool.  
--
-- This content may only delivered to third parties as part of a 
-- completed game developed using EAT.
--
-- This content may not be distributed as an example, in any how-to
-- guides, or bundled with educational products not also bundled with
-- a paid copy of EAT.
--
-- If any of the above limitations is true, you and the third party may
-- be in violation of the EAT EULA.  Please delete this content immediately,
-- and contact EAT support for clarification.
--
-- =============================================================
--[[
> mod.init(  id [, listenter ] ) 
> mod.loadInterstitial( )
> mod.showBanner( [ bannerPosition [ , placementID [ , retries ] ] ] )
> mod.hide( )
> mod.enableDebug( [ enable ] )
> mod.enableAutoLoad( [ enable ] )
> mod.setAdMode( adType )
> mod.setPlacementID( placementID )
> mod.setListener( listener )
> mod.setMaxRetries( retries )
> mod.setRetryTime( time )
--]]
-- =============================================================

local revmob = require( "plugin.revmob" )

local w 			= display.contentWidth
local h 			= display.contentHeight
local fullw 		= display.actualContentWidth
local fullh 		= display.actualContentHeight
local centerX 		= display.contentCenterX
local centerY 		= display.contentCenterY
local left   		= centerX - fullw/2
local right  		= centerX + fullw/2
local top    		= centerY - fullh/2
local bottom 		= centerY + fullh/2

local onSimulator 	= system.getInfo( "environment" ) == "simulator"
local oniOS 		= ( system.getInfo("platformName") == "iPhone OS") 
local onAndroid 	= ( system.getInfo("platformName") == "Android") 

local mod = {}
mod.debugEn 		= false
mod.maxRetries 		= 10
mod.retryTime 		= 500
mod.autoLoading 	= true
mod.adMode 			= "banner" -- banner, interstitial, video, rewardedVideo
mod.placementID 	= "INIT"
mod.loadOustanding  = false

-- ==
--		mod.init( id [ , listenter ] ) 
-- 
-- 		listener - Optional Listener
-- ==
function mod.init( id, listener )	
	if( mod.debugEn ) then
		print( "mod_revmob.init( ", id, listener, " ) " )
	end

	-- Hook listener to our private listener 
	if( listener ) then
		mod.setListener( listener )
	end
	
	local params =  { appId = tostring(id) } 	
	
	if( mod.debugEn ) then
		mod._table_dump( params, nil, "mod_revmob.init() params")
	end

	revmob.init(  mod.defaultListener, params )
end


-- ==
--		mod.hide() - Hide ad if showing
-- ==
function mod.hide( )	
	revmob.hide( mod.placementID )
end

-- ==
--		mod.showBanner( [ bannerPosition [ , retries ] ] ) - Try to show a banner or insterstitial ad
--   bannerPosition - Optional override for placement position.
--          retries - internally produced value to retry showing ads that didn't load
-- ==
function mod.showBanner( bannerPosition, retries )
	bannerPosition 	= bannerPosition or "bottom"
	retries 		= retries or 0

	if( mod.debugEn ) then
		print( "mod_revmob.showBanner( ", bannerPosition, retries,  " )" )
	
		if( onSimulator ) then
			print( "mod_revmob.showBanner( ) - On Simulator.  Skipping." )
			return
		end
	end

	-- If we need to, change mode to banner so auto-load will get proper ad type.
	if( mod.adMode ~= "banner" ) then
		mod.setAdMode( "banner" )
	end

	-- Trick: Defer show for one frame.  This allows any user rendering code to
	-- finish drawing anything created in the same frame as this function call, 
	-- before the ad code starts to execute.
	timer.performWithDelay( 1, 
		function()
			local adLoaded = revmob.isLoaded( mod.placementID )
			if( mod.debugEn ) then
				print( "mod_revmob.showBanner() - '" .. tostring(mod.adMode) .. "' Ad Loaded? ", adLoaded )
			end
			if( adLoaded ) then
				revmob.show( mod.placementID, { yAlign = bannerPosition } )
			
			elseif( retries < mod.maxRetries ) then
				if( not mod.loadOustanding ) then
					revmob.load( mod.adMode, mod.placementID )
					mod.loadOustanding = true
				end
				timer.performWithDelay( mod.retryTime, function() mod.showBanner( bannerPosition, retries + 1 ) end )
			end
		end )
end


-- ==
--		mod.showVideo([retries ] ] ) - Try to show a banner or insterstitial ad
--          retries - internally produced value to retry showing ads that didn't load
-- ==
function mod.showVideo( retries )
	retries 		= retries or 0

	if( mod.debugEn ) then
		print( "mod_revmob.showVideo( ", retries,  " )" )
	
		if( onSimulator ) then
			print( "mod_revmob.showVideo( ) - On Simulator.  Skipping." )
			return
		end
	end

	-- If we need to, change mode to banner so auto-load will get proper ad type.
	if( mod.adMode ~= "video" ) then
		mod.setAdMode( "video" )
	end

	-- Trick: Defer show for one frame.  This allows any user rendering code to
	-- finish drawing anything created in the same frame as this function call, 
	-- before the ad code starts to execute.
	timer.performWithDelay( 1, 
		function()
			local adLoaded = revmob.isLoaded( mod.placementID )
			if( mod.debugEn ) then
				print( "mod_revmob.showVideo() - '" .. tostring(mod.adMode) .. "' Ad Loaded? ", adLoaded )
			end
			if( adLoaded ) then
				revmob.show( mod.placementID )
			
			elseif( retries < mod.maxRetries ) then
				if( not mod.loadOustanding ) then
					revmob.load( mod.adMode, mod.placementID )
					mod.loadOustanding = true
				end
				timer.performWithDelay( mod.retryTime, function() mod.showVideo( retries + 1 ) end )
			end
		end )
end


-- ==
--		mod.showInterstitial([retries ] ] ) - Try to show a banner or insterstitial ad
--          retries - internally produced value to retry showing ads that didn't load
-- ==
function mod.showInterstitial( retries )
	retries 		= retries or 0

	if( mod.debugEn ) then
		print( "mod_revmob.showInterstitial( ", retries,  " )" )
	
		if( onSimulator ) then
			print( "mod_revmob.showInterstitial( ) - On Simulator.  Skipping." )
			return
		end
	end

	-- If we need to, change mode to banner so auto-load will get proper ad type.
	if( mod.adMode ~= "interstitial" ) then
		mod.setAdMode( "interstitial" )
	end

	-- Trick: Defer show for one frame.  This allows any user rendering code to
	-- finish drawing anything created in the same frame as this function call, 
	-- before the ad code starts to execute.
	timer.performWithDelay( 1, 
		function()
			local adLoaded = revmob.isLoaded( mod.placementID )
			if( mod.debugEn ) then
				print( "mod_revmob.showInterstitial() - '" .. tostring(mod.adMode) .. "' Ad Loaded? ", adLoaded )
			end
			if( adLoaded ) then
				revmob.show( mod.placementID )
			
			elseif( retries < mod.maxRetries ) then
				if( not mod.loadOustanding ) then
					revmob.load( mod.adMode, mod.placementID )
					mod.loadOustanding = true
				end
				timer.performWithDelay( mod.retryTime, function() mod.showInterstitial( retries + 1 ) end )
			end
		end )
end



-- ==
--		mod.enableDebug( [ enable ] ) - Enable/disable debug messages.
-- 
--		enable - 'true' to enable, 'false' or nil to disable.
-- ==
function mod.enableDebug( enable )
	if( enable == nil ) then
		enable = false 
	end
	mod.debugEn = enable
end


-- ==
--		mod.enableAutoLoad( [ enable ] ) - Automatic ad loading and optionally set type to load.
-- 
--		enable - 'true' to enable, 'false' or nil to disable.
-- ==
function mod.enableAutoLoad( enable, adType )
	if( enable == nil ) then
		enable = false 
	end
	mod.autoLoading = enable	
end

-- ==
--		mod.setAdMode( [ enable ] ) - Automatic ad loading and optionally set type to load.
-- 
--      adType - Ad type to autoload and show when requested. (banner, interstitial, video, rewardedVideo)
-- ==
function mod.setAdMode( adType )
	mod.adMode = adType or "banner" 

	-- Clear this flag to allow new request of the current type of ad
	mod.loadOustanding = false
end

-- ==
--		mod.setPlacementID( [ enable ] ) - Automatic ad loading and optionally set type to load.
-- 
--      adType - Ad type to autoload and show when requested. (banner, interstitial, video, rewardedVideo)
-- ==
function mod.setPlacementID( placementID )
	mod.placementID = placementID or "DEFAULT" 
end




-- ==
--		mod.setListener( [ listener  ] )	- Change the current user listener/callback.
-- 
-- 		listener - Optional listener.  
--                 If nil or no arugment, clears listener.
-- ==
function mod.setListener( listener )
	mod._cb = listener
end


-- ==
--		mod.setMaxRetries( retries )	- Change the current maximum number of retries when showing a interstitial fails
-- 
-- 		retries - Number of times to attempt to show a interstitial if it fails to show.
-- ==
function mod.setMaxRetries( retries )
	mod.maxRetries = retries or 0
end

-- ==
--		mod.setRetryTime( time )	- Set the wait time between retries.
-- 
-- 		retries - Time in ms to wait between retries
-- ==
function mod.setRetryTime( time )
	mod.retryTime  = time or 1
end

-- == ******************* EXPERTS ONLY - DO NOT CHANGE THIS LISTENER 
--		mod.defaultListener() - Default listener.  Optionally:
--
--		1. Prints all details of incoming events (if debug enabled)
--		2. Calls user defined  listener/callback.
--
-- == ******************* EXPERTS ONLY - DO NOT CHANGE THIS LISTENER 
function mod.defaultListener( event )
	if( mod.debugEn ) then
		print( "==================================\n" ..
			   tostring(system.getTimer()) .. ": mod.defaultListener() " )
		mod._print_r( event )
	end

	if( event.phase == "init" ) then
		local adLoaded = revmob.isLoaded( mod.placementID )
		if( mod.debugEn ) then
			print( "mod_revmob.defaultListener() - phase == 'init'; '" .. tostring(mod.adMode) .. "' Ad Loaded? ", adLoaded )
		end
		if( not adLoaded ) then
			if( mod.debugEn ) then
				print( "mod_revmob.defaultListener() - phase == 'init'; Requesting Load '" .. tostring(mod.adMode) .. "' Ad " )
			end
			revmob.load( mod.adMode, mod.placementID )
			mod.loadOustanding = true
		end

	elseif( event.phase == "loaded" ) then
		if( mod.debugEn ) then
			print( "mod_revmob.defaultListener() - phase == 'loaded' " )
		end
		mod.loadOustanding = false
	end

	-- If there is a custom listener/callback, execute it now
	--
	if( mod._cb and type(mod._cb) == "function" ) then
		mod._cb( event )
	end

	if( mod.debugEn ) then
		print( "==================================\n\n" )
	end	
end


-- *******************************************************
-- HELPER CODE AFTER THIS POINT
-- *******************************************************

-- ==
--    string:rpad( len, char ) - Places padding on right side of a string, such that the new string is at least len characters long.
-- ==
function mod._rpad( theStr, len, char)
    char = char or ' ' 
    return theStr .. string.rep(char, len - #theStr)
end


function mod._table_dump( theTable, padding, marker ) -- Sorted
	marker = marker or ""
	local theTable = theTable or  {}
	local function compare(a,b)
	  return tostring(a) < tostring(b)
	end
	local tmp = {}
	for n in pairs(theTable) do table.insert(tmp, n) end
	table.sort(tmp,compare)

	local padding = padding or 30
	print("\Table Dump:")
	print("-----")
	if(#tmp > 0) then
		for i,n in ipairs(tmp) do 		

			local key = tmp[i]
			local value = tostring(theTable[key])
			local keyType = type(key)
			local valueType = type(value)
			local keyString = tostring(key) .. " (" .. keyType .. ")"
			local valueString = tostring(value) .. " (" .. valueType .. ")" 

			keyString = mod._rpad( keyString, padding )
			valueString = mod._rpad( valueString, padding )

			print( keyString .. " == " .. valueString ) 
		end
	else
		print("empty")
	end
	print( marker .. "-----\n")
end


-- ==
--    table.print_r( theTable ) - Dumps indexes and values inside multi-level table (for debug)
-- ==
function mod._print_r( t ) 
	--local depth   = depth or math.huge
	local print_r_cache={}
	local function sub_print_r(t,indent)
		if (print_r_cache[tostring(t)]) then
			print(indent.."*"..tostring(t))
		else
			print_r_cache[tostring(t)]=true
			if (type(t)=="table") then
				for pos,val in pairs(t) do
					if (type(val)=="table") then
						print(indent.."["..pos.."] => "..tostring(t).." {")
						sub_print_r(val,indent..string.rep(" ",string.len(pos)+1))
						print(indent..string.rep(" ",string.len(pos)+1).."}")
					elseif (type(val)=="string") then
						print(indent.."["..pos..'] => "'..val..'"')
					else
						print(indent.."["..pos.."] => "..tostring(val))
					end
				end
			else
				print(indent..tostring(t))
			end			
		end
	end
	if (type(t)=="table") then
		print(tostring(t).." {")
		sub_print_r(t," ")
		print("}")
	else
		sub_print_r(t," ")
	end
end


-- ==
--    Need to (re-) Start Session on resume to get ads after sleeping
-- ==
local function onSystemEvent( event )
    if( event.type == "applicationResume" ) then
    	revmob.startSession()
    end
end
Runtime:addEventListener( "system", onSystemEvent )

return mod