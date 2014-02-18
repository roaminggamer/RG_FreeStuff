-- =============================================================
-- ifc_Splash.lua
-- =============================================================

----------------------------------------------------------------------
--	1. Requires
----------------------------------------------------------------------
-- none.


----------------------------------------------------------------------
--	2. Initialization
----------------------------------------------------------------------
-- none.


----------------------------------------------------------------------
-- 3. Declarations
----------------------------------------------------------------------
-- Locals
local layers 
local lastTimer
local waitTime = 2000 

-- Forward Declarations
local create 
local destroy


----------------------------------------------------------------------
-- 4. Definitions
----------------------------------------------------------------------

-- ==
-- create() - Create the splash screen.
-- ==
create = function ( parentGroup )
	local parentGroup = parentGroup or display.currentStage

	-- Create some rendering layers
	layers = ssk.display.quickLayers( parentGroup, "background", "buttons", "overlay" )

	local backImage
	if(build_settings.orientation.default == "landscapeRight") then
		backImage = display.newImage( layers.background, "images/interface/RGSplash1_Landscape.jpg" )
	else
		backImage = display.newImage( layers.background, "images/interface/RGSplash1_Portrait.jpg" )
	end

	backImage.x = w/2
	backImage.y = h/2

	-- Add a touch listener that will switch to the main menu immediately on 'tap'
	backImage.touch = function( self, event )
		
		-- Only do something if the finger is lifted, AND
		-- if the timer handle has not yet been cleared.
		if( event.phase == "ended" and lastTimer ) then
			timer.cancel( lastTimer )
			destroy()
		end

		return true
	end
	
	backImage:addEventListener( "touch", backImage )

--[[
	local overlayImage
	overlayImage = display.newImage( layers.overlay, "images/interface/protoOverlay.png" )
	if(build_settings.orientation.default == "landscapeRight") then
		overlayImage.rotation = 90
	end

	overlayImage.x = w/2
	overlayImage.y = h/2
--]]

	-- Switch to the Main Menu in 'waitTime' milliseconds
	lastTimer = timer.performWithDelay( waitTime, destroy )
end


-- ==
-- destroy() - Destroy the splash screen.
-- ==
destroy = function ( )

	ifc_MainMenu.create()

	local closure = 
		function()
			layers:removeSelf()
			layers = nil
			lastTimer = nil
		end

	transition.to( layers, {alpha = 0, time = sceneCrossFadeTime, onComplete = closure } )

end


----------------------------------------------------------------------
-- 5. The Module
----------------------------------------------------------------------


local public = {}
public.create  = create
public.destroy = destroy

return public
