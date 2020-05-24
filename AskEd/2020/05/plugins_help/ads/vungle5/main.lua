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
-- https://docs.coronalabs.com/plugin/vungle/index.html
-- =====================================================
local vungle = require( "plugin.vungle" )
 
local appId 			= "YOUR_AP_ID_HERE"
local placementId1 		= "YOUR_ID_HERE"
local placementId2		= "YOUR_ID_HERE"

local function test( id )
	-- Vungle listener function
	local function adListener( event )
 		for k,v in pairs( event ) do
			print( k, v )
		end
		print( '---------------------------\n' )

    	if ( event.type == "adInitialize" ) then  -- Successful initialization
        	print( event.provider )
        	-- Try to load an ad
			vungle.load( id )
			-- Wait a little bit and try to show an add
			timer.performWithDelay( 1000, function() vungle.show( { placementId = id }  ) end )
	    end
	end

	local initParams = appId .. "," .. placementId1 .. "," .. placementId2
	vungle.init( "vungle", initParams, adListener )
end

-- Run one or the other, but not both
test( placementId1 )
--test( placementId2 )

