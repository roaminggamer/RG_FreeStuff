-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local vScroller = {}

_G.ssk = _G.ssk or {}
_G.ssk.vScroller = vScroller


-- =============================================================
-- Localizations
-- =============================================================
-- Lua
local mAbs = math.abs
local pointInRect = display.pointInRect

function vScroller.new( group, x, y, params )
   group   = group or display.currentStage
   params  = params or {}

   local cw             = params.w or fullw
   local ch             = params.h or fullh
   local backFill       = params.backFill
   local hideBack       = fnn( params.hideBack, backFill == nil )
   local autoScroll     = fnn(params.autoScroll, false )
   local scrollBuffer   = params.scrollBuffer or 0

   local widget = require( "widget" )
   widget.setTheme( params.widgetTheme or "widget_theme_android_holo_dark")

   local function passOnTouch( theScroll, event )
      --table.dump( event, nil, "passOnTouch" )
      --table.dump( theScroll.notifyObjects, nil, "passOnTouch" )

      -- Pass to global listener set first
      post("onScrollerTouch", { scroller = theScroll, event = event } )

      -- Pass to child objects second
      if( theScroll.notifyObjects ) then
         for k,v in pairs( theScroll.notifyObjects ) do
            --print("Notify", event.phase, theScroll.dragged, event.dragged )
            if( v.touch ) then v:touch( event ) end
         end
      end

      if( event.phase == "ended" or event.phase == "cancelled" ) then
         theScroll.notifyObjects = {}
      end

      -- Pass to custom scroll listener last
      if( params.listener ) then
         params.listener( theScroll, event )
      end
   end

   local listener = function( event )    
      local target = event.target

      if( event.phase == "began" ) then
         --print("onScrollerTouch - began")

         target.dragged = false

         --for k,v in pairs( target.potentialNotifyObjects ) do
         for i = 1, #target.potentialNotifyObjects do
            local v = target.potentialNotifyObjects[i]
            if( v.touch and pointInRect( event, v ) ) then 
               target.notifyObjects[v] = v 
            end
         end
      
      elseif( event.phase == "moved" ) then
         local dragTrigger = ( mAbs(event.y - event.yStart) > (params.dragDist or 10 ) ) or 
                             ( mAbs(event.x - event.xStart) > (params.dragDist or 10 ) )
         if( not target.dragged and dragTrigger ) then 
            --print("DRAGGED!")
         end
         target.dragged = target.dragged or dragTrigger
      
      elseif( event.phase == "ended" ) then
         --table.dump( event, nil, "onScrollerTouch - ended")
      end

      if( event and event.phase ) then
         --print("PASS IT ON")
         event.dragged = target.dragged
         passOnTouch( target, event )
      else
         --table.dump( event, nil, "WTH" )
      end
      
      return true
   end

   -- Create a scrollView
   local scroller = widget.newScrollView {
      --parent                      = group,
      left                          = x - cw/2,
      top                           = y - ch/2,
      width                         = cw,
      height                        = ch,

      hideBackground                = hideBack,
      backgroundColor               = backFill,

      isBounceEnabled               = fnn(params.isBounceEnabled, true),
      isVBounceEnabled              = fnn(params.isBounceEnabled, true),
      isHBounceEnabled              = fnn(params.isHBounceEnabled, false),
      
      horizontalScrollDisabled      = fnn(params.horizontalScrollingDisabled, true),
      verticalScrollDisabled        = fnn(params.verticalScrollingDisabled, false),
      
      listener                      = listener
   }



   local totalH = 0

   scroller._isvScroller = true

   group:insert(scroller)

   if( params.placeByTopLeft ) then
      scroller.anchorX = 0
      scroller.anchorY = 0
      scroller.x = x
      scroller.y = y
   elseif( params.placeByTopCenter ) then
      scroller.anchorX = 0.5
      scroller.anchorY = 0
      scroller.x = x
      scroller.y = y
   end

   scroller.potentialNotifyObjects = {}
   scroller.notifyObjects = {}

   function scroller.addTouch( self, obj, onTouch )
      --self.potentialNotifyObjects[obj] = obj
      self.potentialNotifyObjects[#self.potentialNotifyObjects+1] = obj
      obj.touch = onTouch
      --obj:addEventListener("touch")
   end

   function scroller.alignToTop( self, time )
      self:scrollToPosition( { y = 0, time = time }  )
   end
   
   function scroller.alignToBottom( self, time )
      local toY = -self:getView().contentHeight + ch
      self:scrollToPosition( { y = toY, time = time }  )
   end

   function scroller.alignToY( self, toY, time )
      local toY = -toY
      local maxY = -self:getView().contentHeight + ch
      toY = (toY < maxY) and maxY or toY
      self:scrollToPosition( { y = toY, time = time }  )
   end

   function scroller.insertContent( self, obj, params )
      params = params or {}
      local ox    = params.ox or 0
      local oy    = params.oy or 0
      local x     = 0
      local y     = 0


      -- groups are placed by <0,0> as upper-left corner (start of content)
      -- Where content moves down and right
      if( obj.__isGroup and not obj.__isContainer ) then
         x = ox
         y = totalH + oy 

      -- All other objects are placed by their relative anchors just like normal objects
      else         
         x = ox + obj.contentWidth * obj.anchorX
         y = oy + totalH + obj.contentHeight * obj.anchorY                  
      end

      x = params.x or x
      y = params.y or y

      obj.x = x
      obj.y = y

      if( params.skipScrollBuffering ) then 
         --print("SKIPPING BUFFER ADJUST ", totalH )
         self:insert( obj )

      else
         --print("ADJUSTING BUFFER ", totalH )

         -- SCROLL BUFFER
         local _scrollBuffer = self._scrollBuffer
         if( scrollBuffer and _scrollBuffer ) then            
            display.currentStage:insert( _scrollBuffer )
         else
            _scrollBuffer = display.newRect( cw/2, 0, 10, scrollBuffer )
            _scrollBuffer.anchorY = 0
            _scrollBuffer.isVisible = false
            self._scrollBuffer = _scrollBuffer
         end

         totalH = totalH + obj.contentHeight + oy

         -- SCROLL BUFFER
         if( scrollBuffer and _scrollBuffer ) then
            self:insert( _scrollBuffer )
            _scrollBuffer.y = totalH
         end

         self:insert( obj )

         if( autoScroll or params.autoScroll ) then
            local toY = obj.y + obj.contentHeight - ch
            if( scrollBuffer ) then
               toY = toY + scrollBuffer
            end

            --print( "vscroller ", scroller.contentHeight, ch, toY, obj.contentHeight )
            if( toY > 0 ) then            
               --print("Scroll to" .. -toY)
               if( scrollBuffer ) then
                  scroller:scrollToPosition( { y = -toY, time = 500 })
               else
                  scroller:scrollToPosition( { y = -toY, time = 500 })
               end
            end
         end
      end
   end

   function scroller.insertText( self, text, params )
      params = params or {}
      local ox          = params.ox or 0
      local oy          = params.oy or 0
      local fontColor   = params.fontColor or _W_
      local fontSize    = params.fontSize or 22
      local font        = params.font or native.systemFont

      local options = 
      {
          text       = text,
          x          = 0,
          y          = 0,
          width      = scroller.contentWidth - ox * 2,
          font       = font,
          fontSize   = fontSize,     
      }   
      local textObj = display.newText( options )
      textObj:setFillColor( unpack( fontColor ) )  
      self:insertContent( textObj, params )
   end   

   return scroller
end


return vScroller



   --[[
   function scroller.insertContent_alt( self, obj, params )
      params = params or {}
      local ox    = params.ox or 0
      local oy    = params.oy or 0
      local x     = 0
      local y     = 0


      -- Objects in group must be placed right and below <0,0>
      if( obj.__isGroup and not obj.__isContainer ) then
         --print( obj.contentWidth)
         --print( obj.contentHeight)
         x = ox + obj.contentWidth/2
         y = totalH + oy + obj.contentHeight/2
      else
         x = ox + obj.contentWidth * obj.anchorX
         y = oy + totalH + obj.contentHeight * obj.anchorY         
      end

      obj.x = x
      obj.y = y

      totalH = totalH + obj.contentHeight + oy

      self:insert( obj )

      if( params.autoScroll ) then
         local toY = obj.y + obj.contentHeight - ch
         if( toY > 0 ) then            
            --print("Scroll to" .. -toY)
            scroller:scrollToPosition( { y = -toY, time = 500 })
         end
      end
   end
   ]]

   --[[
   function scroller.insertContent_old( self, obj, params )
      params = params or {}
      local ox    = params.ox or 0
      local oy    = params.oy or 0
      local x     = ox + obj.contentWidth * obj.anchorX
      local y     = oy + totalH + obj.contentHeight * obj.anchorY

      -- Objects in group must be placed right and below <0,0>
      if( obj.__isGroup and not obj.__isContainer ) then
         x = ox
         y = oy + totalH
      end

      obj.x = x
      obj.y = y

      totalH = totalH + obj.contentHeight + oy

      self:insert( obj )

      if( params.autoScroll ) then
         local toY = obj.y + obj.contentHeight - ch
         if( toY > 0 ) then            
            print("Scroll to" .. -toY)
            scroller:scrollToPosition( { y = -toY, time = 500 })
         end
      end
   end
   --]]
