-- =============================================================
-- effects.lua - 
-- =============================================================
----------------------------------------------------------------------
--	1. Requires
----------------------------------------------------------------------
-- none.

----------------------------------------------------------------------
-- 2. Declarations
----------------------------------------------------------------------

----------------------------------------------------------------------
--	3. Initialization
----------------------------------------------------------------------
-- none.

----------------------------------------------------------------------
-- 4. Definitions
----------------------------------------------------------------------


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


local function easyFlyIn( obj, params )
	local params = params or {}
	
	local delay 			= params.delay or 0
	local time 				= params.time or 250
	local myEasing 			= params.easing or easing.outBack
	local startOffsetX		= params.sox or display.contentWidth
	local startOffsetY		= params.soy or 0
	local startDeltaRot		= params.sdr or 0
	local startDeltaScaleX	= params.sdsx or 1
	local startDeltaScaleY	= params.sdsy or 1

	local x = obj.x
	local y = obj.y

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
		                  transition = myEasing, delay = delay, time = time } )
	
	if(obj.label) then
		obj.label:translate( startOffsetX, startOffsetY )
		obj.label.xScale = obj.label.xScale * startDeltaScaleX
		obj.label.yScale = obj.label.yScale * startDeltaScaleY
		obj.label.rotation = obj.label.rotation + startDeltaRot

		transition.to( obj.label, { x = x, y = y, rotation = labelRotation, xScale = labelScaleX, yScale = labelScaleY, 
			                        transition = myEasing, delay = delay, time = time } )
	end
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


-- EFM
-- This is a placeholder and not meant to be used yet.
--
-- You were warned!
-- 
--

local function traySwipe( self, event )
	local phase = event.phase
	local inBounds = isInBounds( event, obj )
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

local function doShrink( obj )
	transition.to( obj, { xScale = 0.85, yScale = 0.85, time = 50 })
	if(obj.label) then
		transition.to( obj.label, { xScale = 0.85, yScale = 0.85, time = 50 })
	end
end

local function doGrow( obj )
	transition.to( obj, { xScale = 1, yScale = 1, time = 250, transition = easing.outBounce })
	if(obj.label) then
		transition.to( obj.label, { xScale = 1, yScale = 1, time = 250, transition = easing.outBounce })
	end
end

local easyFlip = function ( obj, params )
	local params = params or {}
	
	local delay 			= params.delay or 0
	local time 				= params.time or 250
	local myEasing 			= params.easing or easing.linear
	local startXScale		= params.sxs or -1
	local startYScale		= params.sys or 1

	obj.xScale = startXScale
	obj.yScale = startYScale

	transition.to( obj, { xScale = 1, yScale = 1, transition = myEasing, delay = delay, time = time } )
end


----------------------------------------------------------------------
-- 5. Package Module
----------------------------------------------------------------------
local public = {}


public.isInBounds 		= isInBounds
public.easyFlyIn		= easyFlyIn
public.easySqueeze 		= easySqueeze
public.easyInflate 		= easyInflate
--EFM public.traySwipe 		= traySwipe

public.doShrink 		= doShrink
public.doGrow 			= doGrow

public.easyFlip			= easyFlip


return public
