-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
--
-- =============================================================

----------------------------------------------------------------------
--	Declarations
----------------------------------------------------------------------
-- Variables
local currentPips = {}

local theHUD

-- Forward Declarations
local createHUD
local destroyHUD

local watchObject
local ignoreObject

local updateHUD

local vecLen
local vecSquareLen 

-- Callbacks

-- Localizations (for speedup)
local mAbs 				= math.abs
local mPow 				= math.pow
local mRand 			= math.random
local getInfo			= system.getInfo
local getTimer 			= system.getTimer
local strMatch 			= string.match
local strFormat 		= string.format
local mDeg  			= math.deg
local mRad  			= math.rad
local mCos  			= math.cos
local mSin  			= math.sin
local mAcos 			= math.acos
local mAsin 			= math.asin
local mSqrt 			= math.sqrt
local mCeil 			= math.ceil
local mFloor 			= math.floor
local mAtan2 			= math.atan2
local mPi 				= math.pi

----------------------------------------------------------------------
--	Core Definitions
----------------------------------------------------------------------

-- ==
--    createHUD - EFM
-- ==
createHUD = function( group, x, y, radius, radiusEquivalent, backColor, borderColor, centerObject  )
	local group 			= group or display.currentStage
	local radius 			= radius or 60
	local x 				= display.contentWidth - radius - 5
	local y 				= radius + 5
	local radiusEquivalent 	= radiusEquivalent or display.contentWidth  
	local backColor 		= backColor or { 0.1, 0.1, 0.3, 0.5 }
	local borderColor 		= borderColor or { 0.8, 0.8, 0.2, 0.5 }
	
	destroyHUD()	

	theHUD = display.newGroup()
	group:insert( theHUD )

	-- Calculate a distance based on HUD radius vs what that radius is equivalent to in world pixels
	theHUD.distScale = radius / radiusEquivalent

	-- Remember the HUD radius
	theHUD.radius = radius
	theHUD.radius2 = radius * radius 

	-- The HUD Background
	local tmp = display.newCircle( theHUD, 0, 0, radius )
	tmp:setFillColor( unpack( backColor ) )
	tmp:setStrokeColor( unpack( borderColor ) )
	tmp.strokeWidth = 1

	-- The HUD Center (us)
	local tmp = display.newRect( theHUD, 0, 0, 2, 2 )
	tmp.x = 0
	tmp.y = 0
	tmp:setFillColor( 0,1,0 )

	-- Create a ring showing the visible edge of the radar space	
	local vw = radius / radiusEquivalent * display.contentWidth	
	local vh = vw * display.contentHeight / display.contentWidth
	local tmp = display.newRect( theHUD, 0, 0, vw, vh)
	tmp:setFillColor( 0,0,0,0 )
	tmp:setStrokeColor( unpack( borderColor ) )
	tmp.strokeWidth = 1
	tmp.x = 0
	tmp.y = 0
	tmp.alpha = 0.2

	-- Add enterFrame event listener to HUD and have it update the position of all 
	-- current tracking objects, every frame
	theHUD.enterFrame = updateHUD
	Runtime:addEventListener( "enterFrame", theHUD )

	--
	-- Pre-calculate the center for the 'radar' area
	--
	theHUD.cx = display.contentCenterX
	theHUD.cy = display.contentCenterY

	theHUD.x = x
	theHUD.y = y
	return theHUD 
end

-- ==
--    destroyHUD - EFM
-- ==
destroyHUD = function( )
	for k,v in pairs(currentPips) do
		display.remove(v)
	end		
	if( theHUD ) then 
		Runtime:removeEventListener( "enterFrame", theHUD )
		display.remove( theHUD ) 
	end

	currentPips = {}
	theHUD = nil
end

-- ==
--    watchObject - Create a pip for tracking an object in our HUD
-- ==
watchObject = function( obj, pipColor, size )
	local pipColor 	= pipColor or { 1, 0, 0 }
	local size 		= size or 2

	-- 1. Create a pip representing the object to track 
	local tmp = display.newRect( theHUD, 0, 0, size, size )

	-- 2. Color it, place it, and hide it for now
	tmp:setFillColor( unpack( pipColor ) )
	tmp.isVisible = false
	tmp.x = 0
	tmp.y = 0

	-- 3. Store the pip (use the object it represents as the index)
	currentPips[obj] = tmp
end

-- ==
--    ignoreObject - EFM
-- ==
ignoreObject = function( obj )
	if( currentPips[obj] ) then 
		display.remove( currentPips[obj] )
		currentPips[obj] = nil
	end
end

-- ==
--    updateHUD - EFM
-- ==
updateHUD = function( self )
	-- localize for speedup
	local cx = theHUD.cx
	local cy = theHUD.cy
	local squareRadius = theHUD.radius2
	for k, v in pairs( currentPips ) do
		local x = k.x - cx
		local y = k.y - cy
		x = x * theHUD.distScale
		y = y * theHUD.distScale
		v.x = x 
		v.y = y
		-- Hide the pip if it is 'off radar' (beyond the HUD radius)
		v.isVisible = squareRadius > vecSquareLen( x, y )
	end
end


----------------------------------------------------------------------
--	Utility Code (used above)
----------------------------------------------------------------------
-- ==
--    vecLen( x, y ) - Calculates the length of vector <x, y> 
-- ==
vecLen = function( x, y )
	return mSqrt(x * x + y * y)
end

-- ==
--    vecSquareLen( x, y ) - Calculates the squared length of vector <x, y> 
-- ==
vecSquareLen = function( x, y )
	return x * x + y * y
end

----------------------------------------------------------------------
--	The Module
----------------------------------------------------------------------
local public = {}

public.create 		= createHUD
public.destroy 		= destroyHUD
public.watchObject	= watchObject
public.ignoreObject	= ignoreObject

return public
