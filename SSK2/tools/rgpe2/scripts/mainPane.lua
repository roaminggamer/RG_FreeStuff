-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Roaming Gamer Particle Editor 2 (a free SSK2 co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
-- =============================================================
-- Center working area
-- =============================================================
local mainPane = {}

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
local leftPane 			= require "scripts.leftPane"
local rightPane 		= require "scripts.rightPane"

local mpw
local mph
local mpl
local mpr
local mpt
local mpb

local currentContainer
local touchObj
local currentMasterGroup

local function onZoom()
	transition.cancel( currentMasterGroup )
	transition.to( currentMasterGroup, 
					{ 
						xScale = (currentMasterGroup.xScale == 1) and 0.15 or 1,
						yScale = (currentMasterGroup.yScale == 1) and 0.15 or 1,
						time = 2000 
						} )
end; listen( "onZoom", onZoom )


-- ==
--
-- == 
function mainPane.getMasterGroup( )
	return currentMasterGroup
end


-- ==
--
-- == 
function mainPane.insertAtLayerNum( obj, num )
	local numChildren = currentMasterGroup.numChildren or 0	
	currentMasterGroup:insert( obj )
	if( num <= numChildren ) then
		local tmp = {}
		for i = num, numChildren do
			tmp[#tmp+1] = currentMasterGroup[i]
		end
		for i = 1, #tmp do
			tmp[i]:toFront()
		end
	end
	obj.layerNum = num
end


-- ==
--
-- == 
local function touchHandler( self, event )
	--table.dump(event)
	return true 
end

-- ==
--
-- == 
function mainPane.init( cb )
	local layers = layersMgr.get()

	-- Calculate some helper values
	mpw = skel.mainPane.contentWidth
	mph = skel.mainPane.contentHeight
	mpl = skel.mainPane.x - mpw/2
	mpr = skel.mainPane.x + mpw/2
	mpt = skel.mainPane.y - mph/2
	mpb = skel.mainPane.y + mph/2

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

	if( common.isDirty ) then
		-- ISSUE: Does not account for closing dialog w/ X button?
		easyAlert( "Save First?", 
			       "The current project has unsaved changes.\n\nWant to save first?",
			       {
			         { "Cancel", function() if( cb ) then cb(false) end end },
			         { "Skip Save", doPurge },
			         { "Save", saveThenPurge },
			       } )
	else
		doPurge()
	end

	currentContainer = display.newContainer( layers.mpane, mpw, mph )
	currentContainer.x = skel.mainPane.x
	currentContainer.y = skel.mainPane.y
	currentMasterGroup = display.newGroup()

	touchObj = newImageRect( currentContainer, 0, 0, "images/fillW.png",
		                     { w = mpw, h = mph, fill = _K_, alpha = 1,
		                       touch = touchHandler } )

	currentContainer:insert( currentMasterGroup )

end


-- ==
--
-- == 
local function touchDragger( self, event )
	local phase = event.phase
	local id 	= event.id
	if( event.phase == "began" ) then
		self:setStrokeColor(unpack(_G_))
		self.strokeWidth = 3
		self:setFillColor(  0, 0, 0 , 0.75 )
		self:toFront()

		display.getCurrentStage():setFocus( self, id )
		self.isFocus = true
		print( event.x, event.y )
		print( skel.mainPane.x, skel.mainPane.y )
		print( event.x - skel.mainPane.x, event.y - skel.mainPane.y )
		print("----------------")
		self.tdx = (event.x - skel.mainPane.x) - self.x
		self.tdy = (event.y - skel.mainPane.y) - self.y

	elseif( self.isFocus == true ) then

		self.x = event.x - skel.mainPane.x - self.tdx
		self.y = event.y - skel.mainPane.y - self.tdy
		self.emitter.x = self.x
		self.emitter.y = self.y
		if( phase == "ended" ) then
			display.getCurrentStage():setFocus( self, nil )
			self.isFocus = false
			self:setStrokeColor(unpack(_GREY_))
			self.strokeWidth = 2
			self:setFillColor(  0, 0, 0 , 0.25 )
			self:toBack()
			common.curEmitterRec = self.emitterRecord
			common.curEmitterObj = self.emitter
			common.curSelectedObj = self.emitter
			print("touchDragger() ", "ImageLayer", common.curSelectedObj, common.curEmitterObj, common.curImageObject )
			--table.dump(common.curEmitterRec)
			post( "onSelectedObject", { isType = "emitter" } )
			post( "onRefreshLeftPane", { layerNum = self.parent.layerNum } )
		end
	end	
	return true
end

-- ==
--	  onCreateNewEmitter() 
-- == 
function mainPane.onCreateNewEmitter( event )
	--table.dump(event,nil,"onCreateNewEmitter")
	local details = event.details
	local group = display.newGroup()
	group.objType = "emitter"

	local handle = newImageRect( group, 0, 0, "images/fillW.png", 
		                         { size = common.handleSize, 
		                           strokeWidth = 2, stroke = _GREY_,
		                           fill =  {0,0,0,0.25}, touch = touchDragger  } )
	
	local emitter  = display.newEmitter( details.definition )
	
	group:insert( emitter )

	group.emitter 				= emitter
	handle.emitter 			= emitter
	group.emitterRecord 		= details
	handle.emitterRecord 	= details
	emitter.myHandle 			= handle
	
	group.isType = "emitter"	
	group.recordID = details.id

	mainPane.insertAtLayerNum( group, event.toLayer )
	leftPane.addObject( event.toLayer, group, details, "emitter" )

	common.curEmitterRec 	= details
	common.curEmitterObj 	= emitter
	common.curSelectedObj	= emitter
	print("onCreateNewEmitter() ", "ImageLayer", common.curSelectedObj, common.curEmitterObj, common.curImageObject )
	post( "onSelectedObject", { isType = "emitter" } )

	function emitter.onRefresh( self, event )
		if( autoIgnore( "onRefresh", self ) ) then
			return false 
		end		
		
		if( common.curEmitterRec ~= details ) then return false end		
		
		local emitter2 = display.newEmitter( details.definition )
		emitter2.x = self.x
		emitter2.y = self.y
		
		self.parent:insert( emitter2 )
		handle:toFront()

		emitter2.myHandle 		= group.emitter.myHandle
		group.emitter 			= emitter2
		handle.emitter 			= emitter2
		common.curEmitterObj 	= emitter2
		common.curSelectedObj 	= emitter2
		print("onCreateNewEmitter() -> onRefresh() ", "ImageLayer", common.curSelectedObj, common.curEmitterObj, common.curImageObject )

		emitter2.onRefresh = self.onRefresh
		display.remove( self )

		table.save( common.emitterLibrary, "emitterLib.json" ) 

		nextFrame( 
			function()
				if(isValid(emitter2) ) then
					listen( "onRefresh", emitter2 )
				end
			end )
		
	end; listen( "onRefresh", emitter )


	function group.onSelectedMainPaneLayer( self, event )
		if( autoIgnore( "onSelectedMainPaneLayer", self ) ) then return end
		if(event.layerNum ~= self.layerNum) then return end
		print("******************************", self.layerNum, event.layerNum )
		common.curEmitterRec 	= details
		common.curEmitterObj 	= self.emitter
		common.curSelectedObj 	= self.emitter
		print("onCreateNewEmitter() -> onSelectedMainPaneLayer() ", "ImageLayer", common.curSelectedObj, common.curEmitterObj, common.curImageObject )
		post( "onSelectedObject", { isType = "emitter" } )

	end; listen( "onSelectedMainPaneLayer", group )

	return group
end; listen( "onCreateNewEmitter", mainPane.onCreateNewEmitter )


-- ==
--
-- == 
function mainPane.onCreateNewImageLayer( event )
	--table.dump(event,nil,"onCreateNewImageLayer")
	--table.dump(event.details,nil,"onCreateNewImageLayer")

	local obj 
	local details = event.details

	if( details.user ) then		
		obj = display.newImageRect( "images/" .. details.filename, system.DocumentsDirectory, details.w, details.h )
	else
		obj = newImageRect( nil, 0, 0, "images/imageLayer/" .. details.filename,
		                    { w = details.w, h = details.h } )
	end	

	obj.isType = "image"
	obj.recordID = details.id or details.name

	mainPane.insertAtLayerNum( obj, event.toLayer )
	leftPane.addObject( event.toLayer, obj, details, "image" )

	function obj.onSelectedMainPaneLayer( self, event )
		if( autoIgnore( "onSelectedMainPaneLayer", self ) ) then return end
		if(event.layerNum ~= self.layerNum) then return end
		print("******************************", self.layerNum, event.layerNum )
		--common.curEmitterRec 	= details
		common.curImageObject 	= self
		common.curSelectedObj 	= self
		print("onSelectedMainPaneLayer() ", "ImageLayer", common.curSelectedObj, common.curEmitterObj, common.curImageObject )
		post( "onSelectedObject", { isType = "image" } )

	end; listen( "onSelectedMainPaneLayer", obj )

	common.curImageObject 	= obj
	common.curSelectedObj 	= obj
	post( "onSelectedObject", { isType = "image" } )


	--obj.fill.blendMode = "add"
	return obj
end; listen( "onCreateNewImageLayer", mainPane.onCreateNewImageLayer )

return mainPane
