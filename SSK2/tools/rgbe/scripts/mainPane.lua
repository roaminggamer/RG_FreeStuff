-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Roaming Gamer Button (Presets) Editor (a free SSK2 co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
--   Last Updated: 06 JAN 2017
-- =============================================================
local mainPane = {}

-- =============================================================
-- =============================================================
-- =============================================================
-- Useful Localizations
local getInfo           = system.getInfo
local getTimer          = system.getTimer
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
local normRot = ssk.misc.normRot;local easyAlert = ssk.misc.easyAlert
local tpd = timer.performWithDelay
-- =============================================================
-- =============================================================
local common 			= require "scripts.common"
local records 			= require "scripts.records"

local layersMgr 		= require "scripts.layersMgr"
local skel 				= require "scripts.skel"
local leftPane 		= require "scripts.leftPane"
local rightPane 		= require "scripts.rightPane"

local mpw
local mph
local mpl
local mpr
local mpt
local mpb

local currentContainer
local touchObj
local curPaneGroup

local curChip  				= 1
local curRecordNum 			= 1
local curPage 					= 1
local maxPage 					= 1

local prevB
local nextB
local newB
local textB
local renameB
local cloneB
local deleteB

-- ==
--
-- == 
local function onPreview( )
end


-- ==
--
-- == 
local showText = true
function mainPane.redraw( resetPage )

	if( resetPage ) then curPage = 1 end

	-- Clear
	ignoreList( { "key" }, curPaneGroup )

	display.remove( curPaneGroup )
	curPaneGroup = display.newGroup()
	currentContainer:insert( curPaneGroup )
	curPaneGroup.x = -mpw/2
	curPaneGroup.y = -mph/2

	-- Create
	local chipSize 		= 220
	local buttonHeight 	= 60
	local buttonWidth 	= 150
	local chipCols			= 3 -- 5
	local chipRows 		= 2
	local chipsPerPage 	= chipCols * chipRows
	local tweenChipsH		= (mpw - (chipCols*chipSize))/chipCols
	local tweenChipsV		= 50


	if( not records.current ) then
		maxPage = 1
		curPage = 1
	elseif( #records.current == 0 ) then
		maxPage = 1
		curPage = 1
	else
		maxPage =  math.ceil( #records.current / chipsPerPage )
	end


	local pages = easyIFC:quickLabel( curPaneGroup, "aaa", mpl + 10, mpt + 26, ssk.gameFont(), 18, _W_, 0 )

	local startX 	= mpl + (chipSize + tweenChipsH)/2
	local startY 	= mpt + (chipSize + tweenChipsV)/2 + 40
	local curX 		= startX
	local curY 		= startY
	local row 		= 1
	local col 		= 1	

	curRecordNum = (curPage-1) * chipsPerPage + 1

	pages.text =  "Page: " .. curPage .. "/" .. maxPage

	local chips = {}

	local function onTouchChip( self, event )			
		if( event.phase == "ended" ) then
			for i = 1, #chips do 
				chips[i]:setStrokeColor( unpack(_GREY_) )
				chips[i].stroke.effect = ""
				chips[i].stroke.width = 2
			end
			--self:setStrokeColor( unpack( common.selectedChipColor ) )
			self:setStrokeColor( unpack( _G_ ) )
			self.stroke.effect = "generator.marchingAnts"
			self.strokeWidth = 4

			-- Select Record
			common.sliderB.isVisible = false
			post( "onClearSelection" )
			common.currentRecord = self.rec
			common.currentChip = self
			post("onSelectedRecord" )

			local curTime = getTimer()
			if( self.clickTime ) then					
				local dt = curTime - self.clickTime
				if( dt <= common.doubleClickTime ) then
					-- PREVIEW
				end
			end
			self.clickTime = curTime

			self:redraw( )


		end
		return true
	end		

	if( not records.current ) then
		return
	end
	local firstChip
	for i = 1, chipsPerPage do

		if( curRecordNum <= #records.current ) then				
			local curRec = records.current[curRecordNum]
			local tmp = newRect( curPaneGroup, curX, curY, 
				                 { size = chipSize, fill = _K_, stroke = _GREY_, strokeWidth = 2,
				                   touch = onTouchChip, isHitTestable = true })
			tmp.rec = curRec
			local tmp2 = display.newContainer( curPaneGroup, chipSize-3, chipSize-3 )
			tmp2.x = tmp.x
			tmp2.y = tmp.y
			tmp.container = tmp2

			function tmp.redraw( self )
				--table.dump(self.rec.definition) -- EDO
				local pdFields = require "scripts.pdFields"
				local mgr = require "ssk2.interfaces.buttons"

				local fieldSets = 
				{
					"image",
					"image2",
					"rect",
					"strokes",
					"label",
					"overlay",
					"other",
				}				
				local presetName = "dummy_" .. self.rec.name
				local definition = self.rec.definition
				--table.dump(definition,nil,"definition")

				local presetParams = {}
				for i = 1, #fieldSets do
					local fields = pdFields[fieldSets[i]]
					for k, v in pairs( fields ) do
						local attrName = v.attrName						
						if( attrName ) then
							
							local value = definition[attrName]
							if( value and not
								( type(value) == "string" and string.len(value) == 0 ) ) then
								--print("redrawing", attrName,value)																
								
								if( tonumber( value ) ) then
									presetParams[attrName] = definition[attrName]
								else
									if(string.match(value,",")) then
										local parts = string.split(value,",")
										for i = 1, #parts do
											parts[i] = tonumber(parts[i])
										end
										presetParams[attrName] = parts
									elseif(string.match(value,"%/")) then
										presetParams[attrName] = "incoming/" .. value
									elseif(string.match(value,"true")) then
										presetParams[attrName] = true
									elseif(string.match(value,"false")) then
										presetParams[attrName] = false
									end
								end
							end
						end
					end
				end
				--table.print_r( presetParams )
				mgr:addButtonPreset( presetName, presetParams )			

				--print('Redrawing @ ' .. tostring(getTimer()))
				display.remove(self.buttonGroup)
				local bg = display.newGroup()
				self.buttonGroup = bg
				self.container:insert( bg )

				-- Visual Rep Of Current Record
				local button1
				local button2
				local button3
				local bw = tonumber(curRec.definition.width) or buttonWidth
				local bh = tonumber(curRec.definition.height) or buttonHeight
				bw = bw or buttonWidth
				bh = bh or buttonHeight			

				local scale = buttonHeight/bh
				if( scale * bw > buttonWidth ) then
					scale = buttonWidth/bw
				end
				--print("x", bw,bh,scale)			

				
				button1 = easyIFC:presetRadio( bg, presetName, 
					                                  0, -buttonHeight - 10, 
					                                  bw * scale, bh * scale, 
					                                  showText and "Test" or "", nil )

				button2 = easyIFC:presetRadio( bg, presetName, 
					                                  0, 0, 
					                                  bw * scale, bh * scale, 
					                                  showText and "Test" or "", nil, { scale = scale } )

				button3 = easyIFC:presetRadio( bg, presetName, 
					                                  0, buttonHeight + 10, 
					                                  bw * scale, bh * scale, 
					                                  showText and "Disabled" or "", nil, { scale = scale } )
				button3:disable()
				button2:toggle()
			end
			tmp:redraw()

			function tmp.onRefresh( self )
				if( autoIgnore( "onRefresh", self ) ) then return end
				if( self.rec ~= common.currentRecord ) then return end
				self:redraw()
			end; listen( "onRefresh", tmp )


			local name = curRec.name or tostring(curRecordNum)
			local label = easyIFC:quickLabel( curPaneGroup, name, tmp.x, tmp.y + chipSize/2 + 22, ssk.gameFont(), 16, _W_ )

			tmp.label = label
			firstChip = firstChip or tmp

			if( i == 1 ) then
				
				nextFrame( 
					function() 
						common.sliderB.isVisible = false
						post( "onClearSelection" )
						local selected = tmp

						for i = 1, #chips do
							if( common.currentRecord and chips[i].rec == common.currentRecord ) then
								selected = chips[i]
							end					
						end
						selected:setStrokeColor( unpack( _G_ ) )
						selected.stroke.effect = "generator.marchingAnts"
						selected.strokeWidth = 4
						common.currentRecord = selected.rec
						common.currentChip = selected
						post("onSelectedRecord" ) 
					end )
			end

			curRecordNum = curRecordNum + 1
			chips[#chips+1] = tmp			
		end

		curX = curX + chipSize + tweenChipsH
		col = col + 1
		if( col > chipCols ) then
			curX = startX
			col = 1
			row = row + 1
			curY = curY + chipSize + tweenChipsV
		end
	end

	-- Buttons
	local onKey
	local function onPrev( target )
		curPage = curPage - 1
		if( curPage < 1 ) then
			curPage = maxPage
		end
		mainPane.redraw()	
	end
	local function onNext( target )
		curPage = curPage + 1
		if( curPage > maxPage ) then
			curPage = 1
		end
		mainPane.redraw()
	end
	local function onClone()
		post("onNewRecord", { rec = common.currentRecord } )
		post("onSave")
	end

	local function onDelete()
		post("onRemoveRecord", { rec = common.currentRecord } )
		mainPane.redraw()
	end

	local function onNewRecord()
		post("onNewRecord")
	end

	local function onRenameRecord()
		local dialogs 	= ssk.dialogs
		local record 	= common.currentRecord
		local curChip 	= common.currentChip

		--table.dump(curChip)

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
		local title = easyIFC:quickLabel( group, "Rename Record", 0, -height/2 + 15, _G.boldFont, 28, _K_ )
		title.anchorY = 0

		local currentSelection

		local function onCancel( event )
			onClose( dialog, function() dialog.frame:close() end )			
		end

		local function onOK( event )
			native.setKeyboardFocus( nil )
			if( string.len(textField.text) > 0 ) then
				record.name = textField.text
				curChip.label.text = textField.text
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

	curPaneGroup.key = function( self, event )
		if( event.phase == "up" ) then
			if( event.keyName == "left" or event.keyName == "a" ) then
				onPrev()
			elseif( event.keyName == "right" or event.keyName == "d" ) then
				onNext()
			end
		end
	end; listen("key", curPaneGroup)

	local ox2 = skel.leftPane.contentWidth/2

	prevB = easyIFC:presetPush( curPaneGroup, "default", left + 25, mpb - 25, 40, 40, "<<", onPrev, 
		                             { labelFont = ssk.gameFont(), labelSize = 24, labelOffset = { 0, 2 } }  )

	nextB = easyIFC:presetPush( curPaneGroup, "default", mpr - 25, mpb - 25, 40, 40, ">>", onNext, 
		                             { labelFont = ssk.gameFont(), labelSize = 24, labelOffset = { 0, 2 } }  )


	deleteB = easyIFC:presetPush( curPaneGroup, "default", mpl + mpw/2 - 285, mpb - 25, 120, 40, "Delete", onDelete, 
								{ labelFont = ssk.gameFont(), labelSize = 24, labelOffset = { 0, 2 } }  )


	cloneB = easyIFC:presetPush( curPaneGroup, "default", deleteB.x + 130, mpb - 25, 120, 40, "Clone", onClone, 
		                             { labelFont = ssk.gameFont(), labelSize = 24, labelOffset = { 0, 2 } }  )

	renameB = easyIFC:presetPush( curPaneGroup, "default", cloneB.x + 130, mpb - 25, 120, 40, "Rename", onRenameRecord, 
		                             { labelFont = ssk.gameFont(), labelSize = 24, labelOffset = { 0, 2 } }  )


	newB = easyIFC:presetPush( curPaneGroup, "default", renameB.x + 130, mpb - 25, 120, 40, "New", onNewRecord, 
		                             { labelFont = ssk.gameFont(), labelSize = 24, labelOffset = { 0, 2 } }  )

	local function onShowText( event )
		showText = event.target.isPressed
		mainPane.redraw()
	end
	textB = easyIFC:presetToggle( curPaneGroup, "default", newB.x + 160, mpb - 25, 140, 40, "Show Text", onShowText, 
		                             { labelFont = ssk.gameFont(), labelSize = 24, labelOffset = { 0, 2 } }  )
	if( showText ) then
		textB:toggle(true)
	end

	


	if( #records.current < 1 ) then
		local layers = layersMgr.get()
		deleteB:disable()
		cloneB:disable()
		renameB:disable()
		
		layers.rpane_buttonPreset.isVisible = false
		layers.rpb_buttonPreset.isVisible = false
	else
		local layers = layersMgr.get()
		layers.rpane_buttonPreset.isVisible = true
		layers.rpb_buttonPreset.isVisible = true
	end

end


-- ==
--
-- == 
function mainPane.init( cb )
	local layers = layersMgr.get()

	-- Calculate some helper values
	mpw = skel.mainPane.contentWidth
	mph = skel.mainPane.contentHeight
	mpl = 0
	mpr = mpw
	mpt = 0
	mpb = mph

	-- Function to Destroy ALL content in layers
	local function doPurge()		
		local layers = layersMgr.get()
		layers:purge("mpane")
		if( cb ) then cb(true) end
		common.isDirty = false
	end
	local function saveThenPurge()
		local layers = layersMgr.get()
		layers:purge("mpane")
		if( cb ) then cb(true) end
		common.isDirty = false
	end

	doPurge()

	currentContainer = display.newContainer( layers.mpane, mpw, mph )
	currentContainer.x = skel.mainPane.x
	currentContainer.y = skel.mainPane.y

	touchObj = newImageRect( currentContainer, 0, 0, "images/fillW.png",
		                     { w = mpw, h = mph, fill = _K_, alpha = 1,
		                       touch = function() return true end } )

	mainPane.redraw()
end




return mainPane



