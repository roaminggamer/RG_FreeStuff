-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- Prototyping Objects
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
-- Docs: https://github.com/roaminggamer/SSKCorona/wiki
-- =============================================================

local debugLevel = 0 -- Comment out to get global debugLevel from main.cs
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
		--print("PURGING... " .. tostring(name) )
		--print(debug.traceback())
		local layer = self[name]
		if( not layer ) then return end

		while( layer.numChildren > 0 ) do
			--layer:remove(layer[1])
			display.remove(layer[1])
		end
	end
	

	return layers	
end

return displayExtended