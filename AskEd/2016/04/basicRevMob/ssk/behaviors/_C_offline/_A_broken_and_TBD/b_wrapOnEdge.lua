-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Behavior - Wrap on Edge
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
--
-- =============================================================


--[[ 
     FUNCTIONS IN THIS FILE
--]]

local function deferedMove( target, other )
	local right = other.x + other.width / 2
	local left  = other.x - other.width / 2

	local top = other.y - other.height / 2
	local bot  = other.y + other.height / 2

	if(target.x >= right) then
		target.x = left
	elseif(target.x <= left) then 
		target.x = right
	end

	if(target.y >= bot) then
		target.y = top
	elseif(target.y <= top) then 
		target.y = bot
	end
end

local function deferedMoveold( target, other )
	if(target.x > other.x) then
		target.x = target.x - other.width
	elseif(target.x < other.x) then 
		target.x = target.x + other.width
	end

	if(target.y > other.y) then
		target.y = target.y - other.height
	elseif(target.y < other.y) then 
		target.y = target.y + other.height
	end

end

public = {}
public._behaviorName = "Wrap On Edge"

function public:onAttach( obj, params )
	print("Attached Behavior: " .. self._behaviorName)
	behaviorInstance = {}
	behaviorInstance._behaviorName = self._behaviorName
	behaviorInstance._singletonRef = self

	-- ==
	-- behaviorInstance:collision() - Wraps object when it exits the bounds of wrapSensor.
	-- ==
	function behaviorInstance:collision( event )
		local target  = event.target
		local other   = event.other
		local debugEn = self.debugEn -- Note: self == behaviorInstance

		if(other ~= self.wrapSensor ) then
			return false
		end

		-- Do wrap work on collision ended phase. i.e. when object leaves wrapSensor bounds.
		if( event.phase == "ended" ) then
			if( debugEn ) then
				-- Ensure target has a name for debug message(s)
				if(not target.myName ) then target.myName = "An Object" end
				print(target.myName .. " exited wrap sensor " .. " @ time: " .. system.getTimer())
			end

			-- Defer wrap until next frame (allows collision() callback can complete)
			local myclosure = function() deferedMove( target, other ) end			
			timer.performWithDelay( 1, myclosure) 
		end

		return false
	end

	function behaviorInstance:onDetach( obj )
		print("Detached Behavior: " .. self._behaviorName)
		-- =========  ADD YOUR DETACH CODE HERE =======

		self.wrapSensor.referenceCount = self.wrapSensor.referenceCount - 1

		if( self.wrapSensor.referenceCount <= 0 ) then
			if(self.debugEn) then 
				print("Wrap Sensor reference count <= 0.  Removing Sensor.")
			end
			self.wrapSensor:removeSelf()
			self.wrapSensor = nil
			self._singletonRef.wrapSensor = nil

			self._singletonRef.nonWrapArea:removeSelf()
			self._singletonRef.nonWrapArea = nil
		else
			if(self.debugEn) then 
				print("Wrap Sensor reference count == " .. self.wrapSensor.referenceCount)
			end
		end

		obj:removeEventListener( "collision", self )

		-- =========  ADD YOUR DETACH CODE HERE =======
	end

	-- =========  ADD YOUR ATTACH CODE HERE =======
	-- Create wrap detection boxes
	if( not params ) then
		params = {}
	end

	local debugEn        = params.debugEn or false

	if( not self.wrapSensor ) then
		local dw = display.contentWidth
		local dh = display.contentHeight
		local dCenterX = dw/2 
		local dCenterY = dh/2

		local group = display.getCurrentStage()

		local edgeSize       = params.edgeSize or 64
		local wrapWidthMult  = params.wrapWidthMult or 1.0
		local wrapHeightMult = params.wrapHeightMult or 1.0
		local wrapParams     = params.wrapParams or { w = wrapWidthMult * dw  + 2 * edgeSize, 
			                                          h = wrapHeightMult * dh + 2 * edgeSize, 
												  	  x = dCenterX, y = dCenterY }
		local innerParams      = { w = wrapParams.w - 2 * edgeSize, h = wrapParams.h - 2 * edgeSize, 
			                       x = wrapParams.x, y = wrapParams.y }

		local translucency = 0
		if(debugEn == true) then
			translucency = 32
		end
		local wrapSensor = display.newRect(0,0,wrapParams.w, wrapParams.h)
		wrapSensor.x = wrapParams.x
		wrapSensor.y = wrapParams.y
		wrapSensor:setReferencePoint(display.CenterReferencePoint)
		wrapSensor:setFillColor( 255, 255, 255, translucency)
		physics.addBody( wrapSensor, "static", {isSensor=true} )
		wrapSensor.myName = "wrapSensor"
		group:insert(wrapSensor)

		local nonWrapArea = display.newRect(0,0,innerParams.w, innerParams.h)
		nonWrapArea.x = innerParams.x
		nonWrapArea.y = innerParams.y
		nonWrapArea:setFillColor( 0, 255, 0, translucency)
		group:insert(nonWrapArea)
		self.nonWrapArea = nonWrapArea

		self.wrapSensor = wrapSensor

		self.wrapSensor.referenceCount = 1
	else
		self.wrapSensor.referenceCount = self.wrapSensor.referenceCount + 1
	end

	behaviorInstance.wrapSensor = self.wrapSensor
	behaviorInstance.debugEn = debugEn

	obj:addEventListener( "collision", behaviorInstance )

	-- =========  ADD YOUR ATTACH CODE HERE =======
	return behaviorInstance
end

ssk.behaviors:registerBehavior( "wrapOnEdge", public )
return public
