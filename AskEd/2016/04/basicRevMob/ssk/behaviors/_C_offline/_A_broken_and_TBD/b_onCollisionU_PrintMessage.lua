-- =============================================================
-- b_onCollisionU_PrintMessage.lua 
-- Behavior Template - Instance
-- Behavior Type: Instance
-- =============================================================
--
-- =============================================================

--[[ 
     FUNCTIONS IN THIS FILE
--]]

public = {}
public._behaviorName = "onCollisionU - Print Message (universal behavior; all collision variants selectable through params)"

function public:onAttach( obj, params )
	print("Attached Behavior: " .. self._behaviorName)
	behaviorInstance = {}
	behaviorInstance._behaviorName = self._behaviorName

	if( not params ) then
		params = {}
	end

	-- Default to onCollision (began) unless explicity set
	if( params.onCollision == nil ) then
		params.onCollision = true
	end

	behaviorInstance.params = params

	-- ==================== collision
	function behaviorInstance:collision( event )
		local target = event.target
		local other  = event.other
		--Note: use 'self' to reference the behavior instance
		
		if( self.params.onCollision and event.phase == "began" ) then
			if(not target.myName ) then target.myName = "An Object" end
			if(not other.myName ) then other.myName = "Another Object" end
			print(target.myName .. " collided with " .. other.myName .. " @ time: " .. system.getTimer())			
		end

		if( self.params.onCollisionEnded and event.phase == "ended" ) then
			if(not target.myName ) then target.myName = "An Object" end
			if(not other.myName ) then other.myName = "Another Object" end
			print(target.myName .. " collided with " .. other.myName .. " @ time: " .. system.getTimer())			
		end

		return false
	end

	-- ==================== preCollision
	function behaviorInstance:preCollision( event )
		local target  = event.target
		local other   = event.other
		--Note: use 'self' to reference the behavior instance
		
		if(not target.myName ) then target.myName = "An Object" end
		if(not other.myName ) then other.myName = "Another Object" end
		print(target.myName .. " is about to collide with " .. other.myName .. " @ time: " .. system.getTimer())

		return false
	end

	-- ==================== postCollision
	function behaviorInstance:onPostCollision( event )
		local target   = event.target
		local other    = event.other
		local force    = event.force
		local friction = event.friction
		--Note: use 'self' to reference the behavior instance

		if(not target.myName ) then target.myName = "An Object" end
		if(not other.myName ) then other.myName = "Another Object" end
		print(target.myName .. " collided with " .. other.myName .. " @ time: " .. system.getTimer() .. " with force: " .. force)

		return false
	end

	function behaviorInstance:onDetach( obj )
		print("Detached Behavior: " .. self._behaviorName)
		-- =========  ADD YOUR DETACH CODE HERE =======

		if( self.params.onCollision or self.params.onCollisionEnded ) then
			obj:removeEventListener( "collision", self )
		end

		if( self.params.onPreCollision ) then
			obj:removeEventListener( "preCollision", self )
		end

		if( self.params.onPostCollision ) then
			obj:removeEventListener( "postCollision", self )
		end
		-- =========  ADD YOUR DETACH CODE HERE =======
	end

	-- =========  ADD YOUR ATTACH CODE HERE =======

	if( params.onCollision or params.onCollisionEnded ) then
		print("Attaching collision listener")
		obj:addEventListener( "collision", behaviorInstance )
	end

	if( params.onPreCollision ) then
		print("Attaching pre listener")
		obj:addEventListener( "preCollision", behaviorInstance )
	end

	if( params.onPostCollision ) then
		print("Attaching post listener")
		obj:addEventListener( "postCollision", behaviorInstance )
	end

	-- =========  ADD YOUR ATTACH CODE HERE =======

	return behaviorInstance
end

ssk.behaviors:registerBehavior( "onCollisionU_PrintMessage", public )
return public
