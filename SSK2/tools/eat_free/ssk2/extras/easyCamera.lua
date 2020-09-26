-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Various 'Basic' Cameras 
--
-- While these can be used out-of-the-box, the purpose of this module
-- is to give you a 'starting' point for your own custom camera logic.
-- =============================================================

local camera = {}

local centerX 	= display.contentCenterX
local centerY 	= display.contentCenterY
local w 		= display.contentWidth
local h 		= display.contentHeight
local fullw 	= display.actualContentWidth
local fullh 	= display.actualContentHeight

local mDeg  	= math.deg
local mRad  	= math.rad
local mCos  	= math.cos
local mSin  	= math.sin
local mAcos 	= math.acos
local mAsin 	= math.asin
local mSqrt 	= math.sqrt
local mCeil 	= math.ceil
local mFloor 	= math.floor
local mAtan2 	= math.atan2
local mPi 		= math.pi

local getTimer  = system.getTimer
local mAbs 		= math.abs

local isValid = isValid or function( obj ) 
	return obj.removeSelf ~= nil 
end
local fnn = fnn or function( ... ) 
	for i = 1, #arg do
		local theArg = arg[i]
		if(theArg ~= nil) then return theArg end
	end
	return nil
end

local function add( x1, y1, x2, y2 )
	return x2+x1, y2+y1
end

local function sub( x1, y1, x2, y2 )
	return x2-x1, y2-y1
end

local function len( x, y )
	return mSqrt( x * x + y * y )
end

local function norm( x, y, doNorm )
	if( not doNorm ) then
		return x, y
	end
	local vLen = len( x, y )
	return x/vLen, y/vLen
end

local function a2v( angle )
	return a2vCache[angle][1], a2vCache[angle][2] 
end

local function v2a( x, y )
	return mCeil(mAtan2( y, x ) * 180 / mPi) + 90	
end

local function scale( x, y, mag )
	return x*mag,y*mag
end


----------------------------------------------------------------------
--	3. Definitions
----------------------------------------------------------------------

-- ==
--		tracking() - Follows target exactly.
-- ==
function camera.tracking( trackObj, world, params )	

	if( not isValid( trackObj ) ) then return end
	if( not isValid( world ) ) then return end
	
	params = params or {}	
	local lockX = params.lockX 
	local lockY = params.lockY
	local centered = fnn( params.centered, false)
	local disableSubPixel = fnn( params.disableSubPixel, false )

	local lx = 0
	local ly = 0

	if( centered ) then
		if( lockX ) then
			lx = trackObj.x
		else
			lx = centerX
		end

		if( lockY ) then
			ly = trackObj.y
		else
			ly = centerY
		end
	else
		lx = params.lx or trackObj.x
		ly = params.ly or trackObj.y
	end

	world.enterFrame = function( event )
		local dx = 0
		local dy = 0
		if(not lockX) then dx = trackObj.x - lx end		
		if(not lockY) then dy = trackObj.y - ly end
		if( disableSubPixel ) then
			dx = math.round(dx)
			dy = math.round(dy)
		end
		if(dx ~= 0 or dy ~= 0) then	
			world:translate(-dx,-dy)
			lx = trackObj.x
			ly = trackObj.y
		end
		return false
	end
	listen( "enterFrame", world )

	world.finalize = function( self )
		ignoreList( { "enterFrame" }, self )
	end; world:addEventListener( "finalize" )

	function trackObj.stopCamera( self )
		if( isValid(world) ) then
			ignoreList( {"enterFrame"}, world )
			if( world.finalize ) then
				world:removeEventListener("finalize")
				world.finalize = nil		
			end
		end
	end
end


