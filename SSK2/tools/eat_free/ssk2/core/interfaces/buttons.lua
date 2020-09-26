-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local fnn = _G.fnn or 
   function( ... ) 
      for i = 1, #arg do
         local theArg = arg[i]
         if(theArg ~= nil) then return theArg end
      end
      return nil
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
   local entry = table.deepCopy( params )
   self.buttonPresetsCatalog[presetName] = entry

   entry.touchMaskW     	= params.touchMaskW
   entry.touchMaskH     	= params.touchMaskH

   entry.unselRectEn       = (params.unselRectFillColor) and (not params.unselImgSrc) 
   entry.selRectEn         = (params.selRectFillColor) and (not params.selImgSrc) 
   entry.toggledRectEn     = (params.toggledRectFillColor) and (not params.toggledImgSrc) 
   entry.lockedRectEn     = (params.lockedRectFillColor) and (not params.lockedImgSrc) 
   entry.buttonType   		= fnn(params.buttonType, "push" )
   entry.labelText 		   = fnn(params.labelText, "")
   entry.labelSize     	   = fnn(params.labelSize, 20)
   entry.labelColor    	   = fnn(params.labelColor, {1,1,1,1})
   entry.selLabelColor 	   = fnn(params.selLabelColor, params.labelColor, {1,1,1,1})
   entry.labelFont 		   = fnn(params.font, params.labelFont, ssk.__gameFont, native.systemFontBold)
   entry.labelOffset 		= fnn(params.labelOffset, {0,0})
   entry.labelHorizAlign 	= fnn(params.labelHorizAlign, "center" )
   entry.baseFolder 	      = fnn(params.baseFolder, system.ResourceDirectory )

   entry.emboss 			   = fnn(params.emboss, false)
   entry.embossColor       = fnn(params.embossColor, { highlight = { r = 1, g = 1, b =  1 }, 
                                                       shadow = { r = 0, g = 0, b = 0 } } )
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
      table.deepCopy( presetCatalogEntry, buttonInstance )
   end

   -- 2. Apply any passed params and override existing values
   if( params ) then
      table.deepCopy( params, buttonInstance )
   end

   -- 3. Ensure all 'required' values have something in them or assign defaults
   buttonInstance.x                 = fnn(buttonInstance.x, 0)
   buttonInstance.y                 = fnn(buttonInstance.y, 0)
   buttonInstance.w                 = fnn(buttonInstance.w, 178)
   buttonInstance.h                 = fnn(buttonInstance.h, 56)
   buttonInstance.buttonType        = fnn(buttonInstance.buttonType, "push")

   buttonInstance.labelText         = fnn(buttonInstance.labelText, "")
   buttonInstance.labelSize         = fnn(buttonInstance.labelSize, 20)
   buttonInstance.labelColor        = fnn(buttonInstance.labelColor, {1,1,1,1})
   buttonInstance.selLabelColor     = fnn(buttonInstance.selLabelColor, buttonInstance.labelColor)
   buttonInstance.labelColor[4]     = buttonInstance.labelColor[4]  or 1
   buttonInstance.selLabelColor[4]  = buttonInstance.selLabelColor[4]  or 1

   buttonInstance.labelFont         = fnn(buttonInstance.font, buttonInstance.labelFont, native.systemFontBold)
   buttonInstance.labelOffset       = fnn(buttonInstance.labelOffset, {0,0})
   buttonInstance.labelHorizAlign 	= fnn(buttonInstance.labelHorizAlign, "center" )
   buttonInstance.emboss            = fnn(buttonInstance.emboss, false)

   buttonInstance.unselRectEn       = (buttonInstance.unselRectFillColor) and (not buttonInstance.unselImgSrc)
   buttonInstance.selRectEn         = (buttonInstance.selRectFillColor) and (not buttonInstance.selImgSrc)

   buttonInstance.isPressed         = false 

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

   -- Rect Components
   --
   local prefixes = { "unsel", "sel", "toggled", "locked" }
   for i = 1, #prefixes do
      local prefix = prefixes[i]

      local name1 = prefix .. "RectEn"
      local name2 = prefix .. "RectFillColor"
      local name3 = prefix .. "StrokeColor"
      local name4 = prefix .. "Rect"

      if(buttonInstance[name1]) then
         local obj
         if(buttonInstance.cornerRadius) then
            obj = display.newRoundedRect( buttonInstance.w/2, buttonInstance.h/2, buttonInstance.w, buttonInstance.h, buttonInstance.cornerRadius)
         else
            obj = display.newRect( buttonInstance.w/2, buttonInstance.h/2, buttonInstance.w, buttonInstance.h)
         end

         obj.isHitTestable = true

         if(buttonInstance.strokeWidth) then
            obj.strokeWidth = buttonInstance.strokeWidth
         elseif(buttonInstance.selStrokeWidth) then
            obj.strokeWidth = buttonInstance.selStrokeWidth
         end

         if(buttonInstance[name2]) then
            local r = fnn(buttonInstance[name2][1], 1)
            local g = fnn(buttonInstance[name2][2], 1)
            local b = fnn(buttonInstance[name2][3], 1)
            local a = fnn(buttonInstance[name2][4], 1)
            obj:setFillColor(r,g,b,a)
         end

         if(buttonInstance[name3]) then
            local r = fnn(buttonInstance[name3][1], 1)
            local g = fnn(buttonInstance[name3][2], 1)
            local b = fnn(buttonInstance[name3][3], 1)
            local a = fnn(buttonInstance[name3][4], 1)
            obj:setStrokeColor(r,g,b,a)

         elseif(buttonInstance.strokeColor) then
            local r = fnn(buttonInstance.strokeColor[1], 1)
            local g = fnn(buttonInstance.strokeColor[2], 1)
            local b = fnn(buttonInstance.strokeColor[3], 1)
            local a = fnn(buttonInstance.strokeColor[4], 1)
            obj:setStrokeColor(r,g,b,a)
         end

         buttonInstance:insert( obj, true )
         obj.isVisible = (i == 1)
         buttonInstance[name4] = obj
      end

   end

   -- Image Components
   --
   local prefixes = { "unsel", "sel", "toggled", "locked" }
   for i = 1, #prefixes do
      local prefix = prefixes[i]

      local name1 = prefix .. "ImgSrc"
      local name2 = prefix .. "ImgFillColor"
      local name3 = prefix .. "StrokeColor"
      local name4 = prefix .. "Img"

      if(buttonInstance[prefix .. "ImgSrc"]) then
         local obj
         obj = display.newImageRect( buttonInstance[name1], buttonInstance.baseFolder, buttonInstance.w, buttonInstance.h)
         obj.isHitTestable = true

         if(buttonInstance[name2]) then
            local r = fnn(buttonInstance[name2][1], 1)
            local g = fnn(buttonInstance[name2][2], 1)
            local b = fnn(buttonInstance[name2][3], 1)
            local a = fnn(buttonInstance[name2][4], 1)
            obj:setFillColor(r,g,b,a)
         end

         if(buttonInstance.strokeWidth) then
            obj.strokeWidth = buttonInstance.strokeWidth
         elseif(buttonInstance.selStrokeWidth) then
            obj.strokeWidth = buttonInstance.selStrokeWidth
         end

         if(buttonInstance[name3]) then
            local r = fnn(buttonInstance[name3][1], 1)
            local g = fnn(buttonInstance[name3][2], 1)
            local b = fnn(buttonInstance[name3][3], 1)
            local a = fnn(buttonInstance[name3][4], 1)
            obj:setStrokeColor(r,g,b,a)

         elseif(buttonInstance.strokeColor) then
            local r = fnn(buttonInstance.strokeColor[1], 1)
            local g = fnn(buttonInstance.strokeColor[2], 1)
            local b = fnn(buttonInstance.strokeColor[3], 1)
            local a = fnn(buttonInstance.strokeColor[4], 1)
            obj:setStrokeColor(r,g,b,a)
         end
         buttonInstance:insert( obj, true )
         obj.isVisible = (i == 1) 
         buttonInstance[name4] = obj
      end 
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
      local overlayImage = display.newImageRect( buttonInstance.buttonOverlayImgSrc, buttonInstance.baseFolder, buttonInstance.w, buttonInstance.h)
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
      labelText = display.newEmbossedText( buttonInstance.labelText, 0, 0, buttonInstance.labelFont, buttonInstance.labelSize )
   else
      labelText = display.newText( buttonInstance.labelText, 0, 0, buttonInstance.labelFont, buttonInstance.labelSize )
   end


   labelText.anchorX = buttonInstance.labelAnchorX or 0.5

   buttonInstance.myLabel = labelText
   labelText:setFillColor(unpack(buttonInstance.labelColor))   
   buttonInstance:insert( labelText, true )

   if(buttonInstance.emboss) then
      labelText:setEmbossColor(buttonInstance.embossColor)
   end

   if( buttonInstance.labelHorizAlign == "center" ) then
      labelText.x = buttonInstance.labelOffset[1]
      labelText.y = buttonInstance.labelOffset[2]

   elseif( buttonInstance.labelHorizAlign == "left" ) then
      labelText.anchorX = 0
      labelText.x = buttonInstance.labelOffset[1] - 
                    params.w/2                    
      labelText.y = buttonInstance.labelOffset[2]

   elseif( buttonInstance.labelHorizAlign == "right" ) then
      labelText.anchorX = 1
      labelText.x = buttonInstance.labelOffset[1] + 
                    params.w/2                    
      labelText.y = buttonInstance.labelOffset[2]
   else
      labelText.x = buttonInstance.labelOffset[1]
      labelText.y = buttonInstance.labelOffset[2]
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
      --print(tostring(buttonEvent) .. SPC .. buttonEvent.id) -- bug: Not actually dispatching event
      --table.dump(buttonEvent)
      self:dispatchEvent( buttonEvent )
      buttonEvent.phase = "ended"
      self:dispatchEvent( buttonEvent )
   end

   -- ==
   --    buttonInstance:disable() - Disable the current button.  (Make button translucent and ignores touches.)
   -- ==
   function buttonInstance:disable( alpha ) 
      self.isEnabled = false
      local prefixes = { "unsel", "sel", "toggled", "locked" }
      
      if( self.lockedRect ) then
         for i = 1, #prefixes do 
            local obj = self[prefixes[i] .. "Rect"]
            if( obj and obj._lastVis == nil ) then
               obj._lastVis = obj.isVisible
               obj.isVisible = false
            end
         end
         self.lockedRect.isVisible = true
      elseif( self.lockedImg ) then
         for i = 1, #prefixes do 
            local obj = self[prefixes[i] .. "Img"]
            if( obj and obj._lastVis == nil ) then
               obj._lastVis = obj.isVisible
               obj.isVisible = false
            end
         end
         self.lockedImg.isVisible = true
      else
         self.alpha = alpha or 0.3
      end
      
   end

   -- ==
   --    buttonInstance:enable() - Enables the current button.  (Make button opaque and acknowledge touches.)
   -- ==
   function buttonInstance:enable( ) 
      self.isEnabled = true

      local prefixes = { "unsel", "sel", "toggled", "locked" }
      
      if( self.lockedRect ) then
         for i = 1, #prefixes do 
            local obj = self[prefixes[i] .. "Rect"]
            if( obj and obj._lastVis ~= nil ) then
               obj.isVisible = obj._lastVis
               obj._lastVis = nil
            end
         end
         self.lockedRect.isVisible = false
      elseif( self.lockedImg ) then
         for i = 1, #prefixes do 
            local obj = self[prefixes[i] .. "Img"]
            if( obj and obj._lastVis ~= nil ) then
               obj.isVisible = obj._lastVis
               obj._lastVis = nil
            end
         end
         self.lockedImg.isVisible = false
      else
         self.alpha = 1.0
      end

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
         myLabel:setText( newText )
      else
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
   --    buttonInstance:setLabelColor( color ) - Set the color of the labelText on the current button.
   --
   --    color - A table containing a color code.
   -- ==
   function buttonInstance:setLabelColor( color ) 
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
   function buttonInstance:setHighlight( vis, isEnd ) 
      local isToggleRadio  = (self.buttonType ~= "push")

      -- Rectangle Buttons
      if(self.selRect) then self.selRect.isVisible = vis end
      if(self.unselRect) then self.unselRect.isVisible = (not vis) end


      -- TOGGLE AND RADIO IMAGE BUTTONS
      if( isToggleRadio ) then
         -- BUTTONS WITH TOGGLED IMAGE         
         if(self.toggledImg) then
            if( isEnd ) then
               if( self.isPressed ) then
                  self.toggledImg.isVisible = true

                  -- Handle Selected Image
                  if(self.selImg) then 
                     self.selImg.isVisible = false
                  end

                  -- Finally Handle Not Selected Image
                  if(self.unselImg) then
                     self.unselImg.isVisible = false
                  end

               else
                  self.toggledImg.isVisible = false

                  -- Handle Selected Image
                  if(self.selImg) then self.selImg.isVisible = self.isPressed end

                  -- Finally Handle Not Selected Image
                  if(self.unselImg) then
                     self.unselImg.isVisible = not self.isPressed
                  end
               end               
            else                  
               self.toggledImg.isVisible = (not vis and self.isPressed)
               if(self.selImg) then self.selImg.isVisible = vis end
               if(self.unselImg) then self.unselImg.isVisible = not vis end               
            end

         -- BUTTONS WITH TOGGLED RECT         
         elseif(self.toggledRect) then
            if( isEnd ) then
               if( self.isPressed ) then
                  self.toggledRect.isVisible = true

                  -- Handle Selected Image
                  if(self.selRect) then 
                     self.selRect.isVisible = false
                  end

                  -- Finally Handle Not Selected Image
                  if(self.unselRect) then
                     self.unselRect.isVisible = false
                  end

               else
                  self.toggledRect.isVisible = false

                  -- Handle Selected Image
                  if(self.selRect) then self.selRect.isVisible = self.isPressed end

                  -- Finally Handle Not Selected Image
                  if(self.unselRect) then
                     self.unselRect.isVisible = not self.isPressed
                  end
               end               
            else                  
               self.toggledRect.isVisible = (not vis and self.isPressed)
               if(self.selRect) then self.selRect.isVisible = vis end
               if(self.unselRect) then self.unselRect.isVisible = not vis end               
            end


         -- BUTTONS WITHOUT TOGGLED IMAGE
         else
            if( isEnd ) then
               -- Next Handle Selected Image
               if(self.selImg) then self.selImg.isVisible = self.isPressed  end

               -- Finally Handle Not Selected Image
               if(self.selImg) then
                  self.unselImg.isVisible = not self.selImg.isVisible
               elseif(self.unselImg) then
                  self.unselImg.isVisible = not vis
               end
            else
               -- Next Handle Selected Image
               if(self.selImg) then self.selImg.isVisible = vis or self.isPressed  end

               -- Finally Handle Not Selected Image
               if(self.selImg) then
                  self.unselImg.isVisible = not self.selImg.isVisible
               elseif(self.unselImg) then
                  self.unselImg.isVisible = not vis
               end
            end
            --print( vis, self.isPressed, twoStateSel, isEnd, isToggleRadio, self.highlighted == nil, self.highlighted ~= vis, system.getTimer() )            
         end

      -- PUSH IMAGE BUTTONS
      else
         -- Next Handle Selected Image
         if(self.selImg) then
            self.selImg.isVisible = vis
         end

         -- Finally Handle Not Selected Image
         if(self.unselImg) then
            self.unselImg.isVisible = not vis
         end
      end

      local doOffsetColor = vis or self.isPressed
      if( isToggleRadio and isEnd and not self.isPressed ) then doOffsetColor = false end
      if( not isToggleRadio and not vis ) then doOffsetColor = false end
      if( self.toggledImg ) then doOffsetColor = false end

      if(self.touchOffset) then
         --print(self.x0)
         local xOffset = self.touchOffset[1] or self.x
         local yOffset = self.touchOffset[2] or self.y
         if(doOffsetColor) then                  
            self.x = self.x0 + xOffset
            self.y = self.y0 + yOffset
         else
            self.x = self.x0 
            self.y = self.y0 
         end
      end

      if(self.selLabelColor) then
         if( self.embossColor )  then
            -- DO NOTHING (Idea: add selEmbossColor option?)
         elseif(doOffsetColor) then      
            self.myLabel:setFillColor( unpack( self.selLabelColor ) )
         else
            self.myLabel:setFillColor( unpack( self.labelColor ) )
         end
      end

   end



   ----[[
   -- ==
   --    buttonInstance:setSize( width, height ) - Sets the width and height of the button.
   --    Note: This is an 'editMode' only feature designed to simplify the implementation of 
   --    the editor.  It has NO REALWORLD APPLICATION.  
   --    
   --    width, height - New width and height of button.
   -- ==
   function buttonInstance:setSize( width, height )      
      if( not self.editMode ) then return end
      --[[
      local parts = { "unselRect", "selRect", "unselImgObj", "selImgObj", "overlayRect" }
      self.width = self.w
      self.height = self.h
      print(self.width,self.height)
      for i = 1, #parts do
         if( self[parts[i] ] ) then
            self[ parts[i] ].width = width
            self[ parts[i] ].height = height
         end
      end
      self.width = width
      self.height = height
      print(self.width,self.height)
      --]]

      
      self.xScale = width / self.w
      self.yScale = height / self.h
      if( self.myLabel ) then
         self.myLabel.xScale = 1/self.xScale
         self.myLabel.yScale = 1/self.yScale
      end
--      table.dump(self)
   end   
--]]
   parentGroup:insert( buttonInstance )

   --
   -- Handle Special Alignment Rules (if requested)
   --
   if( buttonInstance.placeRelative ) then
      local dw, dh = display.contentWidth, display.contentHeight
      local aw, ah = display.actualContentWidth, display.actualContentHeight
      local cx,cy = dw/2, dh/2
      -- Q: Would this be more consisten w/ x/y Factors?
      --local xFactor = dw/aw
      --local yFactor = dh/ah
      --print( buttonInstance.placeRelative, dw, dh, dO, cx, cy, aw, ah, round(xFactor,4), round(xFactor,4) )
      
      -- Fix horizontal alignment
      --
      if( buttonInstance.x < cx ) then
         buttonInstance.x = buttonInstance.x - (aw-dw)/2
      elseif( buttonInstance.x > cx ) then
         buttonInstance.x = buttonInstance.x + (aw-dw)/2
      end

      -- Fix vertical alignment
      --
      if( buttonInstance.y < cy ) then
         buttonInstance.y = buttonInstance.y - (ah-dh)/2
      elseif( buttonInstance.y > cy ) then
         buttonInstance.y = buttonInstance.y + (ah-dh)/2
      end      
   end

   buttonInstance.x0 = buttonInstance.x
   buttonInstance.y0 = buttonInstance.y

   function buttonInstance:resetStartPosition()
      --print(self.x, self.y)
      self.x0 = self.x
      self.y0 = self.y
   end

   -- ==
   --    buttonInstance:setSelColor( color ) - Change the selected color.
   --    buttonInstance:setUnselColor( color ) - Change the unselected color.
   --
   --    color - A table containing a color code.
   -- ==
   function buttonInstance:setSelColor( color ) 
      if( self.selRect ) then 
         self.selRect:setFillColor( unpack(color) )
      end
      if( self.selImg ) then 
         self.selImg:setFillColor( unpack(color) )
      end
   end
   function buttonInstance:setUnselColor( color ) 
      if( self.selRect ) then 
         self.unselRect:setFillColor( unpack(color) )
      end
      if( self.selImg ) then 
         self.unselImg:setFillColor( unpack(color) )
      end
   end

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

   sliderKnob.unselImg  = display.newImageRect(sliderKnob, tmpButton.unselKnobImg, tmpButton.kw, tmpButton.kh )
   sliderKnob.selImg    = display.newImageRect(sliderKnob, tmpButton.selKnobImg, tmpButton.kw, tmpButton.kh )

   if(presetData.unselKnobImgFillColor ) then
      local r = fnn(presetData.unselKnobImgFillColor[1], 1)
      local g = fnn(presetData.unselKnobImgFillColor[2], 1)
      local b = fnn(presetData.unselKnobImgFillColor[3], 1)
      local a = fnn(presetData.unselKnobImgFillColor[4], 1)
      sliderKnob.unselImg:setFillColor(r,g,b,a)
   end

   if(presetData.selKnobImgFillColor ) then
      local r = fnn(presetData.selKnobImgFillColor[1], 1)
      local g = fnn(presetData.selKnobImgFillColor[2], 1)
      local b = fnn(presetData.selKnobImgFillColor[3], 1)
      local a = fnn(presetData.selKnobImgFillColor[4], 1)
      sliderKnob.selImg:setFillColor(r,g,b,a)
   end

   sliderKnob.selImg.isVisible = false

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
      self.selImg.alpha = 0.3
      self.unselImg.alpha = 0.3
      self.myKnob.alpha = 0.3
   end

   -- ==
   --    sliderInstance:enable( ) - Enables the slider and makes is opaque.  
   -- ==
   function tmpButton:enable( ) 
      self.isEnabled = true
      self.selImg.alpha = 1.0
      self.unselImg.alpha = 1.0
      self.myKnob.alpha = 1.0		
   end

   return tmpButton, sliderKnob
