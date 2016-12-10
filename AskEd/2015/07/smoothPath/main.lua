-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

--[[
		This example shows how to use the catmull-spline algorithm to convert a 'rough' path into a smoothed path.		
--]]

--
-- 1. Require the catmul.loa module
local catmull = require "catmull"

-- 
-- 2. Provide a table to store our path and points in.
local path = {}
local points = {}


--
-- 3. Create an object to 'draw on'
local drawObj = display.newRect( 0, 0, display.actualContentWidth, display.actualContentHeight )
drawObj.alpha = 0.1
drawObj.x = display.contentCenterX
drawObj.y = display.contentCenterY


--
-- 4. Provide a touch listener that does the following:
--[[

	During began' and 'moved' phases,
	a. Destroy any current path and points list.
	b. Draw a circle every 50 pixels as you drag your finger.
	c. Store the circle reference in 'path' for later destruction.
	d. Store the position of the circle as a 'point' in our points table.

	Upon 'ended' phase,
	a. Destroy the original path.
	b. Smooth the points via catmull-rom algorith( in module)
	c. Draw a new smothed path
]]
local function onTouch( self, event )

	if( event.phase == "began") then
		-- 
		-- destroy an existing path
		for k,v in pairs( path ) do
			display.remove( v )
		end
		path = {}

		-- 
		-- Destroy exiting points list
		points = {}

		--
		-- Create first circle and point
		local tmp = display.newCircle( event.x, event.y, 2 )
		path[#path+1] = tmp
		local point = { x = tmp.x, y = tmp.y }
		points[#points+1] = point
		tmp:setFillColor(0,1,0)


	elseif( event.phase == "moved") then
		--
		-- Grab last point and circle
		local lastPoint = points[#points]
		local lastCircle = path[#path]

		
		--
		-- See if we are 50 pixels or more away from the last point
		if( catmull.squareDist( event, lastPoint ) >= (50 * 50) ) then

			--
			-- If so, make a new circle and point
			local tmp = display.newCircle( event.x, event.y, 2 )
			path[#path+1] = tmp
			local point = { x = tmp.x, y = tmp.y }
			points[#points+1] = point
			tmp:setFillColor(1,0,0)

			-- If this is the 3rd point or later, re-color the last circle
			if( #points > 2 ) then
				lastCircle:setFillColor(1,1,0)
			end
		end

	elseif( event.phase == "ended") then
		-- 
		-- Smooth the points list
		points = catmull.smoothPath( points, 3 )

		-- 
		-- destroy temporrly path
		for k,v in pairs( path ) do
			display.remove( v )
		end
		path = {}

		--
		-- draw a new path
		for i = 1, #points do
			local tmp = display.newCircle( points[i].x, points[i].y, 2 )
			path[#path+1] = tmp
			if( i == 1) then			
				tmp:setFillColor(0,1,0)
			elseif( i == #points ) then
				tmp:setFillColor(1,0,0)
			else
				tmp:setFillColor(1,1,0)
			end
		end
	end
	return true
end


--
-- 5. Attach the listener to our draw object
drawObj.touch = onTouch
drawObj:addEventListener( "touch" )



