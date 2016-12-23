-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
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
local common = require "scripts.common"
local factoryMgr = {}
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
--    new( name, group, x, y [, params ] ) - Create new instance of name factory object,
--                                           in group, at < x,  y >.
--                                           Pass optional params table to factory.
-- ==
function factoryMgr.new( name, group, x, y, params )	
	if( not factories[name] ) then 
		print( "factorMgr.new() - Unknown factory: " .. tostring(name) )
		return nil 
	end

	return factories[name].new( group, x, y, params )
end


return factoryMgr