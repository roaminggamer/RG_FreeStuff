local function shortestPathTransition( obj, targetAngle, dps, myEasing )
	targetAngle = targetAngle or 0
   local dps = dps or 0
   dps = dps/1000 -- degrees per second
   local myEasing = myEasing or easing.linear

   -- Instant Turn
   if(dps < 0 ) then
      obj.rotation = targetAngle      

   -- Timed Turn
   else
	   -- Normalize angles
	   while( obj.rotation < 0 ) do obj.rotation = obj.rotation + 360 end
	   while( obj.rotation >= 360 ) do obj.rotation = obj.rotation - 360 end
	   while( targetAngle < 0 ) do targetAngle = targetAngle + 360 end
	   while( targetAngle >= 360 ) do targetAngle = obj.rotation - 360 end

   	-- Stop any prior transitions on this object
   	transition.cancel( obj )

   	-- Calc initial tween angle
   	local tweenAngle = obj.rotation - targetAngle

   	-- Adjust to shortest path
      if(tweenAngle >= 180) then
         targetAngle = targetAngle + 360
         tweenAngle  = targetAngle - obj.rotation
      elseif(tweenAngle <= -180) then
         targetAngle = targetAngle - 360
         tweenAngle  = targetAngle - obj.rotation
      end   

      -- Calc rotation time
      local rotateTime = math.abs(math.floor(tweenAngle / dps))

      -- Transition
      transition.to( obj, { rotation = targetAngle, time = rotateTime, transition = myEasing } )
   end
   obj.targetAngle = targetAngle
end


--
-- Test it
--
local arrow = display.newImageRect( "arrow.png", 80, 80 )
arrow.targetAngle = 0 
arrow.x = display.contentCenterX
arrow.y = display.contentCenterY

local label = display.newText( "TBD", arrow.x, arrow.y + 200 )

function label.enterFrame( self )
	self.text = string.format("Arrow Rotation: %d   Rotation Target: %d", arrow.rotation, arrow.targetAngle)
end
Runtime:addEventListener("enterFrame",label)


local function test()
	local targetAngle = math.random( -360, 360 )
	shortestPathTransition( arrow, targetAngle, 360 )
	timer.performWithDelay( 1500, test )
end

test()






