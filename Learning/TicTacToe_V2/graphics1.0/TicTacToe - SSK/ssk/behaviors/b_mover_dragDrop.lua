-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Behavior - Mover: Drag-n-Drop with Callback on Drop
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
public._behaviorName = "mover_dragDrop"

function public:onAttach( obj, params )
	dprint(1,"Attached Behavior: " .. self._behaviorName)

	local behaviorInstance = {}
	behaviorInstance._behaviorName = self._behaviorName

	local params = params or {}
	local inputObj = obj
	local moveObj  = obj
	local processEvent = ssk.misc.processEvent
	local moveData = {}
	local onDrop   = params.onDrop or nil

	function behaviorInstance:touch( event )
		local target  = event.target
		local eventID = event.id

		processEvent( moveData, event, true, false, false )

		if(event.phase == "began") then
			display.getCurrentStage():setFocus( target )
			target.isFocus = true
			target:toFront()
			return true

		elseif(target.isFocus) then

			if(event.phase == "ended") then
				display.getCurrentStage():setFocus( nil )
				target.isFocus = false
				if(onDrop) then 
					onDrop( moveObj, event )
				end
				return true

			elseif(event.phase == "moved") then

				moveObj.x = moveObj.x + moveData.deltaX
				moveObj.y = moveObj.y + moveData.deltaY
				return true
			end
		end
	end

	inputObj:addEventListener( "touch", behaviorInstance )		

	function behaviorInstance:onDetach( obj )
		dprint(1,"Detached behavior:" .. self._behaviorName)

		inputObj = nil
		moveObj = nil
		processEvent = nil
		moveData = nil
		inputObj:removeEventListener( "touch", self )		
	end


	return behaviorInstance
end


ssk.behaviors:registerBehavior( public._behaviorName, public )

return public
