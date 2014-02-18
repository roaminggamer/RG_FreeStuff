-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Game Logic Modules
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

local components

if( not _G.ssk.components ) then
	_G.ssk.components = {}
end

components = _G.ssk.components

local fnn = fnn
local angle2Vector = ssk.math2d.angle2Vector
local scaleVector = ssk.math2d.scale


-- EFM: I: Point attractors and repulsors, object attractors and repulsors

-- ==
--    func() - what it does
-- ==
function components.hasForce( obj, forceValue, params )

	if( obj.__hasForce ) then
		print("ERROR: This object already has the component hasForce() applied.")
		print("If you need multiple forces, use the hasForces() component instead.")
	end

	obj.__hasForce = {}
	obj.__hasForce.value  = forceValue
	obj.__hasForce.params = table.shallowCopy( params )

	table.print_r( obj.__hasForce )

	local enterFrameListener


	enterFrameListener = function( event )


		if( not isDisplayObject( obj ) ) then
			Runtime:removeEventListener( "enterFrame", enterFrameListener )			
			return false
		end

		if( not obj.__hasForce ) then
			Runtime:removeEventListener( "enterFrame", enterFrameListener )
			return false
		end

		local fx = fnn(obj.__hasForce.value[1], obj.__hasForce.value.x, 0 )
		local fy = fnn(obj.__hasForce.value[2], obj.__hasForce.value.y, 0 )
		local params  = obj.__hasForce.params

		if( params ) then

			-- Is this force forward? (Only in direction it is facing)
			if( params.forward ) then
				dprint(2,"forward")
				local nx,ny = angle2Vector( obj.rotation )
				local scale = fx
				fx,fy = scaleVector( nx, ny, scale )

				if( debugLevel > 1 ) then 
					fx = round(fx,2)
					fy = round(fy,2)
					nx = round(nx,2)
					ny = round(ny,2)
				end
					
				dprint(2, fx,fy, nx, ny, scale, obj.rotation)
			end
				
			-- Is this force gravitic? (Only applied to 
			if ( params.gravitic ) then
				dprint(2,"gravitic")
				fx = fx * obj.mass
				fy = fy * obj.mass
			end

		end
			
		dprint(2, fx, fy, obj.x, obj.y )
		obj:applyForce( fx, fy, obj.x, obj.y )  -- This force is cumulative

		return false
	end

	-- ==
	--    func() - what it does
	-- ==
	obj.remove_hasForce = function( self )

		-- Stop the event listener if it is running
		self:disableForce()

		-- Remove all (added) methods
		self.remove_hasForce = nil
		self.getForce = nil
		self.setForce = nil
		self.enableForce = nil
		self.disableForce = nil
		self.forceEnabled = nil
		self.toggleForce = nil
		self.dumpForce = nil

		-- Clear the data
		self.__hasForce = nil
	end



	-- ==
	--    func() - what it does
	-- ==
	obj.getForce = function( self )
		return self.__hasForce.value, self.__hasForce.params
	end

	-- ==
	--    func() - what it does
	-- ==
	obj.setForce = function( self, forceValue )
		self.__hasForce.value = forceValue
	end

	-- ==
	--    func() - what it does
	-- ==
	obj.enableForce = function( self )
		-- Don't re-enable if already enabled
		if(self.__hasForceEnabled) then
			return
		end
		Runtime:addEventListener( "enterFrame", enterFrameListener )
		self.__hasForceEnabled = true
	end

	-- ==
	--    func() - what it does
	-- ==
	obj.disableForce = function( self )
		-- Don't re-disable if already enabled
		if(not self.__hasForceEnabled) then
			return
		end
		Runtime:removeEventListener( "enterFrame", enterFrameListener )
		self.__hasForceEnabled = false
	end

	-- ==
	--    func() - what it does
	-- ==
	obj.forceEnabled = function( self )
		if(not self.__hasForceEnabled) then
			return false
		end
		return true
	end

	-- ==
	--    func() - what it does
	-- ==
	obj.toggleForce = function( self )
		if(not self.__hasForceEnabled) then
			self:enableForce()
		else
			self:disableForce()
		end
	end

	-- ==
	--    func() - what it does
	-- ==
	obj.dumpForce = function( self )
		if( not self.__hasForce ) then
			return
		end
		local force = self.__hasForce

		print("\n-----------------------" )
		print("hasForce - Dump Force:" )
		print("-----------------------" )
		local force = self.__hasForce
		table.print_r( force )
		print("-----------------------" )
		if(not self.__hasForceEnabled) then
			print("This object's force are DISABLED")
		else
			print("This object's force are ENABLED")
		end
		print("-----------------------" )
	end

end


