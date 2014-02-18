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
function components.hasForces( obj )

	local function enterFrameListener( event )


		if( not isDisplayObject( obj ) ) then
			Runtime:removeEventListener( "enterFrame", enterFrameListener )			
			return false
		end

		if( not obj.__forces ) then
			Runtime:removeEventListener( "enterFrame", enterFrameListener )
			return false
		end

		local forces = obj.__forces

		local p     -- For holding current force params (if any)
		local fx,fy -- current force x,y

		for k,v in pairs( forces ) do

			fx = fnn(v.value[1], v.value.x, 0 )
			fy = fnn(v.value[2], v.value.y, 0 )
			p = v.params
			
			if( p ) then

				-- Is this force forward? (Only in direction it is facing)
				if( p.forward ) then
					local nx,ny = angle2Vector( obj.rotation )
					fx,fy = scaleVector( nx, ny, fx )

					if( debugLevel > 1 ) then 
						fx = round(fx,2)
						fy = round(fy,2)
						nx = round(nx,2)
						ny = round(ny,2)
					end
					
					dprint(2, fx,fy, nx, ny, obj.rotation)
				end
				
				-- Is this force gravitic? (Only applied to 
				if ( p.gravitic ) then
					dprint(2,"gravitic")
					fx = fx * obj.mass
					fy = fy * obj.mass
				end

			end
			
			obj:applyForce( fx, fy, obj.x, obj.y)  -- This force is cumulative

		end

		return false
	end


	-- ==
	--    func() - what it does
	-- ==
	obj.addForce = function( self, forceName, forceValue, params )
		if( not self.__forces ) then
			self.__forces = {}
		end

		local forces = self.__forces

		local forceName = forceName or #forces+1

		if( forces[forceName] ) then
			print( "ERROR: addForces( " .. forceName .. " ) - Already exists!" )
			return
		end

		forces[forceName] = { value=forceValue, params = params }
	end

	-- ==
	--    func() - what it does
	-- ==
	obj.removeForce = function( self, forceName )
		if( not self.__forces ) then
			return
		end
		local forces = self.__forces
		forces[forceName] = nil
	end

	-- ==
	--    func() - what it does
	-- ==
	obj.removeAllForces = function( self )
		if( not self.__forces ) then
			return
		end
		local forces = self.__forces
		for k,v in pairs( forces ) do
			self:removeForce(k)
		end
	end

	-- ==
	--    func() - what it does
	-- ==
	obj.getForce = function( self, forceName )
		if( not self.__forces ) then
			return nil
		end
		local forces = self.__forces
		return forces[forceName]
	end

	-- ==
	--    func() - what it does
	-- ==
	obj.setForce = function( self, forceName, forceValue )
		if( not self.__forces ) then
			print( "ERROR: setForces( " .. forceName .. " ) - Does not exist!" )
			return
		end
		local forces = self.__forces
		forces[forceName].value = forceValue
	end

	-- ==
	--    func() - what it does
	-- ==
	obj.enableForces = function( self )
		-- Don't re-enable if already enabled
		if(self.__forcesEnabled) then
			return
		end
		Runtime:addEventListener( "enterFrame", enterFrameListener )
		self.__forcesEnabled = true
	end

	-- ==
	--    func() - what it does
	-- ==
	obj.disableForces = function( self )
		-- Don't re-disable if already enabled
		if(not self.__forcesEnabled) then
			return
		end
		Runtime:removeEventListener( "enterFrame", enterFrameListener )
		self.__forcesEnabled = false
	end

	-- ==
	--    func() - what it does
	-- ==
	obj.forceEnabled = function( self )
		if(not self.__forcesEnabled) then
			return false
		end
		return true
	end

	-- ==
	--    func() - what it does
	-- ==
	obj.toggleForces = function( self )
		if(not self.__forcesEnabled) then
			self:enableForces()
		else
			self:disableForces()
		end
	end

	-- ==
	--    func() - what it does
	-- ==
	obj.dumpForces = function( self )
		if( not self.__forces ) then
			return
		end
		local forces = self.__forces

		print("\n-----------------------" )
		print("hasForces - Dump Forces:" )
		print("-----------------------" )
		local forces = self.__forces
		table.print_r( forces )
		print("-----------------------" )
		if(not self.__forcesEnabled) then
			print("This object's forces are DISABLED")
		else
			print("This object's forces are ENABLED")
		end
		print("-----------------------" )
	end

end


