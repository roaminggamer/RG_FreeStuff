-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- 								License
-- =============================================================
--[[
	> SSK is free to use.
	> SSK is free to edit.
	> SSK is free to use in a free or commercial game.
	> SSK is free to use in a free or commercial non-game app.
	> SSK is free to use without crediting the author (credits are still appreciated).
	> SSK is free to use without crediting the project (credits are still appreciated).
	> SSK is NOT free to sell for anything.
	> SSK is NOT free to credit yourself with.
]]
-- =============================================================

-- EFM bug - slider chained cb not called if finger off knob during release
-- EFM add 'auto-fit' labelText option so long labelText is scaled/shrunk to fit?

local fnn
if( not _G.fnn ) then
	fnn = function( ... ) 
		for i = 1, #arg do
			local theArg = arg[i]
			if(theArg ~= nil) then return theArg end
		end
		return nil
	end
else
	fnn = _G.fnn
end

local buttons = {}

buttons.buttonPresetsCatalog = {}

function buttons.getCurrentRadio( group )
	return group.currentRadio
end

-- ==
--    ssk.buttons:addButtonPreset( presetName, params ) - Creates a new button preset (table containing 
--    visual and functional options for button).
--
--    presetName - Name of new buttons preset (options table).
--        params - Parameters list. (See [ [ssk.buttons.params|ssk.buttons.params] ])
-- ==
function buttons:addButtonPreset( presetName, params )
	local entry = {}
	self.buttonPresetsCatalog[presetName] = entry

	local copyParams = { "x", "y", "w", "h", "rotation",
						 "kw", "kh", "unselKnobImg", "selKnobImg",
	                     "touchMask",  "touchOffset", 
						 "selRectFillColor", "unselRectFillColor",
						 "strokeWidth", "strokeColor", 
						 "unselStrokeWidth", "unselStrokeColor", "selStrokeWidth", "selStrokeColor", 
						 "unselImgSrc", "selImgSrc", "selImgFillColor", "unselImgFillColor",  "selKnobImgFillColor", "unselKnobImgFillColor", 
						 "buttonOverlayRectColor", "buttonOverlayImgSrc", "buttonOverlayFillColor",
						 "onPress", "onRelease", "onEvent", "buttonType", 
						 "pressSound", "releaseSound", "sound", "cornerRadius", "labelHorizAlign" 
					   }

	for i = 1, #copyParams do
		local paramName = copyParams[i]
		entry[paramName] = params[paramName]
	end

	entry.touchMaskW     	= params.touchMaskW
	entry.touchMaskH     	= params.touchMaskH

	entry.unselRectEn 		= fnn(params.unselRectEn, not params.unselImgSrc)
	entry.selRectEn    		= fnn(params.selRectEn, not params.selImgSrc)
	entry.buttonType   		= fnn(params.buttonType, "push" )
	entry.labelText 		= fnn(params.labelText, "")
	entry.labelSize     	= fnn(params.labelSize, 20)
	entry.labelColor    	= fnn(params.labelColor, {1,1,1,1})
	entry.selLabelColor 	= fnn(params.selLabelColor, params.labelColor, {1,1,1,1})
	entry.labelFont 		= fnn(params.labelFont, gameFont, native.systemFontBold)
	entry.labelOffset 		= fnn(params.labelOffset, {0,0})
	entry.labelHorizAlign 	= fnn(params.labelHorizAlign, "center" )
    entry.emboss 			= fnn(params.emboss, false)
    entry.labelAnchorX		= fnn(params.labelAnchorX, 0.5)

end

