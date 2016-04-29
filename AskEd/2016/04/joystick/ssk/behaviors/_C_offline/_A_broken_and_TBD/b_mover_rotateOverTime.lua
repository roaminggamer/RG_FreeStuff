-- =============================================================
-- b_mover_rotateOverTime.lua 
-- Mover Behavior - Rotate Object Over Time
-- Behavior Type: Instance
-- =============================================================
--
-- =============================================================

--[[ 
     FUNCTIONS IN THIS FILE
--]]
--behaviors = require("behaviors")

public = {}
public._behaviorName = "mover_rotateOverTime"

function public:onAttach( obj, params )
	print("Attached Behavior: " .. self._behaviorName)
	local behaviorInstance = {}
	behaviorInstance._behaviorName = self._behaviorName

	if( not params ) then
		params = {}
	end

	-- Event listener for touches on 'inputObj'
	function behaviorInstance:touch( event )
		local target      = event.target

		if(event.phase == "began") then
			self.startX = event.x
			self.startY = event.y

			display.getCurrentStage():setFocus( target )
			target.isFocus = true

		elseif(target.isFocus) then

			if(event.phase == "ended") then
				self.startX = nil
				self.startY = nil
				display.getCurrentStage():setFocus( nil )
				target.isFocus = false

				--self.moveObj:applyForce( 0, 0, self.moveObj.x, self.moveObj.y )


			elseif(event.phase == "moved") then
				if(not self.startX) then
					return
				end

				local deltaX = event.x - self.startX
				local deltaY = event.y - self.startY

				local vLen  = ssk.math2d.length(deltaX, deltaY)
				local angle = ssk.math2d.vector2Angle(deltaX, deltaY)

				local forceX,forceY = ssk.math2d.scale(deltaX, deltaY, self.forceMult)
				
				print( vLen, angle, forceX, forceY )

				self.moveObj.rotation = angle

				self.moveObj:applyForce( forceX, forceY, self.moveObj.x, self.moveObj.y )

				--self.moveObj.x = self.moveObj.x + deltaX
				--self.moveObj.y = self.moveObj.y + deltaY
			end
		end
	end


	-- This method is required (even if it does no work) ==>
	function behaviorInstance:onDetach( obj )
		print("Detached behavior:" .. self._behaviorName)
		-- =========  ADD YOUR DETACH CODE HERE =======

		self.inputObj:removeEventListener( "touch", behaviorInstance )		

		-- =========  ADD YOUR DETACH CODE HERE =======
	end

	-- =========  ADD YOUR ATTACH CODE HERE =======

	-- do initialization work here (like adding functions, fields, etc.)
	behaviorInstance.inputObj   = params.inputObj or obj -- Default to this object as input obj
	behaviorInstance.moveObj    = params.moveObj or obj -- Object to move

	behaviorInstance.forceMult  = params.forceMult or 1.0 

	behaviorInstance.moveObj:applyForce( 0, -400, behaviorInstance.moveObj.x, behaviorInstance.moveObj.y )

	-- Configure object's linear damping
	behaviorInstance.moveObj.linearDamping = params.linDamp or 0.0

	-- Enable "touch" listener for for the 'inputObj' and pass these events to the 'behaviorInstance'
	behaviorInstance.inputObj:addEventListener( "touch", behaviorInstance )		

	-- =========  ADD YOUR ATTACH CODE HERE =======

	return behaviorInstance
end


ssk.behaviors:registerBehavior( public._behaviorName, public )
return public
