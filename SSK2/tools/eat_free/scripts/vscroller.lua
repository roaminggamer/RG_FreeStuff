-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Eds Awesome Tool (a free SSK2 PRO co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
--   Last Updated: 06 JAN 2017
-- =============================================================
local vscroller = {}
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



function vscroller.new( group, x, y, width, height, params )
    group   = group or display.currentStage
    params  = params or {}
    
    local widget = require( "widget" )
    widget.setTheme("widget_theme_android_holo_dark")

    local listener = function( event )    
        local target = event.target

        if( event.phase == "began" ) then
            --print("onScrollerTouch")
            post("onScrollerTouch", { scroller = target } )
        end
        
        if( params.listener ) then
            params.listener( target, event )
        end
        -- Notify all children of 'ended'
        if( event.phase == "ended" ) then
            for k,v in pairs( target.toNotify ) do
                if( v.touch ) then v:touch( event ) end
            end
            target.toNotify = {}
        end

        return false
    end

    -- Create a scrollView
    local scroller = widget.newScrollView {
        --parent                      = group,
        left                        = x,
        top                         = y,
        width                       = width,
        height                      = height,
        hideBackground              = fnn(params.hideBackground, false),
        backgroundColor             = fnn(params.backgroundColor, { 48/255 }),
        isBounceEnabled             = fnn(params.isBounceEnabled, true),
        isVBounceEnabled            = fnn(params.isBounceEnabled, true),
        isHBounceEnabled            = false,
        horizontalScrollingDisabled = true,
        verticalScrollingDisabled   = false,
        listener                    = listener
    } 
    group:insert(scroller)
    scroller.anchorX = 0
    scroller.anchorY = 0
    scroller.x = x
    scroller.y = y

    scroller.toNotify = {}

    function scroller.addTouch( obj, onTouch )
        function obj.touch( self, event )                  
            scroller.toNotify[self] = self

            local dy = mAbs(event.y - event.yStart)
            local dx = mAbs(event.x - event.xStart)
            if( dx < 10 and dy < 10 and isInBounds( event, self ) ) then
               event.isClick = true
            end

            onTouch( self, event )
            return false
        end
        obj:addEventListener("touch")
    end

    function scroller.alignToTop( self, time )
        self:scrollToPosition( { y = 0, time = time }  )
    end
    function scroller.alignToBottom( self, time )
        local toY = -self:getView().contentHeight + height
        self:scrollToPosition( { y = toY, time = time }  )
    end

    function scroller.alignToY( self, toY, time )
        local toY = -toY
        local maxY = -self:getView().contentHeight + height
        toY = (toY < maxY) and maxY or toY
        self:scrollToPosition( { y = toY, time = time }  )
    end


    --table.dump(scroller)
    return scroller
end


return vscroller