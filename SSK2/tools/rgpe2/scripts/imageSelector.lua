-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Roaming Gamer Particle Editor 2 (a free SSK2 co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
local imageSelector = {}

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
local RGFiles = ssk.files
-- =============================================================
-- =============================================================
local common 	= require "scripts.common"
local layersMgr = require "scripts.layersMgr"
local skel 		= require "scripts.skel"

local chipSize 		= 200
local tweenChips	= 50
local chipCols		= 4 -- 5
local chipRows 		= 2
local chipsPerPage 	= chipCols * chipRows

local curChip  		= 1
local curImageNum 	= 1
local selectedChipNum = 1
local curPage 		= 1
local maxPage 		= 1

local prevB
local nextB
local okB
local cancelB
local helpB

local defaultImages = {
	{ filename = "white.png", w = 2048, h = 2048, name = "White", user = false },
	{ filename = "black.png", w = 2048, h = 2048, name = "Black", user = false },
	{ filename = "kenney1.png", w = 2048, h = 2048, name = "Kenney 1", user = false },
	{ filename = "kenney2.png", w = 2048, h = 2048, name = "Kenney 2", user = false },
	{ filename = "kenney3.png", w = 2048, h = 2048, name = "Kenney 3", user = false },
	{ filename = "kenney4.png", w = 2048, h = 2048, name = "Kenney 4", user = false },
	{ filename = "grey.png", w = 2048, h = 2048, name = "Grey", user = false },
	{ filename = "grid2.png", w = 2048, h = 2048, name = "Black & White Grid", user = false },
	{ filename = "grid1.png", w = 2048, h = 2048, name = "Grey & White Grid", user = false },
	{ filename = "grid3.png", w = 2048, h = 2048, name = "Black & Grey Grid", user = false },
	{ filename = "grid4.png", w = 2048, h = 2048, name = "White & Transparent Grid 1", user = false },
	{ filename = "grid5.png", w = 2048, h = 2048, name = "White & Transparent Grid 2", user = false },
}

local imgPath = RGFiles.documents.getPath("images")
if( RGFiles.util.isFolder( imgPath ) ) then
	local userFiles = RGFiles.util.getFilesInFolder( imgPath )
	for i = 1, #userFiles do
		local filename = userFiles[i]
		local isPNG = (string.match(filename,"%.png") ~= nil)
		local isJPG = (string.match(filename,"%.jpg") ~= nil)
		if( isJPG or isPNG ) then
			local tmp = display.newImage( "images/" .. filename, system.DocumentsDirectory, 100000, 100000 )
			defaultImages[#defaultImages+1] = 
			{
				filename 	= filename,
				w 			= tmp.contentWidth,
				h 			= tmp.contentHeight,
				name 		= "User: " .. filename,
				user 		= true
			}
			display.remove(tmp)
		end
	end
	--table.print_r(defaultImages)
end

local knownImages = table.deepCopy( defaultImages )
maxPage = math.ceil( #knownImages/chipsPerPage)

-- ==
--
-- ==
function imageSelector.getKnownImages( )
	return knownImages
end

-- ==
--
-- ==
function imageSelector.run( toLayer )
	local layers = layersMgr.get()
	layers:purge("select_block")
	layers:purge("mpane_select")
	layers:purge("rpane_select")

	layers.overlay.frame.fill = { type = "image", filename = "images/overlay6.png" }

	local onOK

	local mpl = skel.mainPane.x - skel.mainPane.contentWidth/2
	local mpr = skel.mainPane.x + skel.mainPane.contentWidth/2
	local mpt = skel.mainPane.y - skel.mainPane.contentHeight/2
	local mpb = skel.mainPane.y + skel.mainPane.contentHeight/2	

	-- Touch Blocker and Edit Area Backgrounds
	local blocker = newImageRect( layers.select_block, centerX, centerY, "images/fillW.png",
					              { w = fullw, h = fullh, alpha = 0, fill = _K_,
					                touch = function() return true end } )

	transition.to( blocker, { alpha = 0.85, time = 250 } )

	local backm = newImageRect( layers.mpane_select, left, skel.mainPane.y, "images/fillW.png",
					              { w = skel.mainPane.contentWidth + skel.leftPane.contentWidth + 4, 
					                h = skel.rightPane.contentHeight, 
					                anchorX = 0, alpha = 0, fill = common.backgroundColor } )
	transition.to( backm, { alpha = 1, time = 250 } )

	local backr = newImageRect( layers.mpane_select, skel.rightPane.x, skel.rightPane.y, "images/fillW.png",
					              { w = skel.rightPane.contentWidth, h = skel.rightPane.contentHeight, 
					                alpha = 0, fill = common.backgroundColor } )
	transition.to( backr, { alpha = 0.5, time = 250 } )


	-- Title
	local title = easyIFC:quickLabel( layers.mpane_select, "Choose An Image", skel.mainPane.x - skel.leftPane.contentWidth/2, mpt + 26, ssk.gameFont(), 32, _W_ )
	local pages = easyIFC:quickLabel( layers.mpane_select, "aaa", left + 10, mpt + 26, ssk.gameFont(), 18, _W_, 0 )

	local chipGroup
	local selectedRec
	local function redrawChips()
		display.remove( chipGroup )
		chipGroup = display.newGroup()
		layers.mpane_select:insert( chipGroup )

		local startX 	= skel.mainPane.x - (chipCols * (chipSize + tweenChips))/2 + 32--+ (chipSize + tweenChips)/2
		local startY 	= skel.mainPane.y - (chipRows * (chipSize + tweenChips))/2 + (chipSize + tweenChips)/2 - 30
		local curX 		= startX
		local curY 		= startY
		local row 		= 1
		local col 		= 1	

		curImageNum = (curPage-1) * chipsPerPage + 1

		print("Current page", curPage, curImageNum )

		pages.text =  "Page: " .. curPage .. "/" .. maxPage

		local chips = {}

		local function onTouchChip( self, event )
			if( event.phase == "ended" ) then
				for i = 1, #chips do 
					chips[i]:setStrokeColor( unpack(_GREY_) )
					chips[i].stroke.effect = ""
					chips[i].stroke.width = 2
					chips[i]:setFillColor(unpack(_T_))

				end
				--self:setStrokeColor( unpack( common.selectedChipColor ) )
				self:setStrokeColor( unpack( _G_ ) )
				self.stroke.effect = "generator.marchingAnts"
				self.strokeWidth = 4
				self:setFillColor(unpack(_G_))
				selectedChipNum = self.imageNum
				selectedRec = self.rec
				local curTime = getTimer()
				if( self.clickTime ) then					
					local dt = curTime - self.clickTime
					if( dt <= common.doubleClickTime ) then
						onOK()
					end
				end
				self.clickTime = curTime
			end
			return true
		end		

		for i = 1, chipsPerPage do

			if( curImageNum <= #knownImages ) then
				local curRec = knownImages[curImageNum]
				local tmp = newRect( chipGroup, curX, curY, 
					                 { size = chipSize, fill = _T_, stroke = _GREY_, strokeWidth = 2,
					                   touch = onTouchChip, isHitTestable = true })
				tmp.rec = curRec
				local tmp2 = display.newContainer( chipGroup, chipSize-3, chipSize-3 )
				tmp2.x = tmp.x
				tmp2.y = tmp.y

				local tmp3

				-- User Image
				if( curRec.user ) then
					print("USER%%%%%%%%%%%%%%%%%%%")
					tmp3 = display.newImage( tmp2, "images/" .. curRec.filename, system.DocumentsDirectory  )
				
				-- Library Image
				else
					tmp3 = display.newImage( tmp2, "images/imageLayer/" .. curRec.filename  )
				end				
				tmp2:insert( tmp3 )

				local name = curRec.name or curRec.filename
				easyIFC:quickLabel( chipGroup, name, tmp.x, tmp.y + chipSize/2 + 22, ssk.gameFont(), 16, _W_ )

				if( i == 1 ) then
					--curEmitterNum = emitterNum
					--tmp:setStrokeColor( unpack( common.selectedChipColor ) )
					tmp:setStrokeColor( unpack( _G_ ) )
					tmp.stroke.effect = "generator.marchingAnts"
					tmp.strokeWidth = 4
					tmp:setFillColor(unpack(_G_))
					selectedChipNum = curImageNum	
					selectedRec = curRec
				end

				tmp.imageNum = curImageNum
				curImageNum = curImageNum + 1
				chips[#chips+1] = tmp			
			end

			curX = curX + chipSize + tweenChips
			col = col + 1
			if( col > chipCols ) then
				curX = startX
				col = 1
				row = row + 1
				curY = curY + chipSize + tweenChips
			end
		end
	end

	local onKey
	local function onPrev( event )
		curPage = curPage - 1
		if( curPage < 1 ) then
			curPage = maxPage
		end
		redrawChips()	
	end
	local function onNext( event )
		curPage = curPage + 1
		if( curPage > maxPage ) then
			curPage = 1
		end
		redrawChips()
	end
	local function onCancel( event )
		layers:purge("select_block")
		layers:purge("mpane_select")
		layers:purge("rpane_select")
		ignore("key", onKey)
		layers.overlay.frame.fill = { type = "image", filename = "images/overlay5.png" }
	end
	onOK = function( event )
		--table.dump( selectedRec )
		post("onCreateNewImageLayer", { details = selectedRec, toLayer = toLayer } )
		onCancel()
	end

	onKey = function( event )
		--table.dump(event)
		if( event.phase == "up" ) then
			if( event.keyName == "escape" ) then
				onCancel()
			elseif( event.keyName == "left" or event.keyName == "a" ) then
				onPrev()
			elseif( event.keyName == "right" or event.keyName == "d" ) then
				onNext()
			elseif( event.keyName == "enter" ) then
				onOK()				
			end
		end
	end; listen("key", onKey)


	prevB = easyIFC:presetPush( layers.mpane_select, "default", mpl + 45, mpb - 45, 80, 80, "<<", onPrev, 
		                             { labelFont = ssk.gameFont(), labelSize = 48, labelOffset = { 0, 2 } }  )

	nextB = easyIFC:presetPush( layers.mpane_select, "default", mpr - 45, mpb - 45, 80, 80, ">>", onNext, 
		                             { labelFont = ssk.gameFont(), labelSize = 48, labelOffset = { 0, 2 } }  )


	okB	= easyIFC:presetPush( layers.mpane_select, "default", skel.mainPane.x + 90, mpb - 45, 160, 80, "OK", onOK, 
		                             { labelFont = ssk.gameFont(), labelSize = 48, labelOffset = { 0, 2 } }  )


	cancelB = easyIFC:presetPush( layers.mpane_select, "default", skel.mainPane.x - 90, mpb - 45, 160, 80, "Cancel", onCancel, 
		                             { labelFont = ssk.gameFont(), labelSize = 48, labelOffset = { 0, 2 } }  )


	redrawChips()


	--local bw 	= skel.lpo[1].contentWidth
	--local bh 	= skel.lpo[1].contentHeight
	
	--
	--objectButtons = {}

	--objectButtons[1] = easyIFC:presetPush( layers.tbar, "default", 
		                                   --skel.lpo[1].x, skel.lpo[1].y, 
		                                   --bw-4, bh-4, "+", onNewObject, 
		                                   --{ labelFont = native.systemFont, labelSize = 28, labelOffset = { 0, 2 } } )
	--objectButtons[1].layerNum = 1	
	--local bar = newRect( layers.tbar, skel.tbar.x, skel.tbar.y, { w = fullw, h = barHeight, fill = common.barColor } )
	--local tmp = easyIFC:presetPush( layers.tbar, "edgeless2", curX, bar.y, buttonW, buttonH, "roaminggamer.com", onLink, 
		                             --{ labelFont = native.systemFont, labelSize = 16, labelOffset = { 0, 2 } }  )
	--nextFrame( onLoadEmitter, 100 )
end

return imageSelector
