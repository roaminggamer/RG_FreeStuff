-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
--                              License
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
local multiScroller = {}
_G.ssk = _G.ssk or {}
_G.ssk.multiScroller = multiScroller

---
---
-- Forward Declarations
local newCircle         = ssk.display.circle
local newRect           = ssk.display.rect
local newImageRect      = ssk.display.imageRect

-- Lua and Corona
local mAbs              = math.abs
local mRand             = math.random
local mDeg              = math.deg
local mRad              = math.rad
local mCos              = math.cos
local mSin              = math.sin
local mAcos             = math.acos
local mAsin             = math.asin
local mSqrt             = math.sqrt
local mCeil             = math.ceil
local mFloor            = math.floor
local mAtan2            = math.atan2
local mPi               = math.pi

local getInfo           = system.getInfo
local getTimer          = system.getTimer
local strMatch          = string.match
local strFormat         = string.format
local pairs             = pairs
local fnn               = fnn


-- Local
local dragMode = "click"
local hDragMin = 10


-- Forward Declarations

-- Callbacks/Functions
local onOverlayTouch
local onVScrollTouch
local onContentTouch
local onContentTouch2

----------------------------------------------------------------------
--
----------------------------------------------------------------------
multiScroller.createVScroller = function( group, params )
    params = params or {}
    local x             = params.x or 0
    local y             = params.x or y
    local ox, oy        = group:localToContent( group.x, group.y )
    local cTop          = (params.cTop or 0) 
    local cTopActual    = cTop -- (oy == 0) and (cTop - unusedHeight/2) or cTop
    local contentH      = params.contentH or h - cTop + unusedHeight
    local cFill         = params.cFill or { 1, 1, 1, 1 }
    local sFill         = params.sFill or { 1, 1, 1, 1 }
    local throwEasing   = params.throwEasing or easing.inOutQuad -- easing.outCirc
    local throwFriction = params.throwFriction or 0.92 -- 0.972
    local passThrough   = fnn(params.passThrough, true )

    local throwDiminish = 20

    if(params.debug) then
        print("Calculated values: ", cTop, cTopActual, contentH)
        print("Calculated values: ", cTop, cTopActual, contentH)
        print("Calculated values: ", cTop, cTopActual, contentH)
    end
        
    if(cTop < 0) then print( "ERROR: cTop cannot be negative" ) end

    local underlayG
    local overlayG
    local contentG = display.newGroup()
    underlayG = display.newGroup()
    overlayG = display.newGroup()
    group:insert(underlayG)
    group:insert(contentG)
    group:insert(overlayG)      

    contentG.underlayG      = underlayG
    contentG.overlayG       = overlayG

    -- Adjust position of content group and attach settings
    contentG.x              = x
    contentG.y              = y -- cTopActual
    contentG.cTop           = cTop
    contentG.y0             = contentG.y
    contentG.throwEasing    = throwEasing
    contentG.passThrough    = passThrough
    contentG.isActive       = false
    contentG.isVisible      = false

    -- Overlay Touch
    local overlayTouch  

    overlayTouch = newImageRect( overlayG, centerX, centerY, "images/fillW.png",
                                 { alpha = 0.5, w = 100000, h = 100000,  fill = _W_,  
                                 isHitTestable = false } )

    if( params.touchX ) then
        overlayTouch.x = params.touchX 
    end

    -- Vertical Scroll Touch
    local scrollTouch 
    scrollTouch = newImageRect( overlayG, centerX, centerY, "images/fillT.png",
                                   { w = 100000, h = 100000,
                                     fill = _R_, alpha = 0.5 } )
    scrollTouch:toBack()
    if( params.touchX ) then
        scrollTouch.x = params.touchX 
    end
    
    --scrollTouch.dragLayer = contentG

    -- Track my touchLayers
    contentG.overlayTouch   = overlayTouch
    contentG.scrollTouch    = scrollTouch

    -- Content Filler
    local contentFill  = newImageRect( contentG, centerX, contentH/2, "images/fillT.png",
                                       { w = w + unusedWidth, h = contentH, fill = _T_, 
                                         isHitTestable = false } )
    
    -- Utility functions for drag layer (contentG)
    contentG.belowTop = function( self, offset )
        offset = offset or 0
        return self.y > (cTopActual + offset)
    end
    contentG.aboveBottom = function( self, offset )
        offset = offset or 0
        return (self.y + self.contentHeight + offset) < (h + unusedHeight/2)
    end
    
    contentG.belowTopBy = function( self, offset )
        offset = offset or 0
        local by = self.y - (cTopActual + offset)
        if( by > 0 ) then
            return by
        end
        return 0
    end
    contentG.aboveBottomBy = function( self, offset )
        offset = offset or 0
        by = (self.y + self.contentHeight + offset) - (h + unusedHeight/2)
        if( by < 0 ) then
            return mAbs(by)
        end
        return 0
    end
    
    contentG.alignToTop = function( self, offset )
        offset = offset or 0
        self.y = cTopActual + offset        
    end
    contentG.alignToBottom = function( self, offset )
        offset = offset or 0
        self.y = (h + unusedHeight/2) - self.contentHeight - offset
        --self.y = self.y0
    end

    contentG.alignToTopDelayed = function( self, delay, time, myEasing )
        --print( self.y, cTopActual, offset )
        transition.to( self, { y = cTopActual, delay = delay or 0, time = time or 0, transition = myEasing or throwEasing } ) 
    end
    contentG.alignToBottomDelayed = function( self, delay, time, myEasing )
        --print( "BOB", self.y, cTopActual, offset )
        transition.to( self, { y = (h + unusedHeight/2) - self.contentHeight, delay = delay or 0, time = time or 0, transition = myEasing or throwEasing } ) 
        --transition.to( self, { y = self.y0, delay = delay or 0, time = time or 0, transition = myEasing or throwEasing } ) 
    end

    -- Attach touch listenerers
    overlayTouch.touch = onOverlayTouch
    overlayTouch:addEventListener( "touch" )

    scrollTouch.touch = onVScrollTouch
    scrollTouch:addEventListener( "touch" )

    local function capMovement()
        if( contentG == nil or contentG.removeSelf == nil ) then return end
        
        if( contentG:belowTop() ) then 
            contentG:alignToTop() 
            contentG._update = false
            contentG._velocity = 0
        end
        if( contentG:aboveBottom() ) then 
            contentG:alignToBottom() 
            contentG._update = false
            contentG._velocity = 0
        end
    end

    local function capMovement2()
        if( contentG == nil or contentG.removeSelf == nil ) then return end
        if( contentG._rebounding ) then return end

        local executeRebound = false
        if( contentG:belowTop() ) then 
            contentG:alignToTopDelayed( 60, 200, easing.linear ) 
            contentG._rebounding = true
            executeRebound = true
        
        elseif( contentG:aboveBottom() ) then 
            contentG:alignToBottomDelayed( 60, 200, easing.linear ) 
            contentG._rebounding = true
            executeRebound = true       
        end     
        if( executeRebound ) then
            timer.performWithDelay( 30,
                function()
                    --contentG._update = false
                    contentG._velocity = 0
                    --contentG._rebounding = false
                end )
        end
    end

    contentG.scrollLimit = function( self )     
        if( self == nil or self.removeSelf == nil ) then return end
        
        if( self:belowTop( 60 ) ) then 
            self:alignToTop( 60 ) 
            self._velocity = 0
            return true
        end
        if( self:aboveBottom( 60 ) ) then 
            self:alignToBottom( 60 ) 
            self._velocity = 0
            return true
        end
        return false
    end

    contentG.scrollLimit2 = function( self, lastY, dy, limit )
        if( self == nil or self.removeSelf == nil ) then return end
        local belowTopBy    = self:belowTopBy( 0 )
        local aboveBottomBy = self:aboveBottomBy( 0 )
        local dyMult        = 1
        if( belowTopBy > 0 ) then
            dyMult = belowTopBy
        elseif( aboveBottomBy > 0 ) then
            dyMult = aboveBottomBy
        end
        
        if( dyMult == 0 ) then
            self.y = lastY + dy
        else
            dyMult = 1 - (dyMult/limit)     

            --print("A", round(dyMult*100), round(belowTopBy), round(aboveBottomBy), round(limit) )
            self.y = lastY + dy * dyMult
        end
        return false
    end

    -- Handle throwing
    --
    contentG._track = false
    contentG._update = false
    contentG._friction = throwFriction
    contentG._velocity = 0
    contentG._rebounding = false

    local lastTime = getTimer()
    local lastY 
    contentG.enterFrame = function( self, event )
        if( not self or self.removeSelf == nil ) then 
            ignore("enterFrame", self)
            return
        end
        self.overlayG:toFront()
        self.underlayG:toBack()
        if(lastY == nil) then
            lastY = self.y
            return
        end
        
        local dy = self.y - lastY
        lastY = self.y

        local curTime = getTimer()
        local dt = curTime - lastTime
        lastTime = curTime

        if( self._rebounding == true and dy == 0 and not self:belowTop() and not self:aboveBottom() ) then
            self._rebounding = false
            --print("DONE REBOUNDING", round(dy,2), round(self.y,2), cTopActual, self._rebounding)
        end

        -- Dragging Move
        if( dy ~= 0 and not self._update ) then
            post( "onVScroll", { target = self, x = self.x, y = self.y, dy = dy, phase == event.phase } )
            --print("A - Dragging ", round(dy,2), round(self.y,2), cTopActual, self._rebounding)
        end

        if( self._update ) then
            capMovement2()
            --print("B", round(dy,2), round(self.y,2), cTopActual, self._rebounding)
            --post( "onVScroll", { target = self, x = self.x, y = self.y, dy = dy } )
            self._velocity = self._velocity * self._friction
            if( mAbs( self._velocity ) < 0.01 ) then
                self._velocity = 0
                self._update = false
                post( "onVScroll", { target = self, x = self.x, y = self.y, dy = dy, phase == event.phase} )
                --print("DONE DRAGGING", round(dy,2), round(self.y,2), cTopActual, self._rebounding)
            end
            if( mAbs(self._velocity) > 0 ) then
                self.y = self.y + dt * self._velocity       
                post( "onVScroll", { target = self, x = self.x, y = self.y, dy = dy } )     
            end
        end
    end
    --listen( "enterFrame", contentG )


    -- Activate/Deactivate
    contentG.setActive = function( self, status, params )
        if( status and not self.isActive ) then
            --overlayTouch:addEventListener( "touch" )          
            --scrollTouch:addEventListener( "touch" )
            scrollTouch.dragLayer = contentG
            listen( "enterFrame", contentG )
            self.isVisible = true
        elseif( not status and self.isActive ) then
            --overlayTouch:removeEventListener( "touch" )
            --scrollTouch:removeEventListener( "touch" )
            scrollTouch.dragLayer = nil
            ignore( "enterFrame", contentG )
            self.isVisible = false
        end
        self.isActive = status
    end

    contentG:setActive( true )

    return contentG
