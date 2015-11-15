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
local createHScroller 
local addFloater

-- Callbacks/Functions
local onOverlayTouch
local onVScrollTouch
local onHScrollTouch
local onHScrollTouchExternal
local onContentTouch
local onContentTouch2

----------------------------------------------------------------------
--
----------------------------------------------------------------------
multiScroller.createVScroller = function( group, params )
    params = params or {}
    local cTop          = (params.cTop or 0) 
    local cTopActual    = cTop - unusedHeight/2
    local contentH      = params.contentH or h - cTop + unusedHeight
    local cFill         = params.cFill or { 1, 1, 1, 1 }
    local sFill         = params.sFill or { 1, 1, 1, 1 }
    local throwEasing   = params.throwEasing or easing.inOutQuad -- easing.outCirc
    local throwFriction = params.throwFriction or 0.92 -- 0.972
    local passThrough   = fnn(params.passThrough, true )
    local peerScroller  = params.peer 

    local throwDiminish = 20

    if(params.debug) then
        --print("Calculated values: ", cTop, cTopActual, contentH)
        --print("Calculated values: ", cTop, cTopActual, contentH)
        --print("Calculated values: ", cTop, cTopActual, contentH)
    end
        
    if(cTop < 0) then print( "ERROR: cTop cannot be negative" ) end

    local underlayG
    local overlayG
    local contentG = display.newGroup()
    if( peerScroller ) then
        underlayG = peerScroller.underlayG
        overlayG = peerScroller.overlayG
        group:insert(contentG)
    else
        underlayG = display.newGroup()
        overlayG = display.newGroup()
        group:insert(underlayG)
        group:insert(contentG)
        group:insert(overlayG)      
    end
    contentG.underlayG      = underlayG
    contentG.overlayG       = overlayG

    -- Adjust position of content group and attach settings
    contentG.y              = cTopActual
    contentG.cTop           = cTop
    contentG.y0             = contentG.y
    contentG.throwEasing    = throwEasing
    contentG.passThrough    = passThrough
    contentG.isActive       = false
    contentG.isVisible      = false

    -- Overlay Touch
    local overlayTouch  

    if( peerScroller ) then
        overlayTouch = peerScroller.overlayTouch
    else
        overlayTouch = newImageRect( overlayG, centerX, centerY, "images/fillT.png",
                                     { w = w + unusedWidth, 
                                       h = h + unusedHeight, fill = sFill, 
                                       isHitTestable = false } )
    end

    -- Vertical Scroll Touch
    local scrollTouch 
    if( peerScroller ) then
        scrollTouch = peerScroller.scrollTouch
    else
        scrollTouch = newImageRect( overlayG, centerX, centerY, "images/fillT.png",
                                       { w = w + unusedWidth, h = h + unusedHeight,
                                         fill = _R_, alpha = 0.5 } )
        scrollTouch:toBack()
    end
    
    --scrollTouch.dragLayer = contentG

    -- Track my touchLayers
    contentG.overlayTouch   = overlayTouch
    contentG.scrollTouch    = scrollTouch

    -- Content Filler
    local contentFill  = newImageRect( contentG, centerX, contentH/2, "images/fillT.png",
                                   { w = w + unusedWidth, h = contentH, fill = cFill, isHitTestable = false } )
    
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
    end

    contentG.alignToTopDelayed = function( self, delay, time, myEasing )
        transition.to( self, { y = cTopActual, delay = delay or 0, time = time or 0, transition = myEasing or throwEasing } ) 
    end
    contentG.alignToBottomDelayed = function( self, delay, time, myEasing )
        transition.to( self, { y = (h + unusedHeight/2) - self.contentHeight, delay = delay or 0, time = time or 0, transition = myEasing or throwEasing } ) 
    end

    -- Attach touch listenerers
    if( not peerScroller ) then
        overlayTouch.touch = onOverlayTouch
        overlayTouch:addEventListener( "touch" )
    end
    if( not peerScroller ) then
        scrollTouch.touch = onVScrollTouch
        scrollTouch:addEventListener( "touch" )
    end

    -- Add methods for adding horizontal scroller
    contentG.createHScroll = createHScroller
    contentG.addFloater = addFloater

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

    if( not peerScroller ) then
        contentG:setActive( true )
    end


    return contentG
