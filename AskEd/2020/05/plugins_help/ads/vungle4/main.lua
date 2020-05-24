io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- require "ssk2.loadSSK"
-- _G.ssk.init( { measure = false } )
-- =====================================================
-- IGNORE ABOVE; Included for my convenience.  - Roaming Gamer
-- =====================================================

-- *******************************************************
--                        TEST STARTS HERE
-- *******************************************************
-- =====================================================
-- https://docs.coronalabs.com/plugin/vungle-v4/index.html
-- =====================================================
local ads = require( "ads" )
 
local appId 			= "YOUR_ID_HERE"

local function test( ad_type )
	-- Vungle listener function
	local function adListener( event )
		for k,v in pairs( event ) do
			print( k, v )
		end
		print( '---------------------------\n' )
 
    	if ( event.type == "cachedAdAvailable" ) then
			ads.show( ad_type )
	    end
	end

	ads.init( "vungle", appId, adListener )
end

-- Run one or the other, but not both
--test( "interstitial" )
test( "incentivized" )

