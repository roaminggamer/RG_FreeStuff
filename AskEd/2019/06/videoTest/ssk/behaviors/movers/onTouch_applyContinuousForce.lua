-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Behavior - Mover: On Touch, Apply Continous Force
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
local bmgr = ssk.behaviors.manager
local butils = ssk.behaviors.utils

public = {}
public._behaviorName = "mover_onTouch_applyContinuousForce"

function public:onAttach( obj, params )
	print("Attached Behavior: " .. self._behaviorName)

	if(not params.inputObj) then
		error("ERROR: This behavior requires that you pass an object reference in the paramter: params.inputObj ")
		return nil
	end

	behaviorInstance = {}
	behaviorInstance._behaviorName = self._behaviorName

	local inputObj = params.inputObj
	local myForce = {x = (params.forceX or 0), y = (params.forceY or 0) }
	local enabled = force

	local function updateForce( event )
		if(not enabled) then return false end

		local x,y = myForce.x, myForce.y
		obj:applyForce(myForce.x,myForce.y,obj.x,obj.y)		

		return false
	end

	function behaviorInstance:touch( event )
		if(event.phase == "began") then
			enabled = true
		elseif(event.phase == "ended" or event.phase == "cancelled") then
			enabled = false
		end
		return false
	end

	Runtime:addEventListener( "enterFrame", updateForce )
	inputObj:addEventListener( "touch", behaviorInstance )	
	
	function behaviorInstance:onDetach( obj )
		print("Detached Behavior: " .. self._behaviorName)
		
		inputObj:removeEventListener( "touch", behaviorInstance )
		Runtime:removeEventListener( "enterFrame", updateForce )
	end

	return behaviorInstance
end

bmgr:registerBehavior( "mover_onTouch_applyContinuousForce", public )
return public
