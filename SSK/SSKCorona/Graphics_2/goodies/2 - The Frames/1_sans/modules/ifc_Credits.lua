-- =============================================================
-- ifc_Credits.lua
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

local effectsSlider
local musicSlider

-- Forward Declarations
local create 
local destroy

local onBack

----------------------------------------------------------------------
-- 4. Definitions
----------------------------------------------------------------------
-- ==
-- create() - Create EFM
-- ==
create = function ( parentGroup )
	local parentGroup = parentGroup or display.currentStage

	-- Create some rendering layers
	layers = ssk.display.quickLayers( parentGroup, "background", "buttons", "overlay" )

	local backImage
	if(build_settings.orientation.default == "landscapeRight") then
		backImage = display.newImage( layers.background, "images/interface/RGSplash2_Landscape.jpg" )
	else
		backImage = display.newImage( layers.background, "images/interface/RGSplash2_Portrait.jpg" )
	end

	backImage.x = w/2
	backImage.y = h/2

	local overlayImage
	overlayImage = display.newImage( layers.overlay, "images/interface/protoOverlay.png" )
	if(build_settings.orientation.default == "landscapeRight") then
		overlayImage.rotation = 90
	end

	overlayImage.x = w/2
	overlayImage.y = h/2

	-- Add dummy touch catcher to backImage to keep touches from 'falling through'
	backImage.touch = function() return true end
	backImage:addEventListener( "touch", backImage )


	-- Labels and Buttons
	ssk.labels:quickLabel( layers.buttons, "Credits", centerX, 40, nil, 40 )
	



	ssk.buttons:presetPush( layers.buttons, "default", 55, h-25, 100, 40, "Back", onBack )

	transition.from( layers, {alpha = 0, time = sceneCrossFadeTime, onComplete = closure } )
end

-- ==
-- destroy() - Destroy EFM
-- ==
destroy = function ( )
	layers:removeSelf()
	layers = nil
	effectsSlider = nil
	musicSlider = nil

end

-- ==
-- onBack() - EFM
-- ==
onBack = function( event ) 
	
	local closure = 
		function()
			destroy()
			ssk.debug.monitorMem()
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
