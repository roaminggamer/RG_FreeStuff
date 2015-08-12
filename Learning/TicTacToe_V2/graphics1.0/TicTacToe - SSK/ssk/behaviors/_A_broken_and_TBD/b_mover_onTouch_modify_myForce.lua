
-- =============================================================
-- b_mover_onTouch_modify_myForce.lua 
-- Mover Behavior - onTouch ...
--   began: Add fixed force[X,Y] to moveObj.myForce[X,Y]
--   ended or cancelled: Subtract fixed force[X,Y] to moveObj.myForce[X,Y]
-- Behavior Type: Instance
-- =============================================================
--
-- =============================================================
--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

public = {}
public._behaviorName = "mover_onTouch_modify_myForce"

function public:onAttach( obj, params )
	dprint(1,"Attached Behavior: " .. self._behaviorName)

	if(not params.inputObj) then
		error("ERROR: This behavior requires that you pass an object reference in the paramter: params.inputObj ")
		return nil
	end

	local behaviorInstance = {}
	behaviorInstance._behaviorName = self._behaviorName

	if( not params ) then 
		behaviorInstance.params = {}
	else
		behaviorInstance.params = table.shallowCopy(params)
	end

	-- Set defaults
	behaviorInstance.params.forceX = params.forceX or 0
	behaviorInstance.params.forceY = params.forceY or 0

	behaviorInstance.moveObj     = obj

	function behaviorInstance:touch( event )
		if(event.phase == "began") then
			self.moveObj:set_myForceDelta( self.params.forceX, self.params.forceY )

		elseif(event.phase == "ended" or event.phase == "cancelled") then
			self.moveObj:set_myForceDelta( self.params.forceX * -1, self.params.forceY * -1 )

		end

		return false
	end

	params.inputObj:addEventListener( "touch", behaviorInstance )		

	return behaviorInstance
end


ssk.behaviors:registerBehavior( public._behaviorName, public )

return public
