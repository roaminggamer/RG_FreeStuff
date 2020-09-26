-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================

local public = {}
local getTimer = system.getTimer
function public.create_fps( allowDrag, scale )
	scale = scale or 1
	local fpsMeter = display.newGroup()
	fpsMeter.back = display.newRect( fpsMeter, left + 2 * scale, top + 2 * scale, 100 * scale, 25 * scale )
	fpsMeter.back.anchorX = 0
	fpsMeter.back.anchorY = 0
	fpsMeter.lastTime = getTimer()
	local cx = fpsMeter.back.x + fpsMeter.back.contentWidth/2
	local cy = fpsMeter.back.y + fpsMeter.back.contentHeight/2
	fpsMeter.label = display.newText(fpsMeter, "initializing...", cx, cy, native.systemFont, 12 * scale )
	fpsMeter.label:setFillColor( 0,0,0 )
	fpsMeter.avgWindow = {}
	fpsMeter.maxWindowSize = display.fps * 2 or 60

	fpsMeter.enterFrame = function(self)
		self:toFront()
		--self.back.x = left + 2
		--self.back.y = top + 2
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

	if( allowDrag ) then
		fpsMeter.back.touch = function(self, event) 
			if( event.phase == "began" ) then
				self.isFocus = true
				display.currentStage:setFocus( self, event.id )
				self.x0 = self.x
				self.y0 = self.y
			elseif( self.isFocus ) then
				local dx = event.x - event.xStart
				local dy = event.y - event.yStart
				self.x = self.x0 + dx
				self.y = self.y0 + dy
				if( event.phase == "ended" ) then
					self.isFocus = false
					display.currentStage:setFocus( self, nil )
				end
			end
			return true
		end; fpsMeter.back:addEventListener( "touch" )
	end
end


function public.create_mem( allowDrag, scale )
	scale = scale or 1
	local hud = display.newGroup()
	local hudFrame = display.newRect( hud, 0, 0, 240*scale, 80*scale)
	hudFrame:setFillColor(0.2,0.2,0.2)
	hudFrame:setStrokeColor(1,1,0)
	hudFrame.strokeWidth = 1
	hudFrame.x = right - hudFrame.contentWidth/2 - 5*scale
	hudFrame.y = top + hudFrame.contentHeight/2 + 5*scale

	local mMemLabel = display.newText( hud, "Main Mem:", hudFrame.x - hudFrame.contentWidth/2 + 15 * scale, hudFrame.y - hudFrame.contentHeight/2 + 15 * scale, native.systemFont, 16*scale )
	mMemLabel:setFillColor(1,0.4,0)
	mMemLabel.anchorX = 0
	mMemLabel.anchorY = 0

	local tMemLabel = display.newText( hud, "Texture Mem:", hudFrame.x - hudFrame.contentWidth/2 + 15 * scale , hudFrame.y + hudFrame.contentHeight/2 - 15 * scale, native.systemFont, 16*scale )
	tMemLabel:setFillColor(0.2,1,0)
	tMemLabel.anchorX = 0
	tMemLabel.anchorY = 1

	hud.enterFrame = function( self )
		self:toFront()
		mMemLabel.x = hudFrame.x - hudFrame.contentWidth/2 + 10 * scale
		mMemLabel.y = hudFrame.y - hudFrame.contentHeight/2 + 15 * scale
		tMemLabel.x = hudFrame.x - hudFrame.contentWidth/2 + 10 * scale
		tMemLabel.y = hudFrame.y + hudFrame.contentHeight/2 - 15 * scale

		-- Fill in current main memory usage
		collectgarbage("collect") -- Collect garbage every frame to get 'true' current memory usage
		local mmem = collectgarbage( "count" ) 
		mMemLabel.text = "Main Mem: " .. round(mmem/(1024),2) .. " MB"

		-- Fill in current texture memory usage
		local tmem = system.getInfo( "textureMemoryUsed" )
		tMemLabel.text = "Texture Mem: " .. round(tmem/(1024 * 1024),2) .. " MB"
	end; Runtime:addEventListener( "enterFrame", hud )

	if( allowDrag ) then
		hudFrame.touch = function(self, event) 
			if( event.phase == "began" ) then
				self.isFocus = true
				display.currentStage:setFocus( self, event.id )
				self.x0 = self.x
				self.y0 = self.y
			elseif( self.isFocus ) then
				local dx = event.x - event.xStart
				local dy = event.y - event.yStart
				self.x = self.x0 + dx
				self.y = self.y0 + dy
				if( event.phase == "ended" ) then
					self.isFocus = false
					display.currentStage:setFocus( self, nil )
				end
			end
			return true
		end; hudFrame:addEventListener( "touch" )
	end

end

_G.ssk.meters = public

return public

