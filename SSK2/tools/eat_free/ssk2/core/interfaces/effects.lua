-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Development Notes:
-- 1. Some features still not exposed/documented.
-- 2. Easy Fly Out Not Ready yet

local function easyFlyIn( obj, params )
	local params = params or {}
	
	local delay 			= params.delay or 0
	local time 				= params.time or 250
	local myEasing 			= params.myEasing or easing.outBack
	local startOffsetX		= params.sox or 0
	local startOffsetY		= params.soy or 0
	local startDeltaRot		= params.sdr or 0
	local startDeltaScaleX	= params.sdsx or 1
	local startDeltaScaleY	= params.sdsy or 1
	local onComplete		= params.onComplete
	local onCompleteLabel	= params.onCompleteLabel

	local x = obj.x
	local y = obj.y
	local xL = (obj.label) and obj.label.x or 0
	local yL = (obj.label) and obj.label.y or 0

	local rotation = obj.rotation
	local scaleX = obj.xScale
	local scaleY = obj.YScale

	local labelRotation
	local labelScaleX
	local labelScaleY
	if( obj.label ) then
		labelScaleX = obj.label.xScale
		labelScaleY = obj.label.yScale
		labelRotation = obj.label.rotation
	end

	obj:translate( startOffsetX, startOffsetY )
	obj.xScale = obj.xScale * startDeltaScaleX
	obj.yScale = obj.yScale * startDeltaScaleY
	obj.rotation = obj.rotation + startDeltaRot

	transition.to( obj, { x = x, y = y, rotation = rotation, xScale = scaleX, yScale = scaleY, 
		                  transition = myEasing, delay = delay, time = time, onComplete = onComplete } )
	
	if(obj.label) then
		obj.label:translate( startOffsetX, startOffsetY )
		obj.label.xScale = obj.label.xScale * startDeltaScaleX
		obj.label.yScale = obj.label.yScale * startDeltaScaleY
		obj.label.rotation = obj.label.rotation + startDeltaRot

		transition.to( obj.label, { x = xL, y = yL, rotation = labelRotation, xScale = labelScaleX, yScale = labelScaleY, 
			                        transition = myEasing, delay = delay, time = time, onComplete = onCompleteLabel } )
	end
end

local function easyFlyOut( obj, params )
	local params = params or {}
	
	local delay 			= params.delay or 0
	local time 				= params.time or 250
	local myEasing 		= params.myEasing or easing.outBack
	local endOffsetX		= params.eox or 0
	local endOffsetY		= params.eoy or 0
	local endDeltaRot		= params.edr or 0
	local endDeltaScaleX	= params.edsx or 0
	local endDeltaScaleY	= params.edsy or 0
	local onComplete		= params.onComplete

	transition.to( obj, { x = obj.x + endOffsetX,
		                   y = obj.y + endOffsetY,
		                   rotation = obj.rotation + endDeltaRot,
		                   --xScale = obj.xScale + endDeltaScaleX,
		                   --yScale = obj.yScale + endDeltaScaleY,
		                   delay = delay, time = time, onComplete = onComplete } )
	
end


local function easySqueeze( obj, xScale1, yScale1, xScale2, yScale2, delay, time1, time2, time3, myEasing, myEasing2, myEasing3 )
	local myEasing = myEasing or easing.outBack
	local myEasing2 = myEasing2 or myEasing
	local myEasing3 = myEasing3 or myEasing

	local xScale = obj.xScale
	local yScale = obj.yScale


	local function scale3( self )
		transition.to( self, 
			{ xScale = xScale, yScale = yScale, transition = myEasing, time = time3} )
		if(self.label) then
			transition.to( self.label, 
				{ xScale = xScale, yScale = yScale, transition = myEasing, time = time3} )
		end
	end

	local function scale2( self )
		transition.to( self, 
			{ xScale = xScale2, yScale = yScale2, transition = myEasing2, time = time2, onComplete=scale3 } )
		if(self.label) then
			transition.to( self.label, 
				{ xScale = xScale2, yScale = yScale2, transition = myEasing2, time = time2, onComplete=scale3 } )		end
	end

	local function scale1( self )
		transition.to( self, 
			{ xScale = xScale1, yScale = yScale1, transition = myEasing3, delay = delay, time = time1, onComplete=scale2 } )
		if(self.label) then
			transition.to( self.label, 
				{ xScale = xScale1, yScale = yScale1, transition = myEasing3, delay = delay, time = time1, onComplete=scale2 } )
		end
	end
	scale1( obj )
