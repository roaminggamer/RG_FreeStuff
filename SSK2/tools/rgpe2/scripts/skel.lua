-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Roaming Gamer Particle Editor 2 (a free SSK2 co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================

-- =============================================================
-- This module sets up the 'layout' of the app and then I later use all of
-- these objects as positioning guides
-- =============================================================
local skel = {}

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

function skel.create()

	local layers = layersMgr.get()
	
	-- Menu Bar
	--
	local barHeight = 32
	local barStrokeW = 1
	skel.tbar = newRect( layers.skel, centerX, top + barHeight/2, 
							{ w = fullw, h = barHeight, fill = _C_ } )

	local barOffsetY = 4

	-- Left Pane
	--
	local lpw = 180
	local lph = fullh - (barHeight + 36 + 8) --600
	skel.leftPane = newRect( layers.skel,
		                     left + lpw/2, 
		                     skel.tbar.y +  barHeight/2 + lph/2 + barOffsetY, 
							{ w = lpw, h = lph, fill = _GREY_ } )

	-- Left Pane Objects
	--
	----[[
	local lpoh = 28
	local lpow = lpw - 4
	local startY = skel.leftPane.y - lph/2 + lpoh/2 + 4
	local curY = startY
	skel.lpo = {}
	for i = 1, 20 do 
		local tmp = newRect( layers.skel, skel.leftPane.x, curY,
	                     	 { w = lpow, h = lpoh, fill = _G_ } )
		
		skel.lpo[i] = tmp
		curY = curY + lpoh + 4

		if( i <= 12 ) then
			local label = easyIFC:quickLabel( layers.skel, "Object Name " .. i, tmp.x - lpow/2 + 10, tmp.y, "Lato-Regular.ttf", 12, _K_, 0 )
			local eye   = newImageRect( layers.skel, tmp.x + lpow/2 - 1.5 * lpoh, tmp.y, "images/eye.png",
			                        { w = 150, h = 200, scale = 0.15 } )

			local lock   = newImageRect( layers.skel, tmp.x + lpow/2 - 0.5 * lpoh, tmp.y, "images/lock.png",
			                        { w = 100, h = 100, scale = 0.25 } )
		else
			local plus   = newImageRect( layers.skel, tmp.x, tmp.y, "images/plus.png",
			                        { w = 80, h = 80, scale = lpoh/100, alpha = 0.5 } )
		end

	end
	--]]



	-- Main Pane
	--
	local mpw = 800
	local mph = fullh - (barHeight + 36 + 8) --600
	skel.mainPane = newRect( layers.skel, 
		                     skel.leftPane.x + lpw/2 + mpw/2 + 4, 
		                     skel.tbar.y +  barHeight/2 + mph/2 + barOffsetY, 
							{ w = mpw, h = mph, fill = _O_ } )

	-- Right Pane
	--
	local rw = fullw - skel.mainPane.x - skel.mainPane.contentWidth/2
	local rh = fullh - (barHeight + 36 + 8)
	skel.rightPane = newRect( layers.skel,  fullw - rw/2 + 2, top + barHeight + rh/2 + 4, { w = rw - 4, h = rh, fill = _GREY_ } )

	-- Right Pane Buttons
	--
	skel.rpb = {}
	local ps = 32
	local curX = skel.rightPane.x - skel.rightPane.contentWidth/2 + ps/2 + 4
	local curY = skel.rightPane.y - skel.rightPane.contentHeight/2 + ps/2 + 4
	for i = 1, 8 do
		skel.rpb[i] = newRect( layers.skel, curX, curY, { w = ps, h = ps, fill = _B_ } )
		curX = curX + ps + 4
	end

	----[[
	-- Current Edit 'Option' Label
	--
	local curX = skel.rightPane.x 
	local curY = skel.rightPane.y - skel.rightPane.contentHeight/2 + 55
	skel.currentEditOption = easyIFC:quickLabel( layers.skel, "Current Edit Option", curX, curY, ssk.gameFont(), 32, _W_ )

	-- Preview 'Option' Buttons
	--
	local ps = 32
	for i = 1, 25 do
		skel.pob = newRect( layers.skel,  left + (i-1) * (ps+4) + ps/2 + 3, skel.mainPane.y + mph/2 + ps/2  + 4, 
							{ w = ps, h = ps, fill = _GREY_ } )
	end
	--]]

	-- Parameter Scroll Bar
	--
	local barHeight = 36
	local barStrokeW = 1
	skel.bbar = newRect( layers.skel,  fullw/2, fullh - barHeight/2, 
		                { w = fullw, h = barHeight, fill = _P_ } )


	-- Overlay
	-- 
	--newImageRect( layers.overlay,  centerX, centerY, "images/overlay2.png", { w = fullw, h = fullh, fill = common.overlayFill } )
	--newImageRect( layers.overlay,  centerX, centerY, "images/overlay3.png", { w = fullw, h = fullh, alpha = 0.5 } )
	layers.overlay.frame = newImageRect( layers.overlay,  centerX, centerY, "images/overlay5.png", { w = fullw, h = fullh, alpha = 0.5 } )
	--newImageRect( layers.overlay,  centerX, centerY, "images/overlay6.png", { w = fullw, h = fullh, alpha = 0.5 } )

end

return skel