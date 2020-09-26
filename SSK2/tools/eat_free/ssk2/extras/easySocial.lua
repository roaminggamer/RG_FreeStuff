-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Easy Social Features - Currently ONLY Rating
-- =============================================================

local social = {}
_G.ssk.social = social

-- ==
--    Easy Rating Function - Just pass in correct ID (+ App Name for tvOS) for current Store
--
--		Params:
-- 		id           - ID of app, varies by store (see 'Supported Stores' below)
--       appName      - (Optional) Name of app (used for tvOS).
--       preProcessed - Set this to 'true' if you have already converted your app name to a 'proper' string
--                      for the URL, otherwise rate() will try to convert the appName into a 'proper' string.
--
--    Supported Stores:
--
--    Amazon (untested)          		- id == "Package Name" used when buiding app
--    Google Play (tested)   				- id == "Package Name" used when buiding app
--    iTunes Connect (tested)    		- id == Numeric App ID found on your store page when submitting app.
--    (Apple) tvOS Store (untested)    - id == Numeric App ID found on your store page when submitting app.
--                                     - appName == Name of app.  Utility will clean it for you.
--
-- ==
function social.rate( params )
	params = params or {}
	local id = params.id or ""
	
	local appName = params.appName or ""
	if( not params.preProcessed ) then
		appName = string.gsub(string.lower(string.clean("appName") ), "% ", "%-" )
	end

	local url
	if( _G.onAmazon ) then		
		url = "amzn://apps/android?p=" .. id

	elseif( _G.onAndroid ) then
		--url = "market://details?id=" .. id
		url = "https://play.google.com/store/apps/details?id=" .. id
	
	elseif( _G.oniOS ) then		
		url = "itms-apps://itunes.apple.com/app/id" .. id .. "?onlyLatestVersion=false"
		
		-- Old Varations(s)
		-- local osVer = tonumber(system.getInfo("platformVersion").sub(1, 1))
		--
		-- if (iOS Ver < 7) ==>
		-- url = "itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=" .. id

	elseif( _G.onAppleTV ) then		
		url = "com.apple.TVAppStore://itunes.apple.com/us/app/" .. name .. "/id" .. id .. "?mt=‌​8"
			
	end
	if( not url ) then return false end


	if( not system.canOpenURL( url ) ) then
		print("Warning! - ssk.social.rate() - Cannot Open URL: ", url ) 
	end

	if( params.debugEn ) then print("ssk2.social.rate() - Opening URL: ", url ) end
	system.openURL( url )	
	return true
end


return social