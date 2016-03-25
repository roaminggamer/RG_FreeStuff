

local curCount = 0

local enterFrame 
enterFrame = function()	
	curCount = curCount + 1
	local submitCount = curCount
	local submitTime = system.getTimer()

	local function timerFunc()
		print("timerFunc  | " .. string.format("%2.2d",submitCount) .. " | " .. string.format("%2.2d",curCount - submitCount) .. " | " .. system.getTimer()-submitTime )
	end
	timer.performWithDelay(1, timerFunc)

	print("enterFrame | " .. string.format("%2.2d",curCount) .. " |    | " .. system.getTimer() )
	
	if( curCount > 90 ) then
		Runtime:removeEventListener("enterFrame", enterFrame )		
	end

end

Runtime:addEventListener("enterFrame", enterFrame )

