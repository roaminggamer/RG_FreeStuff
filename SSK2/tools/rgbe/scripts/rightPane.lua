-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Roaming Gamer Button (Presets) Editor (a free SSK2 co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
--   Last Updated: 06 JAN 2017
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
local pdFields 	= table.deepCopy(require("scripts.pdFields"))

pane.mode = "buttonPreset"

local buttonPreset_fields = 
{
	pdFields.image,
	pdFields.image2,
	pdFields.rect,
	pdFields.strokes,
	pdFields.label,
	pdFields.overlay,
	pdFields.other,
}
-- Add more as needed for additional 'modes'



local totalPanes_buttonPreset = #buttonPreset_fields

local buttons_buttonPreset = {}

local function paneCreate(num)
	local layers = layersMgr.get()
	layers:purge("rpane_buttonPreset")

	if( pane.mode == "buttonPreset" ) then


		local group = display.newGroup()
		layers.rpane_buttonPreset:insert( group )
		local curFields = buttonPreset_fields[num]

		local label = easyIFC:quickLabel( layers.rpane_buttonPreset, curFields.title, 
			                              skel.currentEditOption.x, skel.currentEditOption.y, 
			                              common.rightPaneHeaderFont, common.rightPaneHeaderFontSize,
			                              common.rightPaneHeaderFontColor )
		for i = 1, #curFields do
			controls.fieldButton( group, i, curFields[i] )
		end 

	end

	local back = newImageRect( layers.rpane_buttonPreset, skel.rightPane.x, skel.rightPane.y, 
										"images/fillT.png",
										{ w = skel.rightPane.w, h = skel.rightPane.h, 
										  fill = _O_, alpha = 0.5,
										  touch = function(self,event)
												if( event.phase == "ended" ) then
													post("onClearSelection")
													--post("onSave")
												end
											end } )
	back:toBack()

end


local lastPage = 1

local function onPane( event )
	--print("BOGART", event.x)
	local num = event.target.num
	--pane[num].create()
	paneCreate(num)
	lastPage = num

	post("onClearSelection")
end

--
function pane.onSelectedRecord( self, event )
	local layers = layersMgr.get()

	if( common.currentRecord.isType == "buttonPreset" ) then
		controls.setMode( "buttonPreset" )
		pane.mode = "buttonPreset"
		post("onClearSelection")
		local button = buttons_buttonPreset[lastPage]
		if( button ) then
			button:toggle()
		end
		layers.rpane_buttonPreset.isVisible = true
		layers.rpb_buttonPreset.isVisible = true

	end
end


function pane.init()
	--print("INITIALIZE RIGHT PANE")
	local layers = layersMgr.get()
	layers:purge("rpane_buttonPreset")
	layers:purge("rpb_buttonPreset")

	-- Create and fill buttonPreset right pane
	for i = 1, totalPanes_buttonPreset do		
		local tmp = easyIFC:presetRadio( layers.rpb_buttonPreset, "default", skel.rpb[i].x, skel.rpb[i].y, 32, 32, i, onPane )
		tmp.num = i
		buttons_buttonPreset[i] = tmp
	end

	layers.rpane_buttonPreset.isVisible = false
	layers.rpb_buttonPreset.isVisible = false


	listen("onSelectedRecord", pane )
end

return pane