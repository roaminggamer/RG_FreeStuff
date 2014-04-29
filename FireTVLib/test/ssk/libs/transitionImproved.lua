-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- transition 2  (improved trasition library)
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
-- Adopted from http://developer.coronalabs.com/code/improved-transition-function-calls
-- =============================================================


local tranImprov
if( not _G.ssk.transition ) then
	_G.ssk.transition = {}
end
tranImprov = _G.ssk.transition

-- table to track all transitions
local transitionStack = {}

-- localising math functions
local sin = math.sin
local asin = math.asin
local cos = math.cos
local sqrt = math.sqrt
local abs = math.abs
local PI = math.pi


-- Foward declaration of listener
local transitFunc

-- forward declare functions
local cancel,pause,resume,cancelAll,pauseAll,resumeAll,to,from

---------------------------------------------------------------------------------------------------
-- Transition Easing Functions																	 --
-- Based on Actionscript Easing Equations from Robert Penner http://www.robertpenner.com/easing/ --
-- Open source under the BSD License. 															 --
-- Copyright 2001 Robert Penner																	 --
-- All rights reserved.																			 --
---------------------------------------------------------------------------------------------------
local easings = {}

--[[Linear Easings (t) --]]
easings["linear"] = function(t,b,c,d)
	return c*t/d+b
end

--[[Quadratic Easings (t^2)--]]
easings["inQuad"] = function(t,b,c,d)
	t=t/d
	return c*t*t + b
end

easings["outQuad"] = function(t,b,c,d)
	t=t/d
	return (-c)*t*(t-2) + b
end

easings["inOutQuad"] = function(t,b,c,d)
	t=2*t/d
	if t < 1 then
		return c*0.5*t*t + b
	end
	t=t-1
	return (-c)*0.5*((t)*(t-2)-1) + b
end

--[[Quadratic Easings (t^3)--]]
easings["inCubic"] = function(t,b,c,d)
	return c*((t/d)^3) + b
end

easings["outCubic"] = function(t,b,c,d)
	return c*(((t/d-1)^3)+1) + b
end

easings["inOutCubic"] = function(t,b,c,d)
	t=2*t/d
	if t<1 then
		return c*0.5*(t^3) + b;
	end
	return c*0.5*(((t-2)^3)+2) + b;
end

--[[Quartic Easings (t^4)--]]

easings["inQuart"] = function(t,b,c,d)
	t=t/d
	return c*(t^4) + b;
end

easings["outQuart"] = function(t,b,c,d)
	return -c*(((t/d-1)^4)-1) + b
end

easings["inOutQuart"] = function(t,b,c,d)
	t=2*t/d
	if t < 1 then 
		return c*0.5*(t^4) + b
	end
	return -c*0.5*(((t-2)^4)-2) + b
end

--[[Quintic Easings (t^5)--]]
easings["inQuint"] = function(t,b,c,d)
	return c*((t/d)^5) + b
end

easings["outQuint"] = function(t,b,c,d)
	return c*((t/d-1)^5+1) + b
end

easings["inOutQuint"] = function(t,b,c,d)
	t=2*t/d
	if t<1 then
		return c*0.5*(t^5) + b
	end
	return c*0.5*((t-2)^5+2) + b
end

--[[Exponential Easings (2^t)--]]
easings["inExpo"] = function(t,b,c,d)
	if t == 0 then
		return b
	else
		return c*(2^(10*(t/d-1))) + b
	end
end

easings["outExpo"] = function(t,b,c,d)
	if t==d then
		return b+c
	else
		return c*(-2^(-10*t/d)+1) + b
	end
end

easings["inOutExpo"] = function(t,b,c,d)
	if t==0 then return b end
	if t==d then return b+c end

	t=2*t/d
	if t<1 then 
		return c*0.5*(2^(10*(t-1))) + b
	end
	t=t-1
	return c*0.5*(2-(2^(-10*t))) + b;
end

--[[Sinusoidal Easings (sin t)--]]
easings["inSine"] = function(t,b,c,d)
	return -c*cos(t/d*PI*0.5) + c + b
end

easings["outSine"] = function(t,b,c,d)
	return c*sin(t/d*PI*0.5) + b
end

easings["inOutSine"] = function(t,b,c,d)
	return -c*0.5*(cos(PI*t/d)-1) + b
end

--[[Circular Easings (sqrt(1-t^2))--]]
easings["inCirc"] = function(t,b,c,d)
	t=t/d
	return -c*(sqrt(1-t*t)-1) + b
end

