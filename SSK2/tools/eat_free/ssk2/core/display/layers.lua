-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Quick Layers Utility
-- =============================================================
local debugLevel = ssk.__debugLevel or 0
local function _dprint( lvl, ... )
	if( debugLevel >= lvl ) then
		print( unpack(arg) )
	end
end

-- Create the display class if it does not yet exist
--
local displayExtended = {}

function displayExtended.quickLayers( parentGroup, ... )
	local parentGroup = parentGroup or display.currentStage
	local layers = display.newGroup() 
	layers.__isLayer = true
	parentGroup:insert(layers)

	layers._db = {}

	local lastGroup

	_dprint(2,"\\ (parentGroup)")
	
	for i = 1, #arg do
		local theArg = arg[i]
			
		if(type(theArg) == "string") then
			_dprint(2,"|--\\ " .. theArg)
			local group = display.newGroup()
			group.__isLayer = true
			group.__layerName = theArg
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
					group.__isLayer = true
					group.__layerName = theArg2
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
	function layers:purge( name, recursive )
		recursive = fnn( recursive, true )		
		
		local layer 
		if( not name ) then
			_dprint(2,"Attempting to purge entire layer hieararchy" )
			layer = self
		else
			_dprint(2,"Attempting to purge layer: " .. tostring( name ) )
			layer = self[name] 
		end
		if( not layer ) then return end
		
		local toRemove = {}
		for i = 1, layer.numChildren do
			local obj = layer[i]
			if( obj.__isLayer ) then
				if( recursive and obj.__layerName ) then
					self:purge( obj.__layerName, recursive )
				end
			else
				toRemove[#toRemove+1] = obj
			end
		end
		
		for i = 1, #toRemove do
			display.remove(toRemove[i])
		end
	end
	

	return layers	
end

return displayExtended
