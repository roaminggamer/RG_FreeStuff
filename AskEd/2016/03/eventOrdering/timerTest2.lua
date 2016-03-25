local curCount = 0

local bravo 
bravo = function()
	print("bravo @ " .. system.getTimer() )
end

local alpha 
alpha = function()
	print("alpha @ " .. system.getTimer() )
	curCount = curCount + 1

	if( curCount < 15 ) then
		timer.performWithDelay( 1, alpha )
		timer.performWithDelay( 1, bravo )		
	end

end



alpha()

-- Unexpected result: alpha and bravo are NOT strictly ordered.
-- Ordering is better than first test, but still unexpected.