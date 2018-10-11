-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

local public = {}

--
-- Function to 'follow' a path.
function public.followPath( obj, path, speed, dir, moveStyle )
	obj.x = path[1].x
	obj.y = path[1].y


	dir = (moveStyle ==  "loop") and dir or 1 -- Non-looping not allowed to start in -1 dir
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
	
	-- LOOP
	if( moveStyle ==  "loop" ) then
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
	
	-- PING PONG
	elseif( moveStyle ==  "pingpong" ) then
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
	
	-- ONCE
	else 
		local first = true
		onNextNode = function( self )		
			local curNode
			if( dir == 1 ) then				
				curNode = nextNode
				nextNode = nextNode + 1				
				if( nextNode > #path ) then
					return 
				end
			else
				curNode = nextNode
				nextNode = nextNode - 1
				if( nextNode < 1 ) then
					return
				end
			end
			transition.to( obj, { x = path[nextNode].x, y = path[nextNode].y, time = calculateTime( curNode, nextNode ), onComplete = onNextNode } )
		end
	end
	transition.to( obj, { x = path[nextNode].x, y = path[nextNode].y, time = calculateTime( 1, nextNode ), onComplete = onNextNode } )
end

return public