-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local mRand = math.random
local getTimer = system.getTimer
local mAbs = math.abs
--
local mod = {}

function mod.new( settings )
	local behavior = {}
	behavior.ll = {} -- local listeners   obj:event() )   ==> ex: obj:addEventListener( "collision" )
	behavior.gl = {} -- global listeners  Runtime:event() ==> ex: Runtime:addEventListener( "enterFrame", obj )
	--
	--table.dump(settings)
	local hrate = settings.hrate or 1
	local vrate = settings.vrate or 0
	local hdir = 1
	local vdir = 1
	local xScaleMax
	local yScaleMax
	local xScale
	local yScale
	local lastT
	local minScale = 0.1
	--
	function behavior.onCreate( self ) 
		lastT = getTimer()
		xScaleMax = math.abs(self.xScale)
		yScaleMax = math.abs(self.yScale)
		xScale = self.xScale
		yScale = self.yScale
	end
	--	
	function behavior.gl.enterFrame( self ) 
		local curT = getTimer()
		local dt = curT - lastT
		lastT = curT
		--
		if( hrate ~= 0 ) then
			if(hdir > 0) then
				xScale = xScale + xScaleMax * hdir * hrate * dt/1000
				if( mAbs(xScale) < minScale ) then
					xScale = minScale
				end
				if( xScale > xScaleMax ) then
					xScale = xScaleMax
					hdir = -1
				end
			else
				xScale = xScale + xScaleMax * hdir * hrate * dt/1000
				if( mAbs(xScale) < minScale ) then
					xScale = -minScale
				end
				if( xScale < -xScaleMax ) then
					xScale = -xScaleMax
					hdir = 1
				end
			end
			self.xScale = xScale
		end
		if( vrate ~= 0 ) then
			if(vdir > 0) then
				yScale = yScale + yScaleMax * vdir * vrate * dt/1000
				if( mAbs(yScale) < minScale ) then
					yScale = minScale
				end
				if( yScale == 0 ) then
					yScale = 0.01
				end
				if( yScale > yScaleMax ) then
					yScale = yScaleMax
					vdir = -1
				end
			else
				yScale = yScale + yScaleMax * vdir * vrate * dt/1000
				if( mAbs(yScale) < minScale ) then
					yScale = -minScale
				end
				if( yScale == 0 ) then
					yScale = -0.01
				end
				if( yScale < -yScaleMax ) then
					yScale = -yScaleMax
					vdir = 1
				end
			end
			self.yScale = yScale
		end
	end
	--
	return behavior
end


return mod
