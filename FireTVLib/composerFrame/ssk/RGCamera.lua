-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- =============================================================
local getTimer  = system.getTimer

----------------------------------------------------------------------
--	1. Requires
----------------------------------------------------------------------

----------------------------------------------------------------------
--	2. Locals and Declarations
----------------------------------------------------------------------

local w = display.contentWidth
local h = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local displayWidth        = (display.contentWidth - display.screenOriginX*2)
local displayHeight       = (display.contentHeight - display.screenOriginY*2)
local unusedWidth    = display.actualContentWidth - w
local unusedHeight   = display.actualContentHeight -h



local round4 = function(val)
	return math.floor( (val * 10000) + 0.5) / 10000
end

local post

if( _G.post ) then
	post = _G.post
else
	post = function( name, params, debuglvl )
		local params = params or {}
		local event = { name = name }
		for k,v in pairs( params ) do
			event[k] = v
		end
		if( not event.time ) then event.time = getTimer() end
		if( debuglvl and debuglvl >= 2 ) then table.dump(event) end
		Runtime:dispatchEvent( event )
		if( debuglvl and debuglvl >= 1 ) then print("post( '" .. name .. "' )" ) end   
	end
end

if( not table.dump ) then
	function string:rpad(len, char)
		local theStr = self
	    if char == nil then char = ' ' end
	    return theStr .. string.rep(char, len - #theStr)
	end

	function table.dump(theTable, padding ) -- Sorted

		local theTable = theTable or  {}

		local tmp = {}
		for n in pairs(theTable) do table.insert(tmp, n) end
		table.sort(tmp)

		local padding = padding or 30
		print("\Table Dump:")
		print("-----")
		if(#tmp > 0) then
			for i,n in ipairs(tmp) do 		

				local key = tostring(tmp[i])
				local value = tostring(theTable[key])
				local keyType = type(key)
				local valueType = type(value)
				local keyString = key .. " (" .. keyType .. ")"
				local valueString = value .. " (" .. valueType .. ")" 

				keyString = keyString:rpad(padding)
				valueString = valueString:rpad(padding)

				print( keyString .. " == " .. valueString ) 
			end
		else
			print("empty")
		end
		print("-----\n")
	end
end

local mAbs 	= math.abs
local type 	= type

local mDeg  = math.deg
local mRad  = math.rad
local mCos  = math.cos
local mSin  = math.sin
local mAcos = math.acos
local mAsin = math.asin
local mSqrt = math.sqrt
local mCeil = math.ceil
local mFloor = math.floor
local mAtan2 = math.atan2
local mPi = math.pi

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


local a2vCache = {}
for i = 0,360 do
	local screenAngle = mRad(-(i+90))
	local x = mCos(screenAngle) 
	local y = mSin(screenAngle) 
	a2vCache[i] = { -x, y }
end
local function a2v( angle )
	return a2vCache[angle][1], a2vCache[angle][2] 
end

--[[
local function a2v( angle )
	print(angle)
	if( a2vCache[tonumber(angle)] ) then return a2vCache[angle][1], a2vCache[angle][2] end
	local screenAngle = mRad(-(angle+90))
	local x = mCos(screenAngle) 
	local y = mSin(screenAngle) 
	a2vCache[tonumber(angle)] = { -x, y }
	return -x,y
end
--]]

local function v2a( x, y )
	return mCeil(mAtan2( y, x ) * 180 / mPi) + 90	
end

local function scale( x, y, mag )
	return x*mag,y*mag
end

local isDisplayObject
if( _G.isDisplayObject ) then
	isDisplayObject = _G.isDisplayObject
else
	isDisplayObject = function ( obj )
		return( obj and obj.removeSelf and type(obj.removeSelf) == "function")
	end
end


----------------------------------------------------------------------
--	3. Definitions
----------------------------------------------------------------------

-- ==
--		fixedCamera() - Follows target exactly.
-- ==
local function fixedCamera( player, layers, params )	
	if( not isDisplayObject( layers ) ) then return end
	
	layers.lx = player.x
	layers.ly = player.y

	layers.world.enterFrame = function( event )
		if( not isDisplayObject( layers ) ) then return end
		local dx = player.x - layers.lx
		local dy = player.y - layers.ly

		if(dx or dy) then	
			layers.world:translate(-dx,-dy)
			layers.lx = player.x
			layers.ly = player.y
		end

		return true
	end
	Runtime:addEventListener( "enterFrame", layers.world )
end

-- ==
--		looseCamera() - Follows target, but has a deadzone followed by an acceleration zone to gradually move the camera.
-- ==
local function looseCamera( player, boundarySize, layers, params )	
	if( not isDisplayObject( layers ) ) then return end

	local minDelta = 0.2

	local boundarySize = boundarySize or 240
	local halfBoundary = boundarySize/2 

	local top = boundarySize
	local bot = h - boundarySize
	local left = boundarySize
	local right = w - boundarySize

	layers.lx = player.x
	layers.ly = player.y

	layers.world.enterFrame = function( event )
		if( not isDisplayObject( layers ) ) then return end
		local dx = player.x - layers.lx
		local dy = player.y - layers.ly

		local lx, ly = player:localToContent( 0, 0 ) 

		
		if( lx > left and lx < right and ly > top and ly < bot ) then 
			layers.lx = player.x
			layers.ly = player.y
			return true 
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
			--print( player:contentToLocal( 0, 0 ) )
			--print( player:localToContent( 0, 0 ) )
			layers.world:translate(-dx * ddx,-dy * ddy)
			layers.lx = player.x
			layers.ly = player.y
		end

		return true
	end
	Runtime:addEventListener( "enterFrame", layers.world )
end


-- ==
--		looseRadialCamera() - Same as loose, but using bounding circle
-- ==
local function looseRadialCamera( player, deadRadius, bufferSize, layers, params )	
	if( not isDisplayObject( layers ) ) then return end

	local params     = params or {}
	local debugEn 	 = params.debugEn or false
	local deadRadius = deadRadius or 100
	local bufferSize = bufferSize or 50
	local maxRadius  = deadRadius + bufferSize

	local innerCircle 
	local outerCircle

	if( debugEn ) then
		innerCircle = display.newCircle( centerX, centerY, deadRadius )
		innerCircle:setFillColor(0,0,0,0)
		innerCircle:setStrokeColor(0,1,1,1)
		innerCircle.strokeWidth = 2

		if( bufferSize > 0 ) then
			outerCircle = display.newCircle( centerX, centerY, maxRadius )
			outerCircle:setFillColor(0,0,0,0)
			outerCircle:setStrokeColor(1,0,0,1)
			outerCircle.strokeWidth = 2
		end
	end

	layers.lx = player.x
	layers.ly = player.y

	layers.world.enterFrame = function( event )
		if( not isDisplayObject( layers ) ) then return end
		local dx = player.x - layers.lx
		local dy = player.y - layers.ly
		local lx, ly = player:localToContent( 0, 0 )  -- EFM will allow for offset camera centering?
		local olx, oly = lx - centerX, ly - centerY

		local vLen = len( olx, oly )

		if( innerCircle ) then innerCircle:toFront() end
		if( outerCircle ) then outerCircle:toFront() end

		--print( vLen, olx, oly, deadRadius, bufferSize, maxRadius)
		
		if( vLen <= deadRadius) then 
			layers.lx = player.x
			layers.ly = player.y
			return true 
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
			layers.world:translate(-dx * moveDelta,-dy * moveDelta)
			layers.lx = player.x
			layers.ly = player.y
		end

		return true
	end
	Runtime:addEventListener( "enterFrame", layers.world )
end

local function looseCamera_orig( player, boundarySize )	
	local settings	= settingsMgr.get()
	local layers	= layersMgr.get()
	if( not isDisplayObject( layers ) ) then return end
	

	local boundarySize = boundarySize or 240
	local halfBoundary = boundarySize/2 

	local top = boundarySize
	local bot = h - boundarySize
	local left = boundarySize
	local right = w - boundarySize

	layers.lx = player.x
	layers.ly = player.y

	layers.world.enterFrame = function( event )
		if( not isDisplayObject( layers ) ) then return end
		local dx = player.x - layers.lx
		local dy = player.y - layers.ly

		local lx, ly = player:localToContent( 0, 0 ) 

		
		if( lx > left and lx < right and ly > top and ly < bot ) then 
			layers.lx = player.x
			layers.ly = player.y
			return true 
		end
		if(dx or dy) then	
			--print( player:contentToLocal( 0, 0 ) )
			--print( player:localToContent( 0, 0 ) )
			layers.world:translate(-dx,-dy)
			layers.lx = player.x
			layers.ly = player.y
		end

		return true
	end
	Runtime:addEventListener( "enterFrame", layers.world )
end

----------------------------------------------------------------------
--	4. The Module
----------------------------------------------------------------------
local public = {}
public.fixed		= fixedCamera
public.edgeBuffer 	= looseCamera
public.radialBuffer	= looseRadialCamera

if( not _G.ssk ) then
	_G.ssk = {}
end
_G.ssk.cameras = public

return public