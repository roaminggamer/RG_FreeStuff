-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2016
-- =============================================================
-- Basic Meters Module 
-- =============================================================
-- =============================================================

local w      = display.actualContentWidth
local h      = display.actualContentHeight
local cx     = display.contentCenterX
local cy     = display.contentCenterY
local left   = cx - w/2
local right  = cx + w/2
local top    = cy - h/2
local bottom = cy + h/2
-- ==
--    round(val, n) - Rounds a number to the nearest decimal places. (http://lua-users.org/wiki/FormattingNumbers)
--    val - The value to round.
--    n - Number of decimal places to round to.
-- ==
function _G.round(val, n)
  if (n) then
    return math.floor( (val * 10^n) + 0.5) / (10^n)
  else
    return math.floor(val+0.5)
  end
end
-- Extracted from SSK sampler and modified for this example.
-- https://github.com/roaminggamer/SSKCorona/sampler
--
local public = {}
local getTimer = system.getTimer
function public.create_fps()
	local fpsMeter = display.newGroup()
	fpsMeter.back = display.newRect( fpsMeter, left + 2, top + 2, 100, 25 )
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
		self:toFront()
		self.back.x = left + 2
		self.back.y = top + 2
		self.label.x = self.back.x + self.back.contentWidth/2
		self.label.y = self.back.y + self.back.contentHeight/2

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
		fpsMeter.label.text = round(sum/#avgWindow) .. " FPS"			
	end; 
	timer.performWithDelay(1000, function() Runtime:addEventListener("enterFrame", fpsMeter) end )
end


function public.create_mem()
	local hud = display.newGroup()
	local hudFrame = display.newRect( hud, 0, 0, 240, 80)
	hudFrame:setFillColor(0.2,0.2,0.2)
	hudFrame:setStrokeColor(1,1,0)
	hudFrame.strokeWidth = 1
	hudFrame.x = right - hudFrame.contentWidth/2 - 5
	hudFrame.y = top + hudFrame.contentHeight/2 + 5

	local mMemLabel = display.newText( hud, "Main Mem:", hudFrame.x - hudFrame.contentWidth/2 + 10, hudFrame.y - 15, native.systemFont, 16 )
	mMemLabel:setFillColor(1,0.4,0)
	mMemLabel.anchorX = 0

	local tMemLabel = display.newText( hud, "Texture Mem:", hudFrame.x - hudFrame.contentWidth/2 + 10, hudFrame.y + 15, native.systemFont, 16 )
	tMemLabel:setFillColor(0.2,1,0)
	tMemLabel.anchorX = 0

	hud.enterFrame = function( self )
		self:toFront()
		hudFrame.x = right - hudFrame.contentWidth/2 - 5
		hudFrame.y = top + hudFrame.contentHeight/2 + 5
		mMemLabel.x = hudFrame.x - hudFrame.contentWidth/2 + 10
		mMemLabel.y = hudFrame.y - 15
		tMemLabel.x = hudFrame.x - hudFrame.contentWidth/2 + 10
		tMemLabel.y = hudFrame.y + 15

		-- Fill in current main memory usage
		collectgarbage("collect") -- Collect garbage every frame to get 'true' current memory usage
		local mmem = collectgarbage( "count" ) 
		mMemLabel.text = "Main Mem: " .. round(mmem/(1024),2) .. " MB"

		-- Fill in current texture memory usage
		local tmem = system.getInfo( "textureMemoryUsed" )
		tMemLabel.text = "Texture Mem: " .. round(tmem/(1024 * 1024),2) .. " MB"
	end; Runtime:addEventListener( "enterFrame", hud )

end
return public