-- ==
--    ssk.buttons:newButton( parentGroup, params ) - Core builder function for creating new buttons.
--
--    parentGroup - Display group to store new button in.
--         params - Button options list. (See [ [ssk.buttons.params|ssk.buttons.params] ])
--
--    Returns handle to a new buttonInstance.
-- ==
function buttons:newButton( parentGroup, params )

	local parentGroup = parentGroup or display.currentStage
	local buttonInstance = display.newGroup()

	-- 1. Check for catalog entry option and apply FIRST 
	-- (allows us to override by passing params too)
	buttonInstance.presetName = params.presetName
	local presetCatalogEntry  = self.buttonPresetsCatalog[buttonInstance.presetName]
		
	if(presetCatalogEntry) then
		for k,v in pairs(presetCatalogEntry) do
			buttonInstance[k] = v
		end
	end

	-- 2. Apply any passed params
	if(params) then
		for k,v in pairs(params) do
			buttonInstance[k] = v
		end
	end

	-- 3. Ensure all 'required' values have something in them or assign defaults
	buttonInstance.x            = fnn(buttonInstance.x, 0)
	buttonInstance.y            = fnn(buttonInstance.y, 0)
	buttonInstance.w            = fnn(buttonInstance.w, 178)
	buttonInstance.h            = fnn(buttonInstance.h, 56)
	buttonInstance.buttonType   = fnn(buttonInstance.buttonType, "push")

	buttonInstance.labelText     = fnn(buttonInstance.labelText, "")
	buttonInstance.labelSize     = fnn(buttonInstance.labelSize, 20)
	buttonInstance.labelColor    = fnn(buttonInstance.labelColor, {1,1,1,1})
	buttonInstance.selLabelColor = fnn(buttonInstance.selLabelColor, buttonInstance.labelColor)

	buttonInstance.labelFont    = fnn(buttonInstance.labelFont, native.systemFontBold)
	buttonInstance.labelOffset   = fnn(buttonInstance.labelOffset, {0,0})
	buttonInstance.labelHorizAlign 	= fnn(buttonInstance.labelHorizAlign, "center" )
    buttonInstance.emboss       = fnn(buttonInstance.emboss, false)

	buttonInstance.unselRectEn  = fnn(buttonInstance.unselRectEn, not buttonInstance.unselImgSrc)
	buttonInstance.selRectEn    = fnn(buttonInstance.selRectEn, not buttonInstance.selImgSrc)


	buttonInstance.isPressed    = false -- start off unpressed


	-- ====================
	-- Create the button
	-- ====================

	-- MASK
	if(buttonInstance.touchMask) then
		local tmpMask = graphics.newMask(buttonInstance.touchMask)
		buttonInstance:setMask( tmpMask )
		buttonInstance.maskScaleX = buttonInstance.w / buttonInstance.touchMaskW
		buttonInstance.maskScaleY = buttonInstance.h / buttonInstance.touchMaskH
	end

	-- UNSEL RECT
	if(buttonInstance.unselRectEn) then
		local unselRect
		if(buttonInstance.cornerRadius) then
			unselRect = display.newRoundedRect( buttonInstance.w/2, buttonInstance.h/2, buttonInstance.w, buttonInstance.h, buttonInstance.cornerRadius)
		else
			unselRect = display.newRect( buttonInstance.w/2, buttonInstance.h/2, buttonInstance.w, buttonInstance.h)
		end
		
		unselRect.isHitTestable = true

		if(buttonInstance.strokeWidth) then
			unselRect.strokeWidth = buttonInstance.strokeWidth
		elseif(buttonInstance.selStrokeWidth) then
			unselRect.strokeWidth = buttonInstance.selStrokeWidth
		end

		if(buttonInstance.unselRectFillColor ) then
			local r = fnn(buttonInstance.unselRectFillColor[1], 1)
			local g = fnn(buttonInstance.unselRectFillColor[2], 1)
			local b = fnn(buttonInstance.unselRectFillColor[3], 1)
			local a = fnn(buttonInstance.unselRectFillColor[4], 1)
			unselRect:setFillColor(r,g,b,a)
		end

		if(buttonInstance.unselStrokeColor) then
			local r = fnn(buttonInstance.unselStrokeColor[1], 1)
			local g = fnn(buttonInstance.unselStrokeColor[2], 1)
			local b = fnn(buttonInstance.unselStrokeColor[3], 1)
			local a = fnn(buttonInstance.unselStrokeColor[4], 1)
			unselRect:setStrokeColor(r,g,b,a)

		elseif(buttonInstance.strokeColor) then
			local r = fnn(buttonInstance.strokeColor[1], 1)
			local g = fnn(buttonInstance.strokeColor[2], 1)
			local b = fnn(buttonInstance.strokeColor[3], 1)
			local a = fnn(buttonInstance.strokeColor[4], 1)
			unselRect:setStrokeColor(r,g,b,a)
		end

		buttonInstance:insert( unselRect, true )
		unselRect.isVisible = true
		buttonInstance.unselRect = unselRect
		
	end

	-- SEL RECT
	if(buttonInstance.selRectEn) then

		local selRect
		if(buttonInstance.cornerRadius) then
			selRect = display.newRoundedRect( buttonInstance.w/2, buttonInstance.h/2, buttonInstance.w, buttonInstance.h, buttonInstance.cornerRadius)
		else
			selRect = display.newRect( buttonInstance.w/2, buttonInstance.h/2, buttonInstance.w, buttonInstance.h)
		end
		
		selRect.isHitTestable = true

		if(buttonInstance.strokeWidth) then
			selRect.strokeWidth = buttonInstance.strokeWidth
		elseif(buttonInstance.selStrokeWidth) then
			selRect.strokeWidth = buttonInstance.selStrokeWidth
		end

		if(buttonInstance.selRectFillColor ) then
			local r = fnn(buttonInstance.selRectFillColor[1], 1)
			local g = fnn(buttonInstance.selRectFillColor[2], 1)
			local b = fnn(buttonInstance.selRectFillColor[3], 1)
			local a = fnn(buttonInstance.selRectFillColor[4], 1)
			selRect:setFillColor(r,g,b,a)
		end

		if(buttonInstance.selStrokeColor) then
			local r = fnn(buttonInstance.selStrokeColor[1], 1)
			local g = fnn(buttonInstance.selStrokeColor[2], 1)
			local b = fnn(buttonInstance.selStrokeColor[3], 1)
			local a = fnn(buttonInstance.selStrokeColor[4], 1)
			selRect:setStrokeColor(r,g,b,a)

		elseif(buttonInstance.strokeColor) then
			local r = fnn(buttonInstance.strokeColor[1], 1)
			local g = fnn(buttonInstance.strokeColor[2], 1)
			local b = fnn(buttonInstance.strokeColor[3], 1)
			local a = fnn(buttonInstance.strokeColor[4], 1)
			selRect:setStrokeColor(r,g,b,a)
		end
	
		buttonInstance:insert( selRect, true )
		selRect.isVisible = false
		buttonInstance.selRect = selRect
	end

	-- UNSEL IMG
	if(buttonInstance.unselImgSrc) then		
		local unselImgObj
		unselImgObj = display.newImageRect( buttonInstance.unselImgSrc, buttonInstance.w, buttonInstance.h)
		unselImgObj.isHitTestable = true

		if(buttonInstance.unselImgFillColor ) then
			local r = fnn(buttonInstance.unselImgFillColor[1], 1)
			local g = fnn(buttonInstance.unselImgFillColor[2], 1)
			local b = fnn(buttonInstance.unselImgFillColor[3], 1)
			local a = fnn(buttonInstance.unselImgFillColor[4], 1)
			unselImgObj:setFillColor(r,g,b,a)
		end

		if(buttonInstance.strokeWidth) then
			unselImgObj.strokeWidth = buttonInstance.strokeWidth
		elseif(buttonInstance.selStrokeWidth) then
			unselImgObj.strokeWidth = buttonInstance.selStrokeWidth
		end

		if(buttonInstance.unselStrokeColor) then
			local r = fnn(buttonInstance.unselStrokeColor[1], 1)
			local g = fnn(buttonInstance.unselStrokeColor[2], 1)
			local b = fnn(buttonInstance.unselStrokeColor[3], 1)
			local a = fnn(buttonInstance.unselStrokeColor[4], 1)
			unselImgObj:setStrokeColor(r,g,b,a)

		elseif(buttonInstance.strokeColor) then
			local r = fnn(buttonInstance.strokeColor[1], 1)
			local g = fnn(buttonInstance.strokeColor[2], 1)
			local b = fnn(buttonInstance.strokeColor[3], 1)
			local a = fnn(buttonInstance.strokeColor[4], 1)
			unselImgObj:setStrokeColor(r,g,b,a)
		end


		buttonInstance:insert( unselImgObj, true )
		unselImgObj.isVisible = true
		buttonInstance.unsel = unselImgObj
	end
	
	-- SEL IMG
	if(buttonInstance.selImgSrc) then		
		local selImgObj
		selImgObj = display.newImageRect( buttonInstance.selImgSrc, buttonInstance.w, buttonInstance.h)
		selImgObj.isHitTestable = true

		if(buttonInstance.selImgFillColor ) then
			local r = fnn(buttonInstance.selImgFillColor[1], 1)
			local g = fnn(buttonInstance.selImgFillColor[2], 1)
			local b = fnn(buttonInstance.selImgFillColor[3], 1)
			local a = fnn(buttonInstance.selImgFillColor[4], 1)
			selImgObj:setFillColor(r,g,b,a)
		end
		
		if(buttonInstance.strokeWidth) then
			selImgObj.strokeWidth = buttonInstance.strokeWidth
		elseif(buttonInstance.selStrokeWidth) then
			selImgObj.strokeWidth = buttonInstance.selStrokeWidth
		end
		
		if(buttonInstance.selStrokeColor) then
			local r = fnn(buttonInstance.selStrokeColor[1], 1)
			local g = fnn(buttonInstance.selStrokeColor[2], 1)
			local b = fnn(buttonInstance.selStrokeColor[3], 1)
			local a = fnn(buttonInstance.selStrokeColor[4], 1)
			selImgObj:setStrokeColor(r,g,b,a)

		elseif(buttonInstance.strokeColor) then
			local r = fnn(buttonInstance.strokeColor[1], 1)
			local g = fnn(buttonInstance.strokeColor[2], 1)
			local b = fnn(buttonInstance.strokeColor[3], 1)
			local a = fnn(buttonInstance.strokeColor[4], 1)
			selImgObj:setStrokeColor(r,g,b,a)
		end

		buttonInstance:insert( selImgObj, true )
		selImgObj.isVisible = false
		buttonInstance.sel = selImgObj
	end
		
	-- BUTTON Overlay Rect
	if(buttonInstance.buttonOverlayRectColor) then
		local r = fnn(buttonInstance.buttonOverlayRectColor[1], 1)
		local g = fnn(buttonInstance.buttonOverlayRectColor[2], 1)
		local b = fnn(buttonInstance.buttonOverlayRectColor[3], 1)
		local a = fnn(buttonInstance.buttonOverlayRectColor[4], 1)
		local overlayRect = display.newRect( buttonInstance.w/2, buttonInstance.h/2, buttonInstance.w, buttonInstance.h)
		buttonInstance:insert( overlayRect, true )
		buttonInstance.overlayRect = overlayRect
		buttonInstance.overlayRect:setFillColor( r,g,b,a )
	end

	-- BUTTON Overlay Image
	if(buttonInstance.buttonOverlayImgSrc) then
		local overlayImage = display.newImageRect( buttonInstance.buttonOverlayImgSrc, buttonInstance.w, buttonInstance.h)
		buttonInstance:insert( overlayImage, false )
		buttonInstance.overlayImage = overlayImage
		

		if(buttonInstance.buttonOverlayFillColor ) then
			local r = fnn(buttonInstance.buttonOverlayFillColor[1], 1)
			local g = fnn(buttonInstance.buttonOverlayFillColor[2], 1)
			local b = fnn(buttonInstance.buttonOverlayFillColor[3], 1)
			local a = fnn(buttonInstance.buttonOverlayFillColor[4], 1)
			buttonInstance.overlayImage:setFillColor(r,g,b,a)
		end
		
	end

	-- BUTTON TEXT
	local labelText 
	if(buttonInstance.emboss) then
		labelText = display.newEmbossedText( buttonInstance.labelText, 0, 0, buttonInstance.labelFont, buttonInstance.labelSize, buttonInstance.labelColor )
	else
		labelText = display.newText( buttonInstance.labelText, 0, 0, buttonInstance.labelFont, buttonInstance.labelSize )
	end	
	labelText.anchorX = buttonInstance.labelAnchorX or 0.5

	buttonInstance.myLabel = labelText
	labelText:setFillColor( buttonInstance.labelColor[1], buttonInstance.labelColor[2], 
	                        buttonInstance.labelColor[3], buttonInstance.labelColor[4] )