end

createHScroller = function( self, y, height, params )
    height              = height or 100
    y                   = y or height/2
    params              = params or {}
    local cLeft         = params.cLeft or -unusedWidth/2
    local cRight        = w + unusedWidth/2
    local width         = w + unusedWidth
    local contentW      = w + unusedWidth
    local cFill         = params.cFill or { 1, 1, 1, 1 }
    local sFill         = params.sFill or { 1, 1, 1, 1 }
    local throwEasing   = params.throwEasing or self.throwEasing
    local throwFriction = params.throwFriction or 0.92 -- 0.972
    local external      = fnn(params.external, false)
    local passThrough   = fnn(params.passThrough, true )
    local inContainer   = fnn(params.inContainer, false)


    if( not inContainer and y - height/2 < 0 ) then print( "ERROR: Horizontal scroller placed above or overlapping top of vertial scroller top.", y, height/2 ) end
    if( inContainer and y < -height/2) then print( "ERROR: Horizontal scroller placed above or overlapping top of vertial scroller top.", y, height/2 ) end
        
    local underlayG = display.newGroup()
    local contentG = display.newGroup()
    self:insert(underlayG)
    self:insert(contentG)

    -- Adjust position of content group and attach settings
    contentG.x              = cLeft
    contentG.throwEasing    = throwEasing
    contentG.cy             = y
    contentG.passThrough    = passThrough
    
    -- Horizontal Scroll Touch
    local scrollTouch  = newImageRect( underlayG, cLeft, y, "images/fillT.png",
                                   { w = w + unusedWidth, h = height, fill = _R_, alpha = 0.5, isHitTestable = false, anchorX = 0 } )
    scrollTouch.dragLayer = contentG

    -- Content Filler
    local contentFill  = newImageRect( contentG, width/2, y, "images/fillT.png",
                                   { w = w + unusedWidth, h = height, fill = _G_, alpha = 0.5, isHitTestable = false } )

    -- Utility functions for drag layer (contentG)
    contentG.rightOfLeft = function( self, offset )
        offset = offset or 0
        offset = offset + cLeft
        return self.x > offset
    end
    contentG.leftOfRight = function( self, offset )
        offset = offset or 0
        offset = offset - cLeft

        return (self.x + self.contentWidth + offset) < (w + unusedWidth/2)
    end


    contentG.rightOfLeftBy = function( self, offset )
        offset = offset or 0
        offset = offset + cLeft     
        local by = self.x - offset
        if( by > 0 ) then
            return by
        end
        return 0
    end
    contentG.leftOfRightBy = function( self, offset )
        offset = offset or 0
        offset = offset - cLeft
        by = (self.x + self.contentWidth + offset) - (w + unusedWidth/2) 
        if( by < 0 ) then
            return mAbs(by)
        end
        return 0
    end

    contentG.alignToLeft = function( self, offset )
        offset = offset or 0
        offset = offset + cLeft
        --self.x = 0 - unusedWidth/2 + offset
        self.x = 0 + offset
    end
    contentG.alignToRight = function( self, offset )
        offset = offset or 0
        offset = offset + cLeft
        self.x = (w + unusedWidth/2) - self.contentWidth - offset
    end

    contentG.alignToLeftDelayed = function( self, delay, time, myEasing )
        --transition.to( self, { x = 0 - unusedWidth/2 + cLeft, delay = delay or 0, time = time or 0, transition = myEasing or throwEasing } ) 
        transition.to( self, { x = 0 + cLeft, delay = delay or 0, time = time or 0, transition = myEasing or throwEasing } ) 
    end
    contentG.alignToRightDelayed = function( self, delay, time, myEasing )
        transition.to( self, { x = (w + unusedWidth/2) - self.contentWidth + cLeft, delay = delay or 0, time = time or 0, transition = myEasing or throwEasing } ) 
    end

    -- Attach touch listenerers
    if(external) then
        scrollTouch.touch = onHScrollTouchExternal
    else
        scrollTouch.touch = onHScrollTouch
    end 
    scrollTouch:addEventListener( "touch" )

    local function capMovement()
        if( contentG == nil or contentG.removeSelf == nil ) then return end
        
        if( contentG:rightOfLeft() ) then 
            contentG:alignToLeft() 
            contentG._update = false
            contentG._velocity = 0
        end
        if( contentG:leftOfRight() ) then 
            contentG:alignToRight() 
            contentG._update = false
            contentG._velocity = 0
        end
    end

    local function capMovement2()
        if( contentG == nil or contentG.removeSelf == nil ) then return end
        if( contentG._rebounding ) then return end

        local executeRebound = false
        if( contentG:rightOfLeft() ) then 
            contentG:alignToLeftDelayed( 60, 200, easing.linear ) 
            contentG._rebounding = true
            executeRebound = true
        
        elseif( contentG:leftOfRight() ) then 
            contentG:alignToRightDelayed( 60, 200, easing.linear ) 
            contentG._rebounding = true
            executeRebound = true       
        end     
        if( executeRebound ) then
            timer.performWithDelay( 30,
                function()
                    --contentG._update = false
                    contentG._velocity = 0
                    contentG._rebounding = false
                end )
        end
    end

    contentG.scrollLimit = function( self )
        if( self == nil or self.removeSelf == nil ) then return end
        
        if( self:rightOfLeft( 40 ) ) then 
            self:alignToLeft( 40 ) 
            self._velocity = 0                  
            return true
        end
        if( self:leftOfRight( 40 ) ) then 
            self:alignToRight( 40 ) 
            self._velocity = 0
            return true
        end
        return false
    end


    contentG.scrollLimit2 = function( self, lastX, dx, limit )
        if( self == nil or self.removeSelf == nil ) then return end
        local rightOfLeftBy     = self:rightOfLeftBy( 0 )
        local leftOfRightBy = self:leftOfRightBy( 0 )
        local dxMult        = 1
        if( rightOfLeftBy > 0 ) then
            dxMult = rightOfLeftBy
        elseif( leftOfRightBy > 0 ) then
            dxMult = leftOfRightBy
        end
        
        if( dxMult == 0 ) then
            self.x = lastX + dx
        else
            dxMult = 1 - (dxMult/limit)     

            --print("A", round(dxMult*100), round(rightOfLeftBy), round(leftOfRightBy), round(limit) )
            self.x = lastX + dx * dxMult
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
    contentG.enterFrame = function( self, event )
        if( not self or self.removeSelf == nil ) then 
            ignore("enterFrame", self)
            return
        end
        if(self.parent.isVisible == false) then return end
        local curTime = getTimer()
        local dt = curTime - lastTime
        lastTime = curTime

        if( self._update ) then
            capMovement2()
            self._velocity = self._velocity * self._friction
            if( mAbs( self._velocity ) < 0.01 ) then
                self._velocity = 0
                self._update = false
                post( "onHScroll", { target = contentG, x = contentG.x, y = contentG.y, dx = 0 } )
                --print("DONE")
            end
            if( mAbs(self._velocity) > 0 ) then
                self.x = self.x + dt * self._velocity
            end

        end
    end
    listen( "enterFrame", contentG)

    return contentG
