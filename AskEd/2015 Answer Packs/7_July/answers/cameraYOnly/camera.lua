local public = {}

function public.attach( trackObj, worldLayer, lockX, lockY )
	local lx = 0
	local ly = 0

	if( centered ) then
		if( lockX ) then
			lx = trackObj.x
		else
			lx = centerX
		end

		if( lockY ) then
			ly = trackObj.y
		else
			ly = centerY
		end
	else
		lx = trackObj.x
		ly = trackObj.y
	end

	--local lr = trackObj.rotation

	worldLayer.enterFrame = function( event )
		if( not worldLayer or worldLayer.removeSelf == nil ) then return end
		if( not trackObj or trackObj.removeSelf == nil ) then return end
		local dx = 0
		local dy = 0
		if(not lockX) then dx = trackObj.x - lx end		
		if(not lockY) then dy = trackObj.y - ly end
		if(dx or dy) then	
			worldLayer:translate(-dx,-dy)
			lx = trackObj.x
			ly = trackObj.y
		end
		return true
	end
	Runtime:addEventListener( "enterFrame", worldLayer )
end


return public