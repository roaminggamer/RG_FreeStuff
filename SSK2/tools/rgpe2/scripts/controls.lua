-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Roaming Gamer Particle Editor 2 (a free SSK2 co-product)
-- =============================================================
-- See README.md for full license details.
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

controls.mode = "emitter"
function controls.setMode( newMode )
	controls.mode = newMode or "emitter"
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
			--post( "onRefresh" )
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

		-- Update the field in current emitter or image
		if( controls.mode == "emitter" ) then
			common.curEmitterRec.definition[attrName] = value
		else
			common.curImageObject[attrName] = value
			--EDOCHI curImageObject
		end

	end
	local num

	-- Update the field in current emitter or image
	if( controls.mode == "emitter" ) then
		num = tonumber(common.curEmitterRec.definition[attrName]) or 0	
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
				-- Update the field in current emitter or image
				if( controls.mode == "emitter" ) then
					common.curEmitterRec.definition[attrName] = attr2value( self.label.text, fattr.choices )
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
function controls.sliderFieldButton( group, row, fattr )  --attrName, displayName, min, max, decimalPoints )
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
			--post( "onRefresh" )			

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

		-- Update the field in current emitter or image
		if( controls.mode == "emitter" ) then
			common.curEmitterRec.definition[attrName] = value
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

	if( controls.mode == "emitter" ) then
		num = tonumber(common.curEmitterRec.definition[attrName]) or 0	
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
		if( self.text and event.phase == "editing" ) then
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
		

		if( controls.mode == "emitter" ) then
			self.textField.text = tostring(common.curEmitterRec.definition[attrName] or 0)
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
		--[[
		if( autoIgnore( "onRefresh", self ) ) then return end
		local curValue
		if( controls.mode == "emitter" ) then
			local curValue = common.curEmitterRec.definition[attrName]
		else
			local curValue = common.curImageObject[attrName]
			--EDOCHI curImageObject
		end

		label2.text = curValue

		if( attrName == "emitterType" ) then		
			if( curValue == 0 ) then
				label2.text = "Gravity"
			else
				label2.text = "Radial"
			end
		elseif( attrName == "blendFuncSource" ) then
			label2.text = blendCodeToName[tonumber(curValue)]

		elseif( attrName == "blendFuncDestination" ) then
			label2.text = blendCodeToName[tonumber(curValue)]
		end
		--]]
	end
	listen( "onClearSelection", button )
	listen( "onMakeSelection", button )
	listen ("onRefresh", button )

	return button
end


return controls