easings["outCirc"] = function(t,b,c,d)
	t=t/d-1
	return c*sqrt(1-t*t) + b;
end

easings["inOutCirc"] = function(t,b,c,d)
	t=2*t/d
	if t<1 then 
		return -c*0.5*(sqrt(1 - t*t)-1) + b
	end
	t=t-2
	return c*0.5*(sqrt(1-t*t)+1) + b
end

--[[Elastic Easings (exponentially decaying sine wave)
customizable period and amplitude swapped out for default presets--]]
easings["inElastic"] = function(t,b,c,d)
	if t==0 then return b end

	t=t/d
	if t==1 then return b+c end

	local p = d*0.3
	local a = abs(c)
	local s = p/(2*PI)*asin(c/a)
	t=t-1
	return -(a*(2^(10*(t)))*sin((t*d-s)*(2*PI)/p)) + b
end

easings["outElastic"] = function(t,b,c,d)
	if t==0 then return b end

	t=t/d
	if t==1 then return b+c end

	local p=d*0.3
	local a=abs(c)
	local s = p/(2*PI)*asin(c/a)

	return a*(2^(-10*t))*sin((t*d-s)*(2*PI)/p) + c + b
end

easings["inOutElastic"] = function(t,b,c,d)
	if t==0 then return b end

	t=2*t/d
	if t==2 then return b+c end

	local p = d*(0.45)
	local a = abs(c)
	local s = p/(2*PI)*asin(c/a)

	if t<1 then
		t=t-1
		return -0.5*(a*(2^(10*t))*sin((t*d-s)*(2*PI)/p)) + b
	end

	t=t-1
	return a*(2^(-10*t))*sin((t*d-s)*(2*PI)/p )*0.5 + c + b
end

--[[BACK EASING: overshooting cubic easing: (s+1)*t^3 - s*t^2--]]
easings["inBack"] = function(t,b,c,d)
	local s = 1.70158	-- gives a back bounce effect of 10% c, according to Robert Penner anyway

	t=t/d
	return c*t*t*((s+1)*t-s) + b
end

easings["outBack"] = function(t,b,c,d)
	local s = 1.70158

	t=t/d-1
	return c*(t*t*((s+1)*t+s)+1) + b
end

easings["inOutBack"] = function(t,b,c,d)
	local s = 1.70158

	t=2*t/d
	if t<1 then 
		s=s*1.525
		return c*0.5*(t*t*((s+1)*t-s)) + b
	end

	t=t-2
	s=s*1.525
	return c*0.5*(t*t*((s+1)*t+s) +2) + b
end

--[[Bounce Easings (exponentially decaying parabolic bounce)--]]
easings["outBounce"] = function(t,b,c,d)
	t=t/d
	if t<(1/2.75) then
		return c*(7.5625*t*t) + b
	elseif t < (2/2.75) then
		t=t-(1.5/2.75)
		return c*(7.5625*t*t+0.75) + b
	elseif t < (2.5/2.75) then
		t=t-(2.25/2.75)
		return c*(7.5625*t*t+0.9375) + b
	else
		t=t-(2.625/2.75)
		return c*(7.5625*t*t+0.984375) + b
	end
end

easings["inBounce"] = function(t,b,c,d)
	return c-easings["outBounce"](d-t,0,c,d) + b
end

easings["inOutBounce"] = function(t,b,c,d)
	if t < d/2 then
		return easings["inBounce"](t*2, 0, c, d)*0.5 + b
	end

	return easings["outBounce"](t*2-d,0,c,d)*0.5+c*0.5 + b
end

-- function to replace transition.cancel
function cancel(transitionHandle)
	local index =  #transitionStack

	while transitionStack[index] ~= transitionHandle and index > 0 do
		index = index - 1
	end

	Runtime:removeEventListener("enterFrame", transitionHandle)

	-- to cancel, locate transition handle to remove, remove enterFrame listener
	table.remove(transitionStack, index)
	transitionHandle = nil
end

-- function to pause transitions
function pause(transitionHandle)
	transitionHandle.isActive = false
end

-- function to resume transitions
function resume(transitionHandle)
	transitionHandle.isActive = true
end


