
--
-- Example: The 'timer' closure field 
--

local obj = display.newCircle( 240, 160, 30 )

obj.timer = function( self, event )
    if( self.removeSelf == nil ) then return end
	print( "x:" .. tostring(self.x), 
	   	   "y:" .. tostring(self.y),
	   	   "@" .. tostring(event.time) .. " ms" )
	print("-------------\n")
	timer.performWithDelay( 500, self )
end

timer.performWithDelay( 500, obj )

timer.performWithDelay( 1750, 
	function() 
		display.remove( obj ) 
	end )