--EFM G2	labelText:setReferencePoint( display.CenterReferencePoint )
	buttonInstance:insert( labelText, true )

	if( buttonInstance.labelHorizAlign == "center" ) then
		labelText.x = buttonInstance.labelOffset[1]
		labelText.y = buttonInstance.labelOffset[2]

	elseif( buttonInstance.labelHorizAlign == "left" ) then		
		labelText.anchorX = 0
		print("BOB", buttonInstance.anchorX)
		if( buttonInstance.anchorX == 0.5 ) then			
			--labelText.x = buttonInstance.x - buttonInstance.w/2 + buttonInstance.labelOffset[1]
			labelText.x = - buttonInstance.w/2 + buttonInstance.labelOffset[1]
		elseif( buttonInstance.anchorX == 0 ) then			
			labelText.x = buttonInstance.x + buttonInstance.labelOffset[1]
		elseif( buttonInstance.anchorX == 1 ) then
			labelText.x = buttonInstance.x - buttonInstance.contentWidth + buttonInstance.labelOffset[1]
		end		
		labelText.y = buttonInstance.labelOffset[2]

	elseif( buttonInstance.labelHorizAlign == "right" ) then
		--labelText.anchorX = 1
		--labelText.x = buttonInstance.x + buttonInstance.contentWidth/2 + buttonInstance.labelOffset[1]
		--labelText.y = buttonInstance.labelOffset[2]
	end

	buttonInstance:addEventListener( "touch", self )

	-- ==
	--    buttonInstance:pressed() - Check if button is pressed (down).
	--    
	--    Returns true if button is currently pressed, false otherwise.
	-- ==
	function buttonInstance:pressed( ) 
		return self.isPressed
	end

	-- ==
	--    buttonInstance:toggle() - Change the pressed state of a button.  (Meant to be used on toggle and radio buttons.)
	-- ==
	function buttonInstance:toggle( noDispatch ) 
		--for k,v in pairs(self) do print(k,v) end

		local buttonEvent = {}
		buttonEvent.target = self
		buttonEvent.id = math.random(10000, 50000) -- must have a numeric id to be propagated
		buttonEvent.x = self.x
		buttonEvent.y = self.y
		buttonEvent.name = "touch"
		buttonEvent.phase = "began"
		buttonEvent.forceInBounds = true
		buttonEvent.noDispatch = noDispatch
		--print(tostring(buttonEvent) .. SPC .. buttonEvent.id) -- EFM bug: Not actually dispatching event
		--table.dump(buttonEvent)
		self:dispatchEvent( buttonEvent )
		buttonEvent.phase = "ended"
		self:dispatchEvent( buttonEvent )
	end

	-- ==
	--    buttonInstance:disable() - Disable the current button.  (Make button translucent and ignores touches.)
	-- ==
	function buttonInstance:disable( ) 
		self.isEnabled = false
		self.alpha = 0.3
	end

	-- ==
	--    buttonInstance:enable() - Enables the current button.  (Make button opaque and acknowledge touches.)
	-- ==
	function buttonInstance:enable( ) 
		self.isEnabled = true
		self.alpha = 1.0
	end

	-- ==
	--    buttonInstance:isEnabled() - Checks if button is enabled.
	--    
	--    Returns true if button is enabled, false otherwise. 
	-- ==
	function buttonInstance:isEnabled() 
		return (self.isEnabled == true)
	end

	-- ==
	--    buttonInstance:getText() - Get the currently displayed labelText for the current button if any.
	--    
	--    Returns a string containing the labelText that the button is currently displaying.
	-- ==
	function buttonInstance:getText( ) 
		--print( "buttonInstance:getText() self.labelText == " .. tostring(self.labelText) )
		return tostring(self.labelText)
	end

	-- ==
	--    buttonInstance:setText( labelText ) - Set the currently displayed labelText for the current button.
	--
	--    labelText - String containing new labelText for button.
	-- ==
	function buttonInstance:setText( newText ) 		
		local myLabel = self.myLabel
		self.labelText = newText
		if(self.emboss) then
			--print("BOB", newText)
			myLabel:setText( newText )
		else
			--print("BILL", newText)
			myLabel.text = newText
		end
	end

	-- ==
	--    buttonInstance:getTextColor() - Get the color of the labelText on the current button.
	--    
	--    Returns a table containing the color code for the buttons labelText.
	-- ==
	function buttonInstance:getTextColor() 
		local myLabel = self.myLabel
		return myLabel._color 
	end

	-- ==
	--    buttonInstance:setFillColor( color ) - Set the color of the labelText on the current button.
	--
	--    color - A table containing a color code.
	-- ==
	function buttonInstance:setFillColor( color ) 
		local myLabel = self.myLabel
		myLabel:setFillColor( unpack( color ) )
		myLabel._color  = color
	end
	
	-- ==
	--    buttonInstance:adjustLabelOffset( offset ) - Adjust the x- and y-offset of the current button's (labelText) label.
	--    
	--    offset - An indexed table containing two values, where value [1] is the x-offset, and value [2] is the y-offset.
	-- ==
	function buttonInstance:adjustLabelOffset( offset ) 
		local offset = fnn(offset, {0,0})
		local myLabel = self.myLabel
		self.labelOffset = offset
		myLabel.x = self.labelOffset[1]
		myLabel.y = self.labelOffset[2]
	end

	-- ==
	--    buttonInstance:setHighlight( vis ) - Highlight (or unhighlight) the button.
	--    
	--    vis - true means highlight, false means un-highlight.
	-- ==
	function buttonInstance:setHighlight( vis )	
		--if(not self.selRect) then print "NO RECT" end	
		--if(not self.sel) then print "NO IMAGE" end	
		--if(not self.overlayRect) then print "NO OVERLAY RECT" end	
		--if(not self.overlayImage) then print "NO OVERLAY IMAGE" end	

		if(self.highlighted == nil or self.highlighted ~= vis) then

			if(self.selRect) then self.selRect.isVisible = vis end
			if(self.unselRect) then self.unselRect.isVisible = (not vis) end
			if(self.sel) then self.sel.isVisible = vis end
			if(self.unsel) then self.unsel.isVisible = (not vis) end
		
			if (self.touchOffset) then
				local xOffset = self.touchOffset[1] or self.x
				local yOffset = self.touchOffset[2] or self.y
				if(vis) then						
					self.x = self.x + xOffset
					self.y = self.y + yOffset
				else
					self.x = self.x - xOffset
					self.y = self.y - yOffset
				end
			end

			if(self.selLabelColor) then 
				if(vis) then		
					self.myLabel:setFillColor( unpack( self.selLabelColor ) )
				else
					self.myLabel:setFillColor( unpack( self.labelColor ) )
				end
			end

			self.highlighted = vis

		end
	end
	
	parentGroup:insert( buttonInstance )

	return buttonInstance
