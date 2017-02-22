require "ssk2.loadSSK"
_G.ssk.init( {} )

local physics = require "physics"
physics.start()
physics.setGravity(0,0)


local currentStep = 1
local step1
local step2
local step3
local step4

local group
local stepLabel = display.newText( "TAP TO START", centerX, bottom - 40 )

-- Variables for: IMPORTANT CALCULATION(s)
local paddleSegmentPointA
local paddleSegmentPointB
local ball
local velocityVec
local velocityMagnitude = 350
local intersectPoint



-- Set up and draw the scenario
--
step1 = function()

  stepLabel.text = "STEP 1 - The Scenario"

  -- Destroy old group if it exists
  display.remove(group)

  -- Create new group
  group = display.newGroup()


  -- Create the example scenario
  --

  local paddle = ssk.display.newRect( group, left + 80, centerY, 
                                      { w = 30, h = 80, 
                                        fill = _GREY_, strokeWidth = 4, alpha = 0.7} )

  -- IMPORTANT CALCULATION
  --
  -- Calculate two points REPRESENTING: 
  --   >> A line segment passing through the paddle vertical
  -- 
  -- Tip: This segment is a unit-length vector, but it can be any length
  -- for our purposes.
  --
  paddleSegmentPointA = { x = paddle.x, y = paddle.y - 0.5 }
  paddleSegmentPointB = { x = paddle.x, y = paddle.y + 0.5 }
  local paddleSegment = ssk.math2d.sub( paddleSegmentPointA, paddleSegmentPointB )


  -- Draw a line for the demo (show the segment as a long line)
  --
  local vec2 = ssk.math2d.scale( paddleSegment, 1000 )
  local line = display.newLine( group, paddle.x + vec2.x,  paddle.y + vec2.y, paddle.x + vec2.x,  paddle.y - vec2.y )
  line.strokeWidth = 4
  line:toBack()

  -- 
  -- Draw the ball, but don't move it yet
  --
  ball = ssk.display.newCircle( group, right - 100, centerY + math.random( -fullh/3, fullh/3 ),
                               { radius = 15, stroke = _Y_, fill = _T_, strokeWidth = 3 }, 
                               { } )

  --
  -- Generate a random movement vector
  --
  local angle = math.random( -100, -80 )
  velocityVec = ssk.math2d.angle2Vector( angle, true ) 
  velocityVec = ssk.math2d.scale( velocityVec, velocityMagnitude )

  --
  -- Draw the vector so we know how the ball will move in step3
  --
  local tmp = display.newLine( group, ball.x, ball.y, ball.x + velocityVec.x, ball.y + velocityVec.y )
  tmp:setStrokeColor( unpack(_Y_) )
  tmp.strokeWidth = 3

end

-- Calculate the intersection
--
step2 = function()
   stepLabel.text = "STEP 2 - The Intersection"

   -- IMPORTANT CALCULATION
   --
   -- Normally you would do this,
   --
   --  local vx,vy == ball:getLinearVelocity()
   --
   -- ... but the ball is not moving yet in our example and,
   -- we generated values for our vx, vy in step 1 
   -- (do make this example easy to follow and show)
   --
   -- Calculate intersection point
   -- https://roaminggamer.github.io/RGDocs/pages/SSK2/libraries/math2D/#line-line-intersect
   -- 
   local vx,vy = velocityVec.x, velocityVec.y
   local ballSegmentPointA = { x = ball.x, y = ball.y }
   local ballSegmentPointB = { x = ball.x + vx, y = ball.y + vy }
   table.dump(ballSegmentPointA,nil,"ba")
   table.dump(ballSegmentPointB,nil,"bb")
   table.dump(paddleSegmentPointA,nil,"pa")
   table.dump(paddleSegmentPointB,nil,"pb")
   intersectPoint = ssk.math2d.lineLineIntersect( ballSegmentPointA, ballSegmentPointB, paddleSegmentPointA, paddleSegmentPointB )

   --
   -- Draw the intersection point and a line for the ball path for the demo
   -- 
   if( intersectPoint ) then -- it is possible not to have an intersect if the lines are parallell
      ssk.display.newCircle( group, intersectPoint.x, intersectPoint.y, { radius = 10, fill = _R_ } )
      local tmp = display.newLine( group, ball.x, ball.y, intersectPoint.x, intersectPoint.y )
      tmp:setStrokeColor( unpack(_G_) )
      tmp.strokeWidth = 9
      tmp:toBack()
      tmp.alpha = 0.4
   end

end

step3 = function()
   stepLabel.text = "STEP 3 - VERIFY IT"

   -- Snap to the intersect if we pass within 15 pixels of it and stop moving
   --
   if( intersectPoint ) then
      function ball.enterFrame( self )
         if( autoIgnore( "enterFrame", self ) ) then return end
         local vec = ssk.math2d.sub( self, intersectPoint )
         if( ssk.math2d.length( vec ) <= 15 ) then
            self:setLinearVelocity(0,0)
            self.x = intersectPoint.x
            self.y = intersectPoint.y
         end
      end;  listen( "enterFrame", ball )
   end


   --
   -- Start the ball moving
   --
   ball:setLinearVelocity( velocityVec.x, velocityVec.y )
end



local function onTouch( event )
   if( event.phase == "ended" ) then
      if( currentStep == 1 ) then
         step1()
      elseif( currentStep == 2 ) then
         step2()
      elseif( currentStep == 3 ) then
         step3()
      elseif( currentStep == 4 ) then
         stepLabel.text = "TAP TO RE-START"
      end
      currentStep = currentStep + 1
      if( currentStep > 4 ) then
         currentStep = 1
      end
   end
   return false
end; listen("touch",onTouch)

--step1(); currentStep = currentStep + 1    