end

local function easyInflate( obj, xScale1, yScale1, xScale2, yScale2, xScale3, yScale3, delay, time1, time2, time3, myEasing, myEasing2, myEasing3 )
	local myEasing = myEasing or easing.outBack
	local myEasing2 = myEasing2 or myEasing
	local myEasing3 = myEasing3 or myEasing

	obj.xScale = xScale1
	obj.yScale = yScale1

	local function scale3( self )
		transition.to( self, 
			{ xScale = xScale2, yScale = yScale2, transition = myEasing, time = time3} )
		if(self.label) then
			transition.to( self.label, 
				{ xScale = xScale2, yScale = yScale2, transition = myEasing, time = time3} )
		end
	end

	local function scale2( self )
		transition.to( self, 
			{ xScale = xScale3, yScale = yScale3, transition = myEasing2, time = time2, onComplete=scale3 } )
		if(self.label) then
			transition.to( self.label, 
				{ xScale = xScale3, yScale = yScale3, transition = myEasing2, time = time2, onComplete=scale3 } )
		end
	end

	local function scale1( self )
		transition.to( self, 
			{ xScale = xScale2, yScale = yScale2, transition = myEasing3, delay = delay, time = time1, onComplete=scale2 } )
		if(self.label) then
			transition.to( self.label, 
				{ xScale = xScale2, yScale = yScale2, transition = myEasing3, delay = delay, time = time1, onComplete=scale2 } )
		end
	end
	scale1( obj )
end


-- This is a placeholder and not meant to be used yet.
--
-- You were warned!
-- 
--

local function traySwipe( self, event )
	local phase = event.phase
	local inBounds = display.pointInRect( event, obj )
	local stage = display.getCurrentStage()

	local left			= self.left
	local right			= self.right
	local halfPageWidth	= self.halfPageWidth
		        
	if(phase == "began") then
		stage:setFocus(self, event.id)
		self.isFocus = true			

		self.startX = self.x
		self.lastTime = event.time
		self.lastX = event.x
			
		if(self.lastTransition) then
			transition.cancel( self.lastTransition )
		end
		
	elseif( self.isFocus ) then

		if(phase == "moved") then
			self.x = self.startX + (event.x - event.xStart )
		        
			local dx = event.x - self.lastX
			local dt = event.time - self.lastTime
			self.pps = 1000 * dx/dt

			self.lastTime = event.time
			self.lastX = event.x

		elseif(phase == "ended" or phase == "cancelled") then
			if(self.lastTransition) then
				transition.cancel( self.lastTransition )
			end

			local function rePosition()
				print(self.x, -self.right + halfPageWidth * 2)


				local distance = math.abs( self.x - self.left)
				
				if(self.x > self.left) then
					self.lastTransition = transition.to( self, 
						{ x = self.left, delay = 0, time = self.contentWidth/2, transition=easing.outExpo } )

					self.pagination1of3.isVisible = true 
					self.pagination2of3.isVisible = false
					self.pagination3of3.isVisible = false

				elseif(self.x < 110 and self.x > 0) then
					self.lastTransition = transition.to( self, 
					{ x = self.left, delay = 0, time = self.contentWidth/2, transition=easing.outExpo } )
					self.pagination1of3.isVisible = true 
					self.pagination2of3.isVisible = false
					self.pagination3of3.isVisible = false

				elseif(self.x < 0 and self.x > -220) then
					self.lastTransition = transition.to( self, 
					{ x = self.left - 220, delay = 0, time = self.contentWidth/2, transition=easing.outExpo } )
					self.pagination1of3.isVisible = false 
					self.pagination2of3.isVisible = true
					self.pagination3of3.isVisible = false

				elseif(self.x < -220 and self.x > -440) then
					self.lastTransition = transition.to( self, 
					{ x = self.left - 440, delay = 0, time = self.contentWidth/2, transition=easing.outExpo } )
					self.pagination1of3.isVisible = false 
					self.pagination2of3.isVisible = false
					self.pagination3of3.isVisible = true

				elseif(self.x < -self.right + halfPageWidth  * 2 ) then
					self.lastTransition = transition.to( self, 
						{ x = -self.right + halfPageWidth  * 2, delay = 0, time = self.contentWidth/2, transition=easing.outExpo } )

					self.pagination1of3.isVisible = false 
					self.pagination2of3.isVisible = false
					self.pagination3of3.isVisible = true
				else
					--self.lastTransition = transition.to( self, 
						--{ x = self.left, delay = 500, time = distance, transition=easing.outExpo } )
				end
			end

			if(math.abs( self.pps ) > 900 ) then
				self.pps = 900
			end

			--if(math.abs( self.pps ) > 250 ) then
				--transition.to( self, { x = self.x + self.pps/4, time = 333, onComplete = rePosition } )
			--else
				rePosition()
			--end

			stage:setFocus(self, nil)
			self.isFocus = false

			--transition.to( self, { x = left - right + halfPageWidth, time = 3000 } )

		end
	end		 
	return true