end

-- ==
--    ssk.buttons:presetPush( parentGroup, presetName, x,y,w,h [, labelText [ , onRelease [, overrideParams] ] ] )
--
--    Create a new push-button based on a previously configured preset (settings table).
--
--       parentGroup - Display group to store new button in.
--        presetName - String containing the name of a previously configured preset (settings table).
--               x,y - <x,y> position to place button at
--               w,h - Width and height of button.
--              labelText - (optional) Text to display as button label.
--         onRelease - (optional) Callback to execute when button is released.
--    overrideParams - (optional) A table containing parameters you wish to set or change (overrides preset values) when making the button.
--
--    Returns a handle to a new buttonInstance.
-- ==
function buttons:presetPush( parentGroup, presetName, x, y, w, h, labelText, onRelease, overrideParams)
	local presetName = presetName or "default"

	--print("PUSH BUTTON w = " .. w .. " h = " .. h)
	local tmpParams = 
	{ 
		presetName = presetName,
		w = w,
		h = h,
		x = x,
		y = y,
		buttonType = "push",
		labelText = labelText,
		onRelease = onRelease,
	}

	if(overrideParams) then
		for k,v in pairs(overrideParams) do
			tmpParams[k] = v
		end
	end

	local tmpButton = self:newButton( parentGroup, tmpParams  )

	return tmpButton
