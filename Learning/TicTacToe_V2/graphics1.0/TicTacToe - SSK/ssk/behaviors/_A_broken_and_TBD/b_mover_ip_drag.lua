
-- =============================================================
-- b_mover_ip_drag.lua 
-- Mover Behavior - Drag Object (Self)
-- Behavior Type: Instance
-- =============================================================
--
-- =============================================================
--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

public = {}
public._behaviorName = "mover_ip_drag"

function public:onAttach( obj, params )
	dprint(1,"Attached Behavior: " .. self._behaviorName)

	if(not params.inputObj) then
		error("Error: mover_ip_drag behavior => Input object required!")
		return nil
	end

	local behaviorInstance = {}
	behaviorInstance._behaviorName = self._behaviorName

	if( not params ) then 
		behaviorInstance.params = {}
	else
		behaviorInstance.params = table.shallowCopy(params)
	end

	local ip = params.inputObj.ip
	local lastInputTime = 0
	print("lastInputTime == " .. lastInputTime)

	local function onEnterFrame( event )
		if(ip.isActive) then
			if(ip.inputTime ~= lastInputTime) then
				print(ip.curX)
				print(ip.deltaX, ip.deltaY, ip.curTime, system.getTimer())
				obj.x = obj.x + ip.deltaX
				obj.y = obj.y + ip.deltaY

				lastInputTime = ip.inputTime
			end

		else
			lastInputTime = 0
		end
	end

	Runtime:addEventListener( "enterFrame", onEnterFrame )		

	function behaviorInstance:onDetach( obj )
		dprint(1,"Detached behavior:" .. self._behaviorName)
		Runtime:removeEventListener( "enterFrame", onEnterFrame )		
	end


	return behaviorInstance
end

ssk.behaviors:registerBehavior( public._behaviorName, public )

return public