-- Runtime transition control listener
transitFunc = function(self,e)
	local eTime = e.time

	-- only carry out animation when unpaused
	if self.isActive then
		local deltaTime = eTime - self.prevTime
		local obj = self.obj

		-- execute onStart Listener if assigned
		if	self.onStart then
			self.onStart(obj)
			self.onStart = nil
		end

		deltaTime = deltaTime * self.timeScale			-- timeScale parameter allows slowing and increasing speed of animation on the fly
		self.timePassed = self.timePassed + deltaTime

		-- check if object has been removed
		if obj.x then
			-- make sure delay has passed
			if self.timePassed-self.delay > 0 then
				local timePassed = self.timePassed - self.delay
				-- check if end point reached, ensure object is at required position
				if timePassed >= self.time then
					if self.x then
						obj:translate(self.endX-obj.x,0)
					end

					if self.y then
						obj:translate(0,self.endY-obj.y)
					end

					if self.width then
						obj.width = self.endWidth
					end

					if self.height then
						obj.height = self.endHeight
					end

					if self.xScale then
						obj.xScale = self.endxS
					end

					if self.yScale then
						obj.yScale = self.endyS
					end

					if self.alpha then
						obj.alpha = self.endAlpha
					end

					if self.rotation then
						obj:rotate(self.endRot-obj.rotation)
					end

					if self.maskX then
						obj.maskX = self.endmX
					end

					if self.maskY then
						obj.maskY = self.endmY
					end

					if self.maskScaleX then
						obj.maskScaleX = self.endmxS
					end

					if self.maskScaleY then
						obj.maskScaleY = self.endmyS
					end

					if self.maskRotation then
						obj.maskRotation = self.endmRot
					end

					if self.onFrac then
						if self.onFrac.fraction <= 1 then			-- makes sure fractional listener is executed in cases whereby framerate drops, if it's within animation time
							self.onFrac.listener(obj)
						end
					end

					if self.onComplete then
						self.onComplete(obj)
					end

					cancel(self)
					self=nil
				else
					-- check for fractional listener
					if self.onFrac then
						if timePassed/self.time >= self.onFrac.fraction then
							self.onFrac.listener(obj)
							self.onFrac = nil
						end
					end

					-- change parameters if assigned
					if self.x then
						obj:translate(self.transition(timePassed,self.x,self.dX,self.time)-obj.x,0)
					end

					if self.y then
						obj:translate(0,self.transition(timePassed,self.y,self.dY,self.time)-obj.y)
					end

					if self.width then
						obj.width = self.transition(timePassed,self.width,self.dWidth,self.time)
					end

					if self.height then
						obj.height = self.transition(timePassed,self.height,self.dHeight,self.time)
					end

					if self.xScale then
						obj.xScale = self.transition(timePassed,self.xScale,self.dxS,self.time)
					end

					if self.yScale then
						obj.yScale = self.transition(timePassed,self.yScale,self.dyS,self.time)
					end

					if self.alpha then
						obj.alpha = self.transition(timePassed,self.alpha,self.dA,self.time)
					end

					if self.rotation then
						obj:rotate(self.transition(timePassed,self.rotation,self.dRot,self.time)-obj.rotation)
					end

					if self.maskX then
						obj.maskX = self.transition(timePassed,self.maskX,self.dmX,self.time)
					end

					if self.maskY then
						obj.maskY = self.transition(timePassed,self.maskY,self.dmY,self.time)
					end

					if self.maskScaleX then
						obj.maskScaleX = self.transition(timePassed,self.maskScaleX,self.dmxS,self.time)
					end

					if self.maskScaleY then
						obj.maskScaleY = self.transition(timePassed,self.maskScaleY,self.dmyS,self.time)
					end

					if self.maskRotation then
						obj.maskRotation = self.transition(timePassed,self.maskRotation,self.dmRot,self.time)
					end
				end
			end
		else
			-- kill enterFrame listener ie. transition if object has been removed
			print("Transition Warning: Object Missing. Cancelling transition.")
			cancel(self)
			self=nil
		end
	end

	if self then
		self.prevTime = eTime
	end
end