end

local function doShrink( obj, to )
	to = to or 0.85
	transition.to( obj, { xScale = to, yScale = to, time = 50 })
	if(obj.label) then
		transition.to( obj.label, { xScale = to, yScale = to, time = 50 })
	end
end

local function doGrow( obj, to )
	to = to or 1
	transition.to( obj, { xScale = to, yScale = to, time = 250, transition = easing.outBounce })
	if(obj.label) then
		transition.to( obj.label, { xScale = to, yScale = to, time = 250, transition = easing.outBounce })
	end
end

local easyFlip = function ( obj, params )
	local params = params or {}
	
	local delay 			= params.delay or 0
	local time 				= params.time or 250
	local myEasing 		= params.myEasing or easing.linear
	local startXScale		= params.sxs or -1
	local startYScale		= params.sys or 1

	obj.xScale = startXScale
	obj.yScale = startYScale

	transition.to( obj, { xScale = 1, yScale = 1, transition = myEasing, delay = delay, time = time } )
end



-- ==
--    Pinch Zoom Drag Code
--
--    Code is MIT licensed, see http://www.coronalabs.com/links/code/license
--    Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
-- ==
local function calculateDelta( previousTouches, event )
	local id,touch = next( previousTouches )
	if event.id == id then
		id,touch = next( previousTouches, id )
		assert( id ~= event.id )
	end

	local dx = touch.x - event.x
	local dy = touch.y - event.y
	return dx, dy
end

-- create a table listener object for the bkgd image
local isDragging = false
local mSqrt = math.sqrt
local minDragDist = 3

local function setMinDragDist( dist )
	minDragDist = dist or 3
end

