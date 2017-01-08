-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Eds Awesome Tool (a free SSK2 PRO co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
--   Last Updated: 06 JAN 2017
-- =============================================================
-- ==
--    Localizations
-- ==
-- Corona & Lua
--
local mAbs = math.abs;local mRand = math.random;local mDeg = math.deg;
local mRad = math.rad;local mCos = math.cos;local mSin = math.sin;
local mAcos = math.acos;local mAsin = math.asin;local mSqrt = math.sqrt;
local mCeil = math.ceil;local mFloor = math.floor;local mAtan2 = math.atan2;
local mPi = math.pi
local pairs = pairs;local getInfo = system.getInfo;local getTimer = system.getTimer
local strFind = string.find;local strFormat = string.format;local strFormat = string.format
local strGSub = string.gsub;local strMatch = string.match;local strSub = string.sub
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
--
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale
-- Forward Declarations
local RGFiles = ssk.files
-- =============================================================
-- =============================================================
-- =============================================================
local settings = require "scripts.settings"
local vscroller = require "scripts.vscroller"

local util = {}

-- ==
--		Check to see if a monetizer library is in use
-- ==
function util.getPluginConfigsByName( name  )
	local plugins = require "settings.plugins"
	local plugins_settings = plugins.get()
	local config = {}
	for i = 1, #plugins_settings do
		local choices = plugins_settings[i].choices
		for j = 1, #choices do
			if(choices[j].name == name) then
				return choices[j].config
			end
		end
	end
	return config
end


-- ==
--		Check to see if a monetizer library is in use
-- ==
function util.usingMonetizers( currentProject  )
	local plugins = require "settings.plugins"
	local monetizers = plugins.get()[1].choices
	local curSettings
	local curPlugins
	if( not currentProject ) then 
		curSettings = {}
		curPlugins = {}
	else
		--table.dump(curSettings,nil,"curSettings")
		curSettings = currentProject.settings
		curPlugins = currentProject.plugins
	end
	for i = 1, #monetizers do
		if( curPlugins[monetizers[i].id] ) then
			return true
		end
	end
	return false
end


-- ==
--		Check to see if an analytic library is in use
-- ==
function util.usingAnalytics( currentProject  )
	local plugins = require "settings.plugins"
	local analytics = plugins.get()[2].choices
	local curSettings
	local curPlugins
	if( not currentProject ) then 
		curSettings = {}
		curPlugins = {}
	else
		--table.dump(curSettings,nil,"curSettings")
		curSettings = currentProject.settings
		curPlugins = currentProject.plugins
	end
	for i = 1, #analytics do
		if( curPlugins[analytics[i].id] ) then
			return true
		end
	end
	return false
end


-- ==
--		Check to see if an attribution library is in use
-- ==
function util.usingAttribution( currentProject  )
	local plugins = require "settings.plugins"
	local attributions = plugins.get()[3].choices
	local curSettings
	local curPlugins
	if( not currentProject ) then 
		curSettings = {}
		curPlugins = {}
	else
		--table.dump(curSettings,nil,"curSettings")
		curSettings = currentProject.settings
		curPlugins = currentProject.plugins
	end
	for i = 1, #attributions do
		if( curPlugins[attributions[i].id] ) then
			return true
		end
	end
	return false
end


-- ==
--		Check to see if an iap library is in use
-- ==
function util.usingIAP( currentProject  )
	local plugins = require "settings.plugins"
	local iaps = plugins.get()[5].choices
	local curSettings
	local curPlugins
	if( not currentProject ) then 
		curSettings = {}
		curPlugins = {}
	else
		--table.dump(curSettings,nil,"curSettings")
		curSettings = currentProject.settings
		curPlugins = currentProject.plugins
	end
	for i = 1, #iaps do
		if( curPlugins[iaps[i].id] ) then
			return true
		end
	end
	return false
end


-- ==
--		Check to see if an social library is in use
-- ==
function util.usingSocial( currentProject  )
	local plugins = require "settings.plugins"
	local socials = plugins.get()[6].choices
	local curSettings
	local curPlugins
	if( not currentProject ) then 
		curSettings = {}
		curPlugins = {}
	else
		--table.dump(curSettings,nil,"curSettings")
		curSettings = currentProject.settings
		curPlugins = currentProject.plugins
	end
	for i = 1, #socials do
		if( curPlugins[socials[i].id] ) then
			return true
		end
	end
	return false
end


-- ==
--		Check to see if an utils library is in use (only returns true if library requires configuration)
-- ==
function util.usingUtils( currentProject  )
	local curSettings
	local curPlugins
	if( not currentProject ) then 
		curSettings = {}
		curPlugins = {}
	else
		--table.dump(curSettings,nil,"curSettings")
		curSettings = currentProject.settings
		curPlugins = currentProject.plugins
	end
	if( curPlugins.hockeyapp_plugin or
	    --curPlugins.util_icloud_plugin or  -- doesn't require special init that I can do for the user
	    curPlugins.util_steamworks_plugin or
	    curPlugins.util_googledrive_plugin or	    
	    curPlugins.util_vk_plugin ) then
		return true
	end

	return false
end



-- ==
--
-- ==

-- Popup Menu Drawing Utility
--
function util.drawPopupMenu( editPane, x, y, params )
	--print( editPane, x, y, params, isValid( editPane ) )
	--table.print_r(params)
	display.remove( editPane.popupMenu )
	local popupMenu = display.newGroup()
	editPane:insert(popupMenu)

	local tray
	local labels = {}
	local buttons = {}

	-- Button Mouse Event Listener
	local function onMouse( self, event )
		if ( autoIgnore( "mouse", self ) ) then return end
		if ( isInBounds( event, self ) ) then
			self:setFillColor(unpack(settings.editPaneMenuButtonHoverFill))
			if(event.type == "up") then
				if( self.params.eventName ) then
					post( self.params.eventName, { editPane = editPane, x =  tray.x, y = tray.y } )
				end
				if( self.params.action ) then
					self.params.action( editPane, tray.x,  tray.y )
				end
				display.remove( editPane.popupMenu )
			end
		else
			self:setFillColor(unpack(_T_))
			if( event.isPrimaryButtonDown ) then
				if( not isInBounds( event, tray ) ) then
					display.remove( editPane.popupMenu )
				end
			end
		end
		return false
	end

	-- Create the labels
	for i = 1, #params do
		labels[i] = easyIFC:quickLabel( popupMenu, params[i].text, x, y, settings.editPaneMenuFont, settings.editPaneMenuFontSize, settings.editPaneMenuFontColor, 0 )
	end

	local maxWidth = 0
 	for i = 1, #params do 
 		local curWidth = labels[i].contentWidth + 2 * settings.editPaneMenuLabelIndent
 		maxWidth = (maxWidth > curWidth) and maxWidth or curWidth
 	end

	-- Create the proportionally sized buttons	
	for i = 1, #params do
		buttons[i] = newImageRect( popupMenu, x, y, "images/fillW.png",
			                            { w = maxWidth, h = settings.editPaneMenuButtonH - 2, 
			                              alpha = 0.15, fill = _T_ } )

		buttons[i].params = params[i]
	end

	-- Create a child tray
	local curX = x
	local curY = y

	local totalHeight = 0
	for i = 1, #params do
		totalHeight = totalHeight + buttons[i].contentHeight + 2
	end
	tray = newImageRect( popupMenu, curX, curY, "images/fillW.png", 
		                         { w = maxWidth + settings.editPaneMenuTrayBuffer, 
		                           h = totalHeight + settings.editPaneMenuTrayBuffer, 
		                           anchorX = 0, anchorY = 0, fill = settings.editPaneMenuTrayFill,
		                           touch = function() return true end } )

	-- Position elements and attach listeners
	curX = tray.x + tray.contentWidth/2
	curY = tray.y + settings.editPaneMenuTrayBuffer/2 + settings.editPaneMenuButtonH/ 2
	for i = 1, #params do
		buttons[i].x = curX
		buttons[i].y = curY
		buttons[i]:toFront()
		labels[i]:toFront()
		labels[i].x = buttons[i].x - maxWidth/2 + settings.editPaneMenuLabelIndent
		labels[i].y = buttons[i].y + 1
		curY = curY + settings.editPaneMenuButtonH

		buttons[i].mouse = onMouse
		listen( "mouse", buttons[i] )
	end

	editPane.popupMenu = popupMenu

	return popupMenu
end


-- Dropdown Menu Drawing Utility
--
function util.drawDropdownMenu( group, x, y, width, height, params ) 
	-- Extract all parameters and assign defaults if not provided
	--
	params = params or {}
	local allowToggling		= fnn(params.allowToggling, true )
	local hideCurrentChoice	= fnn(params.hideCurrentChoice, true )
	local sortChoices		= fnn(params.sortChoices, false )
	local maxEntries 		= params.maxEntries or 4.5
	local allowHalfEntry	= fnn( params.allowHalfEntry, false )
	local curChoice			= params.curChoice or "none"
	local choicesIn 		= params.choicesIn or { "default1", "default2", "default3", "default4" }
	local onChoice 			= params.onChoice
	local throwEvent 		= params.throwEvent

	local settingsTbl 		= params.settingsTbl
	local fieldName 		= params.fieldName
	local label 			= params.label

	local buttonStroke 		= params.buttonStroke or _K_
	local buttonFont 		= params.buttonFont or settings.defaultFont
	local buttonFontSize	= params.buttonFontSize or settings.defaultFontSize
	local buttonFontColor	= params.buttonFontColor or settings.defaultFontColor	
	local buttonSelColor 	= params.buttonSelColor or hexcolor("#00aeef")--hexcolor("#00703c")
	local buttonUnselColor 	= params.buttonUnselColor or hexcolor("#00703c") --hexcolor("#00aeef")
	local scrollerBackColor = params.scrollerBackColor or {0.5*0.2, 0.5*0.2, 0.5*0.2, 1}


	-- If we have a 'settings table' assigned to this button, try to 
	-- extract the reall 'current selection'.
	--
	if( settingsTbl and fieldName and settingsTbl[fieldName] ) then		
		curChoice = settingsTbl[fieldName]
	end

	-- Draw  a 'button' whose job it is to display the current selection and 
	-- optionally toggle or create a drop-down menu when pressed.
	--
	local button = newRect( group, x, y, 
		                   { w = width, h = height, anchorX = 0,
							 fill = buttonUnselColor, stroke = buttonStroke } )
	button.label = easyIFC:quickLabel( group, curChoice, 
		                              button.x + button.contentWidth/2, y,
                                      buttonFont, 
                                      buttonFontSize, 
                                      buttonFontColor ) 
	util.addShadow2( button )
	button.x0 = button.x
	button.y0 = button.y
	button.label.x0 = button.label.x
	button.label.y0 = button.label.y

	-- Attach help to label if label is supplied and help is available for this fieldName
	local defaultSettings = require 'scripts.defaultSettings'
	local helpRecord = defaultSettings.getHelp( fieldName )
	if( label and helpRecord ) then
		function label.touch( self, event )
			if( event.phase == "ended" ) then
				--print("help me with", fieldName )
				util.infoPopup( helpRecord, label.text )
			end
		end; label:addEventListener( "touch" )
	end

	-- 'touch' listener that toggles or creates a drop-down menu
	--
	function button.createDropdown( self )

		-- Get the current list of choices.  This can either be a
		-- table or a function that returns a table.
		--
		local choices = {}
		if( type( choicesIn ) == "function" ) then
			choices = choicesIn( curChoice )
		else
			for i = 1, #choicesIn do
				choices[#choices+1] = choicesIn[i]
			end
		end

		-- Remove current choice from choice list if feature enabled AND
		-- If we are not dealing with a toggle case.
		local removedEntry = false
		if( allowToggling and #choices == 2) then
		elseif( hideCurrentChoice ) then
			local index 
			for i = 1, #choices do
				index = ( choices[i] == button.label.text ) and i or index
			end
			if( index ) then
				table.remove( choices, index )
				removedEntry = true
			end
		end

		-- Optionally sort the choices alphabetically
		--
		if ( sortChoices ) then
			table.sort( choices )
		end

		-- Is toggling enabled and are there only two entries?
		-- If so, just toggle between the two choices and skip 
		-- the drop-down menu.
		--
		if( allowToggling and #choices == 2 and removedEntry == false ) then
			if( choices[1] == button.label.text ) then
				button.label.text = choices[2]
			else
				button.label.text = choices[1]
			end
			if( throwEvent) then post("onTextFieldVisiblity", { phase = "show" } ) end
			if( settingsTbl and fieldName ) then					
				settingsTbl[fieldName] = button.label.text
				post("onSaveProject")
			end
			if( onChoice ) then onChoice( button, button.label.text, fieldName ) end
			return
		end

		-- If we made it this far, we're definitely creating a drop-down menu ...
		--

		-- Create a temporary group to house the menu
		local menuGroup = display.newGroup()
		group:insert(menuGroup)
		if( throwEvent) then post("onTextFieldVisiblity", { phase = "hide" } ) end

		--EDOCHI -- WHAT DOES THIS DO?
		--[[
		function menuGroup.onPreSetMode( self )
			ignore("onPreSetMode",self)
			display.remove(self)
			if( throwEvent) then post("onTextFieldVisiblity", { phase = "show" } ) end
		end; listen("onPreSetMode",menuGroup)
		--]]

		local function onBackTouch( self, event )
			--table.dump(event)
			if( event.phase == "ended" ) then
				--EDOCHI -- WHAT DOES THIS DO?ignore("onPreSetMode",menuGroup)
				display.remove( menuGroup )
				if( throwEvent) then post("onTextFieldVisiblity", { phase = "show" } ) end
				if( settingsTbl and fieldName ) then					
					settingsTbl[fieldName] = button.label.text
					post("onSaveProject")
				end
				if( onChoice ) then onChoice( button, button.label.text, fieldName ) end
			end
			return true
		end
		local back = newImageRect( menuGroup, centerX, centerY, "images/fillT.png", { size = 10000, touch = onBackTouch } )

		local scrollHeight
		if( allowHalfEntry and #choices > 2 ) then
			scrollHeight = (#choices >= maxEntries) and (height * (maxEntries - 0.5) ) or ( height * (#choices - 0.5) )
		else
			scrollHeight = (#choices >= maxEntries) and (height * maxEntries) or ( height * #choices )
		end


		local scrollBack = newRect( menuGroup, self.x, self.y + self.contentHeight/2,
	                                { w = width, h = scrollHeight, anchorX = 0, anchorY = 0,
						              fill = scrollerBackColor, stroke = buttonStroke } )
		-- EDOCHI Looks Wrong
		----[[
		scrollBack.shadowR = newImageRect( menuGroup, scrollBack.x + scrollBack.contentWidth - 1, scrollBack.y - 1, "images/gradientLR.png", 
			                         { w = settings.shadowW, h = scrollBack.contentHeight + settings.shadowW, 
			                           anchorX = 0, anchorY = 0, fill = _K_,
			                           alpha = settings.shadowAlpha,
			                           touch = function() return true end } )
		scrollBack.shadowR.blendMode = "multiply"
		scrollBack.shadowB = newImageRect( menuGroup, scrollBack.x - 1, scrollBack.y + scrollBack.contentHeight - 1, "images/gradientLR.png", 
			                         { w = scrollBack.contentWidth + settings.shadowW, h = settings.shadowW, 
			                           anchorX = 0, anchorY = 0, fill = _K_,
			                           alpha = settings.shadowAlpha,
			                           touch = function() return true end } )
		scrollBack.shadowB.blendMode = "multiply"
		--]]

		local scroller = vscroller.new( menuGroup, self.x, self.y + self.contentHeight/2, 
			                            self.contentWidth - 4, scrollHeight - 2, 
			                            { hideBackground = true  } )

		local function clickAction( self )
			local choice = self.label.text
			button.label.text = choice
			display.remove(menuGroup)	
			if( throwEvent) then post("onTextFieldVisiblity", { phase = "show" } ) end
			if( settingsTbl and fieldName ) then				
				settingsTbl[fieldName] = button.label.text
				post("onSaveProject")
			end
			if( onChoice ) then onChoice( button, choice, fieldName ) end
			return true
		end

		local fillScroller

		local function onChoiceTouch( self, event )
		    if( event.phase == "began" ) then
		        self.isFocus = true
		    elseif( self.isFocus ) then 
		        if( event.phase == "ended" ) then
		            self.isFocus = false
		            if( event.isClick ) then                                
		                if( self.clickAction ) then
		                	self:clickAction()
		                end
		            end
		        end            
		    end
		    return false
		end
		fillScroller = function()
			--print("Filling Scroller")
			local curX = button.contentWidth/2
			local curY = height/2
			for i = 1, #choices do
				local choiceButton = newImageRect( nil, curX, curY, "images/fillT.png",
			                                      { w = width, h = height } )

				choiceButton.label = easyIFC:quickLabel( nil, choices[i], curX, curY,
				                                  buttonFont, 
				                                  buttonFontSize, 
				                                  buttonFontColor ) 

			    scroller:insert( choiceButton )
			    scroller:insert( choiceButton.label )
			    scroller.addTouch( choiceButton, onChoiceTouch )
			    choiceButton.clickAction = clickAction
			    curY = curY + height
			end
		end
		fillScroller()
	end

	function button.touch( self, event )
		if( event.phase == "began" ) then
			display.currentStage:setFocus( self, event.id )
			self.isFocus = true
			self:setFillColor(unpack(buttonSelColor))
			self.x = self.x0 + 1
			self.y = self.y0 + 1

			self.label.x = self.label.x0 + 1
			self.label.y = self.label.y0 + 1
		elseif( self.isFocus ) then
			local inBounds = isInBounds( event, self )
			if( inBounds ) then 
				self:setFillColor(unpack(buttonSelColor))
				self.x = self.x0 + 1
				self.y = self.y0 + 1

				self.label.x = self.label.x0 + 1
				self.label.y = self.label.y0 + 1
			else
				self:setFillColor(unpack(buttonUnselColor))
				self.x = self.x0
				self.y = self.y0

				self.label.x = self.label.x0
				self.label.y = self.label.y0
			end
			if( event.phase == "ended" ) then
				self.x = self.x0
				self.y = self.y0

				self.label.x = self.label.x0
				self.label.y = self.label.y0
				display.currentStage:setFocus( self, nil)
				self.isFocus = true
				self:setFillColor(unpack(buttonUnselColor))
				if( inBounds ) then
					button:createDropdown()
				end
			end
		end
		return true
	end; button:addEventListener("touch")

	return button
end


-- ==
--
-- == 
function util.createTextEdit( group, x, y, width, height, font, fontSize, value, inputType, listener )
    local nativeTextField = native.newTextField( 10000 + x, 10000 + x, width, height )

    nativeTextField.inputType = (inputType == "float") and "default" or inputType

    nativeTextField.text = tostring(value or "")
    nativeTextField.font = native.newFont( font )
    nativeTextField.size = fontSize

    nativeTextField.userInput = listener
    if( listener ) then
    	--print("Adding listener", inputType)
        nativeTextField:addEventListener( "userInput" )
    end

    function nativeTextField.onTextFieldVisiblity( self, event )
    	if( autoIgnore( "onTextFieldVisiblity", self ) ) then return end
    	if( self.isVisible == nil ) then
    		ignore( "onTextFieldVisiblity", self )
    		return
    	end
    	self.isVisible = (event.phase == "show")
    	--self.shadowR.isVisible = (event.phase == "show")
    	--self.shadowB.isVisible = (event.phase == "show")
    end; listen( "onTextFieldVisiblity", nativeTextField )

    -- EFM - This hack avoid keeps text fields from flashing on screen in the wrong position
    nextFrame( function() nativeTextField.x = x; nativeTextField.y = y end)

    group:insert( nativeTextField )
    return nativeTextField
end

function util.infoPopup( record, titleText )
   --table.dump(record)
   local title    = titleText or record.title or record.display_name or "Information"
   local body     = record.description or "Placeholder body."
   local video    = record.video --or "https://www.youtube.com/watch?v=4Qor2NSCk6g"
   local webpage  = record.webpage --or "http://roaminggamer.com/makegames/"
   local coronadocs  = record.coronadocs --or "http://roaminggamer.com/makegames/"
   local credit   = record.credit_url --or "http://roaminggamer.com/makegames/"

   if( video and strMatch( video, "http" ) == nil )  then
      video = nil
   end

   if( webpage and strMatch( webpage, "http" ) == nil )  then
      webpage = nil
   end

   if( coronadocs and strMatch( coronadocs, "http" ) == nil )  then
      coronadocs = nil
   end

   local buttons = {}
   buttons[#buttons+1] = { "OK", nil }
   if( video ) then
      buttons[#buttons+1] = { "Video", function() system.openURL( video ) end }
   end
   if( credit ) then
      buttons[#buttons+1] = { "Credits", function() system.openURL( credit ) end }
   end
   if( webpage ) then
      buttons[#buttons+1] = { "More Info", function() system.openURL( webpage ) end }
   end
   if( coronadocs ) then
      buttons[#buttons+1] = { "Corona Docs", function() system.openURL( coronadocs ) end }
   end
   easyAlert(title, body, buttons)        

end





function util.cleanFileName(filename)
	local clean = filename
	clean = clean:gsub(" ", '')
	clean = clean:gsub("`", '')
	clean = clean:gsub("'", '')
	clean = clean:gsub("%[", '')
	clean = clean:gsub("%]", '')
	clean = clean:gsub("%{", '')
	clean = clean:gsub("%}", '')
	clean = clean:gsub("%(", '')
	clean = clean:gsub("%)", '')
	clean = clean:gsub("%!", '')
	clean = clean:gsub("%^", '')
	clean = clean:gsub("%%", '')
	clean = clean:gsub("%&", '')
	clean = clean:gsub("%$", '')
	clean = clean:gsub("%#", '')
	clean = clean:gsub("%@", '')
	clean = clean:gsub("%*", '')
	clean = clean:gsub("%=", '')
	clean = clean:gsub("%*", '')
	return clean
end


-- Properly formats an input for the purpose of injecting it into a Lua 
-- statement for future interpretation/execution.
function util.formatValue( val, useBrackets )
	if(type(val) == "table") then
		local tmp = (useBrackets) and '{ ' or ''
		for i = 1, #val do
			if( i == 1 ) then
				tmp = tmp .. val[i]				
			else
				tmp = tmp .. ', ' .. val[i]
			end
		end
		tmp = tmp .. ( (useBrackets)  and ' }' or '' )
		return tmp
	elseif(tonumber(val) ~= nil) then
		return tonumber(val)
	else
		return '"' .. val .. '"'
	end
end

-- ==
-- Attach finalize event listener to an object.
-- ==
function util.addFinalize( obj, func )
	obj.finalize = function( self )
		func(self)
	end; obj:addEventListener("finalize")
end

-- ==
-- 
-- ==
function util.addShadow( obj, ox, oy, altAlign )
	ox = ox or 0
	oy = oy or 0
	obj.shadowR = newImageRect( obj.parent, obj.x + obj.contentWidth/2 + ox, obj.y-obj.contentHeight/2 + oy, 
								"images/gradientLR.png", 
		                         { w = settings.shadowW, h = obj.contentHeight + settings.shadowW, 
		                           anchorX = 0, anchorY = 0, fill = _K_, alpha = settings.shadowAlpha } )
	 obj.shadowR.blendMode = "multiply"
	 if(altAlign) then
	 	obj.shadowR.x = obj.shadowR.x + obj.contentWidth/2
	 end
	 
	 obj.shadowB = newImageRect( obj.parent,  obj.x-obj.contentWidth/2 + ox,  obj.y +  obj.contentHeight/2 + oy, 
	 							"images/gradientTB.png", 
		                         { w = obj.contentWidth + settings.shadowW, h = settings.shadowW, 
		                           anchorX = 0, anchorY = 0, fill = _K_, alpha = settings.shadowAlpha } )
	obj.shadowB.blendMode = "multiply"
	 if(altAlign) then
	 	obj.shadowB.x = obj.shadowB.x + obj.contentWidth/2
	 end
end

-- ==
-- 
-- ==
function util.addShadow2( obj )
	obj.shadowR = newImageRect( obj.parent, obj.x + obj.contentWidth/2, obj.y-obj.contentHeight/2, 
								"images/gradientLR.png", 
		                         { w = settings.shadowW, h = obj.contentHeight + settings.shadowW, 
		                           anchorX = 0, anchorY = 0, fill = _K_, alpha = settings.shadowAlpha } )
	 obj.shadowR.blendMode = "multiply"
 	 obj.shadowR.x = obj.shadowR.x + obj.contentWidth/2 - 1
	 
	 obj.shadowB = newImageRect( obj.parent,  obj.x-obj.contentWidth/2,  obj.y +  obj.contentHeight/2, 
	 							"images/gradientTB.png", 
		                         { w = obj.contentWidth + settings.shadowW, h = settings.shadowW, 
		                           anchorX = 0, anchorY = 0, fill = _K_, alpha = settings.shadowAlpha } )
	obj.shadowB.blendMode = "multiply"
 	obj.shadowB.x = obj.shadowB.x + obj.contentWidth/2 - 1
end


-- ==
-- 
-- ==
function util.addShadow3( obj, ox )
	ox = ox or 0
	obj.shadowR = newImageRect( obj.parent, obj.x + obj.contentWidth/2, obj.y-obj.contentHeight/2, 
								"images/gradientLR.png", 
		                         { w = settings.shadowW, h = obj.contentHeight + settings.shadowW, 
		                           anchorX = 0, anchorY = 0, fill = _K_, alpha = settings.shadowAlpha } )
	 obj.shadowR.blendMode = "multiply"
 	 obj.shadowR.x = obj.shadowR.x + obj.contentWidth/2 + ox
 	 obj.shadowR.y = obj.shadowR.y + obj.contentHeight/2
	 
	 obj.shadowB = newImageRect( obj.parent,  obj.x-obj.contentWidth/2,  obj.y +  obj.contentHeight/2, 
	 							"images/gradientTB.png", 
		                         { w = obj.contentWidth + settings.shadowW, h = settings.shadowW, 
		                           anchorX = 0, anchorY = 0, fill = _K_, alpha = settings.shadowAlpha } )
	obj.shadowB.blendMode = "multiply"
 	obj.shadowB.x = obj.shadowB.x + obj.contentWidth/2  + ox
 	obj.shadowB.y = obj.shadowB.y + obj.contentHeight/2 
end

-- ==
-- 
-- ==
function util.plugin_hasConfig( details )
	--table.dump(details)
	return details.config ~= nil
	--return true
end

function util.plugin_hasConflict( details )	
	local config = details
	---table.dump(config)
	if( config == nil or 
		config.conflicts == nil or
		table.count(config.conflicts) == 0 ) then
		return false
	end
	local projectMgr = require "scripts.projectMgr"
	local currentProject = projectMgr.current()
	local curSettings
	local curPlugins
	local conflicts = config.conflicts

	if( not currentProject ) then 
		return false
	else
		curSettings = currentProject.settings
		curPlugins = currentProject.plugins

		--table.dump(conflicts,nil,"conflicts")
		--table.dump(curPlugins,nil,"curPlugins")

		local conflictNames = ""

		for k,v in pairs(conflicts) do			
			if( curPlugins[k] ) then 
				--print("Conflict", k, v )
				if(string.len(conflictNames) == 0 ) then
					conflictNames = v
				else
					conflictNames = conflictNames .. ", " .. v
				end				
			end
		end	

		return (string.len(conflictNames) > 0), conflictNames
	end	
	
	return false
end

function util.plugin_isConfigured( details )	
	local projectMgr = require "scripts.projectMgr"
	local currentProject = projectMgr.current()
	local curSettings
	local curPlugins

	local blankCount = 0

	if( not currentProject ) then 
		return true
	else
		curSettings = currentProject.settings
		curPlugins = currentProject.plugins

		-- Count empty 'all' fields
		if( details.config.all ) then
			local settings = details.config.all
			for i = 1, #settings do
				if( string.len(curSettings[settings[i][1]] or "") == 0 ) then
					blankCount = blankCount + 1
				end
			end
		end
		-- Count empty 'android' fields 
		if( details.config.android and curSettings.generate_android == "true" ) then
			local settings = details.config.android
			for i = 1, #settings do
				if( string.len(curSettings[settings[i][1]] or "") == 0 ) then
					blankCount = blankCount + 1
				end
			end
		end
		-- Count empty 'android' fields 
		if( details.config.ios and curSettings.generate_ios == "true" ) then
			local settings = details.config.ios
			for i = 1, #settings do
				if( string.len(curSettings[settings[i][1]] or "") == 0 ) then
					blankCount = blankCount + 1
				end
			end
		end
	end	
	--table.dump(curSettings)
	return blankCount
end

function util.multiSubFromSettings( currentProject, code, toReplace  )
	local plugins = require "settings.plugins"
	local curSettings
	local curPlugins
	if( not currentProject ) then 
		return code
	else
		--table.dump(curSettings,nil,"curSettings")
		curSettings = currentProject.settings
		curPlugins = currentProject.plugins
	end

	--table.dump(curSettings)

	for i = 1, #toReplace do

		local fromStr 	= toReplace[i][1]  
		local toStr 	= toReplace[i][2] 
		
		if( toStr == nil ) then
			print("%%%%%%%%%%%%%%% NIL REPLACE")
			string.gsub( code, fromStr, "" )				
		else
			--print( toReplace[i][1], toReplace[i][2] )
			local toValue = curSettings[toStr]
			if( string.len( toValue, 0 ) ) then
				toValue = "nil"
			end
			print( toStr, toStr == "ads_android_admob_banner_app_id")
			print( ">>>>>>>>>>> ",  fromStr, toStr, toValue, curSettings.ads_android_admob_banner_app_id )
			string.gsub( code, fromStr, toValue )
		end
	end
	return code
end



return util