end


-- ==
--     Easy Rollers, Table Rollers, Table Togglers, etc.
-- ==
local sbc = require "ssk2.core.interfaces.sbc"
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

   sliderKnob.unselImg           = display.newImageRect(sliderKnob, knobImgBase .. ".png", kw, kh )
   sliderKnob.selImg             = display.newImageRect(sliderKnob, knobImgBase .. "Over.png", kw, kh )
   sliderKnob.unselImg.rotation  = sliderKnob.rotation
   sliderKnob.selImg.rotation    = sliderKnob.rotation
   sliderKnob.selImg.isVisible   = false

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
      self.selImg.alpha = 0.3
      self.unselImg.alpha = 0.3
      self.myKnob.alpha = 0.3
   end

   -- ==
   --    sliderInstance:enable( ) - Enables the slider and makes is opaque.  
   -- ==
   function tmpButton:enable( ) 
      self.isEnabled = true
      self.selImg.alpha = 1.0
      self.unselImg.alpha = 1.0
      self.myKnob.alpha = 1.0		
   end

   return tmpButton, sliderKnob
end

-- ============= touch() -- Touch handler for all button types (INTERNAL ONLY)
function buttons:touch( params )
   -- Is this button being displayed in the editor? 
   -- If so, abort the touch early
   if( params.target.editMode == true ) then return false end   

   --for k,v in pairs(params) do print(k,v) end
   local result         = true
   local id		         = params.id 
   local theButton      = params.target 
   local phase          = params.phase
   local selImg         = theButton.selImg
   local unselImg       = theButton.unselImg
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

      if(theKnob and theKnob.selImg) then -- This is a slider
         theKnob.selImg.isVisible = true
         theKnob.unselImg.isVisible = false
      end

      theButton:setHighlight(true)
      display.getCurrentStage():setFocus( theButton, id )
      theButton.isFocus = true

      -- Only Pushbutton fires event here
      if(buttonType == "push") then
         -- PUSH BUTTON
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
            if( onEvent ) then result = result and onEvent( buttonEvent ) end
         elseif(buttonType == "toggle") then
            theButton:setHighlight(isWithinBounds)
            if( onEvent ) then onEvent( buttonEvent ) end
         elseif(buttonType == "radio") then
            theButton:setHighlight(isWithinBounds)
            if( onEvent ) then result = result and onEvent( buttonEvent ) end
         end

      elseif(phase == "ended" or phase == "cancelled") then

         if(buttonType == "push") then -- PUSH BUTTON

            if(theKnob and theKnob.selImg) then -- This is a slider
               theKnob.selImg.isVisible   = false
               theKnob.unselImg.isVisible = true
            end

            theButton.isPressed = false
            theButton:setHighlight(false, true)

            if isWithinBounds then
               if( sound ) then audio.play( sound ) end
               if( releaseSound ) then audio.play( releaseSound ) end
               if( onRelease ) then result = result and onRelease( buttonEvent ) end
               if( onEvent ) then result = result and onEvent( buttonEvent ) end
            end

         elseif(buttonType == "toggle") then -- TOGGLE BUTTON				

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
            --theButton:setHighlight(isWithinBounds,true)
            theButton:setHighlight(theButton.isPressed,true)

         elseif(buttonType == "radio") then -- RADIO BUTTON

            if isWithinBounds then
               if( not parent.currentRadio ) then

               elseif( parent.currentRadio ~= theButton ) then
                  local oldRadio = parent.currentRadio
                  if( oldRadio ) then                     
                     oldRadio.isPressed = false
                     oldRadio:setHighlight(false)
                     --oldRadio.x = oldRadio.x0
                     --oldRadio.y = oldRadio.y0
                     local prefixes = { "unsel", "sel", "toggled", "locked" }                     
                     for i = 1, #prefixes do 
                        local obj = oldRadio[prefixes[i] .. "Img"]
                        if( obj ) then obj._lastVis = nil end
                        local obj = oldRadio[prefixes[i] .. "Rect"]
                        if( obj ) then obj._lastVis = nil end
                     end
                  end
               end

               parent.currentRadio = theButton
               buttonEvent.theButton = theButton

               theButton.isPressed = true
               if( sound ) then audio.play( sound ) end
               if( releaseSound ) then audio.play( releaseSound ) end
               if( onRelease ) then result = result and onRelease( buttonEvent ) end

            end
            if( onEvent ) then result = result and onEvent( buttonEvent ) end

            theButton:setHighlight(theButton.isPressed, true)
         end

         -- Allow touch events to be sent normally to the objects they "hit"
         display.getCurrentStage():setFocus( theButton, nil )
         
         theButton.isFocus = false
      end
   end
   return result
end

-- Attach custom button builders to button library
-- Note: These were designed explicitly for my editor to make the design and 
-- generation of code easier for me to achieve and easier for users to understand.
local customButtons = require "ssk2.core.interfaces.customButtons"
customButtons.attach( buttons )
return buttons