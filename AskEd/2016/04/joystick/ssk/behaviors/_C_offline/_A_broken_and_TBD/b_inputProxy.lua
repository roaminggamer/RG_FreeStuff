-- EFM add option for startOffset

-- =============================================================
-- b_inputProxy.lua 
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
public._behaviorName = "inputProxy"

function public:onAttach( obj, params )
	dprint(1,"Attached Behavior: " .. self._behaviorName)

	local behaviorInstance = {}
	behaviorInstance._behaviorName = self._behaviorName

	if( not params ) then 
		behaviorInstance.params = {}
	else
		behaviorInstance.params = table.shallowCopy(params)
	end
	
	-- Initialize variables
	obj.ip = {}
	ip = obj.ip

	function behaviorInstance:touch( event )
		if(event.phase == "began") then	
			--print("touch began")
			ip.isActive = true
						
			ip.startX, ip.startY     = event.x, event.y
			ip.lastX, ip.lastY       = event.x, event.y
			ip.curX, ip.curY         = event.x, event.y
			ip.deltaX, ip.deltaY     = 0, 0
			ip.delta                 = 0
			
			ip.startTime             = event.time
			ip.activeTime            = event.time
			ip.lastInputTime         = event.time
			ip.inputTime             = event.time
			ip.deltaTime             = 0

			ip.velX, ip.velY         = 0, 0
			ip.lastVel               = 0
			ip.vel                   = 0

			ip.touchVecX, ip.touchVecY = 0, 0
			ip.touchVecLen             = 0
			ip.lastVecAngle            = 0
			ip.angle                   = 0
			ip.deltaAngle              = 0
			ip.angularVel              = 0


		elseif(event.phase == "moved") then	
			--print("touch moved")
			ip.lastX, ip.lastY       = ip.curX, ip.curY
			ip.curX, ip.curY         = event.x, event.y
			ip.deltaX, ip.deltaY     = (ip.curX - ip.lastX), (ip.curY - ip.lastY)
			ip.delta                 = ssk.math2d.length(ip.deltaX, ip.deltaY)
			
			ip.activeTime            = event.time - ip.startTime
			ip.lastInputTime         = ip.inputTime
			ip.inputTime             = event.time
			ip.deltaTime             = ip.inputTime - ip.lastInputTime

			ip.lastVelX, ip.lastVelY = ip.velX, ip.velY
			ip.velX, ip.velY         = round(1000 * ip.deltaX/ip.deltaTime,2), round(1000 * ip.deltaY/ip.deltaTime,2)
			ip.lastVel               = ip.vel
			ip.vel                   = round(1000 * ip.delta/ip.deltaTime,2)

			ip.touchVecX, ip.touchVecY = ip.curX - ip.startX, ip.curY - ip.startY
			ip.touchVecLen             = ssk.math2d.length(ip.touchVecX, ip.touchVecY)
			ip.lastAngle               = ip.angle
			ip.angle                   = ssk.math2d.vector2Angle(ip.touchVecX, ip.touchVecY)
			ip.deltaAngle              = ip.angle - ip.lastAngle
			ip.angularVel              = round((ip.angularVel + 1000 * ip.deltaAngle/ip.deltaTime) / 2,2)

		elseif(event.phase == "ended" or event.phase == "cancelled") then
			--print("touch ended")
			ip.isActive = false
		end

		return false
	end

	obj:addEventListener( "touch", behaviorInstance )		

	function behaviorInstance:onDetach( obj )
		dprint(0,"Detached Behavior: " .. self._behaviorName)
		obj:removeEventListener( "touch", self )		
	end


	return behaviorInstance
end


ssk.behaviors:registerBehavior( public._behaviorName, public )

return public
