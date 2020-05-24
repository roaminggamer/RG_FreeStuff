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
-- https://docs.coronalabs.com/plugin/inMobi/index.html
-- =====================================================
local inMobi = require( "plugin.inMobi" )

local accountId 				= "YOUR_ACCOUNT_ID_HERE"
local banner_placement_id		= "YOUR_BANNER_ID_HERE"
local interstitial_placement_id	= "YOUR_INTERSTITIAL_ID_HERE"

local function test ( test_type, id )
	local function adListener( event )
		for k,v in pairs( event ) do
			print( k, v )
		end
		print( '---------------------------\n' )
	    
	    if ( event.phase == "init" ) then
	        inMobi.load( test_type, id )
	    elseif ( event.phase == "loaded" ) then
	   	    inMobi.show( id )
	    end
	end
	inMobi.init( adListener, { accountId = accountId, logLevel = "debug" } )

end

-- Run one or the other, but not both
--test( 'banner', banner_placement_id )
test( 'interstitial', interstitial_placement_id )
