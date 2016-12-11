-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- 
-- =============================================================
local public = {}

----------------------------------------------------------------------
--								REQUIRES							--
----------------------------------------------------------------------
local physics 		= require "physics"
local common 		= require "scripts.common"

----------------------------------------------------------------------
--								DECLARATIONS						--
----------------------------------------------------------------------
-- Variables

-- Forward Declarations

-- Useful Localizations
-- SSK
--
local newCircle 		= ssk.display.newCircle
local newRect 			= ssk.display.newRect
local newImageRect 		= ssk.display.newImageRect
local newAngleLine 		= ssk.display.newAngleLine
local easyIFC   		= ssk.easyIFC
local oleft 			= ssk.misc.oleft
local oright 			= ssk.misc.oright
local otop 				= ssk.misc.otop
local obottom			= ssk.misc.obottom
local isInBounds    	= ssk.easyIFC.isInBounds
local secondsToTimer	= ssk.misc.secondsToTimer
local isValid 			= display.isValid

local normRot			= math.normRot

local addVec			= ssk.math2d.add
local subVec			= ssk.math2d.sub
local diffVec			= ssk.math2d.diff
local lenVec			= ssk.math2d.length
local len2Vec			= ssk.math2d.length2
local normVec			= ssk.math2d.normalize
local vector2Angle		= ssk.math2d.vector2Angle
local angle2Vector		= ssk.math2d.angle2Vector
local scaleVec			= ssk.math2d.scale


-- Corona & Lua
--
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

