-- =============================================================
-- Roaming Gamer, LLC. 2008-2018
-- =============================================================
local pathFollow = require "pathFollow"
local public = {}

local path = {}
local lastLine
local lastFollowObj
local pathGroup

local function squareDist( p0, p1)
	return ( (p0.x - p1.x) ^ 2 + (p0.y - p1.y) ^ 2 )
end

function public.attach( drawObj, params )
	params = params or {}
	local minDist = params.minDist or 50
	--
	pathGroup = display.newGroup()
	drawObj.parent:insert( pathGroup )
	--
	local function onTouch( self, event )

		if( event.phase == "began") then
			-- 
			-- destroy an existing path
			for k,v in pairs( path ) do
				display.remove( v )
			end
			path = {}
			display.remove(lastLine)
			lastLine = nil

			if( lastFollowObj ) then
				transition.cancel( lastFollowObj ) 
				lastFollowObj = nil
			end

			--
			-- Create first circle
			local tmp
			if( debugEn ) then
				tmp = display.newText( pathGroup, #path+1, event.x, event.y, nil, 12 )
			else
				tmp = display.newCircle( pathGroup, event.x, event.y, 4 )
			end

			path[#path+1] = tmp

			tmp:setFillColor(0,1,0)


		elseif( event.phase == "moved") then
			--
			-- Grab last point
			local lastPoint = path[#path]
			
			--
			-- See if we are minDist pixels or more away from the last point
			if( squareDist( event, lastPoint ) >= (minDist ^ 2) ) then

				local tmp
				if( debugEn ) then
					tmp = display.newText( pathGroup, #path+1, event.x, event.y, nil, 12 )
				else
					tmp = display.newCircle( pathGroup, event.x, event.y, 4 )
				end

				path[#path+1] = tmp

				tmp:setFillColor(1,1,0)

				-- Try to add to line
				if( lastLine == nil ) then
					if( #path == 2 ) then 
						lastLine = display.newLine( pathGroup, path[1].x, path[1].y, path[2].x, path[2].y )
						lastLine:setStrokeColor(1,0,1)
						lastLine.strokeWidth = 4
						lastLine.alpha = 0.5
						lastLine:toBack()
					end
				else
					lastLine:append( tmp.x, tmp.y )
				end
			end

		elseif( event.phase == "ended") then
			path[#path]:setFillColor(1,1,0)

			if( params.followObj and #path > 1 ) then
				lastFollowObj = params.followObj 
				params.followObj:toFront()
				pathFollow.followPath( params.followObj, path, params.speed or 100, 1, "once" )
			end
		end
		return true
	end

	--
	--Attach the listener to our draw object
	drawObj.touch = onTouch
	drawObj:addEventListener( "touch" )

end


return public