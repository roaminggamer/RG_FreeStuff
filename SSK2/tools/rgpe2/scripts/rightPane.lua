-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Roaming Gamer Particle Editor 2 (a free SSK2 co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
local pane = {}

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

local common 			= require "scripts.common"
local layersMgr 		= require "scripts.layersMgr"
local skel 				= require "scripts.skel"
local controls 			= require "scripts.controls"
local emitterFields 	= table.deepCopy(require("scripts.pdFields"))

pane.mode = "emitter"

local emitter_fields = 
{
	emitterFields.basic,
	emitterFields.gravity,
	emitterFields.radial,
	emitterFields.particle,
	emitterFields.color,
	emitterFields.colorslide,
	emitterFields.colorslide2,
}
local image_fields = 
{
	emitterFields.image_basic,
}


local totalPanes_emitter = #emitter_fields
local totalPanes_image = 1

local buttons_emitter = {}
local buttons_image = {}

local function paneCreate(num)
	local layers = layersMgr.get()
	layers:purge("rpane_emitter")
	layers:purge("rpane_image")


	if( pane.mode == "emitter" ) then
		local group = display.newGroup()
		layers.rpane_emitter:insert( group )
		local curFields = emitter_fields[num]

		local label = easyIFC:quickLabel( layers.rpane_emitter, curFields.title, 
			                              skel.currentEditOption.x, skel.currentEditOption.y, 
			                              common.rightPaneHeaderFont, common.rightPaneHeaderFontSize,
			                              common.rightPaneHeaderFontColor )
		for i = 1, #curFields do
			controls.fieldButton( group, i, curFields[i] )
		end 
	elseif( pane.mode == "image" ) then
		local group = display.newGroup()
		layers.rpane_image:insert( group )

		local curFields = image_fields[num]

		local label = easyIFC:quickLabel( layers.rpane_image, curFields.title, 
			                              skel.currentEditOption.x, skel.currentEditOption.y, 
			                              common.rightPaneHeaderFont, common.rightPaneHeaderFontSize,
			                              common.rightPaneHeaderFontColor )
		for i = 1, #curFields do
			controls.fieldButton( group, i, curFields[i] )
		end 

	end
end


local lastPage = 1

local function onPane( event )
	--print("BOGART", event.x)
	local num = event.target.num
	--pane[num].create()
	paneCreate(num)
	lastPage = num
end

--
function pane.onSelectedObject( self, event )
	--table.dump(event)
	local layers = layersMgr.get()
	if( event.isType == "emitter" ) then
		controls.setMode( "emitter" )
		pane.mode = "emitter"
		post("onClearSelection")
		local button = buttons_emitter[lastPage]
		if( button ) then
			button:toggle()
		end
		layers.rpane_emitter.isVisible = true
		layers.rpb_emitter.isVisible = true
		layers.rpane_image.isVisible = false
		layers.rpb_image.isVisible = false


	elseif( event.isType == "image" ) then
		controls.setMode( "image" )
		pane.mode = "image"
		post("onClearSelection")
		local button = buttons_image[lastPage]
		if( button ) then
			button:toggle()
		end
		layers.rpane_emitter.isVisible = false
		layers.rpb_emitter.isVisible = false
		layers.rpane_image.isVisible = true
		layers.rpb_image.isVisible = true
	end
end


function pane.init()
	--print("INITIALIZE RIGHT PANE")
	local layers = layersMgr.get()
	layers:purge("rpane_emitter")
	layers:purge("rpb_emitter")
	layers:purge("rpane_image")
	layers:purge("rpb_image")
	

	-- Create and fill emitter right pane
	for i = 1, totalPanes_emitter do		
		local tmp = easyIFC:presetRadio( layers.rpb_emitter, "default", skel.rpb[i].x, skel.rpb[i].y, 32, 32, i, onPane )
		tmp.num = i
		buttons_emitter[i] = tmp
	end

	-- Create and fill emitter right pane
	for i = 1, totalPanes_image do		
		local tmp = easyIFC:presetRadio( layers.rpb_image, "default", skel.rpb[i].x, skel.rpb[i].y, 32, 32, i, onPane )
		tmp.num = i
		buttons_image[i] = tmp
	end

	--
	easyIFC:quickLabel( layers.rpane_image, "Image", skel.rightPane.x, skel.rightPane.y, "Lato-Regular.ttf", 32, _W_ )

	layers.rpane_emitter.isVisible = false
	layers.rpb_emitter.isVisible = false
	layers.rpane_image.isVisible = false
	layers.rpb_image.isVisible = false

	listen("onSelectedObject", pane )
end

return pane