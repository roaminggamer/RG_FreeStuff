-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Factory Manager
-- =============================================================
--[[
		register() - Called to 'register' a factory (module) by name, 
		             so it can be used later.		

		    init() - Called once to intialize a factory or factories.

		   reset() - Called to reset the state of a factory or factories.  
		             Rarely needed.)

		     new() - Called to create new instance(s) of the named 
		             factory's object(s).
]]
-- =============================================================
-- =============================================================
local factoryMgr = {}
_G.ssk.factoryMgr = factoryMgr

local factories = {}

--
-- Register factories with the manager
-- 
function factoryMgr.register( name, path )	
	factories[name] = require( path )
end

-- ==
--		init( [name [, params ] ]) - Reset specific factory name, or all if name == nil.
--                                  Pass optional params table to factory.
-- ==
function factoryMgr.init( name, params )

	-- No name specified. Reset all factories
	--
	if( name == nil ) then
		for k,v in pairs( factories ) do
			if( v.init ) then
				v.init( params )
			end	
		end
		return	
	end

	-- Try to reset a specific factory
	if( not factories[name] ) then 
		print( "factorMgr.init() - Unknown factory: " .. tostring(name) )
		return nil 
	end

	if( factories[name].init ) then
		factories[name].init( params )
	end
end

-- ==
--		reset( [name [, params ] ]) - Reset specific factory name, or all if name == nil.
--                                  Pass optional params table to factory.
-- ==
function factoryMgr.reset( name, params )

	-- No name specified. Reset all factories
	--
	if( name == nil ) then
		for k,v in pairs( factories ) do
			if( v.reset ) then
				v.reset( params )
			end	
		end
		return	
	end

	-- Try to reset a specific factory
	if( not factories[name] ) then 
		print( "factorMgr.reset() - Unknown factory: " .. tostring(name) )
		return nil 
	end

	if( factories[name].reset ) then
		factories[name].reset( params )
	end
end

-- ==
--    new( name [, group [, x [, y [, params ]]]] ) - Create new instance of name factory object,
--                                           in group, at < x,  y >.
--                                           Pass optional params table to factory.
-- ==
function factoryMgr.new( name, group, x, y, params )
	group = group or display.currentStage
	if( not factories[name] ) then 
		print( "factorMgr.new() - Unknown factory: " .. tostring(name) )
		return nil 
	end

	return factories[name].new( group, x, y, params )
end


-- ==
--    get( name ) - Return a direct reference to the named factory object.
--                  This allows you to access custom function on the factory 
--                   if you choose to add them.
-- ==
function factoryMgr.get( name )
	return factories[name]
end

-- =============================================================
-- Following only needed for editor ready factories
-- =============================================================

-- ==
--    newChip( name [, group [, x [, y [, params ]]]] ) - Create new editor GUI chip instance of name factory object,
--                                           in group, at < x,  y >.
--                                           Pass optional params table to factory.
-- ==
function factoryMgr.newChip( name, group, x, y, params )
	group = group or display.currentStage
	x = x 
	y = y 
	if( not factories[name] ) then 
		print( "factorMgr.newChip() - Unknown factory: " .. tostring(name) )
		return nil 
	end

	return factories[name].newChip( name, group, x, y, params )
end

-- ==
--    newPiece( name [, group [, x [, y [, params ]]]] ) - Create new editor GUI chip instance of name factory object,
--                                           in group, at < x,  y >.
--                                           Pass optional params table to factory.
-- ==
function factoryMgr.newPiece( name, group, x, y, params )
	group = group or display.currentStage
	x = x 
	y = y 
	if( not factories[name] ) then 
		print( "factorMgr.newPiece() - Unknown factory: " .. tostring(name) )
		return nil 
	end

	return factories[name].newPiece( name, group, x, y, params )
end


return factoryMgr