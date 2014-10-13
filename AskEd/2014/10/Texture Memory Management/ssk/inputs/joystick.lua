-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- Input Objects Factory
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
-- =============================================================
local getTimer  = system.getTimer

local debugLevel = 0

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

local inputs = {}

-- =======================
-- ====================== Joystick Builder
-- =======================
-- ==
--    inputs:createJoystick( ) - Creates a simple joystick input device on the screen.
-- ==
function inputs:createJoystick( group, x, y, params )

	-- If group is nil, default to current stage
	--
	local group = group or display.currentStage

	-- Set up defaults for values not specified in params table
	--
	local params			= params or {}

	-- Outer Ring Parameters
	--	
	local outerRadius		= params.outerRadius or 60
	local outerImg			= params.outerImg
	local outerFill
	local outerStrokeColor
	local outerStrokeWidth	= params.outerStrokeWidth or 4
	local outerAlpha		= params.outerAlpha or params.alpha or 1

	if( outerImg ) then
		outerFill			= params.outerFill or {1,1,1,1}
		outerStrokeColor	= params.outerStrokeColor or {1,1,1,0}
	else
		outerFill			= params.outerFill or {1,1,1,0}
		outerStrokeColor	= params.outerStrokeColor or {0.25,0.25,0.25,1}
	end

	-- Stick Parameters
	--	
	local stickRadius		= params.stickRadius or outerRadius/2
	local stickImg			= params.stickImg
	local stickFill
	local stickStrokeColor
	local stickStrokeWidth	= params.stickStrokeWidth or 0
	local stickAlpha		= params.stickAlpha or params.alpha or 1

	if( stickImg ) then
		stickFill			= params.stickFill or {1,1,1,1}
		stickStrokeColor	= params.stickStrokeColor or {1,1,1,0}
	else
		stickFill			= params.stickFill or {0.25,0.25,0.25,1}
		stickStrokeColor	= params.stickStrokeColor or {0.25,0.25,0.25,1}
	end

	-- Dead Zone Parameters
	--	
	local deadZoneRadius		= params.deadZoneRadius or outerRadius/2
	local deadZoneImg			= params.deadZoneImg
	local deadZoneFill
	local deadZoneStrokeColor
	local deadZoneStrokeWidth	= params.deadZoneStrokeWidth or 4
	local deadZoneAlpha			= params.deadZoneAlpha or params.alpha or 1

	if( deadZoneImg ) then
		deadZoneFill			= params.deadZoneFill or {1,1,1,1}
		deadZoneStrokeColor		= params.deadZoneStrokeColor or {1,1,1,0}
	else
		deadZoneFill			= params.deadZoneFill or {1,1,1,0}
		deadZoneStrokeColor		= params.deadZoneStrokeColor or {0.25,0.25,0.25,1}
	end


	-- Misc Parameters
	--	
	local eventName			= params.eventName or "joystickEvent"
	local inputObj			= params.inputObj
	local inUseAlpha		= params.inUseAlpha or 1
	local notInUseAlpha		= params.notInUseAlpha or 0
	local useAlphaFadeTime	= params.useAlphaFadeTime or 0

	local doNorm 		= params.doNorm or false 


	-- Create the joystick container (a group)
	--
	local joystick  = display.newGroup()
	group:insert(joystick)

	-- Create the outer ring of the 'joystick'
	--
	local outerRing
	if( outerImg ) then
		outerRing  = display.newImageRect( joystick, outerImg, outerRadius*2, outerRadius*2 )
		outerRing:setFillColor( unpack( outerFill )  )
		outerRing:setStrokeColor( unpack( outerStrokeColor )  )
		outerRing.strokeWidth = outerStrokeWidth
	else
		outerRing  = display.newCircle( joystick, x, y, outerRadius)
		outerRing:setFillColor( unpack( outerFill )  )
		outerRing:setStrokeColor( unpack( outerStrokeColor )  )
		outerRing.strokeWidth = outerStrokeWidth
	end
	outerRing.alpha = outerAlpha


	-- Create the inner ring (dead zone) of the 'joystick'
	--
	local innerRing
	if( deadZoneImg ) then
		innerRing  = display.newImageRect( joystick, deadZoneImg, deadZoneRadius*2, deadZoneRadius*2 )
		innerRing:setFillColor( unpack( deadZoneFill )  )
		innerRing:setStrokeColor( unpack( deadZoneStrokeColor )  )
		innerRing.strokeWidth = deadZoneStrokeWidth
	else
		innerRing  = display.newCircle( joystick, x, y, deadZoneRadius)
		innerRing:setFillColor( unpack( deadZoneFill )  )
		innerRing:setStrokeColor( unpack( deadZoneStrokeColor )  )
		innerRing.strokeWidth = deadZoneStrokeWidth
	end
	innerRing.alpha = deadZoneAlpha


	-- Create the stick of the 'joystick'
	--
	local stick
	if( stickImg ) then

		stick  = display.newImageRect( joystick, stickImg, stickRadius*2, stickRadius*2 )
		stick:setFillColor( unpack( stickFill )  )
		stick:setStrokeColor( unpack( stickStrokeColor )  )
		stick.strokeWidth = stickStrokeWidth
	else
		stick  = display.newCircle( joystick, x, y, stickRadius)
		stick:setFillColor( unpack( stickFill )  )
		stick:setStrokeColor( unpack( stickStrokeColor )  )
		stick.strokeWidth = stickStrokeWidth

	end
	stick.alpha = stickAlpha
	
	local radiusDelta = outerRadius - deadZoneRadius

	--joystick.alpha = notInUseAlpha
	transition.to( joystick, { alpha = notInUseAlpha, time = useAlphaFadeTime } )

	if(inputObj) then

