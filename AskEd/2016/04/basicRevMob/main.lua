io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
require "ssk.loadSSK"
-- =============================================================
-- Ignore Above - SSK included for access to table helpers, etc.
-- =============================================================

local revmob = require( "plugin.revmob" )

local function testRevMob( appId, adTypeToShow, bannerPos )
	adTypeToShow 	= adTypeToShow or "banner"
	bannerPos 		= bannerPos or "top"

	local showOnLoad = true	

	local bannerParams
	if( adTypeToShow == "banner" ) then
		bannerParams = { yAlign = bannerPos }
	end

	local function revmobListener( event )
		if ( event.phase == "init" ) then  -- Successful initialization
			print("RevMob Initialized... ")

			--print("RevMob Initialized... request an ad.", adTypeToShow, appId )
			--revmob.load( adTypeToShow, appId )

			-- ***************** NOTE *************************
			-- ***************** NOTE *************************
			-- ***************** NOTE *************************
			-- The docs show to load here, but in my experience that doesn't work.
			-- Try waiting for session started instead.
			--

		elseif ( event.phase == "sessionStarted" ) then  -- Successful initialization
			print("RevMob Session Started... now request an ad.", adTypeToShow, appId )
			revmob.load( adTypeToShow, appId )

		elseif ( event.phase == "loaded" ) then  -- The ad was successfully loaded
			if( showOnLoad ) then
				print("RevMob loaded... show the ad: ", appId)

				if( adTypeToShow == "banner" ) then
					revmob.show( appId, { yAlign = bannerPos } )
				else
					revmob.show( appId )
				end

				showOnLoad = false -- ONLY Show first loaded ad for this example
			else
				print("RevMob loaded... ready to show when you need it.")
			end				

		elseif ( event.phase == "displayed" ) then 
			print("RevMob displayed ad... there should be an ad on the screen.")
			--table.print_r(event)

		elseif ( event.phase == "videoPlaybackBegan" or event.phase == "rewardedVideoPlaybackBegan" ) then 
			print("RevMob started showing a video.")
			--table.print_r(event)

		elseif ( event.phase == "videoPlaybackEnded" or event.phase == "rewardedVideoPlaybackEnded" ) then  
			print("RevMob finished showing a video... load a new one.")
			revmob.load( adTypeToShow, appId )
			--table.print_r(event)

		elseif ( event.phase == "rewardedVideoCompleted" ) then 
			print("RevMob completed a rewarded video.")
			--table.print_r(event)

		elseif ( event.phase == "clicked" and event.type == "rewardedVideo" ) then 
			print("RevMob clicked a rewarded video.")
			--table.print_r(event)

		elseif ( event.phase == "hidden" ) then  -- The ad failed to load
			print("RevMob hid ad... there should NOT be an ad on the screen.")
			--table.print_r(event)

		
		-- Some kind of error (not just a load error; rewardedVideo interactions fail too)
		elseif ( event.phase == "failed" ) then  
			table.print_r(event)

		
		-- No idea, better catch it though
		else
			print("UNKNOWN EVENT")
			table.print_r(event)
		end	
	end

	revmob.init( revmobListener, { appId = appId } )
end

testRevMob( 
			--"YOUR_ID_HEREYOUR_ID_HERE", 	-- RevMob ID
			"interstitial", 				-- banner, interstitial, video, rewardedVideo
			"top" 							-- bottom, top
		 )

