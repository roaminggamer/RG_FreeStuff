-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Roaming Gamer Particle Editor 2 (a free SSK2 co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
local leftPane = {}

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
local isInBoundsAlt = ssk.easyIFC.isInBoundsAlt
local normRot = ssk.misc.normRot;local easyAlert = ssk.misc.easyAlert
local tpd = timer.performWithDelay
-- =============================================================
-- =============================================================
local common 			= require "scripts.common"
local layersMgr 		= require "scripts.layersMgr"
local skel 				= require "scripts.skel"
local imageSelector 	= require "scripts.imageSelector"
local emitterSelector 	= require "scripts.emitterSelector"

local objectButtons = {}

function leftPane.getObjectButtons()
	return objectButtons
end

-- ==
--    onNewEmitter() - User has decided to create a new emitter.
--
--    This clones the default emitter into the emitter library.
--   
-- ==
local function onNewEmitter( toLayer )
	print("Create New Emitter in layer: ", toLayer )
	
	local tmp = table.deepCopy( common.defaultNewEmitter )
	tmp.id = math.getUID(15)
	common.emitterLibrary[#common.emitterLibrary+1] = tmp
	
	post("onCreateNewEmitter", { details = tmp, toLayer = toLayer } )
	
	table.save( common.emitterLibrary, "emitterLib.rg" )
end

-- ==
--    onLoadEmitter() - Run the emitter select so the user can select an emitter
--    to insert into the curent project.
-- ==
local function onLoadEmitter( toLayer )
	print("Load Existing Emitter definition in layer: ", toLayer )
	emitterSelector.run( toLayer )
end

-- ==
--
-- ==
local function onNewImageLayer( toLayer )
	print("Create New Image Layer in layer: ", toLayer )
	imageSelector.run( toLayer )
end

-- ==
--
-- ==
----[[ original
local function onNewObject( event )
	local target = event.target
	local toLayer = event.target.layerNum
	easyAlert( "Create Object", "Choose object type to create:",
	           {
	           	{ "Cancel", nil },
	           	{ "Image Layer", 	function() onNewImageLayer(toLayer) end },
	           	{ "Load Emitter", 	function() onLoadEmitter(toLayer) end }, 
	           	{ "New Emitter", 	function() onNewEmitter(toLayer) end },
	           } )
end
--]]
--[[
local function onNewObject( event )
	local target = event.target
	local toLayer = event.target.layerNum
	local addNew = require "scripts.addNew"
	addNew.doDialog( toLayer )
end
--]]


-- ==
--
-- ==
function leftPane.init()	
	local layers = layersMgr.get()
	layers:purge("lpane")

	local bw 	= skel.lpo[1].contentWidth
	local bh 	= skel.lpo[1].contentHeight

	objectButtons = {}

	objectButtons[1] = easyIFC:presetPush( layers.lpane, "default", 
		                                   skel.lpo[1].x, skel.lpo[1].y, 
		                                   bw-4, bh-4, "+", onNewObject, 
		                                   { labelFont = native.systemFont, labelSize = 28, labelOffset = { 0, 2 } } )
	objectButtons[1].layerNum = 1	
	objectButtons[1].isAddButton = true

	--nextFrame( function() objectButtons[1]:toggle() end, 500 ) -- EDOCHI
end

-- ==
--
-- ==
local function handleDrop( obj )
	local buttons = {}
	for i = 1, #objectButtons do
		if( objectButtons[i].isObjectButton and objectButtons[i] ~= obj ) then
			buttons[#buttons+1] = objectButtons[i]
		end
	end

	if( #buttons == 0 ) then
		obj.y = obj.y0
		table.insert( objectButtons, obj.layerNum, obj  )
		return
	end

	local above
	local below
	for i = 1, #buttons do
		if( obj.y < buttons[i].y ) then
			above = buttons[i]

		elseif( obj.y > buttons[i].y ) then
			below = buttons[i]
		end
	end

	if( above and below == nil ) then
		table.insert( objectButtons, above.layerNum, obj  )
	elseif( below and above == nil ) then
		table.insert( objectButtons, below.layerNum+1, obj  )
	elseif( above and below ) then
		table.insert( objectButtons, below.layerNum+1, obj  )
	else
		obj.y = obj.y0
		table.insert( objectButtons, obj.layerNum, obj  )
		return
	end

	for i = 1, #objectButtons do
		if( skel.lpo[i] ) then
			objectButtons[i].layerNum = i 
			objectButtons[i].y = skel.lpo[i].y
		end
	end

	local mainPane = require "scripts.mainPane"
	for i = 1, #objectButtons do
		if(  objectButtons[i].isObjectButton ) then
			mainPane.insertAtLayerNum( objectButtons[i].myObj, objectButtons[i].layerNum )			
		end
	end

end

-- ==
--
-- ==
local function onTouchEye( self, event )
	if( event.phase == "ended" ) then
		self.button.myObj.isVisible = not self.button.myObj.isVisible
		if( self.button.myObj.isVisible ) then
			self:setFillColor(unpack(_G_))
		else
			self:setFillColor(unpack(_R_))
		end
	end
	return true
end


local function onGenerate( bar )

	local dialogs 	= ssk.dialogs
	local record = bar.record

	local generateEmitter
	local generateProject

	local function onClose( self, onComplete )
		transition.to( self, { y = centerY + fullh, transition = easing.inBack, onComplete = onComplete } )
	end

	local width = 600
	local height = 400
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
	local title = easyIFC:quickLabel( group, "Generate", 0, -height/2 + 15, _G.boldFont, 28, _K_ )
	title.anchorY = 0

	local currentSelection

	local function onCancel( event )
		onClose( dialog, function() dialog.frame:close() end )
	end

	local function onProject( event )
		generateProject()
	end

	local function onEmitter( event )
		generateEmitter()
	end

	local bw 		= 160
	local bh 		= 40
	local tween 	= 10
	local curY 		= height/2 - bh/2 - tween

	local textBack = newRect( group, 0, 0, { w = width - 20, height = 40, fill = _LIGHTGREY_ } )
	textField = native.newTextField( 0, 0, width - 20, 40 )
	group:insert( textField )
	textField.text = bar.record.name
	native.setKeyboardFocus( textField )

	
	easyIFC:presetPush( group, "default", -bw - tween, curY, bw, bh, "Cancel", onCancel )
	easyIFC:presetPush( group, "default", 0, curY, bw, bh, "Emitter", onEmitter )
	easyIFC:presetPush( group, "default", bw + tween, curY, bw, bh, "Project", onProject )

	easyIFC.easyFlyIn( dialog, { delay = 250, time = 500, sox = 0, soy = fullh } )


	generateEmitter = function( onComplete )
		local RGFiles = ssk.files
		local saveFolder = RGFiles.desktop.getDesktopPath( "RGPE2_out/" .. tostring(textField.text) )

		local function doGenerate( name )
			print("Generating emitter", tostring(textField.text) )

			RGFiles.util.mkFolder( saveFolder )
			local definition = table.deepCopy( record.definition )
			local srcParticle = RGFiles.resource.getPath( definition.textureFileName )
			local dstParticle = srcParticle
			dstParticle = RGFiles.util.repairPath( dstParticle, true )
			dstParticle = string.split( dstParticle, "/" )		
			dstParticle = dstParticle[#dstParticle]				
			definition.textureFileName = dstParticle

			-- Save particle definition to 
			local path = string.format( "%s/%s.rg", saveFolder, io.cleanFileName(record.name) )
			RGFiles.util.saveTable( definition, path )

			--table.dump(record.definition)
			
			RGFiles.util.cpFile( srcParticle, saveFolder .. "/" .. dstParticle )	
			print("BOGIES", name, onComplete )		
			if( onComplete ) then onComplete( name, saveFolder ) end
			onClose( dialog, function() dialog.frame:close() end )
		end

		if(RGFiles.util.exists( saveFolder ) ) then
			easyAlert( "Overwrite Folder: " .. tostring(textField.text),
			 				"Folder '" .. saveFolder .. "' already exists!  Overwrite it?",
			 				{
			 					{ "Yes", function() doGenerate( textField.text ) end },
			 					{ "No", nil }
			 				} )
		else 
			doGenerate( textField.text )			
			onClose( dialog, function() dialog.frame:close() end )
		end

	end
	
	generateProject = function()
		local RGFiles = ssk.files
		print("GENERATE PROJECT>>>>")
		local function doGenerate( emitterName, saveFolder )
			emitterName = string.clean(emitterName)
			emitterName = string.gsub(emitterName, " ", "")

			print("Generating project for ", emitterName, saveFolder )

			-- Generate config.lua
			local path = string.format( "%s/config.lua", saveFolder )
			local config_lua = 
				"-- =============================================================\n" ..
				"-- Example Generated by Roaming Gamer Particle Editor 2\n" ..
				"-- https://roaminggamer.github.io/RGDocs/pages/RGPE2/\n" ..
				"-- =============================================================\n" ..
				"application = {\n" ..
				"	content = {\n" ..
				"\n" ..
				"		width 	= 640, \n" ..
				"		height 	= 960,\n" ..
				'		scale 	= "letterbox",\n' ..
				"		fps 	= 60,\n" ..
				"	},\n" ..
				"}"
			RGFiles.util.writeFile( config_lua, path )

			-- Generate build.settings
			local path = string.format( "%s/builds.settings", saveFolder )
			local build_settings = 
				"-- =============================================================\n" ..
				"-- Example Generated by Roaming Gamer Particle Editor 2\n" ..
				"-- https://roaminggamer.github.io/RGDocs/pages/RGPE2/\n" ..
				"-- =============================================================\n" ..
				'settings = {\n' .. 
				'   orientation = {\n' .. 
				'      default = "landscapeLeft",\n' .. 
				'      supported = { "landscapeRight", "landscapeLeft" },\n' .. 
				'   },\n' .. 
				'}\n' 
			RGFiles.util.writeFile( build_settings, path )


			-- Generate main.lua
			local path = string.format( "%s/main.lua", saveFolder )
			local main_lua = 
			"-- =============================================================\n" ..
			"-- Example Generated by Roaming Gamer Particle Editor 2\n" ..
			"-- https://roaminggamer.github.io/RGDocs/pages/RGPE2/\n" ..
			"-- =============================================================\n\n" ..
			'-- =============================================================\n' ..
			'-- LOAD & INITIALIZE - SSK 2\n' ..
			'-- =============================================================\n' ..
			'require "ssk2.loadSSK"\n' ..
			'_G.ssk.init( { \n' ..
			'					enableAutoListeners 	= true,\n' ..
			'	            exportCore 				= true,\n' ..
			'	            exportColors 			= true,\n' ..
			'	            exportSystem 			= true,\n' ..
			'	            debugLevel 				= 0 } )\n' ..
			'-- =============================================================\n' .. 
			'local emitter = ssk.pex.loadRG( nil, centerX, centerY, "' .. emitterName ..'.rg" )'

			RGFiles.util.writeFile( main_lua, path )

		end
		generateEmitter( doGenerate )
	end


end



-- ==
--
-- ==
local function onTouchGenerateButton( self, event )
	local phase = event.phase
	local id = event.id 
	if( phase == "began" ) then
		self:setFillColor(unpack(_G_))
		display.getCurrentStage():setFocus( self, id )
		self.isFocus = true
	elseif( self.isFocus == true ) then
		if( isInBounds( event, self ) ) then
			self:setFillColor(unpack(_G_))
		else
			self:setFillColor(unpack(_W_))
		end
		if( phase == "ended" ) then
			display.getCurrentStage():setFocus( self, nil )
			self.isFocus = false
			self:setFillColor(unpack(_W_))
			onGenerate( self.bar )
		end
	end	
	return true
end

local function onRenameEmitter( bar )
	local dialogs 	= ssk.dialogs
	local record = bar.record

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
	local title = easyIFC:quickLabel( group, "Rename Emitter", 0, -height/2 + 15, _G.boldFont, 28, _K_ )
	title.anchorY = 0

	local currentSelection

	local function onCancel( event )
		onClose( dialog, function() dialog.frame:close() end )
	end

	local function onOK( event )
		native.setKeyboardFocus( nil )
		if( string.len(textField.text) > 0 ) then
			bar.record.name = textField.text
			bar.label.text = textField.text
			table.save( common.emitterLibrary, "emitterLib.rg" )
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
	textField.text = bar.record.name
	native.setKeyboardFocus( textField )

	
	easyIFC:presetPush( group, "default", -bw/2 - tween/2, curY, bw, bh, "Cancel", onCancel )
	easyIFC:presetPush( group, "default", bw/2 + tween/2, curY, bw, bh, "OK", onOK )

	easyIFC.easyFlyIn( dialog, { delay = 250, time = 500, sox = 0, soy = fullh } )
end


-- ==
--
-- ==
local function layerButtonTouch( self, event )
	local phase = event.phase
	local id 	= event.id
	if( event.phase == "began" ) then
		self:toFront()
		self.label:toFront()
		self.eye:toFront()
		self.generateB:toFront()
		self.y0 = self.y
		table.remove( objectButtons, table.indexOf( objectButtons, self ) )
		for i = 1, #objectButtons do
			if( skel.lpo[i] ) then
				objectButtons[i].layerNum = i 
				objectButtons[i].strokeWidth = 0
			end
		end
		self:setFillColor(unpack(common.selectedChipColor))

		display.getCurrentStage():setFocus( self, id )
		self.isFocus = true
	elseif( self.isFocus == true ) then
		self.y = event.y		
		if( phase == "ended" ) then
			local curTime = getTimer()
			if( self.lastClick ) then
				local dt = curTime - self.lastClick
				if( dt < 300 ) then
					onRenameEmitter( self )
				end
			end
			self.lastClick = curTime
			
			display.getCurrentStage():setFocus( self, nil )
			self.isFocus = false
			self:setFillColor(unpack(common.barColor))
			handleDrop( self )
			self.strokeWidth = 2
			self:setStrokeColor( unpack(common.selectedChipColor) )
			print("Selected layer type: ", self.isType)
			post("onSelectedMainPaneLayer", { layerNum = self.layerNum, isType = self.isType })
		end
	end	
	return true
end

-- ==
--
-- ==
function leftPane.addObject( layerNum, obj, record, isType )
	--print("addObject", layerNum, isType, #objectButtons, getTimer())
	local layers = layersMgr.get()

	local bw 	= skel.lpo[1].contentWidth
	local bh 	= skel.lpo[1].contentHeight

	local index = #objectButtons
	local x,y 	= skel.lpo[index].x, skel.lpo[index].y

	local addButton = objectButtons[#objectButtons] 

	if( #objectButtons < 20 ) then
		addButton.layerNum = #objectButtons + 1
	else
		addButton:disable()
		addButton.isVisible = false
	end
	
	local rect = newRect( layers.lpane, x, y, { w = bw-4, h = bh-4, fill = common.barColor, touch = layerButtonTouch })

	rect.label = easyIFC:quickLabel( layers.lpane, record.name or "unknown", rect.x - bw/2 + 10, rect.y, "Lato-Regular.ttf", 12, _W_, 0 )
	rect.eye   = newImageRect( layers.lpane, rect.x + bw/2 - 1.5 * bh, rect.y, "images/eye4.png",
	                        { w = 24, h = 24, scale = 1, touch = onTouchEye, fill = _G_ } )

	rect.generateB   = newImageRect( layers.lpane, rect.x + bw/2 - 0.5 * bh, rect.y, "images/generate.png",
	                        { w = 16, h = 16, scale = 1, touch = onTouchGenerateButton, fill = _W_ } )
	rect.generateB.bar = rect
	rect.ly = rect.y

	rect.isObjectButton = true
	rect.layerNum = index
	rect.myObj = obj
	rect.eye.button = rect
	rect.generateB.button = rect
	rect.isType = isType
	rect.record = record
	if( isType == "image" ) then
		rect.generateB.isVisible = false
	end

	function rect.enterFrame( self, event )
		if( autoIgnore( "enterFrame", self ) ) then return end
		if( self.ly == self.y ) then return end
		local dy = self.y - self.ly
		self.ly = self.y
		self.label.y = self.label.y + dy
		self.eye.y = self.eye.y + dy
		self.generateB.y = self.generateB.y + dy

	end; listen("enterFrame", rect)

	table.insert( objectButtons, index, rect  )

	for i = 1, #objectButtons do
		if( skel.lpo[i] ) then
			objectButtons[i].strokeWidth = 0
		end
	end	
	rect.strokeWidth = 2
	rect:setStrokeColor( unpack(common.selectedChipColor) )

	function rect.onRefreshLeftPane( self, event )
		if( autoIgnore( "onRefreshLeftPane", self ) ) then return false end		
		--print("*************", isType)
		--print("*************", event.layerNum)
		if( self.layerNum ~= event.layerNum ) then
			self.strokeWidth = 0
		else
			self.strokeWidth = 2
			self:setStrokeColor( unpack(common.selectedChipColor) )
		end		
	end; listen( "onRefreshLeftPane", rect)


	if( addButton.isVisible ) then
		addButton.y = skel.lpo[index+1].y
		addButton:resetStartPosition()
	end

end

return leftPane