--EFM		local lastTime = system.getTimer()
		function joystick:touch( event )
			local target  = event.target
			local eventID = event.id
--EFM			local deltaTime = event.time - lastTime
--EFM			if( deltaTime < 30 ) then
--EFM				return
--EFM			end
--EFM			lastTime = event.time

			if(event.phase == "began") then
				display.getCurrentStage():setFocus( target, eventID )
				target.isFocus = true

				local newX,newY = event.x,event.y

				if( (newX + outerRing.contentWidth/2) >= w + unusedWidth/2) then
					newX = (w + unusedWidth/2) - outerRing.contentWidth/2
				end

				if( (newX - outerRing.contentWidth/2) <= -unusedWidth/2 ) then
					newX = outerRing.contentWidth/2-unusedWidth/2
				end

				if( (newY + outerRing.contentHeight/2) >= display.actualContentHeight) then
					newY = display.actualContentHeight - outerRing.contentHeight/2
				end

				if( (newY - outerRing.contentHeight/2) <= 0) then
					newY = outerRing.contentHeight/2
				end

				outerRing.x,outerRing.y = newX, newY
				innerRing.x,innerRing.y = newX, newY
				stick.x,stick.y = event.x,event.y

				--joystick.alpha = inUseAlpha
				transition.to( joystick, { alpha = inUseAlpha, time = useAlphaFadeTime } )
			end

			local vx,vy = sub(outerRing.x, outerRing.y, event.x, event.y)

			local nx,ny = norm(vx,vy,doNorm)


			if(vx == 0 ) then
				nx = 0
			else
				nx = round4(nx,4)
			end

			if(vy == 0 ) then
				ny = 0
			else
				ny = round4(ny,4)	
			end

			local angle 

			if(nx == 0 and ny == 0 ) then
				angle = 0
			else
				angle = v2a(vx,vy)
			end
		
			if(angle < 0) then angle = angle + 360 end

			local vLen  = len(vx,vy)
		
			local iLen  = vLen - deadZoneRadius

			local percent = 0

			if(event.phase == "began") then
				if(iLen < 0) then
					percent = 0
				elseif(iLen > radiusDelta) then
					percent = 1
				else
					percent = iLen/radiusDelta
				end

			elseif(target.isFocus) then
				if(event.phase == "ended" or event.phase == "cancelled") then
					display.getCurrentStage():setFocus( nil, eventID ) -- EFM this is wrong?!
					stick.x,stick.y = outerRing.x, outerRing.y

					angle = 0
					vx = 0
					vy = 0
					nx = 0
					ny = 0
					percent = 0

					--joystick.alpha = notInUseAlpha
					transition.to( joystick, { alpha = notInUseAlpha, time = useAlphaFadeTime } )

				elseif(event.phase == "moved") then
					if(vLen <= outerRadius ) then
						stick.x,stick.y = event.x, event.y
					else
						local dx,dy = a2v(angle)
						dx,dy = scale(dx,dy,outerRadius)
						stick.x,stick.y = add( outerRing.x, outerRing.y, dx,dy)
					end
					if(iLen < 0) then
						percent = 0
					elseif(iLen > radiusDelta) then
						percent = 100
					else
						percent = round4(iLen/radiusDelta,4) * 100
					end
				end
			end	

			if( not doNorm ) then 
				nx = nil
				ny = nil
			end
		
			--print( round4(angle,2), round4(nx,2), round4(ny,2), round4(percent,2))
			if(percent == 0 ) then
				post(eventName, {angle=angle, vx=vx, vy=vy, nx=nx, ny=ny, percent=percent, phase = event.phase, state = "off" },debugLevel)
			else
				post(eventName, {angle=angle, vx=vx, vy=vy, nx=nx, ny=ny, percent=percent, phase = event.phase, state = "on" },debugLevel)
			end
			return true
		end
	else
		function joystick:touch( event )
			local target  = event.target
			local eventID = event.id

			if(event.phase == "began") then
				display.getCurrentStage():setFocus( target, eventID )
				target.isFocus = true
				stick.x,stick.y = event.x, event.y
				
				--joystick.alpha = inUseAlpha
				transition.to( joystick, { alpha = inUseAlpha, time = useAlphaFadeTime } )
			end

			local vx,vy = sub(outerRing.x, outerRing.y, event.x, event.y)
			local nx,ny = vx,vy --norm(vx,vy)

			if(vx == 0 ) then
				nx = 0
			else
				nx = round4(nx,4)
			end

			if(vy == 0 ) then
				ny = 0
			else
				ny = round4(ny,4)	
			end

			local angle 

			if(nx == 0 and ny == 0 ) then
				angle = 0
			else
				angle = v2a(vx,vy)
			end

			if(angle < 0) then angle = angle + 360 end

			local vLen  = len(vx,vy)
		
			local iLen  = vLen - deadZoneRadius

			local percent = 0

			if(event.phase == "began") then
				if(iLen < 0) then
					percent = 0
				elseif(iLen > radiusDelta) then
					percent = 1
				else
					percent = iLen/radiusDelta
				end

			elseif(target.isFocus) then
				if(event.phase == "ended" or event.phase == "cancelled") then
					display.getCurrentStage():setFocus( nil, eventID )
					stick.x,stick.y = outerRing.x, outerRing.y

					angle = 0
					vx = 0
					vy = 0
					nx = 0
					ny = 0
					percent = 0

					--joystick.alpha = notInUseAlpha
					transition.to( joystick, { alpha = notInUseAlpha, time = useAlphaFadeTime } )

				elseif(event.phase == "moved") then
					if(vLen <= outerRadius ) then
						stick.x,stick.y = event.x, event.y
					else
						local dx,dy = a2v(angle)
						dx,dy = scale(dx,dy,outerRadius)
						stick.x,stick.y = add( outerRing.x, outerRing.y, dx,dy)
					end
					if(iLen < 0) then
						percent = 0
					elseif(iLen > radiusDelta) then
						percent = 100
					else
						percent = round4(iLen/radiusDelta,4) * 100
					end
				end
			end
		
			--print( round4(angle,2), round4(nx,2), round4(ny,2), round4(percent,2))
			if(percent == 0 ) then
				post(eventName, {angle=angle, vx=vx, vy=vy, nx=nx, ny=ny, percent=percent, phase = event.phase, state = "off" },debugLevel)
			else
				post(eventName, {angle=angle, vx=vx, vy=vy, nx=nx, ny=ny, percent=percent, phase = event.phase, state = "on" },debugLevel)
			end
			return true
		end
	end
	

	if(inputObj) then
		-- Input object catches touches, but the joystick container handles the processing
		--
		inputObj:addEventListener( "touch", joystick )		
	else	
		-- Joystick (outer ring) object catches touches, and the joystick container handles the processing
		--
		outerRing:addEventListener( "touch", joystick )		
	end
	


	-- ==
	--    joystick:destroy( event ) - Destroy joystick parts and clean up event listeners
	-- ==

	function joystick:destroy( event )
--[[ EFM remove me?
		outerRing:removeEventListener( "touch", joystick )		
		stick:removeSelf()
		innerRing:removeSelf()
		outerRing:removeSelf()
--]]
	end
	return joystick
end

return inputs