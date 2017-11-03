io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

--
-- Run in simulated "Borderless 610 x 960 iPhone"
--
local fullw = display.actualContentWidth
local fullh = display.actualContentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

local function createPlayer( group, x, y, boyGirl, initialHP, debugEn )
	local combined = display.newGroup()
	group:insert(combined)
	combined.x = x
	combined.y = y	
	--
	local player = display.newImageRect( combined, 
		(boyGirl == 1) and "images/boy.png" or "images/girl.png",
		100, 100 )
	--
	local progressBarM = require "progressBar"
	player.bar = progressBarM.new( combined, 0, 0 - 100, { debugEn = debugEn } )
	--
	player.y = player.y - player.bar.contentHeight/2 --- player.contentHeight/2
	player.bar.y = player.y + player.contentHeight/2 + player.bar.contentHeight/2
	--
	if( debugEn ) then
		local h = player.contentHeight + player.bar.contentHeight
		local w = player.bar.contentWidth
		display.newLine( combined, -w/2, 0, w/2, 0 ).strokeWidth = 2
		display.newLine( combined, 0, -h/2, 0, h/2 ).strokeWidth = 2
	end
	--
	player.hp 		= initialHP
	player.maxHP 	= initialHP
	---
	function player.setTarget( self, target )
		self.target = target
	end
	--
	player.attacking = false
	--
	function player.touch( self, event )
		print("BOB")
		if( self.attacking or self.target.attacking ) then return false end

		
		if( event.phase == "ended") then
			local function onComplete1()
				local attackValue = math.random( 1, 10)
				--
				player.target.hp = player.target.hp - attackValue
				player.target.hp = player.target.hp > 0 and player.target.hp or 0
				player.target.bar:set( player.target.hp/player.target.maxHP )
				--
				local label = display.newText( group, tostring(-attackValue), 
													 	 player.target.parent.x + 150, 
														 player.target.parent.y)
				transition.to( label, { x = label.x + 100, alpha = 0, time = 750, onComplete = display.remove } )
			end
			local function onComplete2(self)
				self.attacking = false
			end
			--
			-- Tip: self.parent is player's parent group (combined)
			--			
			local scale = 1.5
			local dy = (self.parent.y - self.target.parent.y)/3
			local y0 = self.parent.y
			local y1 = self.parent.y - dy
			--
			self.parent:toFront()
			--
			transition.to( self.parent, { y = y1, xScale = scale, yScale = scale, 
				                           time = 500, onComplete = onComplete1 } )
			transition.to( self.parent, { y = y0, xScale = 1, yScale = 1, 
				                           delay = 1000, time = 500, onComplete = onComplete2 } )			
		end
		return false
	end
	--
	player:addEventListener("touch")

	return player
end

-- I chose this name to imply you're doing it in a scene
local sceneGroup = display.newGroup() 
--
local boy = createPlayer( sceneGroup, centerX, centerY - 150, 1, 100, false )
local girl = createPlayer( sceneGroup, centerX, centerY + 150, 2, 100, false )
--
boy:setTarget(girl)
girl:setTarget(boy)
