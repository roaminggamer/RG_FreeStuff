-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
local getTimer  = system.getTimer

-- =============================================================
-- Locals
-- =============================================================
local useCache = false
local debugLevel = 0

local effect

local highp = system.getInfo( "gpuSupportsHighPrecisionFragmentShaders" )

if( highp ) then
	effect = require( "ssk.huds.tickShader" )
	graphics.defineEffect( effect )
end

-- =============================================================
-- Forward Declarations
-- =============================================================

-- =============================================================
-- Localized Functions
-- =============================================================
local sSub  		= string.sub
local getTimer 		= system.getTimer

local fnn = function( ... ) 
	for i = 1, #arg do
		local theArg = arg[i]
		if(theArg ~= nil) then return theArg end
	end
	return nil
end

-- ==
--    isInBounds( obj, obj2 ) - Is the center of obj over obj2 (inside its axis aligned bounding box?)
-- ==
local function isInBounds( obj, obj2 )

	if(not obj2) then return false end

	local bounds = obj2.contentBounds
	if( obj.x > bounds.xMax ) then return false end
	if( obj.x < bounds.xMin ) then return false end
	if( obj.y > bounds.yMax ) then return false end
	if( obj.y < bounds.yMin ) then return false end
	return true
end

local function isInBounds_alt( obj, obj2 )

	--print("POINK", obj.x, obj.y, obj2.x, obj2.y)

	if(not obj2) then return false end

	local cw2 = obj2.contentWidth/2
	local ch2 = obj2.contentHeight/2

	local xMax = obj2.x + cw2
	local xMin = obj2.x - cw2
	local yMax = obj2.y + ch2
	local yMin = obj2.y - ch2

	--print("POINK", obj.x, obj.y, xMax, xMin, yMax, yMin)

	local bounds = obj2.contentBounds
	if( obj.x > xMax ) then return false end
	if( obj.x < xMin ) then return false end
	if( obj.y > yMax ) then return false end
	if( obj.y < yMin ) then return false end
	return true
end




local round = function(val, n)
  if (n) then
    return math.floor( (val * 10^n) + 0.5) / (10^n)
  else
    return math.floor(val+0.5)
  end
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

local function vAdd( x1, y1, x2, y2, alt )
	if( alt ) then 
		return { x = x2+x1, y = y2+y1 }
	end
	return x2+x1, y2+y1
end

local function vSub( x1, y1, x2, y2, alt )
	if( alt ) then 
		return { x = x2-x1, y = y2-y1 }
	end
	return x2-x1, y2-y1
end

local function vLen( x, y )
	return mSqrt( x * x + y * y )
end

local function vNorm( x, y, alt )	
	local vLen = len( x, y )

	if( alt ) then 
		return { x = x/vLen, y = y/vLen }
	end
	return x/vLen, y/vLen
end


local a2v
local a2vCache = {}
if( useCache ) then


	for i = 0,360 do
		local screenAngle = mRad(-(i+90))
		local x = mCos(screenAngle) 
		local y = mSin(screenAngle) 
		a2vCache[i] = { -x, y }
	end
	a2v = function( angle, alt )
		if( alt ) then
			return { x = a2vCache[angle][1], y = a2vCache[angle][2] }
		end
		return a2vCache[angle][1], a2vCache[angle][2] 
	end

else
	a2v = function( angle, alt )
		local screenAngle = mRad(-(angle+90))
		local x = mCos(screenAngle) 
		local y = mSin(screenAngle) 
		if( alt ) then
			return { x = -x, y = y }
		end
		return -x,y
	end
end

local function v2a( x, y )
	return mCeil(mAtan2( y, x ) * 180 / mPi) + 90	
end

local function vScale( x, y, mag, alt )
	if( alt ) then
		return { x = x*mag, y = y*mag }
	end
	return x*mag,y*mag
end