end

-- Floaters:
--[[

Style 1 - 
* yMin - Top abutting top of screen.
* yMax - Initial position by default.

Style 2 - 
* yMin - Bottom abutting top of screen.
* yMax - Initial position by default.

Style 3 - Same as style 1, but adjusts yMin to yMin + partner height if partner is visible.
Style 4 - Same as style 2, but adjusts yMin to yMin + partner height if partner is visible.

Style 5 - Same as style 2, but adjusts yMin to yMin - partner height if partner is visible.
Style 6 - Same as style 2, but adjusts yMin to yMin - partner height if partner is visible.

]]
local mover1
local mover2
local mover3

addFloater = function( self, floater, params )
    params = params or {}
    params.style            = params.style or 1
    params.ratio            = params.ratio or 1

    params.yMinOffset       = params.yMinOffset or 0
    params.y0               = params.y0 or floater.y
    params.ignoreRebound    = fnn(params.ignoreRebound, true)
    params.ignoreReboundDown = fnn(params.ignoreReboundDown, true)

    floater._floatTarget = self
    floater._floatParams = params

    if(params.style == 1) then
        if(params.frame) then
            params.yMin     = -(params.frame.y-params.frame.contentHeight/2) - unusedHeight/2  + params.yMinOffset
        else
            params.yMin     = (params.yMin or floater.contentHeight/2) - unusedHeight/2   + params.yMinOffset
        end     
        params.yMax         = params.yMax or floater.y
        floater._move       = mover1
        floater._ly         = self.y
        --print("min/max ", params.yMin,params.yMax)
    
    elseif(params.style == 2) then
        if(params.frame) then
            params.yMin     = -(params.frame.y+params.frame.contentHeight/2) - unusedHeight/2  + params.yMinOffset
        else
            params.yMin     = (params.yMin or floater.contentHeight/2) - unusedHeight/2  + params.yMinOffset
        end     
        params.yMax         = params.yMax or floater.y
        floater._move       = mover1
        floater._ly         = self.y
        --print("min/max ", params.yMin,params.yMax)
    
    elseif(params.style == 3) then
        if(params.frame) then
            params.yMin     = -(params.frame.y-params.frame.contentHeight/2) - unusedHeight/2  + params.yMinOffset 
        else
            params.yMin     = (params.yMin or floater.contentHeight/2) - unusedHeight/2  + params.yMinOffset 
        end     
        params.yMax         = params.yMax or floater.y
        floater._move       = mover2
        floater._ly         = self.y
        --print("min/max ", params.yMin,params.yMax)
    
    elseif(params.style == 4) then
        if(params.frame) then
            params.yMin     = -(params.frame.y+params.frame.contentHeight/2) - unusedHeight/2  + params.yMinOffset
        else
            params.yMin     = (params.yMin or floater.contentHeight/2) - unusedHeight/2  + params.yMinOffset 
        end     
        params.yMax         = params.yMax or floater.y
        floater._move       = mover2
        floater._ly         = self.y
        --print("min/max ", params.yMin,params.yMax)

    elseif(params.style == 5) then
        if(params.frame) then
            params.yMin     = -(params.frame.y-params.frame.contentHeight/2) - unusedHeight/2  + params.yMinOffset 
        else
            params.yMin     = (params.yMin or floater.contentHeight/2) - unusedHeight/2  + params.yMinOffset 
        end     
        params.yMax         = params.yMax or floater.y
        floater._move       = mover3
        floater._ly         = self.y
        --print("min/max ", params.yMin,params.yMax)
    
    elseif(params.style == 6) then
        if(params.frame) then
            params.yMin     = -(params.frame.y+params.frame.contentHeight/2) - unusedHeight/2  + params.yMinOffset
        else
            params.yMin     = (params.yMin or floater.contentHeight/2) - unusedHeight/2 + params.yMinOffset 
        end     
        params.yMax         = params.yMax or floater.y
        floater._move       = mover3
        floater._ly         = self.y
        --print("min/max ", params.yMin,params.yMax)

    end

    local enterFrame
    enterFrame = function( event )
        if( not self or self.removeSelf == nil or 
            not floater or floater.removeSelf == nil ) then
            ignore( "enterFrame", enterFrame )
            return
        end
        if( self.isActive ) then
            floater._move( floater, self )
        end
    end

    listen( "enterFrame", enterFrame )

    --listen( "onVScroll", floater )
