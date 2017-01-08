-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Roaming Gamer Button (Presets) Editor (a free SSK2 co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
--   Last Updated: 06 JAN 2017
-- =============================================================
local leftPane = {}

-- =============================================================
-- =============================================================
-- =============================================================
-- Useful Localizations
local getInfo           = system.getInfo
local getTimer 			= system.getTimer
local mRand					= math.random
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
local isInBoundsAlt = ssk.easyIFC.isInBoundsAlt
local normRot = ssk.misc.normRot;local easyAlert = ssk.misc.easyAlert
local tpd = timer.performWithDelay
-- =============================================================
-- =============================================================
local common 			= require "scripts.common"
local layersMgr 		= require "scripts.layersMgr"
local skel 				= require "scripts.skel"


local function onEmpty()
	print("onEmpty")
end

local function onNew()
	print("onNew")
	post("onNewPresets")
end

local function onFromFile()
	print("onFromFile")
end

local function onPaste()
	print("onPaste")
end

local function renameCatalog( target )
	local dialogs 	= ssk.dialogs
	local records 	= require "scripts.records"
	
	local record = target.rec

	table.dump(record)

	local function onClose( self, onComplete )
		transition.to( self, { y = centerY + fullh, transition = easing.inBack, onComplete = onComplete } )
	end

	local width = 400
	local height = 200
	local textField

	local dialog = dialogs.basic.create( display.currentStage, 
						centerX, centerY, 
						{ fill = _W_, 
					 	  width = width,
					 	  height = height,
						  softShadow = true,
						  softShadowOX = 8,
						  softShadowOY = 8,
						  softShadowBlur = 6,
						  closeOnTouchBlocker = false, 
						  blockerFill = _K_,
						  blockerAlpha = 0.65,
						  softShadowAlpha = 0.6,
						  blockerAlphaTime = 100,
						  onClose = onClose,
						  style = 2 } )

	--private.chooseTarget( dialog, width, height )
	local group = display.newGroup()
	dialog:insert(group)
	local title = easyIFC:quickLabel( group, "Rename Catalog", 0, -height/2 + 15, _G.boldFont, 28, _K_ )
	title.anchorY = 0

	local currentSelection

	local function onCancel( event )
		onClose( dialog, function() dialog.frame:close() end )
	end

	local function onOK( event )
		native.setKeyboardFocus( nil )
		if( string.len(textField.text) > 0 ) then
			record.name = textField.text
			target:setText(textField.text)			
			post("onSave")
		end
		onClose( dialog, function() dialog.frame:close() end )
	end

	local bw 		= 160
	local bh 		= 40
	local tween 	= 10
	local curY 		= height/2 - bh/2 - tween

	local textBack = newRect( group, 0, 0, { w = width - 20, height = 40, fill = _LIGHTGREY_ } )
	textField = native.newTextField( 0, 0, width - 20, 40 )
	group:insert( textField )
	textField.text = record.name
	native.setKeyboardFocus( textField )

	
	easyIFC:presetPush( group, "default", -bw/2 - tween/2, curY, bw, bh, "Cancel", onCancel )
	easyIFC:presetPush( group, "default", bw/2 + tween/2, curY, bw, bh, "OK", onOK )

	easyIFC.easyFlyIn( dialog, { delay = 250, time = 500, sox = 0, soy = fullh } )
end



local objectButtons = {}

-- ==
--
-- ==
local function onNewRecord( event )
	local target = event.target
	local toLayer = event.target.layerNum
	easyAlert( "Create Presets Catalog", "Choose method for creating new presets catalog:",
	           {
	           	{ "Cancel", nil },
	           	--{ "From File", onFromFile },
	           	--{ "Paste", 		onPaste },
	           	{ "New", 		onNew },
	           } )
end

local function selectSet( event )
	post( "onSelectSet", { id = event.target.recID })

	local curTime = getTimer()
	if( event.target.lastTime ) then
		local dt = curTime - event.target.lastTime 
		if( dt < common.doubleClickTime ) then
			renameCatalog( event.target )
		end
	end

	event.target.lastTime = curTime

	local mainPane = require "scripts.mainPane"
	mainPane.redraw( true )

end


-- ==
--
-- ==
function leftPane.init()	
	leftPane.draw()
end

-- ==
--
-- ==
function leftPane.draw(skipToggle)	
	local layers = layersMgr.get()
	layers:purge("lpane")

	local radioGroup = display.newGroup()
	layers.lpane:insert(radioGroup)

	local bw 		= skel.lpo[1].contentWidth
	local bh 		= skel.lpo[1].contentHeight
	local records 	= require "scripts.records"


	objectButtons = {}

	objectButtons[1] = easyIFC:presetPush( radioGroup, "default", 
		                                   skel.lpo[1].x, skel.lpo[1].y, 
		                                   bw-4, bh-4, "+", onNewRecord, 
		                                   { labelFont = native.systemFont, labelSize = 28, labelOffset = { 0, 2 } } )
	objectButtons[1].layerNum = 1	
	objectButtons[1].isAddButton = true

	local count = 1
	for i = 1, #records.all do
		local rec = records.all[i]
		count = count + 1
		objectButtons[count] = easyIFC:presetRadio( radioGroup, "default", 
			                                   skel.lpo[count].x, skel.lpo[count].y, 
			                                   bw-4, bh-4, rec.name, selectSet, 
			                                   { labelFont = native.systemFont, labelSize = 14, labelOffset = { 0, 2 } } )
		objectButtons[count].isAddButton = true
		objectButtons[count].recID = rec.id
		objectButtons[count].rec = rec
	end


	if( not skipToggle and count > 1  ) then
		nextFrame( function() objectButtons[2]:toggle() end )
	end

	if( count > (#skel.lpo - 1)  ) then
		objectButtons[1]:disable()
	end

	--nextFrame( function() objectButtons[1]:toggle() end, 500 ) -- EDOCHI
end


return leftPane

