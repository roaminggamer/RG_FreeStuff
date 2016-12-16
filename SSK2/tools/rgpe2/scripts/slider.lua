-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Roaming Gamer Particle Editor 2 (a free SSK2 co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
-- =============================================================
-- Slider Widget used to adjust 'numberic' emitter values
-- =============================================================
local slider = {}

-- =============================================================
-- =============================================================
-- =============================================================
-- Useful Localizations
local getInfo           = system.getInfo
local getTimer          = system.getTimer
local mRand				= math.random
--
-- Common SSK Display Object Builders
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers
--
-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist
--
-- Common SSK Helper Functions
local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
local normRot = ssk.misc.normRot;local easyAlert = ssk.misc.easyAlert
local tpd = timer.performWithDelay
-- =============================================================
-- =============================================================
local common 	= require "scripts.common"
local layersMgr = require "scripts.layersMgr"
local skel 		= require "scripts.skel"

-- ==
--
-- ==
function slider.create()
	local layers = layersMgr.get()
	layers:purge("rightPane")
	local bar = newRect( layers.bbar, skel.bbar.x, skel.bbar.y, { w = fullw, h = barHeight, fill = common.barColor } )

	local widget = require( "widget" )

	-- Slider listener
	local function sliderListener( event )		
		local value = common.sliderB.value
		post("onSliderTouch", { value = value } )
		
		if( event.phase == "ended") then
			post("onRefresh")
		end
	end

	-- Create the widget
	common.sliderB = widget.newSlider(
	    {
	        x 			= skel.bbar.x, 
	        y 			= skel.bbar.y,
	        width 		= fullw - 50,
	        value 		= 50,  -- Start slider at 10% (optional)
	        listener 	= sliderListener
	    }
	)
	layers.bbar:insert(common.sliderB)
	common.sliderB.isVisible = false

end

return slider