end

-- moveFloat2 adjusts own minY if another bar is visible and alpha > 0

local function isShowing( obj )
    local showing = (obj.isVisible == true and obj.alpha > 0)
    local parent = obj.parent
    while(showing and parent) do
        showing = showing and (parent.isVisible == true and parent.alpha > 0)
        parent = parent.parent
    end
    return showing
end

mover1 = function( floater, target )
    local params        = floater._floatParams
    local master        = params.master

    if( floater._ly == nil ) then
        floater._ly = target.y
        return
    end

    local dy =  target.y - floater._ly
    floater._ly = target.y

    -- Target changed, start tracking new target and skip one round of updates.
    if( floater._lastTarget ~= target ) then
        floater._lastTarget = target

        -- If this floater has a 'master' object, ensure that the 
        -- currently re-activated target is not aligned below
        -- the master's bottom edge
        if( master ) then
            local mo = params.masterOffset or 0
            local minY = floater.y + master.y + master.contentHeight/2

            if( isShowing( master ) == false ) then
                --mo = 0
                --minY = floater.y + master.y - master.contentHeight/2
            end

            if(target.y > minY) then
                target.y = minY + mo
            end

            --print("TARGET CHANGED ", floater, target, master, target.y, mo, minY)         
            if(target:aboveBottom()) then
                print("Aligning to bottom")
                target:alignToBottomDelayed(30, 0, easing.linear ) 
            end
        end

        floater._ly = nil

        return
    end



