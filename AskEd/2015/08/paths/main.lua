-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"This user was confused about how to follow a path continously.", 
	"Since the question was a little ambigous, I'm showing these path following styles.",
	"",
	" * Looping - Follows path in loop forever.",
	" * Ping Pong - Follows path continously changing direction when the 'end' is reached."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end

--
-- Function to draw path
local function drawPath( points, closed )
	for i = 2, #points do
		display.newLine( points[i-1].x, points[i-1].y, points[i].x, points[i].y )
	end
	if( closed ) then
		display.newLine( points[#points].x, points[#points].y, points[1].x, points[1].y )
	end
end

--
-- Function to 'follow' a path.
local function followPath( obj, path, speed, dir, loop )
	obj.x = path[1].x
	obj.y = path[1].y


	dir = (loop) and dir or 1 -- Non-looping not allowed to start in -1 dir
	local nextNode = (dir == -1) and #path or 2
	local onNextNode
	local function calculateTime( curNode, nextNode )
		local node1 = path[curNode]
		local node2 = path[nextNode]
		local vx = node1.x - node2.x
		local vy = node1.y - node2.y
		local len = math.sqrt( vx * vx + vy * vy )
		local time = 1000 * len / speed
		return time
	end
	if( loop ) then
		onNextNode = function( self )		
			local curNode
			if( dir == 1 ) then
				curNode = nextNode
				nextNode = nextNode + 1
				if( nextNode > #path ) then
					nextNode = 1
				end
			else
				curNode = nextNode
				nextNode = nextNode - 1
				if( nextNode < 1) then
					nextNode = #path
				end
			end
			transition.to( obj, { x = path[nextNode].x, y = path[nextNode].y, time = calculateTime( curNode, nextNode ), onComplete = onNextNode } )
		end
	else
		onNextNode = function( self )		
			local curNode
			if( dir == 1 ) then
				curNode = nextNode
				nextNode = nextNode + 1
				if( nextNode > #path ) then
					nextNode = curNode - 1
					dir = -1 * dir
				end
			else
				curNode = nextNode
				nextNode = nextNode - 1
				if( nextNode < 1) then
					nextNode = curNode + 1
					dir = -1 * dir
				end
			end
			transition.to( obj, { x = path[nextNode].x, y = path[nextNode].y, time = calculateTime( curNode, nextNode ), onComplete = onNextNode } )
		end
	end
	transition.to( obj, { x = path[nextNode].x, y = path[nextNode].y, time = calculateTime( 1, nextNode ), onComplete = onNextNode } )
end

--
-- Define two paths and draw them.
local sx = display.contentCenterX
local sy = display.contentCenterY 

local path1 = { 
	{ x = sx - 300, y = sy - 100 }, 
	{ x = sx - 50,  y = sy - 100 }, 
	{ x = sx - 50,  y = sy + 100 }, 
	{ x = sx - 300, y = sy + 100 }, 
}
local path2 = {	
	{ x = sx + 50,   y = sy - 100 }, 
	{ x = sx + 300,  y = sy - 100 }, 
	{ x = sx + 300,  y = sy + 100 }, 
	{ x = sx + 50,   y = sy + 100 }, 
}

drawPath( path1, false )
drawPath( path2, true )


--
-- Create two objects to follow our paths
local obj1 = display.newImageRect( "yellow_round.png", 40, 40 )
local obj2 = display.newImageRect( "yellow_round.png", 40, 40 )

--
-- Follow the paths
followPath( obj1, path1, 300, 1, false )
followPath( obj2, path2, 350, 1, true)
-- Comment out above and try these instead:
--followPath( obj1, path1, 300, -1, false )
--followPath( obj2, path2, 350, -1, true)