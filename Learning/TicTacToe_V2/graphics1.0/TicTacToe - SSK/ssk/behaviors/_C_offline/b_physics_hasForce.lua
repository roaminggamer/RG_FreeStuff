-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Behavior - Physics: Has Force
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

public = {}
public._behaviorName = "physics_hasForce"

function public:onAttach( obj, params )
	dprint(0,"Attached Behavior: " .. self._behaviorName)

	behaviorInstance = {}
	behaviorInstance._behaviorName = self._behaviorName
	behaviorInstance.owner = obj

	local myForce = {x = (params.forceX or 0), y = (params.forceY or 0) }
	local hasForce_enabled = enabled or true

	-- Pass a nil for forceX and/or forceY to retain prior value
	obj.hasForce_set = function( self, forceX, forceY)
		myForce.x = forceX or myForce.x
		myForce.y = forceY or myForce.y
	end

	obj.hasForce_get = function( self )
		-- return a copy, not the original table
		return { x = myForce.x,  y = myForce.y } 
	end

	obj.hasForce_getX = function( self )
		return myForce.x
	end

	obj.hasForce_getY = function( self )
		return myForce.y
	end

	obj.disable_myForce = function( self )
		hasForce_enabled = false
	end

	obj.enable_myForce = function( self )
		hasForce_enabled = true
	end

	obj.hasForce_isEnabled = function( self )
		return hasForce_enabled
	end

	local function updateForce( event )
		if(not obj:hasForce_isEnabled()) then return false end

		local x,y = myForce.x, myForce.y
		obj:applyForce(myForce.x,myForce.y,obj.x,obj.y)		

		return false
	end

	Runtime:addEventListener( "enterFrame", updateForce )		
	
	function behaviorInstance:onDetach( obj )
		dprint(0,"Detached Behavior: " .. self._behaviorName)

		Runtime:removeEventListener( "enterFrame", updateForce )		
	end

	return behaviorInstance
end

ssk.behaviors:registerBehavior( "physics_hasForce", public )
return public
