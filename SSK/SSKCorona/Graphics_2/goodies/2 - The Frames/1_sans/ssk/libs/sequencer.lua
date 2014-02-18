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

local sequencer

if( not _G.ssk.sequencer ) then
	_G.ssk.sequencer = {}
end

sequencer = _G.ssk.sequencer

local fnn = fnn
local angle2Vector = ssk.math2d.angle2Vector
local vector2Angle = ssk.math2d.vector2Angle
local scaleVector  = ssk.math2d.scale

local isDisplayObject = isDisplayObject

-- ==
--    func() - what it does
-- ==
function sequencer:new( )

	local seq = {}

	-- ==
	--    load() - what it does
	-- ==
	seq.load = function( self, fileName, base )
		seq.data = table.load( fileName, base )
	end

	-- ==
	--    clear() - what it does
	-- ==
	seq.clear = function( self )
		seq.data = {}
	end

	-- ==
	--    get() - what it does
	-- ==
	seq.get = function( self )
		return seq.data
	end

	-- ==
	--    set() - what it does
	-- ==
	seq.set = function( self, seqTable )
		seq.data = table.shallowCopy(seqTable)
	end

	-- ==
	--    add() - what it does
	-- ==
	seq.add = function( self, entry )
		if( not entry ) then
			return false
		end
		
		if( not seq.data ) then
			seq.data = {}
		end
		
		seq.data[#seq.data+1] = table.shallowCopy( entry )
		
		return true		
	end

	-- ==
	--    stop() - what it does
	-- ==
	seq.stop = function( self )
		print("Stop it")
		if(self.nextAction) then
			print("Stopping")
			timer.cancel(self.nextAction)
			self.nextAction = nil
		end
	end

	-- ==
	--    func() - what it does
	-- ==
	seq.run = function( self, obj, index )
		local index = index or 1


		if( not isDisplayObject( obj ) ) then
			print("WARNING: sequencer()  - Inavlid display object.  Cannot run!")
			return false
		end

		if( not self.data ) then 
			print("ERROR: sequencer()  - No sequence data loaded.  Cannot run!")
			return false
		end

		local nextTime = 0

		local entry = self.data[index]

		local easing = entry.easing or easing.linear
		local shortest = fnn(entry.shortest, true ) -- Use shortest path method for transitions (default)

		dprint(2, index, entry.action, entry.angle, time, shortest, system.getTimer() )

		 -- == 
		 --    ROTATE TO (ANGLE and VECTOR)
		 -- == 
		if(entry.action == "ROTT" or entry.action == "ROTTV") then
			local time = 0			
			local angle = 0
			
			if(entry.action == "ROTTV" and entry.vector) then
				angle = vector2Angle( entry.vector )
			elseif(entry.action == "ROTT" and entry.angle) then
				angle = entry.angle
			end

			--print(angle)

			if( entry.time ) then 
				time = entry.time
			elseif( entry.speed ) then 
				time = (angle / entry.speed) * 1000 -- Assumes speed in degrees-per-second
			end

			-- Don't allow angles to go beyond 360
			if(obj.rotation > 360) then
				obj.rotation = obj.rotation - 360
			elseif(obj.rotation < 0 ) then
				obj.rotation = obj.rotation + 360
			end

			local tweenAngle = angle - obj.rotation

			if(shortest) then
				if(tweenAngle >= 180) then
					angle = angle - 360
					tweenAngle  = angle - obj.rotation
				elseif(tweenAngle <= -180) then
					angle = angle + 360
					tweenAngle  = angle - obj.rotation
				end	
			end

			nextTime = time

			transition.to( obj, { rotation = angle, time = time, easing = easing  } )
					 
		 -- == 
		 --    MOVE TO
		 -- == 
		elseif(entry.action == "MOVT") then
			local time = 0			
			local vector = entry.vector or { x=0, y=0 }
			
			if( entry.time ) then 
				time = entry.time
			elseif( entry.speed ) then 
				local dx,dy = ssk.math2d.sub( obj.x, obj.y, vector.x, vector.y )
				local distance = ssk.math2d.length(dx,dy)
				time = (distance / entry.speed) * 1000 -- Assumes speed in pixels-per-second
			end

			nextTime = time

			transition.to( obj, { x = vector.x, y = vector.y, time = time, easing = easing  } )
		

		 -- == 
		 --    TRANSLATE (TRNT)
		 -- == 
		elseif(entry.action == "TRNT") then
			local time = 0			
			local vector = entry.vector or { x=0, y=0 }

			local tx,ty = ssk.math2d.add( obj, vector, true )
			
			if( entry.time ) then 
				time = entry.time
			elseif( entry.speed ) then 
				local distance = ssk.math2d.length(vector)
				time = (distance / entry.speed) * 1000 -- Assumes speed in pixels-per-second
			end

			nextTime = time

			transition.to( obj, { x = tx, y = ty, time = time, easing = easing  } )


		 -- == 
		 --    LINEAR VELOCITY (LVEL)
		 -- == 
		elseif(entry.action == "LVEL") then
			local vector = entry.vector or { x=0, y=0 }
			nextTime = entry.time or 0
			obj:setLinearVelocity( vector.x, vector.y )

		 -- == 
		 --    ANGULAR VELOCITY (AVEL)
		 -- == 
		elseif(entry.action == "AVEL") then
			local angle = entry.angle or 0
			nextTime = entry.time or 0
			obj.angularVelocity = angle


		 -- == 
		 --    LINEAR IMPULSE (LIMP)
		 -- == 
		elseif(entry.action == "LIMP") then
			local vector = entry.vector or { x=0, y=0 }
			nextTime = entry.time or 0
			obj:applyLinearImpulse( vector.x, vector.y, obj.x, obj.y )

		 -- == 
		 --    ANGULAR IMPULSE (AIMP)
		 -- == 
		elseif(entry.action == "AIMP") then
			
			local angle = entry.angle or 0
			nextTime = entry.time or 0
			obj:applyAngularImpulse( angle )

		 -- == 
		 --    STOP (STOP)
		 -- == 
		elseif(entry.action == "STOP") then
			nextTime = entry.time or 0
			obj:setLinearVelocity( 0, 0 )
			obj.angularVelocity = 0


		 -- == 
		 --    METHOD (METHOD)
		 -- == 
		elseif(entry.action == "METHOD") then
			local name = entry.name 
			if(name and obj[name] and type(obj[name]) == "function") then
				obj[name]( obj )
			end
			nextTime = entry.time or 0

		 -- == 
		 --    FUNCTION (FUNCTION)
		 -- == 
		elseif(entry.action == "FUNCTION") then
			local name = entry.name 
			if(name and obj[name] and type(obj[name]) == "function") then
				obj[name]( )
			end
			nextTime = entry.time or 0

		 -- == 
		 --    GLOBAL FUNCTION (GFUNCTION)
		 -- == 
		elseif(entry.action == "GFUNCTION") then
			local name = entry.name 
			if(name and _G[name] and type(_G[name]) == "function") then
				_G[name]( obj )
			end
			nextTime = entry.time or 0

		 -- == 
		 --    EVENT (EVENT)
		 -- == 
		elseif(entry.action == "EVENT") then
			local name = entry.name 
			if(event) then 
				ssk.gem:post( name, { obj = obj } )
			end
			nextTime = entry.time or 0

		 -- == 
		 --    REPEAT
		 -- == 
		elseif(entry.action == "REPEAT") then
			nextTime = entry.time or 0
			count = entry.count or 1
			if( self.repeatCount == nil ) then
				self.repeatCount = 1
				if(count >= self.repeatCount) then
					index = 0
				end
			elseif( self.repeatCount < count ) then
				self.repeatCount = self.repeatCount + 1
				index = 0
			else

				self.repeatCount = nil
			end
		
		 -- == 
		 --    WAIT
		 -- == 
		elseif(entry.action == "WAIT") then
			nextTime = entry.time or 1000
		end		
		
		 -- == 
		 --    WAIT (DO NOTHING)
		 -- == 
		if(index < #self.data) then
			self.nextAction = timer.performWithDelay( nextTime, function() self:run( obj, index+1 )  end )
		end

		return true
	end


	return seq

end