local function pinchZoomDragTouch( self, event )
	local result = true

	local phase = event.phase

	local previousTouches = self.previousTouches

	local numTotalTouches = 1
	if ( previousTouches ) then
		-- add in total from previousTouches, subtract one if event is already in the array
		numTotalTouches = numTotalTouches + self.numPreviousTouches
		if previousTouches[event.id] then
			numTotalTouches = numTotalTouches - 1
		end
	end

	if "began" == phase then
		-- Very first "began" event
		if ( not self.isFocus ) then
			-- Subsequent touch events will target button even if they are outside the contentBounds of button
			display.getCurrentStage():setFocus( self )
			self.isFocus = true

			previousTouches = {}
			self.previousTouches = previousTouches
			self.numPreviousTouches = 0

			self.x0 = self.x
			self.y0 = self.y
		
		elseif( isDragging ) then 
			return true 

		elseif ( not self.distance ) then
			local dx,dy

			if previousTouches and ( numTotalTouches ) >= 2 then
				dx,dy = calculateDelta( previousTouches, event )
			end

			-- initialize to distance between two touches
			if ( dx and dy ) then
				local d = math.sqrt( dx*dx + dy*dy )
				if ( d > 0 ) then
					self.distance = d
					self.xScaleOriginal = self.xScale
					self.yScaleOriginal = self.yScale
					print( "distance = " .. self.distance )
				end
			end
		end

		if not previousTouches[event.id] then
			self.numPreviousTouches = self.numPreviousTouches + 1
		end
		previousTouches[event.id] = event

	elseif self.isFocus then
		if "moved" == phase then
			--print(numTotalTouches)
			if( isDragging == false and numTotalTouches == 1 ) then
				local dx, dy = event.x - event.xStart, event.y - event.yStart
				local len = mSqrt(dx * dx + dy * dy)
				if( len > minDragDist ) then
					isDragging = true
					self.isDragging = true
				end
			end


			if( isDragging ) then
				local dx, dy = event.x - event.xStart, event.y - event.yStart

				self.x = self.x0 + dx
				self.y = self.y0 + dy


			elseif ( self.distance ) then
				local dx,dy
				if previousTouches and ( numTotalTouches ) >= 2 then
					dx,dy = calculateDelta( previousTouches, event )
				end
	
				if ( dx and dy ) then
					local newDistance = math.sqrt( dx*dx + dy*dy )
					local scale = newDistance / self.distance
					print( "newDistance(" ..newDistance .. ") / distance(" .. self.distance .. ") = scale("..  scale ..")" )
					if ( scale > 0 ) then
						self.xScale = self.xScaleOriginal * scale
						self.yScale = self.yScaleOriginal * scale
					end
				end
			end

			if not previousTouches[event.id] then
				self.numPreviousTouches = self.numPreviousTouches + 1
			end
			previousTouches[event.id] = event

		elseif "ended" == phase or "cancelled" == phase then
			if previousTouches[event.id] then
				self.numPreviousTouches = self.numPreviousTouches - 1
				previousTouches[event.id] = nil
			end

			if ( #previousTouches > 0 ) then
				-- must be at least 2 touches remaining to pinch/zoom
				self.distance = nil
			else
				-- previousTouches is empty so no more fingers are touching the screen
				-- Allow touch events to be sent normally to the objects they "hit"
				display.getCurrentStage():setFocus( nil )

				self.isFocus = false
				self.distance = nil
				self.xScaleOriginal = nil
				self.yScaleOriginal = nil

				-- reset array
				self.previousTouches = nil
				self.numPreviousTouches = nil
			end

			self.x0 = nil
			self.y0 = nil
			if( self.isDragging and isDragging ) then
				self.isDragging = nil
				isDragging = false
			end
		end
	end

	return result
end


local function pulse( obj, params )
	params = params or {}
	local scale 		= params.scale or 1.5
	local delay 		= params.delay or 0
	local time 			= params.time or 500
	local myEasing1 		= params.easing1 or easing.inOutQuad
	local myEasing2 		= params.easing2 or easing.inOutQuad
	local onComplete 	= params.onComplete
	transition.to( obj, { delay = delay, time = time, xScale = scale, yScale = scale, onComplete = onComplete, transition = myEasing1 })
	transition.to( obj, { delay = delay + time, time = time, xScale = 1, yScale = 1, onComplete = onComplete, transition = myEasing2 })
end


----------------------------------------------------------------------
-- 5. Package Module
----------------------------------------------------------------------
local public = {}

public.easyFlyIn				= easyFlyIn
public.easyFlyOut				= easyFlyOut
public.easySqueeze 			= easySqueeze
public.easyInflate 			= easyInflate

public.doShrink 				= doShrink
public.doGrow 					= doGrow

public.easyFlip				= easyFlip

public.pulse					= pulse

public.pinchZoomDragTouch 	= pinchZoomDragTouch
public.setMinDragDist 		= setMinDragDist


return public