-- replacing the transition.to function
function to(obj,params)
	local transitionHandle = {}

	-- setting up flags for required changes
	-- check for delta parameter
	if params.delta then
		if params.x then transitionHandle.x = obj.x; transitionHandle.endX = params.x + obj.x; transitionHandle.dX = params.x; end
		if params.y then transitionHandle.y = obj.y; transitionHandle.endY = params.y + obj.y; transitionHandle.dY = params.y; end
		if params.width then transitionHandle.width = obj.width; transitionHandle.endWidth = params.width + obj.width; transitionHandle.dWidth = params.width; end
		if params.height then transitionHandle.height = obj.height; transitionHandle.endHeight = params.height + obj.height; transitionHandle.dHeight = params.height; end
		if params.xScale then transitionHandle.xScale = obj.xScale; transitionHandle.endxS = params.xScale + obj.xScale; transitionHandle.dxS = params.xScale; end
		if params.yScale then transitionHandle.yScale = obj.yScale; transitionHandle.endyS = params.yScale + obj.yScale; transitionHandle.dyS = params.yScale; end
		if params.alpha then transitionHandle.alpha = obj.alpha; transitionHandle.endAlpha = params.alpha + obj.alpha; transitionHandle.dA = params.alpha; end
		if params.rotation then transitionHandle.rotation = obj.rotation; transitionHandle.endRot = params.rotation + obj.rotation; transitionHandle.dRot = params.rotation; end
		if params.maskX then transitionHandle.maskX = obj.maskX; transitionHandle.endmX = params.maskX + obj.maskX; transitionHandle.dmX = params.maskX; end
		if params.maskY then transitionHandle.maskY = obj.maskY; transitionHandle.endmY = params.maskY + obj.maskY; transitionHandle.dmY = params.maskY; end
		if params.maskScaleX then transitionHandle.maskScaleX = obj.maskScaleX; transitionHandle.endmxS = params.maskScaleX + obj.maskScaleX; transitionHandle.dmxS = params.maskScaleX; end
		if params.maskScaleY then transitionHandle.maskScaleY = obj.maskScaleY; transitionHandle.endmyS = params.maskScaleY + obj.maskScaleY; transitionHandle.dmyS = params.maskScaleY; end
		if params.maskRotation then transitionHandle.maskRotation = obj.maskRotation; transitionHandle.endmRot = params.maskRotation + obj.maskRotation; transitionHandle.dmRot = params.maskRotation; end
	else
		if params.x then transitionHandle.x = obj.x; transitionHandle.endX = params.x; transitionHandle.dX = params.x - obj.x; end
		if params.y then transitionHandle.y = obj.y; transitionHandle.endY = params.y; transitionHandle.dY = params.y - obj.y; end
		if params.width then transitionHandle.width = obj.width; transitionHandle.endWidth = params.width; transitionHandle.dWidth = params.width - obj.width; end
		if params.height then transitionHandle.height = obj.height; transitionHandle.endHeight = params.height; transitionHandle.dHeight = params.height - obj.height; end
		if params.xScale then transitionHandle.xScale = obj.xScale; transitionHandle.endxS = params.xScale; transitionHandle.dxS = params.xScale - obj.xScale; end
		if params.yScale then transitionHandle.yScale = obj.yScale; transitionHandle.endyS = params.yScale; transitionHandle.dyS = params.yScale - obj.yScale; end
		if params.alpha then transitionHandle.alpha = obj.alpha; transitionHandle.endAlpha = params.alpha; transitionHandle.dA = params.alpha - obj.alpha; end
		if params.rotation then transitionHandle.rotation = obj.rotation; transitionHandle.endRot = params.rotation; transitionHandle.dRot = params.rotation - obj.rotation; end
		if params.maskX then transitionHandle.maskX = obj.maskX; transitionHandle.endmX = params.maskX; transitionHandle.dmX = params.maskX - obj.maskX; end
		if params.maskY then transitionHandle.maskY = obj.maskY; transitionHandle.endmY = params.maskY; transitionHandle.dmY = params.maskY - obj.maskY; end
		if params.maskScaleX then transitionHandle.maskScaleX = obj.maskScaleX; transitionHandle.endmxS = params.maskScaleX; transitionHandle.dmxS = params.maskScaleX - obj.maskScaleX; end
		if params.maskScaleY then transitionHandle.maskScaleY = obj.maskScaleY; transitionHandle.endmyS = params.maskScaleY; transitionHandle.dmyS = params.maskScaleY - obj.maskScaleY; end
		if params.maskRotation then transitionHandle.maskRotation = obj.maskRotation; transitionHandle.endmRot = params.maskRotation; transitionHandle.dmRot = params.maskRotation - obj.maskRotation; end
	end


	-- animation parameters
	transitionHandle.transition = easings[params.transition] or easings["linear"]
	transitionHandle.time = params.time or 500
	transitionHandle.delay = params.delay or 0
	transitionHandle.onStart = params.onStart or false
	transitionHandle.onComplete = params.onComplete or false
	transitionHandle.onFrac = params.onFrac or false
	transitionHandle.timeScale = 1
	transitionHandle.prevTime = system.getTimer()
	transitionHandle.timePassed = 0


	-- control parameters
	transitionHandle.isActive = true
	transitionHandle.obj = obj

	-- start enterFrame listener
	transitionHandle.enterFrame = transitFunc
	Runtime:addEventListener("enterFrame", transitionHandle)

	-- add to stack
	transitionStack[#transitionStack+1] = transitionHandle

	-- return handle
	return transitionHandle
end

-- function to replace transition.from function
function from(obj,params)
	local temp
	-- setting up flags for required changes
	-- check for delta parameter
	if params.delta then
		-- swapping starting and ending points with delta considered
		if params.x then
			obj:translate(params.x,0)
			params.x = -params.x
		end

		if params.y then
			obj:translate(0,params.y)
			params.y = -params.y
		end

		if params.width then
			obj.width = obj.width + params.width
			params.width = -params.width
		end

		if params.height then
			obj.height = obj.height + params.height
			params.height = -params.height
		end

		if params.xScale then
			obj.xScale = params.xScale + obj.xScale
			params.xScale = -params.xScale
		end

		if params.yScale then
			obj.yScale = params.yScale + obj.yScale
			params.yScale = -params.yScale
		end

		if params.alpha then
			obj.alpha = obj.alpha + params.alpha
			params.alpha = -params.alpha
		end

		if params.rotation then
			obj:rotate(params.rotation)
			params.rotation = -params.rotation
		end

		if params.maskX then
			obj.maskX = obj.maskX + params.maskX
			params.alpha = -params.maskX
		end

		if params.maskY then
			obj.maskY = obj.maskY + params.maskY
			params.maskY = -params.maskY
		end

		if params.maskScaleX then
			obj.maskScaleX = obj.maskScaleX + params.maskScaleX
			params.maskScaleX= -params.maskScaleX
		end

		if params.maskScaleY then
			obj.maskScaleY = obj.maskScaleY + params.maskScaleY
			params.maskScaleY = -params.maskScaleY
		end

		if params.maskRotation then
			obj.maskRotation = obj.maskRotation + params.maskRotation
			params.maskRotation = -params.maskRotation
		end
	else
		-- swapping starting and ending points
		if params.x then
			temp = obj.x
			obj:translate(params.x-obj.x,0)
			params.x = temp
		end

		if params.y then
			temp = obj.y
			obj:translate(0,params.y-obj.y)
			params.y = temp
		end

		if params.width then
			temp = obj.width
			obj.width = params.width
			params.width = temp
		end

		if params.height then
			temp = obj.height
			obj.height = params.height
			params.height = temp
		end

		if params.xScale then
			temp = obj.xScale
			obj.xScale = params.xScale
			params.xScale = temp
		end

		if params.yScale then
			temp = obj.yScale
			obj.yScale = params.yScale
			params.yScale = temp
		end

		if params.alpha then
			temp = obj.alpha
			obj.alpha = params.alpha
			params.alpha = temp
		end

		if params.rotation then
			temp = obj.rotation
			obj:rotate(params.rotation-obj.rotation)
			params.rotation = temp
		end

		if params.maskX then
			temp = obj.maskX
			obj.maskX = params.maskX
			params.maskX = temp
		end

		if params.maskY then
			temp = obj.maskY
			obj.maskY = params.maskY
			params.maskY = temp
		end

		if params.maskScaleX then
			temp = obj.maskScaleX
			obj.maskScaleX = params.maskScaleX
			params.maskScaleX = temp
		end

		if params.maskScaleY then
			temp = obj.maskScaleY
			obj.maskScaleY = params.maskScaleY
			params.maskScaleY = temp
		end

		if params.maskRotation then
			temp = obj.maskRotation
			obj.maskRotation = params.maskRotation
			params.maskRotation = temp
		end
	end

	return to(obj,params)
end


function pauseAll()
	if #transitionStack > 0 then
		for i=#transitionStack,1,-1 do
			pause(transitionStack[i])
		end
	end
end

function resumeAll()
	if #transitionStack > 0 then
		for i=#transitionStack,1,-1 do
			resume(transitionStack[i])
		end
	end
end

function cancelAll()
	if #transitionStack > 0 then
		for i=#transitionStack,1,-1 do
			cancel(transitionStack[i])
			transitionStack[i] = nil
		end
		transitionStack = {}
	end
end

-- accessibility
tranImprov.cancel = cancel
tranImprov.pause = pause
tranImprov.resume = resume
tranImprov.to = to
tranImprov.from = from
tranImprov.cancelAll = cancelAll
tranImprov.pauseAll = pauseAll
tranImprov.resumeAll = resumeAll

return tranImprov