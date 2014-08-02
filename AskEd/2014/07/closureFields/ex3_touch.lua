
--
-- Example: The 'onComplete' closure field 
--
local obj = display.newCircle( 240, 160, 30 )

obj.touch = function( self, event )
	local phase = event.phase
	if( phase == "began" or phase == "ended" ) then
		print( "Phase: " .. event.phase ,
			   "x:" .. tostring(self.x), 
		   	   "y:" .. tostring(self.y),
		   	   "@" .. tostring(event.time) .. " ms" )
		print("-------------\n")
	end
end

obj:addEventListener( "touch" )