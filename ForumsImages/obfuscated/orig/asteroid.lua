-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
-- asteroid.lua
-- ==========================================================================
local physics     = require "physics"
local common      = require "scripts.common"
local util        = require "scripts.util"

-- **************************************************************************
-- Localize Commonly Used Functions 
-- **************************************************************************
local mDeg = math.deg; local mRad = math.rad; local mCos = math.cos
local mSin  = math.sin; local mAcos = math.acos; local mAsin = math.asin
local mSqrt = math.sqrt; local mCeil = math.ceil; local mFloor = math.floor
local mAtan2 = math.atan2; local mPi = math.pi
local mRand = math.random; local mAbs = math.abs; local mCeil = math.mCeil
local mFloor = math.floor; local getTimer = system.getTimer
local newCircle = display.newCircle; local newImageRect = display.newImageRect
local newLine = display.newLine; local newRect = display.newRect
local newText = display.newText
local performWithDelay = timer.performWithDelay


-- **************************************************************************
-- Module Begins
-- **************************************************************************
local asteroidM = {}

-- Builder Function
--
function asteroidM.new( params )

   -- Draw an 'empty hole'
   local asteroid = newImageRect( common.layers.content, 
                              "images/kenney/asteroid.png", 
                              common.asteroidW, common.asteroidH )
   asteroid.x = params.x
   asteroid.y = params.y
   physics.addBody( asteroid, "dynamic", { radius = common.asteroidW/2} )
   asteroid.isSensor = true   

   -- Track this asteroid in the list of known asteroids
   common.asteroids[asteroid] = asteroid

   -- Set velocity of asteroid
   local vx,vy = util.angle2Vector( params.angle )   
   local rate = mRand( params.minRate, params.maxRate )
   asteroid:setLinearVelocity( vx * rate, vy * rate )

   -- Give asteroid a random spin
   --
   asteroid.angularVelocity = mRand( -90, 90 )


   -- Use enterFrame to wrap asteroid too!
   --
   function asteroid.enterFrame( self, event )         
      if( not common.gameIsRunning or common.gameIsPaused ) then return end
      util.rectWrap( self, common.wrapRect )
   end
   Runtime:addEventListener("enterFrame", asteroid)

   -- Use finalize to clean up deleted asteroids
   --
   function asteroid.finalize( self )
      Runtime:removeEventListener("enterFrame", self)      
   end
   asteroid:addEventListener( "finalize" )   

   -- Add collision listener
   --
   --
   function asteroid.collision( self, event )
      -- Ignore all phases but "began"
      if( event.phase == "began" ) then 
        
         local other = event.other   
         local restarted = false

         -- Ignore anything but player or bullet
         if( not other.isPlayer and not other.isBullet ) then return false end


         -- Special actions for other 'type'
         --
         if( other.isBullet ) then
            common.score = common.score + common.asteroidValue
            common.scoreLabel.text = common.score

            -- Play sound
            audio.play(common.sounds.explode)

            -- Destroy the bullet
            display.remove( other)


         elseif( other.isPlayer ) then
            -- Subtract life
            --
            common.lives = common.lives - 1

            -- Play sound
            audio.play(common.sounds.die)


            -- Update lives label
            --
            common.livesLabel.text = common.lives

            -- Are we out of lives?
            if( common.lives <= 0 ) then
               local game = require "scripts.game"
               -- Yes! Game over!
               game.stop()


            else
               -- No, restart this level
               --

               restarted = true

               -- Destroy all asteroids
               --
               for k,v in pairs( common.asteroids ) do
                  display.remove(v)
               end
               common.asteroids = {}

               -- Note: This is not the normal logic for asteroids, but
               -- it avoids a number of challenging issues like
               -- safe-respawning, etc. 
               --
               -- i.e. It simplifies this template, making it easier to understand.
               local game = require "scripts.game"
      
               -- Wait one frame then re-load this level
               timer.performWithDelay( 1, 
                  function() 
                     if( common.gameIsRunning ) then
                        print("Reset level", getTimer())
                        game.createLevel( true ) -- passing true means 'don't increment level'
                     end
                  end )

            end
         end

         -- If we did not restart (above), then destroy this asteroid
         -- and see if it is time for a new level to load.
         --
         if( not restarted ) then
            -- Stop tracking this asteroid & delete it
            --
            --
            common.asteroids[self] = nil
            display.remove( self)

            -- All asteroids removed?  If so, time for next level
            --
            local count = util.countTable( common.asteroids )
            if( count <= 0 ) then
               local game = require "scripts.game"

               -- Wait one frame then load next level
               timer.performWithDelay( 1, 
                  function() 
                     if( common.gameIsRunning ) then
                        game.createLevel( )
                     end
                  end )

            end
         end
         return true      
      else
         return false
      end
   end
   asteroid:addEventListener( "collision" )

   
   -- Return reference to asteroid
   return asteroid
end


return asteroidM