end

-- ==
--    ssk.buttons:presetToggle( parentGroup, presetName, x,y,w,h [, labelText [ , onEvent [, overrideParams] ] ] )
--
--    Create a new toggle-button based on a previously configured preset (settings table).
--
--       parentGroup - Display group to store new button in.
--        presetName - String containing the name of a previously configured preset (settings table).
--               x,y - <x,y> position to place button at
--               w,h - Width and height of button.
--              labelText - (optional) Text to display as button label.
--           onEvent - (optional) Callback to execute when button is pressed and released.
--    overrideParams - (optional) A table containing parameters you wish to set or change (overrides preset values) when making the button.
--
--    Returns a handle to a new buttonInstance.
-- ==
function buttons:presetToggle( parentGroup, presetName, x,y,w,h, labelText,onEvent, overrideParams)
	local presetName = presetName or "default"

	--print("PUSH BUTTON w = " .. w .. " h = " .. h)
	local tmpParams = 
	{ 
		presetName = presetName,
		w = w,
		h = h,
		x = x,
		y = y,
		buttonType = "toggle",
		labelText = labelText,
		onEvent = onEvent,
	}

	if(overrideParams) then
		for k,v in pairs(overrideParams) do
			tmpParams[k] = v
		end
	end

	local tmpButton = self:newButton( parentGroup, tmpParams )

	return tmpButton
end

-- ==
--    ssk.buttons:presetRadio( parentGroup, presetName, x,y,w,h [, labelText [ , onRelease [, overrideParams] ] ] )
--
--    Create a new radio-button based on a previously configured preset (settings table).
--
--    Note: To work properly, associated radio buttons should be placed in their own display group without 
--    other un-related radios buttons.
--
--       parentGroup - Display group to store new button in.
--        presetName - String containing the name of a previously configured preset (settings table).
--               x,y - <x,y> position to place button at
--               w,h - Width and height of button.
--              labelText - (optional) Text to display as button label.
--         onRelease - (optional) Callback to execute when button is released.
--    overrideParams - (optional) A table containing parameters you wish to set or change (overrides preset values) when making the button.
--
--    Returns a handle to a new buttonInstance.
-- ==
function buttons:presetRadio( parentGroup, presetName, x, y , w, h, labelText, onRelease, overrideParams)
	local presetName = presetName or "default"
	
	--print("PUSH BUTTON w = " .. w .. " h = " .. h)
	local tmpParams = 
	{ 
		presetName = presetName,
		w = w,
		h = h,
		x = x,
		y = y,
		buttonType = "radio",
		labelText = labelText,
		onRelease = onRelease,
	}

	if(overrideParams) then
		for k,v in pairs(overrideParams) do
			tmpParams[k] = v
		end
	end

	local tmpButton = self:newButton( parentGroup, tmpParams )
	return tmpButton
