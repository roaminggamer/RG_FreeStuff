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
	--    func() - what it does
	-- ==
	seq.load = function( self, fileName, base )
		seq.data = table.load( fileName, base )
	end

	-- ==
	--    func() - what it does
	-- ==
	seq.set = function( self, seqTable )
		seq.data = seqTable
	end

	-- ==
	--    func() - what it does
	-- ==
	seq.run = function( self, obj, index )
		local index = index or 1


		if( not isDisplayObject( obj ) ) then
			print("ERROR: sequencer()  - Inavlid display object.  Cannot run!")
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
		 --    ROTATE TO (ANGLE)
		 -- == 
		if(entry.action == "ROTT" or entry.action == "ROTTV") then
			local time = 0			
			local angle = 0
			
			if(entry.action == "ROTTV" and entry.vector) then
				angle = vector2Angle( entry.vector )
			elseif(entry.action == "ROTT" and entry.angle) then
				angle = entry.angle
			end

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

			nextTime = entry.time

			transition.to( obj, { rotation = angle, time = time, easing = easing  } )
					 
		elseif(entry.action == "WAIT") then
			nextTime = entry.time or 1000
		end		
		
		 -- == 
		 --    WAIT (DO NOTHING)
		 -- == 
		if(index < #self.data) then
			timer.performWithDelay( nextTime, function() self:run( obj, index+1 )  end )
		end

		return true
	end


	return seq

end
