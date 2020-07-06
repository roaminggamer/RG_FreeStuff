local creator = {}


local mRand = math.random

function creator.blocking( group, numToCreate, onComplete ) 
   local x = left
   local y = top
   for i = 1, numToCreate do
      local tmp = display.newImageRect( group, string.format("images/dirt_%02d.png",mRand(1,19)), 5, 5 )
      tmp.x = x
      tmp.y = y
      x = x + 5
      if( x > right ) then
         x = left
         y = y + 5
      end
   end
   onComplete()
end

function creator.nonBlocking( group, numToCreate, targetFPS, onComplete ) 
   local x = left
   local y = top   

   -- Queue up the work
   local queue = {}
   for i = 1, numToCreate do
      queue[i] = function()
         local tmp = display.newImageRect( group, string.format("images/dirt_%02d.png",mRand(1,19)), 5, 5 )
         tmp.x = x
         tmp.y = y
         x = x + 5
         if( x > right ) then
            x = left
            y = y + 5
         end
      end
   end

   -- Execute bites of the work till done, without blocking

   local safeDuration = math.round( (1000/targetFPS) * 0.75 )

   print( "safeDuration: ", safeDuration )


   local step = 0
   local stepChunk = 100
   local function doWork()
      local stopTime = system.getTimer() + safeDuration
      while( step < #queue and system.getTimer() < stopTime ) do
         for j = 1, stepChunk do
            step = step + 1
            if( step < #queue ) then
               queue[step]()
            end
         end
      end
      if( step < #queue ) then
         timer.performWithDelay( 1, doWork )
      else
         onComplete()
      end
   end
   timer.performWithDelay( 1, doWork )
   
end   
return creator