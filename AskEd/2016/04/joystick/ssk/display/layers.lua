-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- 								License
-- =============================================================
--[[
	> SSK is free to use.
	> SSK is free to edit.
	> SSK is free to use in a free or commercial game.
	> SSK is free to use in a free or commercial non-game app.
	> SSK is free to use without crediting the author (credits are still appreciated).
	> SSK is free to use without crediting the project (credits are still appreciated).
	> SSK is NOT free to sell for anything.
	> SSK is NOT free to credit yourself with.
]]
-- =============================================================

local debugLevel = 0 or debugLevel
local function _dprint( lvl, ... )
	if( debugLevel >= lvl ) then
		print( unpack(arg) )
	end
end

-- Create the display class if it does not yet exist
--
local displayExtended = {}


-- ==
--    func() - what it does
-- ==
function displayExtended.quickLayers( parentGroup, ... )
	local parentGroup = parentGroup or display.currentStage
	local layers = display.newGroup() 
	parentGroup:insert(layers)

	layers._db = {}

	local lastGroup

	_dprint(2,"\\ (parentGroup)")
	
	for i = 1, #arg do
		local theArg = arg[i]
			
		if(type(theArg) == "string") then
			_dprint(2,"|--\\ " .. theArg)
			local group = display.newGroup()
			lastGroup = group
			layers._db[#layers._db+1] = group 
			layers[theArg] = group 
			layers:insert( group )

		else -- Must be a table -- ALLOW UP TO 'ONE' ADDITIONAL LEVEL OF DEPTH
			for j = 1, #theArg do
				local theArg2 = theArg[j]
				_dprint(2,"   |--\\ " .. theArg2)
				if(type(theArg2) == "string") then
					local group = display.newGroup()
					layers._db[#layers._db+1] = group 
					layers[theArg2] = group 
					lastGroup:insert( group )
				else
					error("layers() Only two levels allowed!")
				end				
			end
		end		
	end

	-- ==
	--    destroy() - Self destruct.
	-- ==
	function layers:destroy()
		display.remove( self )
	end

	-- ==
	--    purge() - Remove all children in a layer without destroying the later.
	--              Warning: Do not call on layers with sub-layers or they will be destroyed.
	-- ==
	function layers:purge( name )		
		local layer = self[name]
		if( not layer ) then return end
		while( layer.numChildren > 0 ) do
			display.remove(layer[1])
		end
	end
	

	return layers	
end

return displayExtended