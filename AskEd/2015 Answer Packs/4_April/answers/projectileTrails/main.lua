-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The user wanted to make 'cool trails' for projectiles.", 
	"",
	"This demo explores a number of options."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end

--
-- 1. Load SSK
--require "ssk.loadSSK"

--
-- 2. Forward Declarations
-- SSK 
local angle2Vector      = ssk.math2d.angle2Vector
local vector2Angle      = ssk.math2d.vector2Angle
local scaleVec          = ssk.math2d.scale
local addVec            = ssk.math2d.add
local subVec            = ssk.math2d.sub
local normVec           = ssk.math2d.normalize
local getNormals        = ssk.math2d.normals
local vecLen            = ssk.math2d.length
local vecLen2           = ssk.math2d.length2
-- Lua and Corona 
local mAbs              = math.abs
local mRand             = math.random
local getInfo           = system.getInfo
local getTimer          = system.getTimer
local strMatch          = string.match
local strFormat         = string.format

--
-- 3. Create lable to show current style
local curStyle = 1
local styles = { "Fading Squares", "Fading Circles", "Lines", "Rainbow Fading Squares", "Rainbow Fading Circles", "Rainbow Lines"  }
local trailLabel = display.newText( styles[curStyle], display.contentCenterX, 200, native.systemFont, 42 )


--
-- 4. Set up physics
local physics = require "physics"
physics.start()
physics.setGravity( 0, 0 )
--physics.setDrawMode("hybrid")

--
-- 5. Function to create and fire bullet.  Fires at any passed in target object.
local function fireBullet( angle, trailStyle )
    -- a. Create a 'bullet' 
    local bullet = display.newCircle( display.contentCenterX, display.contentCenterY, 5 )

	physics.addBody( bullet, "dynamic", { radius = 5 } )
	bullet:setFillColor(1,1,1,0.5)

	-- b. Generate a random velocity vector and apply to the bullet
	local speed = 500
	local vec = angle2Vector( angle, true )
	vec = scaleVec( vec, speed )
	--print(vec.x, vec.y)
    bullet:setLinearVelocity( vec.x, vec.y )

    -- c. Schedule 'auto-destruct' 
    timer.performWithDelay( 5000, function() display.remove( bullet ) end )

    -- d. Apply various trail styles
    local count  = 0

    -- Fading Squares
    if( trailStyle == 1 ) then
    	bullet.enterFrame = function( self )
    		if( self.removeSelf == nil or self.parent == nil) then
    			Runtime:removeEventListener( enterFrame, self )
    			return
    		end

    		-- Draw every 3rd frame (uncomment to reduce particles)
    		--[[
    		if( count % 3 == 0 ) then
    			count = count + 1
    			return
    		end
    		count = count + 1
    		--]]

    		for i = 1, 3 do
    			local tmp = display.newRect( self.parent, 
    				                         self.x + math.random(-2,2), self.y + math.random(-2,2), 
    				                         self.contentWidth/2, self.contentHeight/2 )
    			tmp.alpha = 0.5
    			tmp:setFillColor(0.25,0.25,0.25)
    			tmp:toBack()
    			transition.to( tmp, { alpha = 0.05, xScale = 0.5, yScale = 0.5, time = 1000, onComplete = display.remove })
    		end    		
    	end
    	Runtime:addEventListener( "enterFrame", bullet )

    -- Fading Circles
    elseif( trailStyle == 2 ) then
    	bullet.enterFrame = function( self )
    		if( self.removeSelf == nil or self.parent == nil) then
    			Runtime:removeEventListener( enterFrame, self )
    			return
    		end

    		-- Draw every 3rd frame (uncomment to reduce particles)
    		--[[
    		if( count % 3 == 0 ) then
    			count = count + 1
    			return
    		end
    		count = count + 1
    		--]]

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
    		if( self.removeSelf == nil or self.parent == nil) then
    			Runtime:removeEventListener( enterFrame, self )
    			return
    		end

    		-- Draw every 3rd frame (uncomment to reduce particles)
    		--[[
    		if( count % 3 == 0 ) then
    			count = count + 1
    			return
    		end
    		count = count + 1
    		--]]

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
    		if( self.removeSelf == nil or self.parent == nil) then
    			Runtime:removeEventListener( enterFrame, self )
    			return
    		end

    		-- Draw every 3rd frame (uncomment to reduce particles)
    		--[[
    		if( count % 3 == 0 ) then
    			count = count + 1
    			return
    		end
    		count = count + 1
    		--]]

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

--
-- 6. Create a 'Turret'
local turret = display.newCircle( display.contentCenterX, display.contentCenterY, 15 )
turret:setFillColor(1,0,0,0.5)
turret:setStrokeColor(1,0,1)
turret.strokeWidth = 2

-- Create two walls to hit
--
local wall = display.newRect( display.contentCenterX + display.actualContentWidth/2 - 80,
                              display.contentCenterY, 40, 600  )
physics.addBody( wall, "static"  )
wall:setFillColor(0,1,0,0.5)

--
-- 7. Fire a bullet at 'fireRate' forever
----[[
timer.performWithDelay( 5000,
	function()
		curStyle = curStyle + 1
		if( curStyle > #styles ) then 
			curStyle = 1
		end
		trailLabel.text = styles[curStyle]
	end, -1 )
--]]

timer.performWithDelay( 1000, 
	function() 
		fireBullet( math.random( 55, 125), curStyle) 
	end,  -1  ) 
