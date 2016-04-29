-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- 
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


behaviorsManager = {}

behaviorsManager.knownBehaviors = {}

function behaviorsManager.listBehaviors()
   local count = 0
   for k,v in pairs(behaviorsManager.knownBehaviors) do
      count = count + 1
      print( string.format( "%03.3i - %s", count, k ) )
   end   
end

--[[
h ssk.behaviors:registerBehavior
d Registers new behavior class with behaviors manager.
s ssk.behaviors:registerBehavior( behaviorName, behaviorObject )	
s * behaviorName - String containing name of behavior.
s * behaviorObject - New behavior object (singleton or instance variant).
r None.
e public = {}
e public._behaviorName = "mover_dragDrop"
e
e function public:onAttach( obj, params )
e    -- ...
e end
e
e ssk.behaviors:registerBehavior( public._behaviorName, public ) 
e
--]]
function behaviorsManager:registerBehavior( behaviorName, behaviorObject )	
	--print("behaviorsManager:registerBehavior( \"" .. behaviorName .. "\" , " .. tostring(behaviorObject) .. " )" )	
	if(self.knownBehaviors[behaviorName] ~= nil) then
		-- EFM - Not really an error
		-- EFM - Allow multiple requires of same behavior (users can access them locally)
		print("WARNING: Attempting to register behavior using previously used behavior name: ", behaviorName )
		return
	end

	self.knownBehaviors[behaviorName] = behaviorObject
end

--[[
h ssk.behaviors:attachBehavior
d Attaches a behavior to a display object.
s ssk.behaviors:attachBehavior( obj, behaviorName [, params ])
s * obj - Reference to display object.
s * behaviorName - String containing name of behavior.
s * params - (optional) Extra parameters specific to configuring the named behavior.
r ''true'' if behavior attached successfully, ''false'' otherwise.
--]]
function behaviorsManager:attachBehavior( obj, behaviorName, params )
	print("behaviorsManager:attachBehavior(",obj, behaviorName , ")" )	

	local behaviorObject = self.knownBehaviors[behaviorName]
	if(not behaviorObject) then
		print("ERROR: Attempting to attach behavior using unknown behavior name: ", behaviorName )
		return false
	end

	local theBehavior = behaviorObject:onAttach( obj, params )

	if(not theBehavior) then
		return false
	end

	-- Track behavior owner
	theBehavior.owner = obj

	-- keep track of attached behaviors (per object)
	if(not obj._behaviorsAttached) then
		obj._behaviorsAttached = {}
	end
	obj._behaviorsAttached[theBehavior] = theBehavior


	-- Add a custom removeSelf() function to obj that removes any attached behaviors from the object 
	-- when obj:removeSelf() is called
	local function custom_removeSelf( self ) 
		print("behaviorsManager:custom_removeSelf()")	
		ssk.behaviors:detachBehaviors(self)
	end

	behaviorsManager.addCustom_removeSelf( obj, custom_removeSelf )

	return true
end

--[[
h ssk.behaviors:attachBehaviors
d Attaches one or more behaviors to a display object.
d Note: Behaviors attached in this fashion cannot take optional parameters.
s ssk.behaviors:attachBehaviors( obj, behaviorsTable )
s * obj - Reference to display object.
s * behaviorsTable - Table containing one or more string name(s) of behaviors.
r ''true'' if behavior(s) attached successfully, ''false'' otherwise.
--]]
function behaviorsManager:attachBehaviors( obj, behaviorsTable )
	print("behaviorsManager:attachBehaviors(",obj, behaviorsTable , ")" )	

	local retval = true
	for i=1, #behaviorsTable do
		local curBehavior = behaviorsTable[i]
		print("behaviorsTable[" .. i .. "] == " .. curBehavior[1] )
		retval = retval and self:attachBehavior(obj, curBehavior[1], curBehavior[2])
	end
	return retval
end

--[[
h ssk.behaviors:detachBehaviors
d Detaches all previously attached a behaviors from a display object.
s ssk.behaviors:detachBehaviors( obj )
s * obj - Reference to display object.
r ''true'' if behaviors detached successfully, ''false'' otherwise.
--]]
function behaviorsManager:detachBehaviors( obj )
	print("behaviorsManager:detachBehaviors(",obj , ")" )	
	if( not obj._behaviorsAttached ) then
		return false
	end

	for k,v in pairs(obj._behaviorsAttached) do
		if(v.onDetach) then 
			v:onDetach( obj )
			-- Clear reference to owner object
			v.owner = nil
		end
	end

	return true
end

--[[
h ssk.behaviors:hasBehaviors
d Tests an object to see if it has one or more behaviors attached.
s ssk.behaviors:hasBehaviors( obj )
s * obj - Reference to display object.
r ''true'' if behaviors are attached, ''false'' otherwise.
--]]
function behaviorsManager:hasBehaviors( obj )
	if( not obj._behaviorsAttached ) then
		return false
	end
	return true
end


-- ==
--    ssk.advanced.addCustom_removeSelf( obj, custom_removeSelf )
--
--    Caches a display object's old removeSelf() function and attaches a new one.  
--    This feature allows one display object to have multiple stacked removeSelf() 
--    functions that get called in the reverse-order that they were attached.
--
--    obj - The display object whose removeSelf() function is being cached and stacked.
--    custom_removeSelf - A pointer to the new removeSelf() function to attach to obj.
-- ==
function behaviorsManager.addCustom_removeSelf( obj, custom_removeSelf )

	-- If this is the first time, 
	
	if( not obj._cache_removeSelf ) then

		--  A. Create a cache to store custom removeSelf() functions
		obj._cache_removeSelf = {}
		
		--  B. Add the Corona removeSelf function to the cache
		obj._cache_removeSelf[1] = obj.removeSelf

		--  C. Create a custom removeSelf that will call all cached functions and do some other
		--  helpful stuff
		local function removeSelf( self )
			-- 1. Grab the cache of custom removeSelf functions
			local theCache = self._cache_removeSelf
			
			-- 2. Call the custom removeSelf functions in reverse order
			for i=#theCache, 1, -1 do
				self.func = theCache[i]
				if(self.func) then
					self:func()
				end
			end

			-- 3. Clear the cache
			theCache = {}
			self._cache_removeSelf = {}

			-- 4. Assign a dummy catch function which will warn you if removeSelf() is
			--   incorrectly called again
			local function dummy()
				print("WARNING: removeSelf() called twice on same object!" )
			end

			self.removeSelf = dummy
		end

		obj.removeSelf = removeSelf
	end

	obj._cache_removeSelf[#obj._cache_removeSelf+1] = custom_removeSelf
end



return behaviorsManager
