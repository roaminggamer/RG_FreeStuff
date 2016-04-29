
-- =============================================================
-- b_mover_rotatordpad.lua 
-- Mover Behavior - Virtual DPAD
-- Behavior Type: Instance
-- =============================================================
--
-- =============================================================
--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

public = {}
public._behaviorName = "mover_rotatordpad"

function public:onAttach( obj, params )
	dprint(1,"Attached Behavior: " .. self._behaviorName)

	if(not params.inputObj) then
		error("ERROR: This behavior requires that you pass an object reference in the paramter: params.inputObj ")
		return nil
	end

	local behaviorInstance = {}
	behaviorInstance._behaviorName = self._behaviorName
	behaviorInstance.params = params

	behaviorInstance.moveObj        = obj

	-- Visual representation
	if(params.dpadImgPath and params.dpadGroup) then
		local touchRadius = params.touchRadius or 40
		local size        = touchRadius * 2

		-- EFM destroy this image rect in cleanup
		behaviorInstance.dpadObj =  display.newImageRect( params.dpadGroup, params.dpadImgPath, size, size )
		if(params.dpadAlpha) then
			behaviorInstance.dpadObj.alpha = params.dpadAlpha
		end
	end

	if(behaviorInstance.dpadObj) then --EFM
		behaviorInstance.dpadObj.isVisible = false
		behaviorInstance.dpadX = behaviorInstance.dpadObj.x
		behaviorInstance.dpadY = behaviorInstance.dpadObj.y
	else
		behaviorInstance.dpadX = 0
		behaviorInstance.dpadY = 0
	end

	function behaviorInstance:touch( event )
		local target  = event.target
		local phase   = event.phase
		local touchX  = event.x
		local touchY  = event.y
		local startX  = event.xStart
		local startY  = event.yStart

		local moveObj        = self.moveObj
		local dpadObj        = self.dpadObj
		local touchRadius    = self.params.touchRadius or 40
		local deadSpotRadius = self.params.deadSpotRadius or 15
		local moveSpeed      = self.params.moveSpeed or 100
		
		if(phase == "began") then
			if(dpadObj) then --EFM
				dpadObj.x = touchX
				dpadObj.y = touchY + 20 
				dpadObj.isVisible = true
			end

			self.dpadX = touchX
			self.dpadY = touchY + 20 

		elseif(phase == "ended" or phase == "cancelled") then
			if(dpadObj) then --EFM
				dpadObj.x = touchX
				dpadObj.y = touchY + 20 
				dpadObj.isVisible = false
			end

			self.dpadX = touchX
			self.dpadY = touchY + 20 

		elseif(phase == "moved") then

			local vx,vy   = ssk.math2d.sub( touchX, touchY, self.dpadX, self.dpadY)
			local vlen = ssk.math2d.length(vx,vy)

			-- 1. Check to see if move needs to occur
			if(vlen > deadSpotRadius) then
				local mx,my = ssk.math2d.normalize(vx,vy)
				local mx,my = ssk.math2d.screen2Cartesian(mx,my)
				local angle = -ssk.math2d.vector2Angle(mx,my)
				print(angle)					
				dpadObj.rotation = angle
				self.moveObj.rotation = angle
			end
		end

		return true
	end

	behaviorInstance.params.inputObj:addEventListener( "touch", behaviorInstance )		

	function behaviorInstance:onDetach( obj )
		dprint(1,"Detached behavior: " .. self._behaviorName)

		if(self.dpadObj) then
			self.dpadObj:removeSelf()
			self.dpadObj = nil
		end

		self.params.inputObj:removeEventListener( "touch", behaviorInstance )		
	end

	return behaviorInstance
end

ssk.behaviors:registerBehavior( public._behaviorName, public )

return public