end

-- Callbacks/Functions
--EFM local throwing = false
onOverlayTouch = function( self, event  )
    if( event.phase == "began" ) then
        dragMode = "click"
    elseif(event.phase == "moved") then
        local dx = event.x - event.xStart
        local dy = event.y - event.yStart
        if( dragMode == "click" ) then
            if( mAbs(dy) > 15 ) then                
                dragMode = "vert"
            elseif( mAbs(dx) > hDragMin ) then 
                dragMode = "horiz"
            end
        elseif( dragMode == "vert") then
        elseif( dragMode == "horiz") then
        end         
    elseif(event.phase == "ended" or event.phase == "cancelled") then
        --dragMode = "click"
        timer.performWithDelay( 1, function() dragMode = "click" end )
    end
    --print(dragMode)
    return false
end

local lastTime
onVScrollTouch = function( self, event  )   
    --print("BOB", dragMode)
    if( dragMode ~= "vert" ) then return false end
    local dragLayer     = self.dragLayer
    local retval        = not (self.passThrough)

    if( not dragLayer ) then return false end

    if( not lastTime ) then lastTime = event.time-1 end

    if( event.phase == "moved" and lastTime ~= eventTime ) then     
        lastTime = eventTime
        dragLayer._update = false   
        dragLayer._dragging = true

        if( dragLayer.lastY == nil) then
            dragLayer.lastY = dragLayer.y
            dragLayer.yd = event.y
            dragLayer.ytd = event.time
        else
            local dy = event.y - dragLayer.yd
            dragLayer.yd = event.y          
            local dt = event.time - dragLayer.ytd
            dragLayer.ytd = event.time

            local vel = dy/dt
            if( mAbs( vel ) > 2 ) then
                if( vel < 0 ) then
                    vel = -2
                else
                    vel = 2
                end
            end
            dragLayer._velocity = vel
            dragLayer:scrollLimit2( dragLayer.lastY, dy, fullh * 0.4)
            --dragLayer.y = dragLayer.lastY + dy
            dragLayer.lastY = dragLayer.y
        end     
    
    elseif(event.phase == "ended" or event.phase == "cancelled") then
        dragLayer.lastY = nil
        dragLayer.yd = nil
        dragLayer.ytd = nil
        dragLayer._update = true
        dragLayer._rebounding = false
        dragLayer._dragging = false
    end

    return retval
