-- =============================================================
-- RGEasyPush.lua - A set of simple utilities designed to simplify the design of push button based interfaces.
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
if( not _G.ssk ) then
	_G.ssk = {}
end


-- ==
--    fnn( ... ) - Return first argument from list that is not nil.
--    ... - Any number of any type of arguments.
-- ==
local function fnn( ... ) 
	for i = 1, #arg do
		local theArg = arg[i]
		if(theArg ~= nil) then return theArg end
	end
	return nil
end

-- ==
--    isDisplayObject( obj ) - Check if an object is valid and has NOT had removeSelf() called yet.
--    obj - The object to test.
-- == 
local function isDisplayObject( obj )
	if( obj and obj.removeSelf and type(obj.removeSelf) == "function") then return true end
	return false
end


-- ==
--    round(val, n) - Rounds a number to the nearest decimal places. (http://lua-users.org/wiki/FormattingNumbers)
--    val - The value to round.
--    n - Number of decimal places to round to.
-- ==
local function round(val, n)
  if (n) then
    return math.floor( (val * 10^n) + 0.5) / (10^n)
  else
    return math.floor(val+0.5)
  end
end


--==
--   newImage( group, ... ) -- A universal image to enable one-line specifications.
--==
local function newImage( group, ... )

	local group = group or display.currentStage
	local params = params or {}

	local fileName
	local imageSheet
	local frameIndex
	local x
	local y
	local params

	--table.dump(arg)

	if(type(arg[1]) == "string" ) then
		fileName = arg[1]
		x = arg[2] or 0
		y = arg[3] or 0
		params = arg[4] or {}

	else
		imageSheet = arg[1]
		frameIndex = arg[2] or 1
		x = arg[3] or 0
		y = arg[4] or 0
		params = arg[5] or {}
	end

	local tmp 

	if( fileName ~= nil ) then
		if( params.w ) then
			tmp = display.newImageRect( group, fileName, params.w, params.h )
		else
			tmp = display.newImage( group, fileName )
			print("Warning: Using newImage() - A")
		end
	else
		if( params.w ) then
			tmp = display.newImageRect( group, imageSheet, frameIndex, params.w, params.h )
		else
			tmp = display.newImage( group, imageSheet, frameIndex )
			--print("Warning: Using newImage() - B")
		end
	end

	if(params.ref) then
		tmp:setReferencePoint( params.ref )
	end


	if(params.xScale) then
		tmp.xScale = params.xScale
	elseif( params.scale ) then
		tmp.xScale = params.scale
	end

	if(params.yScale) then
		tmp.yScale = params.yScale
	elseif( params.scale ) then
		tmp.yScale = params.scale
	end

	local ignoreParams = {}
	ignoreParams["w"]		= "w"
	ignoreParams["h"]		= "h"
	ignoreParams["size"]	= "size"
	ignoreParams["xScale"]	= "xScale"
	ignoreParams["yScale"]	= "yScale"
	ignoreParams["scale"]	= "scale"
	ignoreParams["stroke"]	= "stroke"
	ignoreParams["fill"]	= "fill"

	ignoreParams["label"]		= "label"
	ignoreParams["labelFont"]	= "labelFont"
	ignoreParams["labelSize"]	= "labelSize"
	ignoreParams["labelColor"]	= "labelColor"

	if( params ) then
		for k,v in pairs( params ) do
			if( ignoreParams[k] == nil ) then
				tmp[k] = v
			end
		end
	end

	if(params.fill) then
		tmp:setFillColor( unpack( params.fill ) )
	end

	if(params.stroke) then
		tmp:setStrokeColor( unpack( params.stroke ) )
	end

	tmp.x = x
	tmp.y = y

	-- Add optional label
	local label 
	if( params.label ) then
		local labelText = params.label
		local labelFont = params.labelFont or native.systemFont
		local labelSize = params.labelSize or 10
		local labelColor = params.labelColor or {1,1,1,1}

		label = display.newText( group, labelText, tmp.x, tmp.y, labelFont, labelSize )
		label:setFillColor( unpack( labelColor ) )
		tmp.label = label

		if(params.xScale) then
			label.xScale = params.xScale
		elseif( params.scale ) then
			label.xScale = params.scale
		end

		if(params.yScale) then
			label.yScale = params.yScale
		elseif( params.scale ) then
			label.yScale = params.scale
		end
	end
	
	return tmp, label
end


--==
--   newRect( group, x, y, params )
--==
local function newRect( group, x, y, params )

	local group = group or display.currentStage
	local params = params or {}

	local x = x or centerX
	local y = y or centerY
	local params = params or params

	local lw = fnn( params.w, params.size, 64 )
	local lh = fnn( params.h, params.size, 64 )

	local tmp 

	tmp = display.newRect( group, 0, 0, lw, lh )

	if(params.ref) then
		tmp:setReferencePoint( params.ref )
	end

	if(params.xScale) then
		tmp.xScale = params.xScale
	elseif( params.scale ) then
		tmp.xScale = params.scale
	end

	if(params.yScale) then
		tmp.yScale = params.yScale
	elseif( params.scale ) then
		tmp.yScale = params.scale
	end


	local ignoreParams = {}
	ignoreParams["w"]		= "w"
	ignoreParams["h"]		= "h"
	ignoreParams["size"]	= "size"
	ignoreParams["xScale"]	= "xScale"
	ignoreParams["yScale"]	= "yScale"
	ignoreParams["scale"]	= "scale"
	ignoreParams["stroke"]	= "stroke"
	ignoreParams["fill"]	= "fill"

	ignoreParams["label"]		= "label"
	ignoreParams["labelFont"]	= "labelFont"
	ignoreParams["labelSize"]	= "labelSize"
	ignoreParams["labelColor"]	= "labelColor"

	if( params ) then
		for k,v in pairs( params ) do
			if( ignoreParams[k] == nil ) then
				tmp[k] = v
			end
		end
	end

	if(params.fill) then
		tmp:setFillColor( unpack( params.fill ) )
	end

	if(params.stroke) then
		tmp:setStrokeColor( unpack( params.stroke ) )
	end

	--table.dump(params)

	tmp.x = x
	tmp.y = y
	
	-- Add optional label
	local label 
	if( params.label ) then
		local labelText = params.label
		local labelFont = params.labelFont or native.systemFont
		local labelSize = params.labelSize or 10
		local labelColor = params.labelColor or {1,1,1,1}

		label = display.newText( group, labelText, tmp.x, tmp.y, labelFont, labelSize )
		label:setFillColor( unpack( labelColor ) )
		tmp.label = label

		if(params.xScale) then
			label.xScale = params.xScale
		elseif( params.scale ) then
			label.xScale = params.scale
		end

		if(params.yScale) then
			label.yScale = params.yScale
		elseif( params.scale ) then
			label.yScale = params.scale
		end
	end


	return tmp, label
end


--==
--   newCircle( group, x, y, params )
--==
local function newCircle( group, x, y, params )

	local group = group or display.currentStage
	local params = params or {}

	local x = x or centerX
	local y = y or centerY
	local params = params or params

	local size = fnn( params.size, 64 )
	local radius = fnn( params.radius, size/2 )

	local tmp 

	tmp = display.newCircle( group, x, y, radius )

	if(params.ref) then
		tmp:setReferencePoint( params.ref )
	end

	if(params.xScale) then
		tmp.xScale = params.xScale
	elseif( params.scale ) then
		tmp.xScale = params.scale
	end

	if(params.yScale) then
		tmp.yScale = params.yScale
	elseif( params.scale ) then
		tmp.yScale = params.scale
	end


	local ignoreParams = {}
	ignoreParams["radius"]	= "radius"
	ignoreParams["size"]	= "size"
	ignoreParams["xScale"]	= "xScale"
	ignoreParams["yScale"]	= "yScale"
	ignoreParams["scale"]	= "scale"
	ignoreParams["stroke"]	= "stroke"

	ignoreParams["label"]		= "label"
	ignoreParams["labelFont"]	= "labelFont"
	ignoreParams["labelSize"]	= "labelSize"
	ignoreParams["labelColor"]	= "labelColor"

	if( params ) then
		for k,v in pairs( params ) do
			if( ignoreParams[k] == nil ) then
				tmp[k] = v
			end
		end
	end

	if(params.fill) then
		tmp:setFillColor( unpack( params.fill ) )
	end

	if(params.stroke) then
		tmp:setStrokeColor( unpack( params.stroke ) )
	end

	--table.dump(params)

	tmp.x = x
	tmp.y = y
	
	-- Add optional label
	local label 
	if( params.label ) then
		local labelText = params.label
		local labelFont = params.labelFont or native.systemFont
		local labelSize = params.labelSize or 10
		local labelColor = params.labelColor or {1,1,1,1}

		label = display.newText( group, labelText, tmp.x, tmp.y, labelFont, labelSize )
		label:setFillColor( unpack( labelColor ) )
		tmp.label = label

		if(params.xScale) then
			label.xScale = params.xScale
		elseif( params.scale ) then
			label.xScale = params.scale
		end

		if(params.yScale) then
			label.yScale = params.yScale
		elseif( params.scale ) then
			label.yScale = params.scale
		end

	end

	return tmp, label
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




--==
--   easyPushButton( obj, cb, params ) -- Converts a screen object into a push-button.
--==
local function easyPushButton( obj, cb, params)

	local params = params or {}
	local normalScale		= fnn(params.normalScale, 1)
	local pressedScale		= fnn(params.pressedScale, 0.9)
	local normalEasing 		= fnn(params.normalEasing, params.easing) 
	local pressedEasing 	= fnn(params.pressedEasing, params.easing) 
	local pressedScaleTime	= fnn(params.pressedScaleTime, params.scaleTime, 100)
	local normalScaleTime	= fnn(params.normalScaleTime, params.scaleTime, 100)
	local cbDelay			= fnn(params.cbDelay, 150)
	local normalFill		= params.normalFill 
	local pressedFill		= params.pressedFill
	local hideOnPressed 	= fnn(params.hideOnPressed, false)
	local timeout 			= fnn(params.timeout, 0)
	local allowPassThrough 	= fnn(params.allowPassThrough, false)
	
	if( normalFill ) then
		obj:setFillColor( unpack( normalFill ) )	
	end

	local lastPressTime = system.getTimer()
	obj.touch = function ( self, event )
		local phase = event.phase
		local inBounds = isInBounds( event, obj )
		local stage = display.getCurrentStage()
		local curTime = system.getTimer()
		        
		if(phase == "began") then			
			local dt = curTime - lastPressTime
			if( dt < timeout ) then return not allowPassThrough end

			stage:setFocus(self, event.id)
			self.isFocus = true			
			if( pressedScale ) then
				transition.to( self, { time= pressedScaleTime, xScale=pressedScale, yScale=pressedScale, transition = pressedEasing})
				if(self.label) then
					transition.to( self.label, { time=pressedScaleTime, xScale=pressedScale, yScale=pressedScale, transition = pressedEasing})
				end
			end
			self.isOver = true
			if( pressedFill ) then
				self:setFillColor( unpack( pressedFill ) )
			end
			self.isVisible = not hideOnPressed
			if(self.label) then
				self.label.isVisible = not hideOnPressed
			end
		
		elseif( self.isFocus ) then

			-- Undo selected effects
			if(not inBounds and self.isOver ) then
				self.isOver = false
				if( normalScale ) then
					transition.to( self, { time= normalScaleTime, xScale=normalScale, yScale=normalScale, transition = normalEasing})
					if(self.label) then
						transition.to( self.label, { time = normalScaleTime, xScale=normalScale, yScale=normalScale, transition = normalEasing})
					end
				end
				if( normalFill ) then
					self:setFillColor( unpack( normalFill ) )
				end
				self.isVisible = true
				if(self.label) then
					self.label.isVisible = true
				end
		
			-- Redo selected effects
			elseif(inBounds and not self.isOver ) then
				self.isOver = true
				if( pressedScale ) then
					transition.to( self, { time= pressedScaleTime, xScale=pressedScale, yScale=pressedScale, transition = pressedEasing})
					if(self.label) then
						transition.to( self.label, { time= pressedScaleTime, xScale=pressedScale, yScale=pressedScale, transition = pressedEasing})
					end
				end
				if( pressedFill ) then
					self:setFillColor( unpack( pressedFill ) )
				end
				self.isVisible = not hideOnPressed
				if(self.label) then
					self.label.isVisible = not hideOnPressed
				end
			end
			
			if(phase == "moved") then
		        
			elseif(phase == "ended" or phase == "cancelled") then
				stage:setFocus(self, nil)
				self.isFocus = false

				lastPressTime = curTime

				if( inBounds ) then

					self.isOver = false
					if( normalScale ) then
						transition.to( self, { time= normalScaleTime, xScale=normalScale, yScale=normalScale, transition = normalEasing})
						if(self.label) then
							transition.to( self.label, { time= normalScaleTime, xScale=normalScale, yScale=normalScale, transition = normalEasing})
						end
					end
					if( normalFill ) then
						self:setFillColor( unpack( normalFill ) )
					end
					self.isVisible = true
					if(self.label) then
						self.label.isVisible = true
					end

					if( cb ) then
						timer.performWithDelay( cbDelay, function()  cb( obj, event ) end )
					end
				end
			end
		end		 
		return not allowPassThrough
	end
	obj:addEventListener( "touch", obj )

end

local function easyFlyIn( obj, startOffsetX, startOffsetY, delay, time, myEasing )
	local myEasing = myEasing or easing.outBack

	local x = obj.x
	local y = obj.y
	obj:translate( startOffsetX, startOffsetY )
	transition.to( obj, { x = x, y = y, transition = myEasing, delay = delay, time = time } )
	if(obj.label) then
		obj.label:translate( startOffsetX, startOffsetY )
		transition.to( obj.label, { x = x, y = y, transition = myEasing, delay = delay, time = time } )
	end
end

local function easyFlyIn2( obj, params )
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


local function comma_value(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
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

			--print( "PPS = ", round( self.pps, 4 ) )
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

local function quickLabel( group, text, x, y, font, fontSize, fontColor, anchorX )
	local anchorX = fnn(anchorX, 0.5)
	local font = font or  native.systemFontBold
	local fontSize = fontSize or 10
	local fontColor = fontColor or _WHITE_

	local label = display.newText( group, text, 0, 0, font, fontSize )
	label.anchorX = anchorX
	label.x = x
	label.y = y
	label:setFillColor(unpack(fontColor))

	return label
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



----------------------------------------------------------------------
-- 5. Package Module
----------------------------------------------------------------------
local public = {}


public.newImage			= newImage
public.newRect			= newRect
public.newCircle		= newCircle

public.easyPushButton 	= easyPushButton
public.isInBounds 		= isInBounds
public.easyFlyIn 		= easyFlyIn
public.easyFlyIn2		= easyFlyIn2
public.easySqueeze 		= easySqueeze
public.easyInflate 		= easyInflate
--EFM public.traySwipe 		= traySwipe

public.doShrink 		= doShrink
public.doGrow 			= doGrow

public.quickLabel 		= quickLabel

public.comma_value 		= comma_value
public.round			= round
public.fnn				= fnn
public.isDisplayObject	= isDisplayObject

_G.ssk.easyPush = public
return public
