-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Roaming Gamer Particle Editor 2 (a free SSK2 co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
local export = {}
local private = {}

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

local dialogs 	= ssk.dialogs

-- ==
--    EFM - EFM
-- ==
local function onNewProject( event )
	post( "onNewProject")

end

function private.new( event )
end
function private.load( event )
end
function private.backup( event )
end
function private.restore( event )
end

local function onClose( self, onComplete )
	transition.to( self, { y = centerY + fullh, transition = easing.inBack, onComplete = onComplete } )
end

function export.doDialog()
	local layers = layersMgr.get()
	layers:purge("dialog")


	local width = 800
	local height = 500

	local dialog = dialogs.basic.create( layers.dialog, centerX, centerY, 
						{ fill = _W_, 
					 	  width = width,
					 	  height = height,
						  softShadow = true,
						  softShadowOX = 8,
						  softShadowOY = 8,
						  softShadowBlur = 6,
						  closeOnTouchBlocker = false, 
						  blockerFill = _K_,
						  blockerAlpha = 0.15,
						  softShadowAlpha = 0.6,
						  blockerAlphaTime = 100,
						  onClose = onClose,
						  style = 1 } )

	private.chooseTarget( dialog, width, height )

	easyIFC.easyFlyIn( dialog, { delay = 250, time = 500, sox = 0, soy = fullh } )

end

-- ==
--    EFM - EFM
-- ==
function private.chooseTarget( dialog, width, height )
	local group = display.newGroup()
	dialog:insert(group)
	local title = easyIFC:quickLabel( group, "Choose Export Target", 0, -height/2 + 15, _G.boldFont, 50, _K_ )
	title.anchorY = 0

	local currentSelection

	local function onCancel( event )
		onClose( dialog, function() dialog.frame:close() end )

	end

	local function onNext( event )
	end

	local function onSelectTarget( event )
		currentSelection = event.target.exportTarget
		print("currentSelection: " .. currentSelection)
	end

	local bw 		= 160
	local bh 		= 40
	local tween 	= 10
	local curY 		= height/2 - bh/2 - tween


	easyIFC:presetPush( group, "default", -bw/2 - tween/2, curY, bw, bh, "Cancel", onCancel )
	easyIFC:presetPush( group, "default", bw/2 + tween/2, curY, bw, bh, "Next", onNext )

	local bw 		= 100
	local bh 		= 100
	local tweenX 	= 30
	local tweenY	= 45
	local startX 	= -((bw+tweenX) * 5)/2 + (bw+tweenX)/2
	local startY 	= -0.55 * (bh+tweenY)
	local curX 		= startX
	local curY 		= startY

	local targets = 
	{
		"corona",
		"cocos2d",
		"cocos2dx",
		"kobold2d",
		"marmalade",
		"moai",
		"nme",
		"platino",
		"sparrow",
		"starling",
	}

	local toToggle

	for i = 1, #targets do
		local tmp = easyIFC:presetRadio( group, targets[i] .. "_radio", curX, curY, bw, bh, 
			                             string.first_upper(targets[i]), onSelectTarget,
										 { labelOffset = { 0, bh/2 + 20 }, labelFont = _G.normalFont } )
		tmp.exportTarget = targets[i]
		curX = curX + bw + tweenX
		if( i == 5 ) then
			curX = startX
			curY = curY + bh + tweenY
		end

		if( i == 1 ) then
			toToggle = tmp
		end
	end
	toToggle:toggle()


end


-- ==
--    EFM - EFM
-- ==
function export.new()
end

return export
