

local curCount = 0

local alpha 
alpha = function()
	print("alpha @ " .. system.getTimer()  )
end

local bravo 
bravo = function()
	print("bravo @ " .. system.getTimer()  )
	curCount = curCount + 1
	if( curCount > 15 ) then
		Runtime:removeEventListener("enterFrame", alpha )
		Runtime:removeEventListener("enterFrame", bravo )
	end
end

Runtime:addEventListener("enterFrame", alpha )
Runtime:addEventListener("enterFrame", bravo )

