-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Roaming Gamer Button (Presets) Editor (a free SSK2 co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
--   Last Updated: 06 JAN 2017
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
local controls = {}

controls.mode = "buttonPreset"
function controls.setMode( newMode )
	controls.mode = newMode or "buttonPreset"
end

local common 	= require "scripts.common"
local layersMgr = require "scripts.layersMgr"
local skel 		= require "scripts.skel"
local pdFields 	= require "scripts.pdFields"

local blendCodeToName = {}
local blendNameToCode = {}

local function tchelper(first, rest)
  return first:upper()..rest
end

local function capFirst( str )
	str = str:gsub("(%a)([%w_']*)", tchelper)
	return str
end

-- ==================================================
--	Field Button (Generic) Builder
-- ==================================================
function controls.fieldButton( group, row, fattr )  

	if( fattr.type == "dropdown" ) then
		return controls.dropDownFieldButton( group, row, fattr )
	elseif( fattr.type == "color" ) then
		return controls.generalFieldButton( group, row, fattr )
	elseif( fattr.type == "color2" ) then
		return controls.generalFieldButton( group, row, fattr )
	elseif( fattr.type == "xy" ) then
		return controls.generalFieldButton( group, row, fattr )
	elseif( fattr.type == "text" ) then
		return controls.generalFieldButton( group, row, fattr )
	elseif( fattr.type == "texture" ) then
		return controls.generalFieldButton( group, row, fattr )
	elseif( fattr.type == "extract" ) then
		return controls.generalFieldButton( group, row, fattr )
	elseif( fattr.type == "incoming" ) then
		return controls.incomingImages( group, row, fattr )
	else
		return controls.sliderFieldButton( group, row, fattr )
	end
end

-- ==================================================
--	Drop Down Control Builder (and helper functions)
-- ==================================================

-- ==
--
-- ==
local function attr2value( attr, choices )
	for i = 1, #choices do
		if( choices[i][2] == attr ) then return choices[i][1] end
	end
	print("Warning: attr2value - default ")
	return choices[1][1]
end
-- ==
--
-- ==
local function value2attr( value, choices )
	for i = 1, #choices do
		if( choices[i][1] == value ) then return choices[i][2] end
	end
	print("Warning: value2attr - default ")
	return choices[1][2]
end
-- ==
--
-- ==
function controls.dropDownFieldButton( group, row, fattr )  --attrName, displayName, min, max, decimalPoints )
	group.buttons = group.buttons or {}

	local width = skel.rightPane.contentWidth - 8
	local height 	= 38
	local tween 	= 3
	local x = skel.rightPane.x  --- skel.rightPane.contentWidth/2
	local y = skel.currentEditOption.y + 40 + (row - 1) * (height + tween)

	local attrName 		= fattr.attrName
	local displayName 	= fattr.displayName
	local decimalPoints = tonumber(fattr.decimalPoints)

	local function touch( self, event )
		local phase = event.phase
		local id 	= event.id
		if( phase == "ended" ) then      
			post( "onClearSelection" )
			post( "onMakeSelection", { button = self, fattr = fattr } )
			common.sliderB.isVisible = false			
		end
		return true
	end

	-- Button		
	local button = newRect( group, x, y, { w = width, h = height, fill = common.fieldButtonColor, touch = touch, stroke = common.fieldButtonSelStrokeColor, strokeWidth = 0 } )
	group.buttons[#group.buttons+1] = button
	button.selected = false

	-- Attribute (display) label
	button.label1 = easyIFC:quickLabel( group, displayName, button.x - width/2 + 10, button.y, 
		                               common.fieldButtonFont, common.fieldButtonFontSize, common.fieldButtonFontColor, 0 )	

	-- Fake textField
	local fkw = 120
	local fkh = height - 12
	button.fakeTextField = newRect( group, x + width/2 - fkw/2 - 8, button.y, { w = fkw, h = fkh, stroke = _K_, strokeWidth = 1 } )
	button.label2 = easyIFC:quickLabel( group, displayName, button.fakeTextField.x, button.y, 
		                                common.fieldButtonTextFieldFont, 
		                                common.fieldButtonTextFieldFontSize, 
		                                common.fieldButtonTextFieldFontColor )
	
	button.label2.text = ""

	-- Update function for this button
	function button.update( self, value )
		-- Update label		
		self.label2.text = tostring(value2attr(value, fattr.choices))

		-- Update the field in current buttonPreset or image
		if( controls.mode == "buttonPreset" ) then
			common.currentRecord.definition[attrName] = value
		else
			common.curImageObject[attrName] = value
			--EDOCHI curImageObject
		end

	end
	local num

	-- Update the field in current buttonPreset or image
	if( controls.mode == "buttonPreset" ) then
		num = tonumber(common.currentRecord.definition[attrName]) or 0	
	else
		num = tonumber(common.curImageObject[attrName]) or 0	
		--EDOCHI curImageObject
	end

	
	button:update( num )


	function button.onClearSelection( self, event )
		if( autoIgnore( "onClearSelection", self ) ) then return end
		self.strokeWidth = 0
		self.label1:setFillColor( unpack( common.fieldButtonFontColor) )
		self.fakeTextField.isVisible = true
		self.label2.isVisible = true
		self.label2:setFillColor( unpack(common.fieldButtonTextFieldFontColor) )
		self.selected = false
		display.remove( self.dropDownGroup )
	end

	function button.onMakeSelection( self, event )
		if( autoIgnore( "onMakeSelection", self ) ) then return end
		if( event.button ~= self ) then return false end
		self.strokeWidth = 2
		self.label1:setFillColor( unpack( common.fieldButtonFontSelColor) )
		self.selected = true
		self.dropDownGroup = display.newGroup()
		self.parent:insert( self.dropDownGroup )
		self.label2:setFillColor( unpack(common.fieldButtonSelTextFieldFontColor) )

		local function backTouch(self,event)
			if( event.phase == "ended" ) then
				post("onClearSelection")
				return false
			end
			return false
		end		
		newImageRect( self.dropDownGroup, centerX, centerY, "images/fillT.png", { w = fullw, h = fullh, touch = backTouch } )

		local curButton = self
		local curValue = attr2value( self.label2.text, fattr.choices)
		local labelNames = {}

		for i = 1, #fattr.choices do
			local choice = fattr.choices[i]
			if(choice[1] ~= curValue ) then
				labelNames[#labelNames+1] = choice[2]
			end
		end

		local function onButtonTouch( self, event )			
			if( event.phase == "ended" ) then
				-- Update the field in current buttonPreset or image
				if( controls.mode == "buttonPreset" ) then
					common.currentRecord.definition[attrName] = attr2value( self.label.text, fattr.choices )
				else
					common.curImageObject[attrName] = attr2value( self.label.text, fattr.choices )
					--EDOCHI curImageObject
				end

				
				curButton.label2.text = self.label.text
				post( "onClearSelection" )	
				post("onRefresh")			
			end
			return true
		end

		local bw = self.fakeTextField.contentWidth - 2
		local bh = self.fakeTextField.contentHeight - 2
		local bx = self.fakeTextField.x
		local by = self.fakeTextField.y + self.fakeTextField.contentHeight - 1

		for i = 1, #labelNames do
			local tmp = newRect( self.dropDownGroup, bx, by, { w = bw, h = bh, stroke = _K_, strokeWidth = 1 } )
			tmp.label = easyIFC:quickLabel( self.dropDownGroup, labelNames[i], bx, by, 
				                            common.fieldButtonTextFieldFont,
				                            common.fieldButtonTextFieldFontSize,
				                            common.fieldButtonTextFieldFontColor )
			by = by + bh - 1
			tmp.touch = onButtonTouch
			tmp:addEventListener( "touch" )
		end


	end

	-- Automatically select if this is the first button in the pane
	-- EDOCHI OFF FOR NOW
	if( false and #group.buttons == 1 ) then
		nextFrame( function() button:touch( { phase = "ended" } ) end )
	end

	listen( "onClearSelection", button )
	listen( "onMakeSelection", button )

	return button

end


-- ==================================================
--	Numeric Control Builder
-- ==================================================

-- ==
--
-- ==
function controls.sliderFieldButton( group, row, fattr )  
	group.buttons = group.buttons or {}

	local width = skel.rightPane.contentWidth - 8
	local height 	= 38
	local tween 	= 3
	local x = skel.rightPane.x  --- skel.rightPane.contentWidth/2
	local y = skel.currentEditOption.y + 40 + (row - 1) * (height + tween)

	local attrName 		= fattr.attrName
	local displayName 	= fattr.displayName
	local min 			= tonumber(fattr.min)
	local max 			= tonumber(fattr.max)
	local decimalPoints = tonumber(fattr.decimalPoints)

	local function touch( self, event )
		local phase = event.phase
		local id 	= event.id
		if( phase == "ended" ) then      
			post( "onClearSelection" )
			post( "onMakeSelection", { button = self, fattr = fattr } )
			common.sliderB.isVisible = true

			self:update( tonumber(self.label2.text), true )
		end
		return true
	end

	-- Button		
	local button = newRect( group, x, y, { w = width, h = height, fill = common.fieldButtonColor, touch = touch, stroke = common.fieldButtonSelStrokeColor, strokeWidth = 0 } )
	group.buttons[#group.buttons+1] = button
	button.selected = false

	-- Attribute (display) label
	button.label1 = easyIFC:quickLabel( group, displayName, button.x - width/2 + 10, button.y, 
		                               common.fieldButtonFont, common.fieldButtonFontSize, common.fieldButtonFontColor, 0 )	

	-- Fake textField
	local fkw = 120
	local fkh = height - 12
	button.fakeTextField = newRect( group, x + width/2 - fkw/2 - 8, button.y, { w = fkw, h = fkh, stroke = _K_, strokeWidth = 1 } )
	button.label2 = easyIFC:quickLabel( group, displayName, button.fakeTextField.x - fkw/2 + 5, button.y, 
		                               common.fieldButtonTextFieldFont, common.fieldButtonTextFieldFontSize, 
		                               common.fieldButtonTextFieldFontColor, 0 )
	
	button.label2.text = ""

	-- Update function for this button
	function button.update( self, value, updateSlider )
		value = tonumber(value)
		value = round( value, decimalPoints )
		-- Keep values in range
		--print(value,min,max)
		value = (value < min) and min or value
		value = (value > max) and max or value

		-- Update label		
		self.label2.text = tostring(value)

		-- Update the field in current buttonPreset or image
		if( controls.mode == "buttonPreset" ) then
			common.currentRecord.definition[attrName] = value
		else
			common.curImageObject[attrName] = value
			--EDOCHI curImageObject
		end

		-- (Optionally update the slider)
		if( updateSlider ) then
			local range = math.abs(min-max)
			local tmp = math.abs(value)			
			if( min < 0 ) then
				tmp = tmp + math.abs(min)
			end
			local percent = tmp/range
			percent = (percent < 0) and 0 or percent
			percent = (percent > 1) and 1 or percent
			percent = percent * 100
			--print(attrName, percent, range, tmp, min, max )
			common.sliderB:setValue(percent)			
		end
	end
	local num 

	if( controls.mode == "buttonPreset" ) then
		num = tonumber(common.currentRecord.definition[attrName]) or 0	
	else
		num = tonumber(common.curImageObject[attrName]) or 0	
		--EDOCHI curImageObject
	end

	button:update( num )

	-- Listen for slider changes
	function button.onSliderTouch( self, event )
		if( autoIgnore("onSliderTouch", self) ) then return end

		if( not self.selected ) then return false end

		local range = math.abs(min-max)
		local value = range * event.value / 100 + min

		if( self.textField ) then 
			self.textField.text = tostring( round( value, decimalPoints ) )
		end
		self:update( value )
	end; listen( "onSliderTouch", button )

	-- Text field listener
	local function userInput( self, event ) 
		--print(self.text,event.phase)
		if( event.phase == "submitted" ) then
			post( "onClearSelection")
		elseif( self.text and event.phase == "editing" ) then
			button:update( tonumber(self.text) or min, true )
			post("onRefresh")
		end
	end


	function button.onClearSelection( self, event )
		if( autoIgnore( "onClearSelection", self ) ) then return end
		self.strokeWidth = 0
		self.label1:setFillColor( unpack( common.fieldButtonFontColor) )
		self.fakeTextField.isVisible = true
		self.label2.isVisible = true
		display.remove( self.textField )
		self.selected = false
	end

	function button.onMakeSelection( self, event )
		if( autoIgnore( "onMakeSelection", self ) ) then return end
		if( event.button ~= self ) then return false end
		self.strokeWidth = 2
		self.label1:setFillColor( unpack( common.fieldButtonFontSelColor) )
		self.fakeTextField.isVisible = false
		self.label2.isVisible = false
		self.textField = native.newTextField( self.fakeTextField.x, self.fakeTextField.y, self.fakeTextField.contentWidth, self.fakeTextField.contentHeight )
		

		if( controls.mode == "buttonPreset" ) then
			self.textField.text = tostring(common.currentRecord.definition[attrName] or 0)
		else
			self.textField.text = tostring(common.curImageObject[attrName] or 0)
			--EDOCHI curImageObject
		end


		self.textField.font = native.newFont( common.fieldButtonTextFieldFont )
		self.textField.size = common.fieldButtonTextFieldFontSize
		--self.textField.placeholder = placeholder
		--self.textField.isSecure = true
		self.parent:insert( self.textField ) 
		--self.textField:resizeFontToFitHeight()		

		self.textField.userInput = userInput
		self.textField:addEventListener( "userInput" )
		native.setKeyboardFocus(self.textField)
		self.textField:setSelection(999,999)
		self.selected = true
	end

	-- Automatically select if this is the first button in the pane
	-- EDOCHI OFF FOR NOW
	if( false and  #group.buttons == 1 ) then
		nextFrame( function() button:touch( { phase = "ended" } ) end )
	end

	function button.onRefresh( self )
	end
	listen( "onClearSelection", button )
	listen( "onMakeSelection", button )
	listen ("onRefresh", button )

	return button
end

-- ==================================================
--	Text Input Builder (w/ Rules)
-- ==================================================
local function fixColor( inTxt, fattr )
	if( string.len(inTxt) == 0 and fattr.default ) then 
		return fattr.default
	end
	local outTxt = inTxt
	outTxt = string.gsub( outTxt, " ", "" )

	local parts = string.split( outTxt, "," )	
	for i = 1, 4 do		
		if( i < 4 ) then
			parts[i] = tonumber(parts[i]) or 0 
			parts[i] = (parts[i] >= 0) and parts[i] or 0
			parts[i] = (parts[i] <= 1) and parts[i] or 1
		else
			parts[i] = tonumber(parts[i]) or 1 
			parts[i] = (parts[i] >= 0) and parts[i] or 1
			parts[i] = (parts[i] <= 1) and parts[i] or 1
		end
	end
	outTxt = string.format("%s,%s,%s,%s",parts[1],parts[2],parts[3],parts[4])
	return outTxt
end
local function fixColor2( inTxt, fattr )
	if( string.len(inTxt) == 0  ) then 
		return inTxt
	end
	local outTxt = inTxt
	outTxt = string.gsub( outTxt, " ", "" )

	local parts = string.split( outTxt, "," )	
	for i = 1, 4 do		
		if( i < 4 ) then
			parts[i] = tonumber(parts[i]) or 0 
			parts[i] = (parts[i] >= 0) and parts[i] or 0
			parts[i] = (parts[i] <= 1) and parts[i] or 1
		else
			parts[i] = tonumber(parts[i]) or 1 
			parts[i] = (parts[i] >= 0) and parts[i] or 1
			parts[i] = (parts[i] <= 1) and parts[i] or 1
		end
	end
	outTxt = string.format("%s,%s,%s,%s",parts[1],parts[2],parts[3],parts[4])
	return outTxt
end
local function fixXY( inTxt, fattr )
	if( string.len(inTxt) == 0  ) then 
		return inTxt
	end
	local outTxt = inTxt
	outTxt = string.gsub( outTxt, " ", "" )

	local parts = string.split( outTxt, "," )	
	for i = 1, 2 do		
		parts[i] = tonumber(parts[i]) or 0
	end
	outTxt = string.format("%s,%s",parts[1],parts[2])
	return outTxt
end

-- ==
--
-- ==
function controls.generalFieldButton( group, row, fattr ) 
	group.buttons = group.buttons or {}

	local width = skel.rightPane.contentWidth - 8
	local height 	= 38
	local tween 	= 3
	local x = skel.rightPane.x  --- skel.rightPane.contentWidth/2
	local y = skel.currentEditOption.y + 40 + (row - 1) * (height + tween)

	local attrName 		= fattr.attrName
	local displayName 	= fattr.displayName

	local function touch( self, event )
		local phase = event.phase
		local id 	= event.id
		if( phase == "ended" ) then      
			post( "onClearSelection" )
			if( fattr.type == "texture" ) then
				self.label2.text = ""				
				self.icon.fill = { type = "image", filename = "images/fillW.png" }				
				self.icon:setFillColor(unpack( _P_ ))
				common.currentRecord.definition[attrName] = ""
				post("onSave")
				post("onRefresh")
			else
				post( "onMakeSelection", { button = self, fattr = fattr } )
				common.sliderB.isVisible = false
				self:update( self.label2.text, true )
			end
		end
		return true
	end

	-- Button		
	local button = newRect( group, x, y, 
									{ w = width, h = height, fill = common.fieldButtonColor, 
									touch = touch, 
									stroke = common.fieldButtonSelStrokeColor, strokeWidth = 0 } )
	group.buttons[#group.buttons+1] = button
	button.selected = false

	if( fattr.type == "texture" ) then
		function button.onDropped( self, event )
			if( autoIgnore( "onDropped", self ) ) then return end
			--table.dump(event)
			if( isInBounds(event,self)) then
				button.label2.text = ssk.misc.shortenString2( event.obj.rec.folder .. "/" .. event.obj.rec.name, 15, "... "  )				
				button.icon.fill = { type = "image", filename = "incoming/" .. event.obj.rec.folder .. "/" .. event.obj.rec.name }
				button.icon:setFillColor(1,1,1)
				--button.icon.fill = { type = "image", filename = "images/fillT.png" }	
				common.currentRecord.definition[attrName] = event.obj.rec.folder .. "/" .. event.obj.rec.name
				common.currentRecord.definition.width = event.obj.rec.w
				common.currentRecord.definition.height = event.obj.rec.h
				post("onSave")
				post("onRefresh")
			end
		end
		listen("onDropped",button)
	end

	-- Attribute (display) label
	button.label1 = easyIFC:quickLabel( group, displayName, button.x - width/2 + 10, button.y, 
		                               common.fieldButtonFont, common.fieldButtonFontSize, common.fieldButtonFontColor, 0 )	

	-- Fake textField
	local fkw = 120
	local fkh = height - 12
	button.fakeTextField = newRect( group, x + width/2 - fkw/2 - 8, button.y, { w = fkw, h = fkh, stroke = _K_, strokeWidth = 1 } )
	button.label2 = easyIFC:quickLabel( group, displayName, button.fakeTextField.x - fkw/2 + 5, button.y, 
		                               common.fieldButtonTextFieldFont, common.fieldButtonTextFieldFontSize, 
		                               common.fieldButtonTextFieldFontColor, 0 )
	
	button.label2.text = ""

	if( fattr.type == "texture" ) then
		button.icon = newImageRect( group, 
											button.fakeTextField.x - button.fakeTextField.contentWidth/2 - 5,
											button.y, 
											"images/fillW.png",
											{ w = fkh, h = fkh, anchorX = 1, fill = _P_ } )

		if( common.currentRecord.definition[attrName] and common.currentRecord.definition[attrName] ~= "" ) then
				button.icon.fill = { type = "image", filename = "incoming/" .. common.currentRecord.definition[attrName] }
				button.icon:setFillColor(1,1,1)
		end
	end

	-- Update function for this button
	function button.update( self, value, updateSlider )

		-- EFM
		-- EFM Do parsing here to 'correct' data based on selected rules for this text field
		-- EFM
		if( fattr.type == "color" ) then
			value = fixColor(value, fattr)
		
		elseif( fattr.type == "color2" ) then
			value = fixColor2(value, fattr)
		
		elseif( fattr.type == "xy" ) then
			value = fixXY(value, fattr)			
		end

		-- Update label	
		if( fattr.type == "texture" )	then
			self.label2.text = ssk.misc.shortenString2( tostring(value), 15, "... "  )
		else
			self.label2.text = tostring(value)
		end

		-- Update the field in current buttonPreset or image
		if( controls.mode == "buttonPreset" ) then
			common.currentRecord.definition[attrName] = value
		end
	end
	local textVal
	if( controls.mode == "buttonPreset" ) then
		textVal = common.currentRecord.definition[attrName] or fattr.default or ""
	end

	button:update( textVal )

	-- Text field listener
	local function userInput( self, event ) 
		--print(self.text,event.phase)
		if( event.phase == "submitted" ) then
			post( "onClearSelection")
		elseif( self.text and event.phase == "editing" ) then
			button:update( self.text, true )
			post("onRefresh")
		end
	end

	function button.onClearSelection( self, event )
		if( autoIgnore( "onClearSelection", self ) ) then return end
		self.strokeWidth = 0
		self.label1:setFillColor( unpack( common.fieldButtonFontColor) )
		self.fakeTextField.isVisible = true
		self.label2.isVisible = true
		display.remove( self.textField )
		self.selected = false
	end

	function button.onMakeSelection( self, event )
		if( autoIgnore( "onMakeSelection", self ) ) then return end
		if( event.button ~= self ) then return false end
		self.strokeWidth = 2
		self.label1:setFillColor( unpack( common.fieldButtonFontSelColor) )
		self.fakeTextField.isVisible = false
		self.label2.isVisible = false
		self.textField = native.newTextField( self.fakeTextField.x, self.fakeTextField.y, self.fakeTextField.contentWidth, self.fakeTextField.contentHeight )
		

		if( controls.mode == "buttonPreset" ) then
			--table.dump(fattr)
			self.textField.text = tostring(common.currentRecord.definition[attrName] or fattr.default or "" )
		end

		self.textField.font = native.newFont( common.fieldButtonTextFieldFont )
		self.textField.size = common.fieldButtonTextFieldFontSize
		self.parent:insert( self.textField ) 
		self.textField.userInput = userInput
		self.textField:addEventListener( "userInput" )
		native.setKeyboardFocus(self.textField)
		self.textField:setSelection(999,999)
		self.selected = true
	end

	-- Automatically select if this is the first button in the pane
	-- EDOCHI OFF FOR NOW
	if( false and  #group.buttons == 1 ) then
		nextFrame( function() button:touch( { phase = "ended" } ) end )
	end

	function button.onRefresh( self )
	end
	listen( "onClearSelection", button )
	listen( "onMakeSelection", button )
	listen ("onRefresh", button )

	return button
end



-- ==
--
-- ==
local function compareIncoming(a,b)
   return tostring(a.name) < tostring(b.name)
end

local incomingImages = {}
local incomingImageFolders = {}
local currentImageSet = {}
local function getIncomingImages()

	incomingImages = {}
	incomingImageFolders = {}

	local path = ssk.files.resource.getPath( "incoming/")
	print(path)

	local files = ssk.files.util.findAllFiles( path, true )
	--table.print_r( files )

	for k,v in pairs( files ) do
		incomingImageFolders[#incomingImageFolders+1] = k
	end
	table.sort(incomingImageFolders)
	--table.dump(incomingImageFolders)

	for k,v in pairs( files ) do	
		files[k] = ssk.files.util.flattenNames( v, "/", "incoming/" .. k .."/" )
		files[k] = ssk.files.util.keepFileTypes( files[k], {"png", "jpg"} )
	end 
	--table.print_r(files)
	--files2 = 

	for k,v in pairs( files ) do
		local tmp = {}
		incomingImages[k] = tmp
		for l,m in pairs(v) do
			local parts = string.split(m,"/")
			local tmp2 = {}
			tmp2.name = parts[#parts]
			tmp2.folder = parts[#parts-1]

			local width,height = ssk.misc.getImageSize( m )
			tmp2.w = width
			tmp2.h = height
			
			tmp[#tmp+1] = tmp2

		end
		table.sort( tmp, compareIncoming )
	end
end

local lastPage
function controls.incomingImages( group, row, fattr ) 
	group.buttons = group.buttons or {}

	local setButton
	local buttonGroup
	local showCurrentImageSet

	local currentSet = 1
	getIncomingImages()

	local width = skel.rightPane.contentWidth - 8
	local height 	= 38
	local tween 	= 3
	local x = skel.rightPane.x  --- skel.rightPane.contentWidth/2
	local y = skel.currentEditOption.y + 40 + (row - 1) * (height + tween) - height/2

	local height2 = skel.rightPane.contentHeight - 	
						 y + skel.tbar.contentHeight


	local attrName 		= fattr.attrName
	local displayName 	= fattr.displayName

	local function touch( self, event )
		local phase = event.phase
		local id 	= event.id
		if( phase == "ended" ) then      
			post( "onClearSelection" )
			post( "onMakeSelection", { button = self, fattr = fattr } )
			common.sliderB.isVisible = false
			self:update( self.label2.text, true )
		end
		return true
	end

	-- Tray		
	local tray = newRect( group, x, y, 
		                  { w = width, h = height2, --h = fattr.h * (height + tween), 
		                    fill = common.fieldButtonColor, anchorY = 0,
		                    touch = function() return true end,
		                    stroke = common.fieldButtonSelStrokeColor, strokeWidth = 0 } )

	local tray2 = newRect( group, tray.x, tray.y + tray.contentHeight/2,
		                  { w = width - 8, h = height2 - 2 * height,
		                    fill = _W_,
		                    stroke = common.fieldButtonSelStrokeColor, strokeWidth = 1 } )

	local function onSelectSet( event )	
		currentSet = currentSet + 1
		if( currentSet > #incomingImageFolders) then
			currentSet =  1
		end
		if( #incomingImageFolders > 0 ) then
			event.target:setText( incomingImageFolders[currentSet] .. "/" )
			currentImageSet = incomingImages[incomingImageFolders[currentSet]]
			--table.print_r(currentImageSet)
		end
		showCurrentImageSet(1)
	end



	setButton = easyIFC:presetPush( group, "default", 
	                                  x, y + height/2, 
	                                  width - 20, height - 8, 
	                                  "No Images In Incoming?", onSelectSet )
	if( #incomingImageFolders > 0 ) then
		setButton:setText( incomingImageFolders[currentSet] .. "/" )
	end

	showCurrentImageSet = function()
		display.remove( buttonGroup )
		buttonGroup = display.newGroup()
		group:insert( buttonGroup)

		local curPage 	= lastPage or 1
		lastPage = curPage
		local pages 	= {}
		local pageLabel 

		local maxRows 			= 4
		local chipWidth 		= tray2.contentWidth/2 - 10
		local tweenY			= 36
		local chipHeight 		= tray2.contentHeight/maxRows - tweenY
		--chipHeight = (chipHeight > 50) and 50 or chipHeight

		local startX = tray2.x - tray2.contentWidth/4 
		local startY = tray2.y - tray2.contentHeight/2 + chipHeight - tweenY/2
		local curX = startX
		local curY = startY
		local col = 1
		local row = 1

		local pageGroup 
		pageGroup = display.newGroup()
		buttonGroup:insert( pageGroup )
		pages[#pages+1] = pageGroup
		pageGroup.isVisible = true

		for i = 1, #currentImageSet do
			local imgRec = currentImageSet[i]		
						
			--table.dump(imgRec)
			local bw = imgRec.w
			local bh = imgRec.h
			local scale = chipWidth/bw
			if( scale * bh > chipHeight ) then
				scale = chipHeight/bh
			end
			local chip = newImageRect( pageGroup, 
				           curX, curY,
							  "incoming/" .. imgRec.folder .. "/" .. imgRec.name,
							  { w = bw, h = bh, scale = scale  }  )
			easyIFC:quickLabel( pageGroup, imgRec.name, 
				                 chip.x, chip.y + chip.contentHeight/2 + 12,
				                 _G.normalFont, 14, _K_ )

			chip.rec = imgRec
			function chip.onDragged( self, event )
				self.alpha = 0.5
			end
			function chip.onDropped( self, event )
				self.alpha = 1
				self.x = self.x0
				self.y = self.y0
			end
			ssk.misc.addSmartDrag( chip )

			col = col + 1
			curX = tray2.x + tray2.contentWidth/4
			if( col > 2 ) then 
				row = row + 1
				col = 1 
				curY = curY + chipHeight + tweenY
				curX = startX
			end			
			if (row > maxRows) then
				pageGroup = display.newGroup()
				buttonGroup:insert( pageGroup )
				pages[#pages+1] = pageGroup
				pageGroup.isVisible = (#pages == 1) 
				col = 1
				row = 1
				curX = startX
				curY = startY
			end
		end

		local function onPrev( event )
			curPage = curPage - 1
			if( curPage < 1 ) then
				curPage = #pages
			end
			for i = 1, #pages do
				pages[i].isVisible = false
			end
			pages[curPage].isVisible = true
			pageLabel.text = "Page: " .. curPage .. "/" .. #pages
			lastPage = curPage
		end
		local function onNext( event )
			curPage = curPage + 1
			if( curPage > #pages ) then
				curPage = 1
			end
			for i = 1, #pages do
				pages[i].isVisible = false
			end
			pages[curPage].isVisible = true
			pageLabel.text = "Page: " .. curPage .. "/" .. #pages
			lastPage = curPage		
		end

		easyIFC:presetPush( buttonGroup, "default", 
                			tray2.x - tray2.contentWidth/2 + 25, 
                			tray2.y + tray2.contentHeight/2 + 18, 
								40, 28, "<<", onPrev, 
                        { labelFont = ssk.gameFont(), labelSize = 24, labelOffset = { 0, 2 } }  )

		easyIFC:presetPush( buttonGroup, "default", 
                			tray2.x + tray2.contentWidth/2 - 25, 
                			tray2.y + tray2.contentHeight/2 + 18, 
								40, 28, ">>", onNext, 
                        { labelFont = ssk.gameFont(), labelSize = 24, labelOffset = { 0, 2 } }  )

		pageLabel = easyIFC:quickLabel( buttonGroup, "Page: " .. curPage .. "/" .. #pages, 
												  tray2.x, tray2.y + tray2.contentHeight/2 + 18, 
												  _G.normalFont, 18, _W_ )

	end

	-- hack - EFM :(
	for i = 1, #incomingImageFolders do
		setButton:toggle()
	end

	return button
end

return controls