end

function buttons:presetSlider( parentGroup, presetName, x,y,w,h, onEvent, onRelease, overrideParams)
	local parentGroup = parentGroup or display.currentStage
	local presetName = presetName or "default"
	
	local tmpParams = 
	{ 
		presetName = presetName,
		w = w,
		h = h,
		x = x,
		y = y,
		buttonType = "push",
		labelText = labelText,
		onEvent = onEvent,
		onRelease = onRelease,
	}

	if(overrideParams) then
		for k,v in pairs(overrideParams) do
			tmpParams[k] = v
		end
	end

	local presetData = self.buttonPresetsCatalog[presetName]

	local tmpButton = self:newButton( parentGroup, tmpParams )

	local sliderKnob = display.newGroup()

	parentGroup:insert( sliderKnob )

	sliderKnob.unsel = display.newImageRect(sliderKnob, tmpButton.unselKnobImg, tmpButton.kw, tmpButton.kh )
	sliderKnob.sel   = display.newImageRect(sliderKnob, tmpButton.selKnobImg, tmpButton.kw, tmpButton.kh )

	if(presetData.unselKnobImgFillColor ) then
		local r = fnn(presetData.unselKnobImgFillColor[1], 1)
		local g = fnn(presetData.unselKnobImgFillColor[2], 1)
		local b = fnn(presetData.unselKnobImgFillColor[3], 1)
		local a = fnn(presetData.unselKnobImgFillColor[4], 1)
		sliderKnob.unsel:setFillColor(r,g,b,a)
	end

	if(presetData.selKnobImgFillColor ) then
		local r = fnn(presetData.selKnobImgFillColor[1], 1)
		local g = fnn(presetData.selKnobImgFillColor[2], 1)
		local b = fnn(presetData.selKnobImgFillColor[3], 1)
		local a = fnn(presetData.selKnobImgFillColor[4], 1)
		sliderKnob.sel:setFillColor(r,g,b,a)
	end

	sliderKnob.sel.isVisible = false

	sliderKnob.x = tmpButton.x - tmpButton.width/2  + tmpButton.width/2
	sliderKnob.y = tmpButton.y
	tmpButton.myKnob = sliderKnob
	tmpButton.value = 0

	sliderKnob.rotation = tmpButton.rotation

	parentGroup:insert(sliderKnob)

	-- ==
	--    sliderInstance:getValue( ) - Get the current value for the slider.
	--    
	--    Returns a floating-point value in the range [ 0.0 , 1.0 ] representing the left-to-right position of the slider.
	-- ==
	function tmpButton:getValue()
		return  tonumber(string.format("%1.2f", self.value))
	end

	-- ==
	--    sliderInstance:setValue( val ) - Sets the current value of the slider and updates the knob-position.
	--    
	--    val - A floating-point value in the range [ 0.0 , 1.0 ] representing the left-to-right position of the slider.
	-- ==
	function tmpButton:setValue( val )
		local knob = self.myKnob
		local left = (self.x - self.width/2) + knob.width/2
		local right = (self.x + self.width/2) - knob.width/2
		local top = (self.y - self.width/2) + knob.width/2
		local bot = (self.y + self.width/2) - knob.width/2
		local height = bot-top
		local width = right-left

		if(val < 0) then
			self.value = 0
		elseif( val > 1 ) then
			self.value = 1
		else
			self.value = tonumber(string.format("%1.2f", val))
		end

		if( knob.rotation == 0 ) then
			knob.x = left + (width * self.value)

		elseif( knob.rotation == 90 ) then
			knob.y = top + (width * self.value)
	
		elseif( knob.rotation == 180 or knob.rotation == -180 ) then
			knob.x = right - (width * self.value)

		elseif( knob.rotation == 270 or knob.rotation == -90 ) then
			knob.y = bot - (width * self.value)
		end

	end

	-- ==
	--    sliderInstance:disable( ) - Disables the slider and makes is translucent.  
	-- ==
	function tmpButton:disable( ) 
		self.isEnabled = false
		self.sel.alpha = 0.3
		self.unsel.alpha = 0.3
		self.myKnob.alpha = 0.3
	end

	-- ==
	--    sliderInstance:enable( ) - Enables the slider and makes is opaque.  
	-- ==
	function tmpButton:enable( ) 
		self.isEnabled = true
		self.sel.alpha = 1.0
		self.unsel.alpha = 1.0
		self.myKnob.alpha = 1.0		
	end

	return tmpButton, sliderKnob
end


-- ==
--     Easy Rollers, Table Rollers, Table Togglers, etc.
-- ==
local sbc = require "ssk.interfaces.sbc"
function buttons:presetTableRoller( parentGroup, presetName, x, y, w, h, srcTable, onRelease, overrideParams)
	local tmpButton = buttons:presetPush( parentGroup, presetName, x, y, w, h, srcTable[1], sbc.tableRoller_CB, overrideParams)
	sbc.prep_tableRoller( tmpButton, srcTable, onRelease ) 
	return tmpButton
end

function buttons:presetTable2TableRoller( parentGroup, presetName, x, y, w, h, srcTable, dstTable, entryName, onRelease, overrideParams)
	local tmpButton = buttons:presetPush( parentGroup, presetName, x, y, w, h, srcTable[1], sbc.table2TableRoller_CB, overrideParams)
	sbc.prep_table2TableRoller( tmpButton, dstTable, entryName, srcTable, onRelease ) 
	return tmpButton
