-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Behavior - Debug: onPreCollision Print Messsage
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

--
-- IMPORTANT - onPreCollision() callback DOES NOT FIRE for collisions with bodies where: isSensor = true
--


public = {}
public._behaviorName = "onPreCollision - Print Message"

function public:onAttach( obj, params )
	print("Attached Behavior: " .. self._behaviorName)
	behaviorInstance = {}
	behaviorInstance._behaviorName = self._behaviorName

	if( not params ) then params = {} end
	behaviorInstance.params = params

	function behaviorInstance:preCollision( event )
		local target  = event.target
		local other   = event.other
		
		if(not target.myName ) then target.myName = "An Object" end
		if(not other.myName ) then other.myName = "Another Object" end

		print(target.myName .. " is about to collide with " .. other.myName .. " @ time: " .. system.getTimer())

		return false
	end

	obj:addEventListener( "preCollision", behaviorInstance )

	return behaviorInstance
end

ssk.behaviors:registerBehavior( "onPreCollision_PrintMessage", public )

return public
