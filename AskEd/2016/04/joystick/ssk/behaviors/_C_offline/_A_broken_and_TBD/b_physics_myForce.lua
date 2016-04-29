-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Behavior - Physics: My Force
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
public._behaviorName = "physics_myForce"

function public:onAttach( obj, params )
	dprint(0,"Attached Behavior: " .. self._behaviorName)

	behaviorInstance = {}
	behaviorInstance._behaviorName = self._behaviorName

	behaviorInstance.moveObj     = obj

	obj.myForce = {x = (params.forceX or 0), y = (params.forceY or 0) }
	obj.myForce_enabled = enabled or true

	-- Other behaviors and code may add (transient) forces which are used and removed
	-- every frame by this behavior.
	obj.myExtForces = { }

	-- Other behaviors and code may add constant forces which are used and removed
	-- every frame by this behavior.
	obj.myConstantExtForces = { }

	obj.myForce_addForce = function( self, forceX, forceY )
		obj.myExtForces[#obj.myExtForces+1] = {x = forceX or 0, y = forceY or 0}
	end

	-- forceIndex - Required index for storing force value.
	obj.myForce_addConstantForce = function( self, forceIndex, forceX, forceY )
		obj.myConstantExtForces[forceIndex] = {x = forceX or 0, y = forceY or 0}
	end

	obj.myForce_removeConstantForce = function( self, forceIndex )
		obj.myConstantExtForces[forceIndex] = nil
	end


	-- Pass a nil for forceX and/or forceY to retain prior value
	obj.myForce_set = function( self, forceX, forceY)
		obj.myForce.x = forceX or obj.myForce.x
		obj.myForce.y = forceY or obj.myForce.y
	end

	obj.myForce_get = function( self )
		-- return a copy, not the original table
		return { x = obj.myForce.x,  y = obj.myForce.y } 
	end

	obj.myForce_getX = function( self )
		return obj.myForce.x
	end

	obj.myForce_getY = function( self )
		return obj.myForce.y
	end


	obj.disable_myForce = function( self )
		self.myForce_enabled = false
	end

	obj.enable_myForce = function( self )
		self.myForce_enabled = true
	end

	obj.myForce_isEnabled = function( self )
		return self.myForce_enabled
	end

	local function updateForce( event )
		if(not obj:myForce_isEnabled()) then return false end

		local x,y = obj.myForce.x,obj.myForce.y

		for k,v in ipairs(obj.myExtForces) do
			x,y = x+v.x, y+v.y
		end

		obj.myExtForces = {}


		obj:applyForce(x,y,obj.x,obj.y)		
		return false
	end

	Runtime:addEventListener( "enterFrame", updateForce )		
	
	function behaviorInstance:onDetach( obj )
		dprint(0,"Detached Behavior: " .. self._behaviorName)
		Runtime:removeEventListener( "enterFrame", updateForce )		
	end

	return behaviorInstance
end

ssk.behaviors:registerBehavior( "physics_myForce", public )
return public
