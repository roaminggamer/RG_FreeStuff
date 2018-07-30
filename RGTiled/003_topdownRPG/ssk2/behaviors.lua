-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local safeRequire, listen, ignore, ignoreList, autoIgnore, post,parse
local behaviorsPath = "scripts.behaviors"
-- =============================================================
local public = {}
_G.ssk = _G.ssk or {}
_G.ssk.behaviors = public
-- ==
-- Set path at which behaviors are found.
-- ==
function public.setPath( path )
	behaviorsPath = path or "scripts"
end

-- ==
-- Attach a 'named' behavior to a display 'object' and initialize it 
-- with optional 'settings' string/table.
-- ==
function public.add( obj, name, settings ) 
	settings = settings or {}

	if( type(settings) == "string" ) then
		
		settings = parse(settings)
	end

	local behavior = safeRequire( behaviorsPath .. "." .. name)

	if( not behavior ) then
		print("WARNING: Attempting to add unknown behavior to object: " .. tostring( name ) )
		return false
	end
	behavior = behavior.new( settings )

	if( not behavior ) then
		print("WARNING: Behavior loaded, but 'new()' call failed?" .. tostring( name ) )
		return false
	end

	--
	-- All behaviors are stored in a unified table on object
	--
	local behaviors = obj._behaviors
	if( not behaviors ) then
		behaviors = {
			globalEvents = {},
			localEvents = {},
			globalListeners = {},
			localListeners  = {},
			alive = true
		}				
		obj._behaviors = behaviors
	end
	--
	if( behavior.onCreate ) then
		behavior.onCreate( obj )
	end
	--
	for k,v in pairs( behavior.ll ) do
		behaviors.localEvents[k] = true
	end
	for k,v in pairs( behavior.gl ) do
		behaviors.globalEvents[k] = true
	end
	--
	behaviors.localEvents.finalize = true -- FORCE addition of 'finalize'
	--
	local b_localListeners = behavior.ll
	for k,v in pairs( behaviors.localEvents ) do
		if( b_localListeners[k] or k == "finalize" ) then
			public.addEventListener( obj, k, b_localListeners[k] )
		end
	end
	--
	local b_globalListeners = behavior.gl
	for k,v in pairs( behaviors.globalEvents ) do
		if( b_globalListeners[k] ) then
			public.addRuntimeEventListener( obj, k, b_globalListeners[k] )
		end
	end
	--	
	return obj
end


function public.addEventListener( obj, name, listener )
	local behaviors = obj._behaviors
	if( not behaviors ) then
		behaviors = {
			globalEvents = {},
			localEvents = {},
			globalListeners = {},
			localListeners  = {},
			alive = true
		}				
		obj._behaviors = behaviors
	end
	--
	if( name == "finalize" ) then
		local listeners = behaviors.localListeners[name] or {}
		behaviors.localListeners[name] = listeners
		listeners[#listeners+1] = listener
		--
		if( not obj[name] ) then
			obj[name] = function( self, event )
			   if(not self._behaviors.alive) then return false end
			   for j = 1, #listeners do
			   	listeners[j]( self, event )
			   end
			   for eventName, _ in pairs( behaviors.globalListeners ) do
			   	ignore( eventName, obj )
			   end
			   self._behaviors.alive = false
			end; obj:addEventListener(name)
		end
	elseif( name == "touch" ) then
		local listeners = behaviors.localListeners[name] or {}
		behaviors.localListeners[name] = listeners
		listeners[#listeners+1] = listener
		--
		if( not obj[name] ) then
			obj[name] = function( self, event )
			   if(not self._behaviors.alive) then return false end				
			   local retVal = true			   
			   for j = 1, #listeners do
			   	retVal = listeners[j]( self, event ) and retVal
			   end
				return retVal
			end; obj:addEventListener(name)
		end
	elseif( name == "collision" ) then
		local listeners = behaviors.localListeners[name] or {}
		behaviors.localListeners[name] = listeners
		listeners[#listeners+1] = listener
		--
		if( not obj[name] ) then
			obj[name] = function( self, event )
			   if(not self._behaviors.alive) then return false end				
			   local retVal = true			   
			   for j = 1, #listeners do
			   	retVal = listeners[j]( self, event ) and retVal
			   end
				return retVal
			end; obj:addEventListener(name)
		end	else
		local listeners = behaviors.localListeners[name] or {}
		behaviors.localListeners[name] = listeners
		listeners[#listeners+1] = listener
		--
		if( not obj[name] ) then
			obj[name] = function( self, event )
			   if(not self._behaviors.alive) then return false end
			   for j = 1, #listeners do
			   	listeners[j]( self, event )
			   end
			end; obj:addEventListener(name)
		end
	end
end

function public.addRuntimeEventListener( obj, name, listener )
	local behaviors = obj._behaviors
	if( not behaviors ) then
		behaviors = {
			globalEvents = {},
			localEvents = {},
			globalListeners = {},
			localListeners  = {},
			alive = true
		}				
		obj._behaviors = behaviors
	end
	--	
	local listeners = behaviors.globalListeners[name] or {}
	behaviors.globalListeners[name] = listeners
	if( not obj[name] ) then
		obj[name] = function( self, event )
			if(not self._behaviors.alive) then return false end
		   for j = 1, #listeners do
		   	listeners[j]( self, event )
		   end
		end; listen( name, obj )
	end
	listeners[#listeners+1] = listener
end

-- ==
--
-- ==
parse = function( str )
   str = string.trim( str )
	str = string.gsub( str, "\n", ",")
   local tmp = string.split( str, "," )
   for i = 1, #tmp do
   	tmp[i] = string.split( tmp[i], "=" )
   end
   local settings = {}
   for i = 1, #tmp do
   	tmp[i][1] = string.trim(tmp[i][1])
   	if( tmp[i][2] == 'true' ) then
   		tmp[i][2] = true
   	elseif( tmp[i][2] == 'false' ) then
   		tmp[i][2] = false
   	elseif( tonumber(tmp[i][2]) ) then
   		tmp[i][2] = tonumber(tmp[i][2])
   	else
   		tmp[i][2] = string.trim(tmp[i][2])
   	end
      settings[tmp[i][1]] = tmp[i][2]
   end
   --table.dump(settings)
   return settings
end
-- =============================================================
safeRequire = function( path )
	local safe,mod = pcall( require, path )
	return (safe and type(mod) == "table") and mod or nil	
end
listen = function( name, listener ) Runtime:addEventListener( name, listener ) end
ignore = function( name, listener ) Runtime:removeEventListener( name, listener ) end
ignoreList = function( list, obj )
   if( not obj ) then return end
   for i = 1, #list do
      local name = list[i]
      if(obj[name]) then 
         ignore( name, obj ) 
         obj[name] = nil
      end
  end
end
autoIgnore = function( name, obj ) 
   if( not display.isValid( obj ) ) then
      ignore( name, obj )
      obj[name] = nil
      return true
   end
   return false 
end
post = function( name, params )
   params = params or {}
   local event = {}
   for k,v in pairs( params ) do event[k] = v end
   if( not event.time ) then event.time = getTimer() end
   event.name = name
   Runtime:dispatchEvent( event )
end
-- =============================================================
local display_remove = display.remove
function display.remove( self )
	if( self and self._behaviors ) then self._behaviors.alive = false end
	display_remove( self )
end
return public