--print(floater, floater._ly, getTimer())

    if( dy == 0 ) then return end

    local ratio         = params.ratio
    local ignoreRebound = params.ignoreRebound
    local ignoreReboundDown = params.ignoreReboundDown
    
    -- Only move while not rebounding (unless explicitly allowed)
    if(ignoreRebound == false or target._rebounding == false) then
        if(dy > 0) then
            floater.y = floater.y + dy
        else
            floater.y = floater.y + dy * ratio
        end
    elseif(ignoreReboundDown == false) then
        if(dy > 0) then
            floater.y = floater.y + dy
        end
    end

    -- Check for movment breaches
    if( floater.y < params.yMin ) then
        --print("min ",round(floater.y), params.yMin, params.yMax, getTimer())
        floater.y = params.yMin
    elseif( floater.y > params.yMax ) then
        --print("max ",round(floater.y), params.yMin, params.yMax, getTimer())
        floater.y = params.yMax
    end
end

mover2 = function( floater, target )
    local params        = floater._floatParams
    local master        = params.master

    if( floater._ly == nil ) then
        floater._ly = target.y
        return
    end

    local dy =  target.y - floater._ly
    floater._ly = target.y

    -- Target changed, start tracking new target and skip one round of updates.
    if( floater._lastTarget ~= target ) then
        floater._lastTarget = target

        -- If this floater has a 'master' object, ensure that the 
        -- currently re-activated target is not aligned below
        -- the master's bottom edge
        if( master ) then
            local mo = params.masterOffset or 0
            local minY = floater.y + master.y + master.contentHeight/2

            if( isShowing( master ) == false ) then
                --mo = 0
                --minY = floater.y + master.y - master.contentHeight/2
            end

            if(target.y >minY) then
                target.y = minY + mo
            end
        end

        --print("TARGET CHANGED ", floater, target, master, target.y, mo, minY)         
        if(target:aboveBottom()) then
            print("Aligning to bottom")
            target:alignToBottomDelayed(30, 0, easing.linear ) 
        end
        floater._ly = nil

        return
    end

    if( dy == 0 ) then return end

    local ratio         = params.ratio
    local ignoreRebound = params.ignoreRebound
    local ignoreReboundDown = params.ignoreReboundDown
    local partner       = params.partner

    -- Only move while not rebounding (unless explicitly allowed)
    if(ignoreRebound == false or target._rebounding == false) then
        if(dy > 0) then
            floater.y = floater.y + dy
        else
            floater.y = floater.y + dy * ratio
        end
    elseif(ignoreReboundDown == false) then
        if(dy > 0) then
            floater.y = floater.y + dy
        end
    end

    local yMin = params.yMin
    if(isShowing(partner)) then
        yMin = yMin + partner.contentHeight
    end

    -- Check for movment breaches
    if( floater.y < yMin ) then
        --print("min ",round(floater.y), params.yMin, params.yMax, getTimer())
        floater.y = yMin
    elseif( floater.y > params.yMax ) then
        --print("max ",round(floater.y), params.yMin, params.yMax, getTimer())
        floater.y = params.yMax
    end