end


multiScroller.addContentTouch = function( obj, touch )
    obj._touch = touch
    obj.touch = onContentTouch
    obj:addEventListener( "touch" )
    -- isShowing
    -- onShowing
    -- onNotShowing
end


-- The function will only pass "ended" phases
onContentTouch = function( self, event )
    if(dragMode ~= "click") then return false end

    if(event.phase ~= "ended") then return false end 

    if(self._touch) then 
        return self:_touch( event ) 
    end
end


multiScroller.addContentTouch2 = function( obj, touch )
    obj._touch = touch
    obj.touch = onContentTouch2
    obj:addEventListener( "touch" )
end

-- The function will only pass "ended" phases
onContentTouch2 = function( self, event )
--EFM    if(throwing) then return false end -- Stay out while throwing EFM
    --if(dragMode ~= "horiz") then return false end

    if(self._touch) then 
        return self:_touch( event ) 
    end
end


-- This calls a function (just once) when this object is determined to be actually on screen.
multiScroller.addOnScreenExecute = function( obj, cb, buffer, cb2 )
    buffer = buffer or 0

    local enterFrame
    local frameCount = 0
    enterFrame = function()
        frameCount = frameCount + 1
        if( frameCount % 3 > 0) then return end
        if( obj == nil or obj.removeSelf == nil ) then
            ignore( "enterFrame", enterFrame )
            return 
        end

        local parent = obj.parent       
        while( parent ) do              
            if(parent.isVisible == false) then return end
            parent = parent.parent
        end

        if( obj._toggledOnScreen and not _G.enableMemPurge ) then return end

        local xMax = w + unusedWidth/2 + buffer
        local xMin = -unusedWidth/2 - buffer
        local yMax = h + unusedWidth/2 + buffer
        local yMin = -unusedWidth/2 - buffer
        local x,y = obj.parent:localToContent( obj.x, obj.y )
        local onScreen = true 

        if( x > xMax ) then onScreen = false end
        if( x < xMin ) then onScreen = false end
        if( y > yMax ) then onScreen = false end
        if( y < yMin ) then onScreen = false end

        if( onScreen ) then
            --print("Is On Screen - 000 ", getTimer())
            if( cb2 == nil ) then
                --print("Is On Screen - 111 ", getTimer())
                ignore( "enterFrame", enterFrame )
            end
            if( not obj._toggledOnScreen ) then
                --print("Is On Screen - 222 ", getTimer())
                cb( obj )
                obj._toggledOnScreen = true
                obj._toggledOffScreen = false
            end
        elseif( not obj._toggledOffScreen  ) then                               
            --print("Is Off Screen - AAA ", getTimer())
            if( cb2 ) then                  
                --print("Is Off Screen - BBB ", getTimer())
                cb2( obj )
                obj._toggledOffScreen = true
            else
                obj._toggledOffScreen = true
            end
            obj._toggledOnScreen = false
        end

    end
    listen("enterFrame",enterFrame)
end



multiScroller.takeFocus = function( obj, id )
    if( id ) then 
        display.currentStage:setFocus( obj, id )
        obj.hasFocus = true
    else
        display.currentStage:setFocus( obj )
        obj.hasFocus = true
    end
end

multiScroller.releaseFocus = function( obj, id )
    display.currentStage:setFocus( obj, nil )
    obj.hasFocus = false
end

multiScroller.isShowing = isShowing

multiScroller.resetDragMode = function() 
    dragMode = "click" 
end

return multiScroller