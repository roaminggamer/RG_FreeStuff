-- =============================================================
-- ifc_MainMenu.lua
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

local onPlay
local onOptions
local onCredits


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

	-- Create Menu Buttons
	ssk.buttons:presetPush( layers.buttons, "default", centerX, centerY - 120,	400, 100, "Play", onPlay )
	ssk.buttons:presetPush( layers.buttons, "default", centerX, centerY,		400, 100, "Options", onOptions )
	ssk.buttons:presetPush( layers.buttons, "default", centerX, centerY + 120,	400, 100, "Credits", onCredits )

	transition.from( layers, {alpha = 0, time = sceneCrossFadeTime, onComplete = closure } )

	ssk.debug.monitorMem()
end

-- ==
-- destroy() - Destroy EFM
-- ==
destroy = function ( )
	layers:removeSelf()
	layers = nil
end

-- ==
-- onPlay() - Play Game
-- ==
onPlay = function ( )
	ifc_PlayGUI.create()
	ssk.debug.monitorMem()
end

-- ==
-- onOptions() - Destroy EFM
-- ==
onOptions = function ( )
	ifc_Options.create()
	ssk.debug.monitorMem()
end

-- ==
-- onCredits() - Destroy EFM
-- ==
onCredits = function ( )
	ifc_Credits.create()
	ssk.debug.monitorMem()
end


----------------------------------------------------------------------
-- 5. The Module
----------------------------------------------------------------------
local public = {}
public.create  = create
public.destroy = destroy

return public
