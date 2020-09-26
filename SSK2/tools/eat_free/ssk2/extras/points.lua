-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
_G.ssk = _G.ssk or {}
local points = {}
_G.ssk.points = points

-- ==
--    ssk.points:new( ... ) - Create a new points instance.
-- ==
function points.new( ... )
	local pointsInstance = {}
	
	-- ==
	--    pointsInstance:add( x1,y1,... ) - Appends any number of point x,y pairs to the points list.
	-- ==
	function pointsInstance:add(...)
		if(#arg % 2 == 1) then return end
		local i = 1
		while(i < #arg) do
			pointsInstance[#pointsInstance+1] = {x=arg[i],y=arg[i+1]}
			i = i + 2
		end			
	end

	-- ==
	--    pointsInstance:insert( index, x1,y1,... )
	-- ==
	function pointsInstance:insert(index, ...)

		local index = index or 1
		if(#arg % 2 == 1) then return end
		local i = 1
		while(i < #arg) do
			table.insert( self, index, {x=arg[i],y=arg[i+1]} )
			i = i + 2
			index = index + 1
		end			
	end

	-- ==
	--    pointsInstance:get( index ) - Gets a single point out of the points list.
	-- ==
	function pointsInstance:get(index)
		local index = index or 1
		return pointsInstance[index]
	end

	-- ==
	--    pointsInstance:remove( index ) - Removes a single point from the points list
	-- ==
	function pointsInstance:remove(index)
		local index = index or 1
		local element = table.remove( self, index )
		return element
	end

	-- ==
	--    pointsInstance:push( x1,y1,... ) - Treats points list like a stack/FILO and pushes one or more point sets onto the points list top (end).
	-- ==
	function pointsInstance:push(...)
		if(#arg % 2 == 1) then return end
		local i = 1
		while(i < #arg) do
			pointsInstance[#pointsInstance+1] = {x=arg[i],y=arg[i+1]}
			i = i + 2
		end
	end

	-- ==
	--    pointsInstance:peek( ) - Treats points list like a stack/FILO and retrieves the point at the top (end) of the points list.
	-- ==
	function pointsInstance:peek()
		return self[#self]
	end

	-- ==
	--    pointsInstance:pop( ) - Treats points list like a stack/FILO and pops the point at the top (end) off the points list.
	-- ==
	function pointsInstance:pop()
		if( not #self ) then return nil end
		local element = self[#self]
		self[#self] = nil
		return element
	end

	-- ==
	--    pointsInstance:push_head( x1,y1,... ) - Treats points list like a queue/FIFO and pushes one or more point sets (in reverse order) onto the points list front. Like calling insert(1, x1,y1), insert(1, x2,y2), ..., insert(1, xN,yN), 
	-- ==
	function pointsInstance:push_head(...)
		if(#arg % 2 == 1) then return end
		local i = 1
		while(i < #arg) do
			table.insert( self, 1, {x=arg[i],y=arg[i+1]} )
			i = i + 2
		end			
	end

	-- ==
	--    pointsInstance:peek_head( ) - Treats points list like a queue/FIFO and retrieves the point at the front of the points list. Like a get at 1.
	-- ==
	function pointsInstance:peek_head()
		return self[1]
	end

	-- ==
	--    pointsInstance:pop_head( ) - Treats points list like a queue/FIFO and pops the point at the front off the points list. Like a remove at 1.
	-- ==
	function pointsInstance:pop_head(x,y)
		local element = table.remove( self, 1 )
		return element
	end

	-- If any points were passed, add them now
	pointsInstance:add( unpack( arg ) )

	return pointsInstance
end

return points