end

mover3 = function( floater, target )
    local params        = floater._floatParams
    local master        = params.master

    if( floater._ly == nil ) then
        floater._ly = target.y
        return
    end

    local dy =  target.y - floater._ly
    floater._ly = target.y

    -- Target changed, start tracking new target and skip one round of updates.
    if( floater._lastTarget ~= target ) then
        floater._lastTarget = target

        -- If this floater has a 'master' object, ensure that the 
        -- currently re-activated target is not aligned below
        -- the master's bottom edge
        if( master ) then
            local mo = params.masterOffset or 0
            local minY = floater.y + master.y + master.contentHeight/2

            if( isShowing( master ) == false ) then
                --mo = 0
                --minY = floater.y + master.y - master.contentHeight/2
            end

            if(target.y >minY) then
                target.y = minY + mo
            end
        end

        --print("TARGET CHANGED ", floater, target, master, target.y, mo, minY)         
        if(target:aboveBottom()) then
            print("Aligning to bottom")
            target:alignToBottomDelayed(30, 0, easing.linear ) 
        end

        floater._ly = nil

        return
    end
    
    if( dy == 0 ) then return end

    local ratio         = params.ratio
    local ignoreRebound = params.ignoreRebound
    local ignoreReboundDown = params.ignoreReboundDown
    local partner       = params.partner

    -- Only move while not rebounding (unless explicitly allowed)
    if(ignoreRebound == false or target._rebounding == false) then
        if(dy > 0) then
            floater.y = floater.y + dy
        else
            floater.y = floater.y + dy * ratio
        end
    elseif(ignoreReboundDown == false) then
        if(dy > 0) then
            floater.y = floater.y + dy
        end
    end

    local yMin = params.yMin
    if(isShowing(partner)) then
        yMin = yMin - partner.contentHeight
    end
    --print(params.yMin, yMin, partner.contentHeight, isShowing(partner))

    -- Check for movment breaches
    if( floater.y < yMin ) then
        --print("min ",round(floater.y), params.yMin, params.yMax, getTimer())
        floater.y = yMin
    elseif( floater.y > params.yMax ) then
        --print("max ",round(floater.y), params.yMin, params.yMax, getTimer())
        floater.y = params.yMax
    end
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



onHScrollTouch = function( self, event  )   
    if( dragMode ~= "horiz" ) then return false end
    local dragLayer     = self.dragLayer
    local retval        = not (self.passThrough)
    
    if( event.phase == "moved" ) then

        if( self.isFocus ~= true ) then
            self.isFocus = true
            display.currentStage:setFocus( self, event.id ) -- EFM
        end

        dragLayer._update = false
        dragLayer._dragging = true

        if( dragLayer.lastX == nil) then
            dragLayer.lastX = dragLayer.x
            dragLayer.xd = event.x
            dragLayer.xtd = event.time
        else
            local dx = event.x - dragLayer.xd
            dragLayer.xd = event.x          
            local dt = event.time - dragLayer.xtd
            dragLayer.xtd = event.time

            local vel = dx/dt
            if( mAbs( vel ) > 2 ) then
                if( vel < 0 ) then
                    vel = -2
                else
                    vel = 2
                end
            end
            dragLayer._velocity = vel
            dragLayer:scrollLimit2( dragLayer.lastX, dx, fullw * 0.4)
            dragLayer.lastX = dragLayer.x
        end
    
    elseif(event.phase == "ended" or event.phase == "cancelled") then
        dragLayer.lastX = nil
        dragLayer.xd = nil
        dragLayer.xtd = nil
        dragLayer._update = true
        dragLayer._rebounding = false
        dragLayer._dragging = false
        self.isFocus = false
        display.currentStage:setFocus( self, nil ) -- EFM
        timer.performWithDelay( 1, function() dragMode = "click" end )

    end

    return retval