function camera.delayedTracking( trackObj, world, params )	

	if( not isValid( trackObj ) ) then return end
	if( not isValid( world ) ) then return end
	
	params = params or {}	
	local lockX    = params.lockX 
	local lockY    = params.lockY
	local centered = fnn( params.centered, false)

	local lx = 0
	local ly = 0

	if( centered ) then
		if( lockX ) then
			lx = trackObj.x
		else
			lx = centerX
		end

		if( lockY ) then
			ly = trackObj.y
		else
			ly = centerY
		end
	else
		lx = trackObj.x
		ly = trackObj.y
	end
   
   world.cameraMoving = false

	world.enterFrame = function( self )
      if( world.cameraMoving ) then return end      
		local dx = 0
		local dy = 0
		if(not lockX) then dx = trackObj.x - lx end		
		if(not lockY) then dy = trackObj.y - ly end
		if(dx or dy) then
         world.cameraMoving = true
         local tx = trackObj.x
         local ty = trackObj.y
         world.onComplete = function( self )
            self.onComplete = nil
            self.cameraMoving = false
            lx = tx
            ly = ty
         end
			transition.to( world, { x = world.x - dx, y = world.y - dy, onComplete = world, time = 1000 } )
		end
		return false
	end
	listen( "enterFrame", world )

	world.finalize = function( self )
		ignoreList( { "enterFrame" }, self )
	end; world:addEventListener( "finalize" )

	function trackObj.stopCamera( self )
		ignore("enterFrame", world)
		world:removeEventListener("finalize")
		world.finalize = nil
	end

end

-- ==
--		trackingLooseRectangle() - Follows target, but has a deadzone followed by an acceleration zone to gradually move the camera.
-- ==
function camera.trackingLooseRectangle( trackObj, world, params )	

	if( not isValid( trackObj ) ) then return end
	if( not isValid( world ) ) then return end

	params = params or {}

	local minDelta = params.minDelta or 0.2

	local boundarySize = params.boundarySize or 100
	local halfBoundary = boundarySize/2 

	local top 	= centerY - fullh/2 + boundarySize
	local bot 	= centerY + fullh/2 - boundarySize
	local left 	= centerX - fullw/2 + boundarySize
	local right = centerX + fullw/2 - boundarySize

	world.lx = trackObj.x
	world.ly = trackObj.y

	world.enterFrame = function( event )		
		local dx = trackObj.x - world.lx
		local dy = trackObj.y - world.ly
		local lx, ly = trackObj:localToContent( 0, 0 ) 
		
		if( lx > left and lx < right and ly > top and ly < bot ) then 
			world.lx = trackObj.x
			world.ly = trackObj.y
			return false 
		end

		local ddy = 0
		local ddx = 0

		if(ly >= bot) then
			ddy = (mAbs( ly - bot )/ boundarySize) + minDelta
		
		elseif(ly <= top) then
			ddy = (mAbs( ly - top )/ boundarySize) + minDelta			
		end
		if( ddy > 1) then ddy = 1 end

		if(lx >= right) then
			ddx = (mAbs( lx - right )/ boundarySize) + minDelta
		
		elseif(lx <= left) then
			ddx = (mAbs( lx - left )/ boundarySize) + minDelta			

		end
		if( ddx > 1) then ddx = 1 end

		if(dx or dy) then	
			world:translate(-dx * ddx,-dy * ddy)
			world.lx = trackObj.x
			world.ly = trackObj.y
		end

		return false
	end
	listen( "enterFrame", world )

	world.finalize = function( self )
		ignoreList( { "enterFrame" }, self )
	end; world:addEventListener( "finalize" )

	function trackObj.stopCamera( self )
		ignore("enterFrame", world)
		world:removeEventListener("finalize")
		world.finalize = nil
	end

end


