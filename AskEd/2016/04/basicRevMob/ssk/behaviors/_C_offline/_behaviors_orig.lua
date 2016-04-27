-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Behaviors Manager
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
--
-- =============================================================

--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

behaviorsManager = {}

behaviorsManager.knownBehaviors = {}

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
	dprint(1,"behaviorsManager:registerBehavior( \"" .. behaviorName .. "\" , " .. tostring(behaviorObject) .. " )" )	
	if(self.knownBehaviors[behaviorName] ~= nil) then
		-- EFM - Not really an error
		-- EFM - Allow multiple requires of same behavior (users can access them locally)
		dprint(2,"WARNING: Attempting to register behavior using previously used behavior name: ", behaviorName )
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
	dprint(2,"behaviorsManager:attachBehavior(",obj, behaviorName , ")" )	

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
		dprint(2,"behaviorsManager:custom_removeSelf()")	
		ssk.behaviors:detachBehaviors(self)
	end

	ssk.advanced.addCustom_removeSelf( obj, custom_removeSelf )

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
	dprint(2,"behaviorsManager:attachBehaviors(",obj, behaviorsTable , ")" )	

	local retval = true
	for i=1, #behaviorsTable do
		local curBehavior = behaviorsTable[i]
		dprint(3,"behaviorsTable[" .. i .. "] == " .. curBehavior[1] )
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
	dprint(2,"behaviorsManager:detachBehaviors(",obj , ")" )	
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


return behaviorsManager
