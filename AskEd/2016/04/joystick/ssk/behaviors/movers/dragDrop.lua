-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- Behavior - Mover: Drag-n-Drop with Callback on Drop
-- =============================================================
-- 								License
-- =============================================================
--[[
	> SSK is free to use.
	> SSK is free to edit.
	> SSK is free to use in a free or commercial game.
	> SSK is free to use in a free or commercial non-game app.
	> SSK is free to use without crediting the author (credits are still appreciated).
	> SSK is free to use without crediting the project (credits are still appreciated).
	> SSK is NOT free to sell for anything.
	> SSK is NOT free to credit yourself with.
]]
local bmgr = ssk.behaviors.manager
local butils = ssk.behaviors.utils

public = {}
public._behaviorName = "mover_dragDrop"

function public:onAttach( obj, params )
	print("Attached Behavior: " .. self._behaviorName)
   
	local behaviorInstance = {}
	behaviorInstance._behaviorName = self._behaviorName

	params               = params or {}
	local inputObj       = obj
	local moveObj        = obj
	local processEvent   = butils.processEvent  -- EFM TRY NOT TO USE THIS AND REMOVE IT
	local moveData       = {}
	local onDrop         = params.onDrop 
   
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
		print("Detached behavior:" .. self._behaviorName)

		inputObj = nil
		moveObj = nil
		processEvent = nil
		moveData = nil
		inputObj:removeEventListener( "touch", self )		
	end


	return behaviorInstance
end

bmgr:registerBehavior( public._behaviorName, public )

return public
