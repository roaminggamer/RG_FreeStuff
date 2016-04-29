-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2016
-- =============================================================
-- Work In Progress (WIP)
-- =============================================================
-- 								License
-- =============================================================
--[[
	> SSK is free to use.
	> SSK is free to edit.
	> SSK is free to use in a free or commercial game.
	> SSK is free to use in a free or commercial non-game app.
	> SSK is free to use without crediting the author (credits are still appreciated).
	> SSK is free to use without crediting the project (credits are still appreciated).
	> SSK is NOT free to sell for anything.
	> SSK is NOT free to credit yourself with.
]]
-- =============================================================
local easySocial = {}
_G.ssk.easySocial = easySocial


-- ==
--    Easy Rating Function - Just pass in right ID for current Store
-- ==
function easySocial.rate( id )
	local url
	if( onAmazon ) then
		-- EFM Unknown at this time
	
	elseif( onAndroid ) then
		url = "market://details?id=" .. id
	
	elseif( oniOS ) then		
		--local osVer = tonumber(system.getInfo("platformVersion").sub(1, 1)) -- EFM
		--if( osVer < 7 ) then
			url = "itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=" .. id
		--else
			url = "itms-apps://itunes.apple.com/app/id" .. id .. "?onlyLatestVersion=false"
		--end
	end
	if( not url ) then return end
	system.openURL( url )
end


-- ==
--    Easy Sharing Function - Social Share on Android; Activity Popup on iOS 
--    This lets the user choose the social media they want from their installed list of apps.
-- ==
function easySocial.share( msg, url, params )
	params = params or {} 
	-- Future params:
	--[[
		listener - Custom user listener
		image - List of images to share
	]]

	if( onAmazon ) then
		-- WIP - To Be Determined
	
	elseif( onAndroid ) then

		--
		-- Can we share in the current context?
		-- 
		if( onSimulator ) then
			native.showAlert( "Build for device", "This plugin is not supported on the Corona Simulator, please build for an iOS/Android device or the Xcode simulator", { "OK" } )
		
		elseif( not native.canShowPopup( "social", "share" ) ) then
			native.showAlert( "Cannot send " .. "share" .. " message.", "Please setup your " .. "share" .. " account or check your network connection (on android this means that the package/app (ie Twitter) is not installed on the device)", { "OK" } )
		
		else

			--
			-- "Yes", proceed...
			-- 
			local popupListener = {}			
			function popupListener:popup( event )
				if( params.listener ) then
					params.listener( event )
				end
				--print( "name(" .. event.name .. ") type(" .. event.type .. ") action(" .. tostring(event.action) .. ") limitReached(" .. tostring(event.limitReached) .. ")" )			
			end

			local itemsToShare = {}
			itemsToShare.service 	= "share"
			itemsToShare.message 	= msg
			itemsToShare.listener 	= popupListener
			itemsToShare.url 		= url and { url }
			itemsToShare.image 		= image and image
			
			native.showPopup( "social", itemsToShare )
		end

	elseif( oniOS ) then	

		--
		-- Can we share in the current context?
		-- 
		if( not native.canShowPopup( "activity" ) ) then 
			native.showAlert( "Cannot send " .. "activity" .. " message.", "Please setup your " .. "share" .. " account or check your network connection (on android this means that the package/app (ie Twitter) is not installed on the device)", { "OK" } )
		
		else

			--
			-- "Yes", proceed...
			-- 
			local popupListener = {}			
			function popupListener:popup( event )
				if( params.listener ) then
					params.listener( event )
				end
				--print("(name, type, activity, action):", event.name, event.type, tostring(event.activity), tostring(event.action))
			end

			local itemsToShare = {}
			itemsToShare[#itemsToShare+1] = { type = "string", value = msg }
			if( url ) then
				itemsToShare[#itemsToShare+1] = { type = "url", value = url }
			end
			if( params.image ) then
				itemsToShare[#itemsToShare+1] = { 
					type = "image", value = params.image 
				}
			end

			local options = { items = itemsToShare, listener = popupListener }
			native.showPopup( "activity", options )
		end
	end
end

return easySocial