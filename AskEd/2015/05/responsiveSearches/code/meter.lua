-- Extracted from SSK sampler and modified for this example.
-- https://github.com/roaminggamer/SSKCorona/sampler
--
local com = require "common"
local meter = {}
local getTimer = system.getTimer
function meter.create_fps()
	local fpsMeter = display.newGroup()
	fpsMeter.back = display.newRect( fpsMeter, com.left + 2, com.top + 2, 100, 25 )
	fpsMeter.back.anchorX = 0
	fpsMeter.back.anchorY = 0
	fpsMeter.lastTime = getTimer()
	local cx = fpsMeter.back.x + fpsMeter.back.contentWidth/2
	local cy = fpsMeter.back.y + fpsMeter.back.contentHeight/2
	fpsMeter.label = display.newText(fpsMeter, "initializing...", cx, cy, native.systemFont, 12 )
	fpsMeter.label:setFillColor( 0,0,0 )
	fpsMeter.avgWindow = {}
	fpsMeter.maxWindowSize = display.fps * 2 or 60

	fpsMeter.enterFrame = function(self)
		local avgWindow = fpsMeter.avgWindow	
		local curTime = getTimer()
		local dt = curTime - self.lastTime
		self.lastTime = curTime
		if( dt == 0 ) then return end
		avgWindow[#avgWindow+1] = 1000/dt
		while( #avgWindow > self.maxWindowSize ) do table.remove(avgWindow,1) end
		if( #avgWindow ~= self.maxWindowSize ) then return end
		local sum = 0
		for i = 1, #avgWindow do
			sum = avgWindow[i] + sum
		end
		fpsMeter.label.text = com.round(sum/#avgWindow) .. " FPS"
	end; 
	timer.performWithDelay(1000, function() Runtime:addEventListener("enterFrame", fpsMeter) end )
end
return meter