local function newTimerHUD( group, x, y, c1, c2 )
	local group = group or display.currentStage

	local c1 = c1 or {1,1,1,1}
	local c2 = c2 or {1,0,0,1}

	local hud = display.newGroup()
	group:insert(hud)
	

	-- Back Fill
	local backFill = display.newRect( hud, 0, 0, 360, 360 )
	backFill.anchorX = 0.5
	backFill.anchorY = 0.5

	if( c1.type == nil ) then
		backFill:setFillColor( unpack( c1 ) )
	else
		backFill.fill = c1
	end
	

	hud.x = x
	hud.y = y
	local lines = {}
	--local center = { x = 0, y = 0 }

    local numLines = 360 * 3
    local numLines = 600

    local dpl = 360/numLines

	for i = 1, numLines do

		--local vec = { x = 0, y = -1 }
		local vec = a2v( i * dpl, true )
		vec = vScale( vec.x, vec.y , 360/2, true )
		local line = display.newLine( hud, 0, 0, vec.x, vec.y )

		line.strokeWidth = 2
		line.strokeWidth = 3
		lines[#lines+1] = line

		if( c2.type == nil ) then
			line:setStrokeColor( unpack( c2 ) )
		else
			line.fill = c2
		end

	end

	local mask 

	--print( display.imageSuffix )
	if( display.imageSuffix == "@4x" ) then
		--print( "using 4X" )
		mask = graphics.newMask( "images/dialMask4.png" )
		hud:setMask( mask )
		hud.maskScaleX = 0.23
		hud.maskScaleY = 0.23
	elseif( display.imageSuffix == "@2x" ) then
		--print( "using 4X" )
		mask = graphics.newMask( "images/dialMask2.png" )
		hud:setMask( mask )
		hud.maskScaleX = 0.46
		hud.maskScaleY = 0.46
	else
		--print( "using 4X" )
		mask = graphics.newMask( "images/dialMask.png" )
		hud:setMask( mask )
	end
	

	hud.x = x
	hud.y = y

	hud.setPercent = function ( self, percent )
		--print("setPercent", percent, round(#lines * percent/100), #lines)

		local numOn = round( #lines * percent/100 )

		for i = 1, #lines do
			lines[i].isVisible = ( numOn >= i ) 
		end
	end

	--hud:scale(0.5,0.5)

	return hud

end


local function newTimerHUD2( group, x, y, params )
	local group 		= group or display.currentStage
	local params 		= params or {}
	local foreFill 		= params.foreFill or {1,0,0,1}
	local backFill 		= params.backFill or {1,1,1,1}
	local dialRadius 	= params.radius or 100
	local dialTicks  	= params.ticks or 360
	local foreImg    	= params.foreImg or params.img
	local backImg    	= params.backImg or params.img
	local tickW 		= params.tickW or 10
	local tickH 		= params.tickH or 10
	local rotateTick    = params.rotateTick or false
	local useCircle 	= fnn( params.useCircle, true )
	local smooth 		= fnn( params.smooth, false )

	-- EFM fore and back shaders?

	local dpt 			= 360/dialTicks

	local hud = display.newGroup()
	group:insert(hud)

	local backTicks = {}
	local foreTicks = {}

	local angle = 0
	for i = 1, dialTicks do
		local vec = a2v( angle, true )
		vec = vScale( vec.x, vec.y, dialRadius, true )
		vec = vAdd( vec.x, vec.y, x, y, true )

		if( foreImg ) then
			aTick = display.newImageRect( hud, foreImg, tickW, tickH )
			if(smooth and highp) then
				aTick.fill.effect = "filter.tickShader"
				aTick.fill.effect.horizontal.blurSize = 2
				aTick.fill.effect.vertical.blurSize = 2	
			end
		else
			local aTick
			if( useCircle ) then
				aTick = display.newCircle( hud, vec.x, vec.y, tickW/2 )
			else
				aTick = display.newRect( hud, 0, 0, tickW, tickH )
			end
		end

		aTick.x = vec.x
		aTick.y = vec.y
		if( rotateTick ) then
			aTick.rotation = angle
		end
		aTick:toBack()
		foreTicks[i] = aTick
		aTick:setFillColor( unpack( foreFill ) )

		angle = angle + dpt
	end


	for i = 1, #foreTicks do
		local foreTick = foreTicks[i]
		if( backImg ) then
			aTick = display.newImageRect( hud, backImg, tickW, tickH )
			if(smooth and highp ) then
				aTick.fill.effect = "filter.tickShader"
				aTick.fill.effect.horizontal.blurSize = 8
				aTick.fill.effect.vertical.blurSize = 8	
			end
		else
			local aTick
			if( useCircle ) then
				aTick = display.newCircle( hud, foreTick.x, foreTick.y, tickW/2 )
			else
				aTick = display.newRect( hud, 0, 0, tickW, tickH )
			end
			aTick:setFillColor( unpack( backFill ) )
		end

		aTick.x = foreTick.x
		aTick.y = foreTick.y
		if( rotateTick ) then
			aTick.rotation = angle
		end
		aTick:toBack()
		backTicks[i] = aTick
		aTick:setFillColor( unpack( backFill ) )

		angle = angle + dpt
	end


	hud.setPercent = function ( self, percent )
		--print("setPercent", percent, round(#lines * percent/100), #lines)

		local numOn = round( #foreTicks * percent/100 )

		for i = 1, #foreTicks do
			foreTicks[i].isVisible = ( numOn >= i ) 
		end
	end


	
--[[
	-- Back Fill
	local backFill = display.newRect( hud, 0, 0, 360, 360 )
	backFill.anchorX = 0.5
	backFill.anchorY = 0.5

	if( backFill.type == nil ) then
		backFill:setFillColor( unpack( backFill ) )
	else
		backFill.fill = backFill
	end
	

	hud.x = x
	hud.y = y
	local lines = {}
	--local center = { x = 0, y = 0 }

    local numLines = 360 * 3
    local numLines = 600

    local dpl = 360/numLines

	for i = 1, numLines do

		--local vec = { x = 0, y = -1 }
		local vec = a2v( i * dpl, true )
		vec = vScale( vec.x, vec.y , 360/2, true )
		local line = display.newLine( hud, 0, 0, vec.x, vec.y )

		line.strokeWidth = 2
		line.strokeWidth = 3
		lines[#lines+1] = line

		if( foreFill.type == nil ) then
			line:setStrokeColor( unpack( foreFill ) )
		else
			line.fill = foreFill
		end

	end

	local mask 

	--print( display.imageSuffix )
	if( display.imageSuffix == "@4x" ) then
		--print( "using 4X" )
		mask = graphics.newMask( "images/dialMask4.png" )
		hud:setMask( mask )
		hud.maskScaleX = 0.23
		hud.maskScaleY = 0.23
	elseif( display.imageSuffix == "@2x" ) then
		--print( "using 4X" )
		mask = graphics.newMask( "images/dialMask2.png" )
		hud:setMask( mask )
		hud.maskScaleX = 0.46
		hud.maskScaleY = 0.46
	else
		--print( "using 4X" )
		mask = graphics.newMask( "images/dialMask.png" )
		hud:setMask( mask )
	end
	

	hud.x = x
	hud.y = y

	hud.setPercent = function ( self, percent )
		--print("setPercent", percent, round(#lines * percent/100), #lines)

		local numOn = round( #lines * percent/100 )

		for i = 1, #lines do
			lines[i].isVisible = ( numOn >= i ) 
		end
	end

	--hud:scale(0.5,0.5)

	--]]	

	return hud

end


local public = {}

public.timerDial = newTimerHUD
public.timerDial2 = newTimerHUD2


return public