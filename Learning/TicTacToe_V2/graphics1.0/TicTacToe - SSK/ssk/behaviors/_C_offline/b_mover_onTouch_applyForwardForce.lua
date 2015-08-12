-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Behavior - Mover: Apply Forward Force
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

--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

public = {}
public._behaviorName = "mover_onTouch_applyForwardForce"

function public:onAttach( obj, params )
	dprint(1,"Attached Behavior: " .. self._behaviorName)

	if(not params.inputObj) then
		error("ERROR: This behavior requires that you pass an object reference in the paramter: params.inputObj ")
		return nil
	end

	local behaviorInstance = {}
	behaviorInstance._behaviorName = self._behaviorName

	local forceX   = params.forceX or 0
	local forceY   = params.forceY or 0
	local forceLen = ssk.math2d.length( forceX, forceY )
	local inputObj = params.inputObj

	local function apply_ForwardForce( event )

		local vx,vy = ssk.math2d.angle2Vector( obj.rotation )
		vx,vy = ssk.math2d.scale( vx,vy, forceLen)
		obj:applyForce(vx, vy, obj.x, obj.y)		
		return false
	end

	function behaviorInstance:touch( event )
		if(event.phase == "began") then
			Runtime:addEventListener( "enterFrame", apply_ForwardForce )		

		elseif(event.phase == "ended" or event.phase == "cancelled") then
			Runtime:removeEventListener( "enterFrame", apply_ForwardForce )		

		end

		return false
	end

	params.inputObj:addEventListener( "touch", behaviorInstance )		

	function behaviorInstance:onDetach( obj )
		dprint(0,"Detached Behavior: " .. self._behaviorName)
		Runtime:removeEventListener( "enterFrame", apply_ForwardForce ) -- just in case
		inputObj:removeEventListener( "touch", self )		
	end


	return behaviorInstance
end


ssk.behaviors:registerBehavior( public._behaviorName, public )

return public
