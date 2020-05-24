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
-- https://docs.coronalabs.com/plugin/admob/index.html
-- =====================================================
local admob = require( "plugin.admob" )

local appId 			= "YOUR_AP_ID_HERE"
local banner_id 		= "YOUR_BANNER_ID_HERE"
local interstitial_id 	= "YOUR_INTERSTITIAL_ID_HERE"

local function test ( test_type, id )
	local function adListener( event )
		for k,v in pairs( event ) do
			print( k, v )
		end
		print( '---------------------------\n' )
	    
	    if ( event.phase == "init" ) then
	        admob.load( test_type, { adUnitId = id } )
	    elseif ( event.phase == "loaded" ) then
	   	    admob.show( test_type )
	    end
	end
	admob.init( adListener, { appId = appId } )
end

-- Run one or the other, but not both
test( "banner", banner_id )
-- test( "interstitial", interstitial_id )
