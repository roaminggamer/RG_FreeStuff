-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Game Event Manager (uses Runtime Events and makes managing them simple)
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
--local debugLevel = 2 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print


local gem

if( not _G.ssk.gem ) then
	_G.ssk.gem = {}
	_G.ssk.gem.eventsDB = {}
	_G.ssk.gem.eventGroupsDB = {}
end

gem = _G.ssk.gem


-- ==
--    ssk.gem:add( eventName, handler [ , group ] ) - Registers a handler function with the global event eventName.
-- ==
function gem:add( eventName, handler, group )
	if(group) then
		if(not self.eventGroupsDB[group] ) then
			self.eventGroupsDB[group] = {}
		end

		local eventGroup = self.eventGroupsDB[group]
		eventGroup[handler] = eventName
	else
		self.eventsDB[handler] = eventName
	end
	Runtime:addEventListener( eventName, handler )
end

-- ==
--    ssk.gem:remove( eventName, handler ) - Un-registers a handler function with the global event eventName.
-- ==
function gem:remove( eventName, handler )
	Runtime:removeEventListener( eventName, handler )
	self.eventsDB[handler] = nil
end

-- ==
--    ssk.gem:removeGroup( group ) - Automatically un-registers all handlers and event previously registered with ssk.gem:add() using a named group.
-- ==
function gem:removeGroup( group )

	if(not self.eventGroupsDB[group] ) then
		return
	end

	local eventGroup = self.eventGroupsDB[group]

	for k,v in pairs(eventGroup) do
		Runtime:removeEventListener( v, k )
	end

	self.eventGroupsDB[group] = {}
end


-- ==
--    ssk.gem:removeAll( ) - Automatically un-registers all non-grouped handlers and event previously that were registered with ssk.gem:add().
-- ==
function gem:removeAll( ) -- Does not affect grouped events (yet)
	for k,v in pairs(self.eventsDB) do
		Runtime:removeEventListener( v, k )
	end
	self.eventsDB = {}
end

-- ==
--    ssk.gem:post( eventName [ , eparams ] ) - Posts (dispatches) a named event.
-- ==
function gem:post( eventName, eparams )
	local params = eparams or {}
	params.name = eventName
	--table.insert(params, "name", eventName)
	if( debugLevel > 1 ) then
		dprint(2,"gem:post() =>")
		for k,v in pairs(params) do 
			local ktype = type(k)
			local vtype = type(v)
			if( not (ktype == "number" or ktype == "string" or ktype == "boolean") ) then
				k = "other" 
			end
			if( not (vtype == "number" or vtype == "string" or vtype == "boolean") ) then
				v = "other" 
			end
			dprint(2, "   arg: " .. k .. " = " .. v)		
		end
		dprint(2,"----")
	end

	Runtime:dispatchEvent(params)
end
