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

-- IMPORTANT: Android Package ID must match ID you set up for the Ad on Applovin console

-- =====================================================
-- https://docs.coronalabs.com/plugin/applovin/index.html
-- =====================================================
local applovin = require( "plugin.applovin" )

local sdkKey = "YOUR_SDK_KEY_HERE"


local function test( test_type )
	test_type = test_type or "banner" -- default to 'banner'
	local function adListener( event )
		for k,v in pairs( event ) do
			print( k, v )
		end
		print( '---------------------------\n' )
	 
	    if ( event.phase == "init" ) then
	        applovin.load( test_type )
	    elseif ( event.phase == "loaded" ) then
	   	    applovin.show( test_type )
	    end
	end
	applovin.init( adListener, { sdkKey = sdkKey } )
end

-- Run only one
--test( 'banner' )
test( 'interstitial' )
-- test( 'rewardedVideo' )