-- ==
--		trackingLooseCircle() - Same as trackingLooseRectangle, but using bounding circles
-- ==
function camera.trackingLooseCircle( trackObj, world, params )	

	if( not isValid( trackObj ) ) then return end
	if( not isValid( world ) ) then return end

	params     = params or {}
	local debugEn 	 = params.debugEn or false
	local deadRadius = params.deadRadius or 100
	local bufferSize = params.bufferSize or 50
	local maxRadius  = deadRadius + bufferSize

	local innerCircle 
	local outerCircle

	if( debugEn ) then
		innerCircle = display.newCircle( display.currentStage, centerX, centerY, deadRadius )
		innerCircle:setFillColor(0,0,0,0)
		innerCircle:setStrokeColor(0,1,1,1)
		innerCircle.strokeWidth = 2

		if( bufferSize > 0 ) then
			outerCircle = display.newCircle( display.currentStage, centerX, centerY, maxRadius )
			outerCircle:setFillColor(0,0,0,0)
			outerCircle:setStrokeColor(1,0,0,1)
			outerCircle.strokeWidth = 2
		end
	end

	world.lx = trackObj.x
	world.ly = trackObj.y

	world.enterFrame = function( event )
		local dx = trackObj.x - world.lx
		local dy = trackObj.y - world.ly
		local lx, ly = trackObj:localToContent( 0, 0 )  -- QUESTION: will allow for offset camera centering?
		local olx, oly = lx - centerX, ly - centerY

		local vLen = len( olx, oly )

		if( innerCircle ) then innerCircle:toFront() end
		if( outerCircle ) then outerCircle:toFront() end
		
		if( vLen <= deadRadius) then 
			world.lx = trackObj.x
			world.ly = trackObj.y
			return false 
		end

		local dLen 
		local moveDelta

		if( bufferSize == 0 ) then
			moveDelta = 1
		else
			dLen = vLen - deadRadius
			if(dLen > bufferSize) then dLen = bufferSize end
			moveDelta = dLen/bufferSize
		end


		if(dx or dy) then	
			world:translate(-dx * moveDelta,-dy * moveDelta)
			world.lx = trackObj.x
			world.ly = trackObj.y
		end

		return false
	end
	listen( "enterFrame", world )

	function trackObj.destroyCamera( self )
		display.remove(innerCircle)
		display.remove(outerCircle)
		ignoreList( { "enterFrame" }, self )
	end

	world.finalize = function( self )
		ignoreList( { "enterFrame" }, self )
	end; world:addEventListener( "finalize" )

	function trackObj.stopCamera( self )
		ignore("enterFrame", world)
		world:removeEventListener("finalize")
		world.finalize = nil
	end
  
end


-- ==
--		transitioning() - tbd
-- ==
function camera.transitioning( trackObj, world, params )	

	if( not isValid( trackObj ) ) then return end
	if( not isValid( world ) ) then return end
	
	params = params or {}	
   local time     = params.time or 250
   local myEasing = params.easing or easing.linear
	local lockX    = params.lockX 
	local lockY    = params.lockY
	local centered = fnn( params.centered, false)

	local lx = 0
	local ly = 0

	if( centered ) then
		if( lockX ) then
			lx = trackObj.x
		else
			lx = centerX
		end

		if( lockY ) then
			ly = trackObj.y
		else
			ly = centerY
		end
	else
		lx = trackObj.x
		ly = trackObj.y
	end

	trackObj.updateCamera = function( event )
		local dx = 0
		local dy = 0
		if(not lockX) then dx = trackObj.x - lx end		
		if(not lockY) then dy = trackObj.y - ly end      
		if(dx or dy) then	
         transition.to( world, { x = world.x - dx, y = world.y - dy, time = time, transition = myEasing } )
			lx = trackObj.x
			ly = trackObj.y
		end
		return false
	end
	listen( "enterFrame", world )

	world.finalize = function( self )
		ignoreList( { "enterFrame" }, self )
	end; world:addEventListener( "finalize" )

	function trackObj.stopCamera( self )
		ignore("enterFrame", world)
		world:removeEventListener("finalize")
		world.finalize = nil
	end

end

----------------------------------------------------------------------
--	4. The Module
----------------------------------------------------------------------
if( _G.ssk ) then
	ssk.camera = camera
else 
	_G.ssk = { camera = camera }
end

return camera