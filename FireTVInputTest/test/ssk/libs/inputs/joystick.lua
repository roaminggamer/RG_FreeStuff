-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
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
-- Docs: https://github.com/roaminggamer/SSKCorona/wiki
-- =============================================================
--local debugLevel = 2 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

-- Create the inputs class if it does not yet exist
--
local inputs
if( not _G.ssk.inputs ) then
	_G.ssk.inputs = {}
end
inputs = _G.ssk.inputs

-- =======================
-- ====================== Joystick Builder
-- =======================
-- ==
--    ssk.inputs:createJoystick( ) - Creates a simple joystick input device on the screen.
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
	local outerAlpha		= params.outerAlpha or 1

	if( outerImg ) then
		outerFill			= params.outerFill or _WHITE_
		outerStrokeColor	= params.outerStrokeColor or _TRANSPARENT_
	else
		outerFill			= params.outerFill or _TRANSPARENT_
		outerStrokeColor	= params.outerStrokeColor or _DARKGREY_
	end

	-- Stick Parameters
	--	
	local stickRadius		= params.stickRadius or outerRadius/2
	local stickImg			= params.stickImg
	local stickFill
	local stickStrokeColor
	local stickStrokeWidth	= params.stickStrokeWidth or 0
	local stickAlpha		= params.stickAlpha or 1

	if( stickImg ) then
		stickFill			= params.stickFill or _WHITE_
		stickStrokeColor	= params.stickStrokeColor or _TRANSPARENT_
	else
		stickFill			= params.stickFill or _DARKGREY_
		stickStrokeColor	= params.stickStrokeColor or _DARKGREY_
	end

	-- Dead Zone Parameters
	--	
	local deadZoneRadius		= params.deadZoneRadius or outerRadius/2
	local deadZoneImg			= params.deadZoneImg
	local deadZoneFill
	local deadZoneStrokeColor
	local deadZoneStrokeWidth	= params.deadZoneStrokeWidth or 4
	local deadZoneAlpha			= params.deadZoneAlpha or 1

	if( deadZoneImg ) then
		deadZoneFill			= params.deadZoneFill or _WHITE_
		deadZoneStrokeColor		= params.deadZoneStrokeColor or _TRANSPARENT_
	else
		deadZoneFill			= params.deadZoneFill or _TRANSPARENT_
		deadZoneStrokeColor		= params.deadZoneStrokeColor or _DARKGREY_
	end


	-- Misc Parameters
	--	
	local eventName			= params.eventName or "joystickEvent"
	local inputObj			= params.inputObj
	local inUseAlpha		= params.inUseAlpha or 1
	local notInUseAlpha		= params.notInUseAlpha or 0
	local useAlphaFadeTime	= params.useAlphaFadeTime or 0


	-- Create the joystick container (a group)
	--
	local joystick  = display.newGroup()
	group:insert(joystick)

	-- Create the outer ring of the 'joystick'
	--
	local outerRing
	if( outerImg ) then
		outerRing  = ssk.display.imageRect( joystick, x, y, outerImg, 
			{ fill = outerFill, stroke = outerStrokeColor, strokeWidth = outerStrokeWidth,  
			  size = outerRadius*2 } ) 
	else
		outerRing  = ssk.display.circle( joystick, x, y,
			{ fill = outerFill, stroke = outerStrokeColor, strokeWidth = outerStrokeWidth, 
			  radius = outerRadius } ) 
	end
	outerRing.alpha = outerAlpha


	-- Create the inner ring (dead zone) of the 'joystick'
	--
	local innerRing
	if( deadZoneImg ) then
		innerRing  = ssk.display.imageRect( joystick, x, y, deadZoneImg, 
			{ fill = deadZoneFill, stroke = deadZoneStrokeColor, strokeWidth = deadZoneStrokeWidth,  
			  size = deadZoneRadius*2 } ) 
	else
		innerRing  = ssk.display.circle( joystick, x, y,
			{ fill = deadZoneFill, stroke = deadZoneStrokeColor, strokeWidth = deadZoneStrokeWidth, 
			  radius = deadZoneRadius }, nil, nil ) 
	end
	innerRing.alpha = deadZoneAlpha


	-- Create the stick of the 'joystick'
	--
	local stick
	if( stickImg ) then
		stick  = ssk.display.imageRect( joystick, x, y, stickImg, 
			{ fill = stickFill, stroke = stickStrokeColor, strokeWidth = stickStrokeWidth,  
			  size = stickRadius*2 } ) 
	else
		stick  = ssk.display.circle( joystick, x, y,
			{ fill = stickFill, stroke = stickStrokeColor, strokeWidth = stickStrokeWidth, 
			  radius = stickRadius }, nil, nil ) 
	end
	stick.alpha = stickAlpha
	
	local radiusDelta = outerRadius - deadZoneRadius

	--joystick.alpha = notInUseAlpha
	transition.to( joystick, { alpha = notInUseAlpha, time = useAlphaFadeTime } )

	if(inputObj) then

		function joystick:touch( event )
			local target  = event.target
			local eventID = event.id

			if(event.phase == "began") then
				display.getCurrentStage():setFocus( target, eventID )
				target.isFocus = true

				local newX,newY = event.x,event.y

				if( (newX + outerRing.width/2) >= w) then
					newX = w - outerRing.width/2
				end

				if( (newX - outerRing.width/2) <= 0 ) then
					newX = outerRing.width/2
				end

				if( (newY + outerRing.height/2) >= h) then
					newY = h - outerRing.height/2
				end

				if( (newY - outerRing.height/2) <= 0) then
					newY = outerRing.height/2
				end

				outerRing.x,outerRing.y = newX, newY
				innerRing.x,innerRing.y = newX, newY
				stick.x,stick.y = event.x,event.y

				--joystick.alpha = inUseAlpha
				transition.to( joystick, { alpha = inUseAlpha, time = useAlphaFadeTime } )
			end

			local vx,vy = ssk.math2d.sub(outerRing.x, outerRing.y, event.x, event.y)
			local nx,ny = ssk.math2d.normalize(vx,vy)

			if(vx == 0 ) then
				nx = 0
			else
				nx = round(nx,4)
			end

			if(vy == 0 ) then
				ny = 0
			else
				ny = round(ny,4)	
			end

			local angle 

			if(nx == 0 and ny == 0 ) then
				angle = 0
			else
				angle = ssk.math2d.vector2Angle(vx,vy)
			end
		
			if(angle < 0) then angle = angle + 360 end

			local vLen  = ssk.math2d.length(vx,vy)
		
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
						local dx,dy = ssk.math2d.angle2Vector(angle)
						dx,dy = ssk.math2d.scale(dx,dy,outerRadius)
						stick.x,stick.y = ssk.math2d.add( outerRing.x, outerRing.y, dx,dy)
					end
					if(iLen < 0) then
						percent = 0
					elseif(iLen > radiusDelta) then
						percent = 100
					else
						percent = round(iLen/radiusDelta,4) * 100
					end
				end
			end	
		
			dprint(2, round(angle,2), round(nx,2), round(ny,2), round(percent,2))
			if(percent == 0 ) then
				ssk.gem:post(eventName, {angle=angle, vx=vx, vy=vy, nx=nx, ny=ny, percent=percent, phase = event.phase, state = "off" })
			else
				ssk.gem:post(eventName, {angle=angle, vx=vx, vy=vy, nx=nx, ny=ny, percent=percent, phase = event.phase, state = "on" })
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

			local vx,vy = ssk.math2d.sub(outerRing.x, outerRing.y, event.x, event.y)
			local nx,ny = ssk.math2d.normalize(vx,vy)

			if(vx == 0 ) then
				nx = 0
			else
				nx = round(nx,4)
			end

			if(vy == 0 ) then
				ny = 0
			else
				ny = round(ny,4)	
			end

			local angle 

			if(nx == 0 and ny == 0 ) then
				angle = 0
			else
				angle = ssk.math2d.vector2Angle(vx,vy)
			end

			if(angle < 0) then angle = angle + 360 end

			local vLen  = ssk.math2d.length(vx,vy)
		
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
						local dx,dy = ssk.math2d.angle2Vector(angle)
						dx,dy = ssk.math2d.scale(dx,dy,outerRadius)
						stick.x,stick.y = ssk.math2d.add( outerRing.x, outerRing.y, dx,dy)
					end
					if(iLen < 0) then
						percent = 0
					elseif(iLen > radiusDelta) then
						percent = 100
					else
						percent = round(iLen/radiusDelta,4) * 100
					end
				end
			end
		
			dprint(2, round(angle,2), round(nx,2), round(ny,2), round(percent,2))
			if(percent == 0 ) then
				ssk.gem:post(eventName, {angle=angle, vx=vx, vy=vy, nx=nx, ny=ny, percent=percent, phase = event.phase, state = "off" })
			else
				ssk.gem:post(eventName, {angle=angle, vx=vx, vy=vy, nx=nx, ny=ny, percent=percent, phase = event.phase, state = "on" })
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
