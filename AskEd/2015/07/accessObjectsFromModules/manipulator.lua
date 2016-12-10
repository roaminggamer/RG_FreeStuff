
local public = {}

local myObjects


-- Register the external table
function public.register( aTable )
	myObjects = aTable
end

-- Start manipulating the objects in the table
local lastTimer
function public.start()
	print("Started @ ", system.getTimer())
	lastTimer = timer.performWithDelay( 550,
		function()
			local count = 0
			for k,v in pairs( myObjects ) do
				count = count + 1
				transition.to( v, { x = display.contentCenterX + math.random( -300, 300 ),
					                y = display.contentCenterY + math.random( -300, 300 ),
					                time = 500 } )
			end

			-- If no objects were found, stop automatically
			if( count == 0 ) then
				public.stop()
				print("Automatically stopped @ ", system.getTimer())
			end
		end, - 1  )
end

-- Stop manipulating
function  public.stop()
	if( lastTimer ) then
		timer.cancel( lastTimer )
		lastTimer = nil
	end
end

return public