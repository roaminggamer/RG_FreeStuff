local curCount = 0

local alpha 
alpha = function()
	
	local curTime = system.getTimer() 

	print("alpha @ " .. curTime )

	local bravo = function()
		print("bravo@ " .. curTime )
	end
	
	curCount = curCount + 1
	
	if( curCount < 15 ) then
		timer.performWithDelay( 1, bravo )		
		timer.performWithDelay( 1, alpha )
	end
end

alpha()

