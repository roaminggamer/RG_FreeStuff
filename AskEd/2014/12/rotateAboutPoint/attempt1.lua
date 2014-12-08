-- =============================================================
-- sample1.lua
-- =============================================================


local function rotateAbout( obj, x, y, params )	

	params = params or {}
	local radius 	= params.radius or 50
	local time 		= params.time or 1000
	local debugEn 	= params.debugEn

	obj.x = x
	obj.y = y - radius

	local qt = time/4
	local ht = time/2


	transition.to( obj, { delay = 0 * qt, time = qt, x = x + radius } )
	transition.to( obj, { delay = 1 * qt, time = qt, x = x } )
	transition.to( obj, { delay = 2 * qt, time = qt, x = x - radius } )
	transition.to( obj, { delay = 3 * qt, time = qt, x = x } )
	
	transition.to( obj, { delay = 0 * ht, time = ht, y = y + radius } )
	transition.to( obj, { delay = 1 * ht, time = ht, y = y - radius } )


	-- Update position every frame
	if( debugEn ) then
		obj.enterFrame = function ( self )
			if( debugEn ) then
				local tmp = display.newCircle( self.parent, self.x, self.y, 1 )
				tmp:toBack()
			end
		end
		Runtime:addEventListener( "enterFrame", obj )
	end



end

return rotateAbout