end

onHScrollTouchExternal = function( self, event  )   
    local dragLayer     = self.dragLayer
    local retval        = not (self.passThrough)

    -- A vertical scroller is scrolling vertically, abort!
    if( dragMode == "vert" ) then return true end

    if( event.phase == "moved" ) then
        -- Only take focus once dragging has started
        if( self.isFocus ~= true and 
            dragLayer._dragging == true 
            and dragMode ~= "vert" ) then
            self.isFocus = true
            display.currentStage:setFocus( self, event.id ) -- EFM
        end

        dragLayer._update = false
        --dragLayer._dragging = false

        local dx = event.x - event.xStart
        if( dragLayer._dragging ~= true and mAbs(dx) > hDragMin  ) then
            dragLayer._dragging = true
        end     

        if( dragLayer.lastX == nil) then
            dragLayer.lastX = dragLayer.x
            dragLayer.xd = event.x
            dragLayer.xtd = event.time
        elseif( dragLayer._dragging == true ) then
            local dx = event.x - dragLayer.xd
            dragLayer.xd = event.x          
            local dt = event.time - dragLayer.xtd
            dragLayer.xtd = event.time

            local vel = dx/dt
            if( mAbs( vel ) > 2 ) then
                if( vel < 0 ) then
                    vel = -2
                else
                    vel = 2
                end
            end
            dragLayer._velocity = vel
            dragLayer:scrollLimit2( dragLayer.lastX, dx, fullw * 0.4)
            dragLayer.lastX = dragLayer.x
        end
    
    elseif(event.phase == "ended" or event.phase == "cancelled") then
        dragLayer.lastX = nil
        dragLayer.xd = nil
        dragLayer.xtd = nil
        dragLayer._update = true
        dragLayer._rebounding = false
        dragLayer._dragging = false

        self.isFocus = false
        display.currentStage:setFocus( self, nil ) -- EFM
    end

    return false -- EFM
    --return retval -- EFM
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
    -- isShowing
    -- onShowing
    -- onNotShowing
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

-- This calls a function (just once) when this object is determined to be actually on screen.
multiScroller.addHScrollOnScreenExecute = function( hscroll, cb, buffer )
    buffer = buffer or 0

    local enterFrame
    enterFrame = function()
        if( hscroll == nil or hscroll.removeSelf == nil ) then
            ignore( "enterFrame", enterFrame )
            return 
        end

        local parent = hscroll.parent       
        while( parent ) do              
            if(parent.isVisible == false) then return end
            parent = parent.parent
        end

        local xMax = w + unusedWidth/2 + buffer
        local xMin = -unusedWidth/2 - buffer
        local yMax = h + unusedWidth/2 + buffer
        local yMin = -unusedWidth/2 - buffer
        local x,y = hscroll.parent:localToContent( 1, hscroll.cy ) -- fake x coord
        if( x > xMax ) then return end
        if( x < xMin ) then return end
        if( y > yMax ) then return end
        if( y < yMin ) then return end
        ignore( "enterFrame", enterFrame )
        cb( hscroll )
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

multiScroller.createHScroller = createHScroller

multiScroller.isShowing = isShowing

multiScroller.resetDragMode = function() 
    dragMode = "click" 
end

return multiScroller