end

function buttons:presetTableToggler( parentGroup, presetName, x, y, w, h, labelText, dstTable, entryName, onToggle, overrideParams)
	local tmpButton = buttons:presetToggle( parentGroup, presetName, x, y, w, h, labelText, sbc.tableToggler_CB, overrideParams)
	sbc.prep_tableToggler( tmpButton, dstTable, entryName, onToggle ) 
	return tmpButton
end

function buttons:presetSlider2Table( parentGroup, presetName, x,y,w,h, dstTable, entryName, onEvent, onRelease, overrideParams)
	local tmpButton = buttons:presetSlider( parentGroup, presetName, x,y,w,h, sbc.horizSlider2Table_CB, nil, overrideParams)
	sbc.prep_horizSlider2Table( tmpButton, dstTable, entryName, onRelease ) 
	return tmpButton
end



-- ============= quickHorizSlider() -- Quick slider creator
-- ==
--    ssk.buttons:quickHorizSlider(parentGroup,  x, y, w, h, imageBase, onEvent or nil , onRelease or nil , knobImg, kw, kh  )
--
--    Create a new radio-button based on a previously configured preset (settings table).
--
--    Note: To work properly, associated radio buttons should be placed in their own display group without 
--    other un-related radios buttons.
--
--            x,y - <x,y> position to place slider bar at.
--            w,h - Width and height of slider bar.
--      imageBase - File path and name base for normal and Over textures. i.e. If a slider uses two textures sliderBar.png and sliderBarOver.png, the imageBase is "slideBar".
--        onEvent - (optional) Callback to execute when slider is moved.
--      onRelease - (optional) Callback to execute when slider is released.
--        knobImg - Path and filname of image file to use for knob.
--          kw,kh - Width and height of slider knob.
--    parentGroup - Display group to store slider in.
--
--    Returns a handle to a new sliderInstance.
-- ==

function buttons:quickHorizSlider( parentGroup, x, y, w, h, imageBase, onEvent, onRelease, knobImgBase, kw, kh )
	local parentGroup = parentGroup or display.currentStage
	local tmpParams = 
	{ 
		w = w,
		h = h,
		x = x,
		y = y,
		unselImgSrc = imageBase .. ".png",
		selImgSrc   = imageBase .. "Over.png",
		buttonType = "push",
		pressSound = buttonSound,
		onEvent = onEvent,
		onRelease = onRelease,
		emboss = true,
	}

	local tmpButton = self:newButton( parentGroup, tmpParams )

	local sliderKnob = display.newGroup()

	sliderKnob.unsel = display.newImageRect(sliderKnob, knobImgBase .. ".png", kw, kh )
	sliderKnob.sel   = display.newImageRect(sliderKnob, knobImgBase .. "Over.png", kw, kh )
	sliderKnob.unsel.rotation = sliderKnob.rotation
	sliderKnob.sel.rotation = sliderKnob.rotation
	sliderKnob.sel.isVisible = false

	sliderKnob.x = tmpButton.x - tmpButton.width/2  + tmpButton.width/2
	sliderKnob.y = tmpButton.y
	tmpButton.myKnob = sliderKnob
	tmpButton.value = 0

	parentGroup:insert(sliderKnob)

	-- ==
	--    sliderInstance:getValue( ) - Get the current value for the slider.
	--    
	--    Returns a floating-point value in the range [ 0.0 , 1.0 ] representing the left-to-right position of the slider.
	-- ==
	function tmpButton:getValue()
		return  tonumber(string.format("%1.2f", self.value))
	end

	-- ==
	--    sliderInstance:setValue( val ) - Sets the current value of the slider and updates the knob-position.
	--    
	--    val - A floating-point value in the range [ 0.0 , 1.0 ] representing the left-to-right position of the slider.
	-- ==
	function tmpButton:setValue( val )
		local knob = self.myKnob
		local left = (self.x - self.width/2) + knob.width/2
		local right = (self.x + self.width/2)  - knob.width/2
		local width = right-left

		if(val < 0) then
			self.value = 0
		elseif( val > 1 ) then
			self.value = 1
		else
			self.value = tonumber(string.format("%1.2f", val))
		end

		knob.x = left + (width * self.value)
	end

	-- ==
	--    sliderInstance:disable( ) - Disables the slider and makes is translucent.  
	-- ==
	function tmpButton:disable( ) 
		self.isEnabled = false
		self.sel.alpha = 0.3
		self.unsel.alpha = 0.3
		self.myKnob.alpha = 0.3
	end

	-- ==
	--    sliderInstance:enable( ) - Enables the slider and makes is opaque.  
	-- ==
	function tmpButton:enable( ) 
		self.isEnabled = true
		self.sel.alpha = 1.0
		self.unsel.alpha = 1.0
		self.myKnob.alpha = 1.0		
	end

	return tmpButton, sliderKnob
end