--
function public.addTrail( bullet, trailStyle, frameLimit, trailColor )

    if( common.isRunning == false ) then return end

    -- d. Apply various trail styles
    local count  = 0

    -- Fading Squares
    if( trailStyle == 1 ) then
    	bullet.enterFrame = function( self )
            if( common.isRunning == false ) then return end
    		if( self.removeSelf == nil or self.parent == nil) then
    			Runtime:removeEventListener( enterFrame, self )
    			return
    		end

    		-- Draw every Nth frame 
    		if( frameLimit ) then
        		if( count % frameLimit == 0 ) then
        			count = count + 1
        			return
        		end
        		count = count + 1
    		end

    		for i = 1, 3 do
    			local tmp = display.newRect( self.parent, 
    				                         self.x + math.random(-2,2), self.y + math.random(-2,2), 
    				                         self.contentWidth/2, self.contentHeight/2 )
    			tmp.alpha = 0.5
               if( trailColor ) then
                  tmp:setFillColor( unpack(trailColor) )
               else
    			     tmp:setFillColor(0.25,0.25,0.25)
               end
    			tmp:toBack()
    			transition.to( tmp, { alpha = 0.05, xScale = 0.5, yScale = 0.5, time = 1000, onComplete = display.remove })
    		end    		
    	end
    	Runtime:addEventListener( "enterFrame", bullet )

    -- Fading Circles
    elseif( trailStyle == 2 ) then
    	bullet.enterFrame = function( self )
            if( common.isRunning == false ) then return end
    		if( self.removeSelf == nil or self.parent == nil) then
    			Runtime:removeEventListener( enterFrame, self )
    			return
    		end

            -- Draw every Nth frame 
            if( frameLimit ) then
                if( count % frameLimit == 0 ) then
                    count = count + 1
                    return
                end
                count = count + 1
            end

    		for i = 1, 3 do
    			local tmp = display.newCircle( self.parent, 
    				                         self.x + math.random(-2,2), self.y + math.random(-2,2), 
    				                         self.contentWidth/2 )
    			tmp.alpha = 0.5
    			tmp:setFillColor(0.25,0.25,0.25)
    			tmp:toBack()
    			transition.to( tmp, { alpha = 0.05, xScale = 0.5, yScale = 0.5, time = 1000, onComplete = display.remove })
    		end    		
    	end
    	Runtime:addEventListener( "enterFrame", bullet )

    -- Lines
    elseif( trailStyle == 3 ) then
	    bullet.lastX = bullet.x
	    bullet.lastY = bullet.y

    	bullet.enterFrame = function( self )
            if( common.isRunning == false ) then return end
    		if( self.removeSelf == nil or self.parent == nil) then
    			Runtime:removeEventListener( enterFrame, self )
    			return
    		end
    		if( count == 0 ) then
    			count = count + 1
    			return
    		else
    			count = count + 1
    		end

    		local tmp = display.newLine( self.parent, self.lastX, self.lastY, self.x, self.y)
    		self.lastX = self.x
    		self.lastY = self.y

   			tmp.alpha = 0.8
   			tmp:setStrokeColor(0.25,0.25,0.25)
   			tmp:toBack()
   			tmp.strokeWidth = self.contentHeight/2
   			transition.to( tmp, { alpha = 0.05, strokeWidth = 1, time = 1000, onComplete = display.remove })

    	end
    	Runtime:addEventListener( "enterFrame", bullet )

    -- Rainbow Fading Squares
    elseif( trailStyle == 4 ) then
    	bullet.enterFrame = function( self )
            if( common.isRunning == false ) then return end
    		if( self.removeSelf == nil or self.parent == nil) then
    			Runtime:removeEventListener( enterFrame, self )
    			return
    		end

            -- Draw every Nth frame 
            if( frameLimit ) then
                if( count % frameLimit == 0 ) then
                    count = count + 1
                    return
                end
                count = count + 1
            end

    		for i = 1, 3 do
    			local tmp = display.newRect( self.parent, 
    				                         self.x + math.random(-2,2), self.y + math.random(-2,2), 
    				                         self.contentWidth/2, self.contentHeight/2 )
    			tmp.alpha = 0.5
    			tmp:setFillColor(math.random(), math.random(), math.random()) 
    			tmp:toBack()
    			transition.to( tmp, { alpha = 0.05, xScale = 0.5, yScale = 0.5, time = 1000, onComplete = display.remove })
    		end    		
    	end
    	Runtime:addEventListener( "enterFrame", bullet )

    -- Rainbow Fading Circles
    elseif( trailStyle == 5 ) then
    	bullet.enterFrame = function( self )
            if( common.isRunning == false ) then return end
    		if( self.removeSelf == nil or self.parent == nil) then
    			Runtime:removeEventListener( enterFrame, self )
    			return
    		end

            -- Draw every Nth frame 
            if( frameLimit ) then
                if( count % frameLimit == 0 ) then
                    count = count + 1
                    return
                end
                count = count + 1
            end

    		for i = 1, 3 do
    			local tmp = display.newCircle( self.parent, 
    				                         self.x + math.random(-2,2), self.y + math.random(-2,2), 
    				                         self.contentWidth/2 )
    			tmp.alpha = 0.5
    			tmp:setFillColor(math.random(), math.random(), math.random()) 
    			tmp:toBack()
    			transition.to( tmp, { alpha = 0.05, xScale = 0.5, yScale = 0.5, time = 1000, onComplete = display.remove })
    		end    		
    	end
    	Runtime:addEventListener( "enterFrame", bullet )

    -- Rainbow Lines
    elseif( trailStyle == 6 ) then
	    bullet.lastX = bullet.x
	    bullet.lastY = bullet.y

    	bullet.enterFrame = function( self )
            if( common.isRunning == false ) then return end
    		if( self.removeSelf == nil or self.parent == nil) then
    			Runtime:removeEventListener( enterFrame, self )
    			return
    		end
    		if( count == 0 ) then
    			count = count + 1
    			return
    		else
    			count = count + 1
    		end

    		local tmp = display.newLine( self.parent, self.lastX, self.lastY, self.x, self.y)
    		self.lastX = self.x
    		self.lastY = self.y

   			tmp.alpha = 0.8
   			tmp:setStrokeColor(math.random(), math.random(), math.random()) 
   			tmp:toBack()
   			tmp.strokeWidth = self.contentHeight/2

   			transition.to( tmp, { alpha = 0.05, strokeWidth = 1, time = 1000, onComplete = display.remove })

    	end
    	Runtime:addEventListener( "enterFrame", bullet )
    end

end

return public