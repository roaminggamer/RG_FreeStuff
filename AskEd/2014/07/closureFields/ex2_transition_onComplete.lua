
--
-- Example: The 'onComplete' closure field 
--

local obj = display.newCircle( 240, 160, 30 )

obj.onComplete = function( self )
    if( self.removeSelf == nil ) then return end
	print( "x:" .. tostring(self.x), 
	   	   "y:" .. tostring(self.y) )
	print("-------------\n")
end

transition.to( obj, { x = 25, time = 1000, onComplete = obj })


if( false ) then
	timer.performWithDelay( 500, 
		function() 
			display.remove( obj ) 
		end )
end