-- ============= touch() -- Touch handler for all button types (INTERNAL ONLY)
function buttons:touch( params )
	--for k,v in pairs(params) do print(k,v) end
	local result         = true
	local id		     = params.id 
	local theButton      = params.target 
	local phase          = params.phase
	local sel            = theButton.sel
	local unsel          = theButton.unsel
	local onPress        = theButton.onPress
	local onRelease      = theButton.onRelease
	local onEvent        = theButton.onEvent
	local buttonType     = theButton.buttonType
	local parent         = theButton.parent
	local sound          = theButton.sound
	local pressSound     = theButton.pressSound
	local releaseSound   = theButton.releaseSound
	local forceInBounds  = params.forceInBounds

	local theKnob = theButton.myKnob
	if(params.noDispatch == true) then
		onPress = nil
		onRelease = nil
		onEvent = nil
	end


	-- If not enabled, exit immediately
	if(theButton.isEnabled == false) then
		return result
	end

	local buttonEvent = params -- For passing to callbacks

	if(phase == "began") then
		
		if(theKnob and theKnob.sel) then -- This is a slider
			theKnob.sel.isVisible = true
			theKnob.unsel.isVisible = false
		end

		theButton:setHighlight(true)
		display.getCurrentStage():setFocus( theButton, id )
		theButton.isFocus = true

		-- Only Pushbutton fires event here
		if(buttonType == "push") then
			-- PUSH BUTTON
			--print("push button began")
			theButton.isPressed = true
			if( sound ) then audio.play( sound ) end
			if( pressSound ) then audio.play( pressSound ) end
			if( onPress ) then result = result and onPress( buttonEvent ) end
			if( onEvent ) then result = result and onEvent( buttonEvent ) end
		elseif(buttonType == "radio") then
			if( onEvent ) then result = result and onEvent( buttonEvent ) end
		end

	elseif theButton.isFocus then
		local bounds = theButton.stageBounds
		local x,y = params.x, params.y
		local isWithinBounds = 
			bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y

		if( forceInBounds == true ) then
			isWithinBounds = true
		end

		if( phase == "moved") then
			if(buttonType == "push") then
				theButton:setHighlight(isWithinBounds)
				--sel.isVisible   = isWithinBounds
				--unsel.isVisible = not isWithinBounds
				if( onEvent ) then result = result and onEvent( buttonEvent ) end
			elseif(buttonType == "toggle") then
				if( not isWithinBounds ) then
					theButton:setHighlight(theButton.isPressed)
					--sel.isVisible   = theButton.isPressed
					--unsel.isVisible = not theButton.isPressed					
				else
					theButton:setHighlight(true)
					--sel.isVisible   = true
					--unsel.isVisible = false
				end
			elseif(buttonType == "radio") then
				if( onEvent ) then result = result and onEvent( buttonEvent ) end
			end

		elseif(phase == "ended" or phase == "cancelled") then
			--print("buttonType " .. buttonType )
			------------------------------------------------------
			if(buttonType == "push") then -- PUSH BUTTON
			------------------------------------------------------
				--print "push button ended"	
				
				if(theKnob and theKnob.sel) then -- This is a slider
					theKnob.sel.isVisible   = false
					theKnob.unsel.isVisible = true
				end
							
				theButton:setHighlight(false)
				--sel.isVisible   = false
				--unsel.isVisible = true

				theButton.isPressed = false

				if isWithinBounds then
					if( sound ) then audio.play( sound ) end
					if( releaseSound ) then audio.play( releaseSound ) end
					if( onRelease ) then result = result and onRelease( buttonEvent ) end
					if( onEvent ) then result = result and onEvent( buttonEvent ) end
				end
			
			------------------------------------------------------
			elseif(buttonType == "toggle") then -- TOGGLE BUTTON				
			------------------------------------------------------
				--print( "\ntoggle button ended -- " .. buttonEvent.phase )
				if isWithinBounds then
					if(theButton.isPressed == true) then
						theButton.isPressed = false
						if( sound ) then audio.play( sound ) end
						if( releaseSound ) then audio.play( releaseSound ) end
						if( onRelease ) then result = result and onRelease( buttonEvent ) end
						if( onEvent ) then result = result and onEvent( buttonEvent ) end
					else
						theButton.isPressed = true
						buttonEvent.phase = "began"
						if( sound ) then audio.play( sound ) end
						if( pressSound ) then audio.play( pressSound ) end
						if( onPress ) then result = result and onPress( buttonEvent ) end
						if( onEvent ) then result = result and onEvent( buttonEvent ) end
					end					
				end
				theButton:setHighlight(theButton.isPressed)
				--sel.isVisible   = theButton.isPressed
				--unsel.isVisible = not theButton.isPressed				
			------------------------------------------------------
			elseif(buttonType == "radio") then -- RADIO BUTTON
			------------------------------------------------------
				--print "radio button ended" 
				if isWithinBounds then
					--print( "parent.currentRadio ==> " .. tostring(parent.currentRadio))
					if( not parent.currentRadio ) then
						--print("First radio press")
					 
					elseif( parent.currentRadio ~= theButton ) then
						local oldRadio = parent.currentRadio
						if( oldRadio ) then
							oldRadio.isPressed = false
							oldRadio:setHighlight(false)
						end
					end
						
					parent.currentRadio = theButton
					buttonEvent.theButton = theButton

					theButton.isPressed = true
					--buttonEvent.phase = "ended"
					if( sound ) then audio.play( sound ) end
					--if( onEvent ) then result = result and onEvent( buttonEvent ) end

					if( releaseSound ) then audio.play( releaseSound ) end
					if( onRelease ) then result = result and onRelease( buttonEvent ) end


				end
				if( onEvent ) then result = result and onEvent( buttonEvent ) end
				
				theButton:setHighlight(theButton.isPressed)
				--sel.isVisible   = theButton.isPressed
				--unsel.isVisible = not theButton.isPressed
			end
			
			-- Allow touch events to be sent normally to the objects they "hit"
			display.getCurrentStage():setFocus( theButton, nil )
			theButton.isFocus = false


		end
	end
	return result
end

return buttons