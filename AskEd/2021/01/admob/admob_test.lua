-- =============================================================
-- AdMob Test
-- =============================================================
-- This module is used to test your AdMob settings to ensure
-- they are working.
--
-- This module is also valuable to dig into and learn more about
-- using AdMob.
-- 
-- =============================================================
local test = {}

local admob = require( "plugin.admob" )

-- Local Variables
local group    		 
local objects 		= {}  

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

-- ==
--    Destroy and Cleanup Test
-- ==
function test.destroy()

	-- Destroy the group and nil it.	
	display.remove( group ) 
	group   = nil

	-- Clear the table reference.  Also clears all held refrences to tester objects.
	objects = nil
end	

-- ==
--    Create
-- ==
function test.create( )
	group = display.newGroup()
	objects = {}

	local offset = 50

	objects.loaded = display.newCircle( group, left + 45, top + 200 + 0 * offset, 20 )
	display.newText("Loaded", objects.loaded.x + 50, objects.loaded.y, native.systemFont, 20 ).anchorX = 0

	objects.shown = display.newCircle( group, left + 45, top + 200 + 1 * offset, 20 )
	display.newText("Shown", objects.shown.x + 50, objects.shown.y, native.systemFont, 20 ).anchorX = 0

	objects.refreshed = display.newCircle( group, left + 45, top + 200 + 2 * offset, 20 )
	display.newText("Refreshed (banner only)", objects.refreshed.x + 50, objects.refreshed.y, native.systemFont, 20 ).anchorX = 0

	objects.gotError = display.newCircle( group, left + 45, top + 200 + 3 * offset, 20 )
	display.newText("Error? (RED == BAD; GREEN == OK)", objects.gotError.x + 50, objects.gotError.y, native.systemFont, 20 ).anchorX = 0

	objects.loaded:setFillColor(0.5,0.5,0.25)
	objects.shown:setFillColor(0.5,0.5,0.25)
	objects.refreshed:setFillColor(0.5,0.5,0.25)
	objects.gotError:setFillColor(0.5,0.5,0.25)

local aButton = display.newRect( group,  centerX, top + 200 + 5 * offset, 240, 80 )
	display.newText("Init", aButton.x, aButton.y, native.systemFont, 20 )
	aButton:setFillColor( 0, 0.8, 0.4)
	aButton.touch = function( self, event )
		if(event.phase == "ended") then
			admob.init( adListener, { appId = _G.appId, testMode = testMode } )
		end
		return true
	end 
	aButton:addEventListener( "touch" )


	local aButton = display.newRect( group,  centerX, top + 200 + 7 * offset, 240, 80 )
	display.newText("Load New Banner", aButton.x, aButton.y, native.systemFont, 20 )
	aButton:setFillColor( 0, 0.8, 0.4)
	aButton.touch = function( self, event )
		if(event.phase == "ended") then
			admob.load( "banner", { adUnitId  = _G.interstitialID } )
		end
		return true
	end 
	aButton:addEventListener( "touch" )


	local aButton = display.newRect( group,  centerX, top + 200 + 9 * offset, 240, 80 )
	display.newText("Show Banner", aButton.x, aButton.y, native.systemFont, 20 )
	aButton:setFillColor( 0, 0.8, 0)
	aButton.touch = function( self, event )
		if(event.phase == "ended") then
			admob.show( "banner", {  y = "top"  } )
		end
		return true
	end 
	aButton:addEventListener( "touch" )

	local aButton = display.newRect( group,  centerX, top + 200 + 11 * offset, 240, 80 )
	display.newText("Load New Interstitial", aButton.x, aButton.y, native.systemFont, 20 )
	aButton:setFillColor( 0, 0.8, 0.8)
	aButton.touch = function( self, event )
		if(event.phase == "ended") then
			admob.load( "interstitial", { adUnitId  = _G.interstitialID } )
		end
		return true
	end 
	aButton:addEventListener( "touch" )

	local aButton = display.newRect( group,  centerX, top + 200 + 13 * offset, 240, 80 )
	display.newText("Show Interstitial", aButton.x, aButton.y, native.systemFont, 20 )
	aButton:setFillColor( 0, 0, 0.8)
	aButton.touch = function( self, event )
		if(event.phase == "ended") then
			admob.show( "interstitial" )
		end
		return true
	end 
	aButton:addEventListener( "touch" )

end

-- ==
--    AdMob Event Listener - Used for this example to update indicators and print messages to the console
-- ==
function test.customListener( event ) 
	print( "==== USER DEFINED CALLBACK =====\n" .. tostring(system.getTimer()) .. ": customListener() " )

	-- Extract base set of useful event details:
	local isError 	= (event.isError == nil) and false or event.isError
	local name 		= (event.name == nil) and "unknown" or event.name
	local phase 	= (event.phase == nil) and "unknown" or event.phase
	local provider 	= (event.provider == nil) and "unknown" or event.provider


	if( isError ) then
		print( "AdMob is getting errors. Turn on admob module's debug output to see more details.")
		objects.gotError:setFillColor(1,0,0)
	else
		objects.gotError:setFillColor(0,1,0)
		if( name == "adsRequest" ) then

			-- Tip: These are checked for in the typical order they happen:
			--
			if( phase == "loaded" ) then
				print("We got an ad!  We should be ready to show it.")
				objects.loaded:setFillColor(0,1,0)
			

			elseif( phase == "shown" ) then
				print("Ad started showing!")
				objects.shown:setFillColor(0,1,0)

			elseif( phase == "refreshed" ) then
				print("Ad refreshed!")
				objects.refreshed:setFillColor(0,1,0)
				timer.performWithDelay( 1000, function() objects.refreshed:setFillColor(0.5,0.5,0.25) end )
			end

		else			
			print( "Admob is getting a weird event.name value?! Turn on admob module's debug output to see more details.")
			print( event.response )
		end

	end
end


return test