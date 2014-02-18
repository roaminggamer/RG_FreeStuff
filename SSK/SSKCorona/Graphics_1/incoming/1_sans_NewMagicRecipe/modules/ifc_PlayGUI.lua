-- =============================================================
-- ifc_PlayGUI.lua
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
	backImage = display.newImage( layers.background, "images/interface/protoBack.png" )
	if(build_settings.orientation.default == "landscapeRight") then
		backImage.rotation = 90
	end

	backImage.x = w/2
	backImage.y = h/2

	-- Add dummy touch catcher to backImage to keep touches from 'falling through'
	backImage.touch = function() return true end
	backImage:addEventListener( "touch", backImage )

	-- AWESOME CONTENT HERE
	if(build_settings.orientation.default == "landscapeRight") then		
		ssk.labels:quickLabel( layers.buttons, "The Awesome Goes Here", centerX, centerY, nil, 75 )
	else
		ssk.labels:quickLabel( layers.buttons, "The Awesome Goes Here", centerX, centerY, nil, 55 )
	end
	
	ssk.buttons:presetPush( layers.buttons, "default", 130, h-55, 250, 100, "Back", onBack )

	transition.from( layers, {alpha = 0, time = sceneCrossFadeTime, onComplete = closure } )
end

-- ==
-- destroy() - Destroy EFM
-- ==
destroy = function ( )
	layers:removeSelf()
	layers = nil
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
