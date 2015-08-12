-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Behavior - Mover: Face Touch Instantly
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
public._behaviorName = "mover_faceTouch"

function public:onAttach( obj, params )
	dprint(1,"Attached Behavior: " .. self._behaviorName)

	if(not params.inputObj) then
		error("ERROR: This behavior requires that you pass an object reference in the paramter: params.inputObj ")
		return nil
	end

	local behaviorInstance = {}
	behaviorInstance._behaviorName = self._behaviorName

	local inputObj  = params.inputObj
	local moveObj   = obj
	
	function behaviorInstance:touch( event )
		local target  = event.target
		local eventID = event.id

		if(event.phase == "began") then
			return true

		elseif(event.phase == "ended" or event.phase == "cancelled") then

		ssk.component.transition_faceObject( moveObj, event )
		
		return true

		elseif(event.phase == "moved") then
			return true
		end
	end

	inputObj:addEventListener( "touch", behaviorInstance )		

	function behaviorInstance:onDetach( obj )
		dprint(1,"Detached behavior:" .. self._behaviorName)
		inputObj = nil
		moveObj = nil
		inputObj:removeEventListener( "touch", self )		
	end


	return behaviorInstance
end


ssk.behaviors:registerBehavior( public._behaviorName, public )

return public
