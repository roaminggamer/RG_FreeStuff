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
function components.movesForward( obj, velocity )

	if( obj.__movesForward ) then
		print("ERROR: This object already has the component movesForward() applied.")
		print("If you need multiple forces, use the hasForces() component instead.")
	end

	obj.__movesForward = {}
	obj.__movesForward.velocity = velocity

	local enterFrameListener

	enterFrameListener = function( event )

		if( not isDisplayObject( obj ) ) then
			Runtime:removeEventListener( "enterFrame", enterFrameListener )			
			return false
		end

		if( not obj.__movesForward ) then
			Runtime:removeEventListener( "enterFrame", enterFrameListener )
			return false
		end

		local nx,ny = angle2Vector( obj.rotation )
		local vx,vy = scaleVector( nx, ny, obj.__movesForward.velocity )

		if( debugLevel > 1 ) then 
			vx = round(fx,2)
			vy = round(fy,2)
			nx = round(nx,2)
			ny = round(ny,2)
		end
					
		dprint(2, vx,vy, nx, ny, scale, obj.rotation)

		obj:setLinearVelocity( vx, vy ) 

		return false
	end

	-- ==
	--    func() - what it does
	-- ==
	obj.remove_movesForward = function( self )

		-- Stop the event listener if it is running
		self:disableForwardVelocity()

		-- Remove all (added) methods
		self.remove_movesForward = nil
		self.getForwardVelocity = nil
		self.setForwardVelocity = nil
		self.enableForwardVelocity = nil
		self.disableForwardVelocity = nil
		self.movesForwardEnabled = nil
		self.toggleMovesFoward = nil
		self.dumpMovesForward = nil

		-- Clear the data
		self.__movesForward = nil
	end
	
	-- ==
	--    func() - what it does
	-- ==
	obj.getForwardVelocity = function( self )
		return self.__movesForward.velocity
	end

	-- ==
	--    func() - what it does
	-- ==
	obj.setForwardVelocity = function( self, velocity )
		self.__movesForward.velocity = velocity
	end

	-- ==
	--    func() - what it does
	-- ==
	obj.enableForwardVelocity = function( self )
		-- Don't re-enable if already enabled
		if(self.__movesForwardEnabled) then
			return
		end
		Runtime:addEventListener( "enterFrame", enterFrameListener )
		self.__movesForwardEnabled = true
	end

	-- ==
	--    func() - what it does
	-- ==
	obj.disableForwardVelocity = function( self )
		-- Don't re-disable if already enabled
		if(not self.__movesForwardEnabled) then
			return
		end
		Runtime:removeEventListener( "enterFrame", enterFrameListener )
		self.__movesForwardEnabled = false
	end

	-- ==
	--    func() - what it does
	-- ==
	obj.movesForwardEnabled = function( self )
		if(not self.__movesForwardEnabled) then
			return false
		end
		return true
	end

	-- ==
	--    func() - what it does
	-- ==
	obj.toggleMovesFoward = function( self )
		if(not self.__movesForwardEnabled) then
			self:enableForwardVelocity()
		else
			self:disableForwardVelocity()
		end
	end

	-- ==
	--    func() - what it does
	-- ==
	obj.dumpMovesForward = function( self )
		if( not self.__movesForward ) then
			return
		end
		local force = self.__movesForward

		print("\n-----------------------" )
		print("movesForward - Dump Force:" )
		print("-----------------------" )
		local force = self.__movesForward
		table.print_r( force )
		print("-----------------------" )
		if(not self.__movesForwardEnabled) then
			print("This object's force are DISABLED")
		else
			print("This object's force are ENABLED")
		end
		print("-----------------------" )
	end

end


