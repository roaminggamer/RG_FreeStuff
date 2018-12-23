io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
--require "ssk2.loadSSK"
--_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================
local cx     = display.contentCenterX
local cy     = display.contentCenterY
local fullw  = display.actualContentWidth
local fullh  = display.actualContentHeight
local left   = cx - fullw/2
local right  = cx + fullw/2
local top    = cy - fullh/2
local bottom = cy + fullh/2
-- == Uncomment following lines if you need  physics
local physics = require "physics"
physics.start()
physics.setGravity(0,30)
--physics.setDrawMode("hybrid")
-- =====================================================
-- Example begins
-- =====================================================

local speed = 250

--
-- Define and Create Sprite (Player)
--

local playerInfo 	= require "player"
local playerSheet 	= graphics.newImageSheet("player.png", playerInfo:getSheet() )
local playerSeqData = 
	{
		{name = "walk", frames = {2,3,4,5,6,7,8,9,10,11,12}, time = 300, loopCount = 0, loopDirection = "forward"}, 
		{name = "jump", frames = {1}, time = 100, loopCount = 0, loopDirection = "forward"}, 
	}

-- Create sprite, play 'idle'
local player = display.newSprite( playerSheet, playerSeqData )
player.x = cx
player.y = cy
player:setSequence( "walk" )
player:play()
-- Add status value to player
player.isJumping = false


-- 
-- Make 'Ground'
--
local ground = display.newRect( cx,cy + 80, fullw, 40)
ground:setFillColor(0,1,0,0.2)

--
-- Add bodies to player and ground, plus set up player physics value(s)
--
physics.addBody( ground, "static", { bounce = 0 } )

physics.addBody( player, "dynamic", { bounce = 0 } )
player.isFixedRotation = true

-- 
-- Add a player collision listener
--
function player.collision( self, event )
	if( event.phase == "began" and self.isJumping ) then		
		self.isJumping = false
		self:setSequence("walk")
		self:play()
		print("Landed @ ", system.getTimer())
		print("------------------------\n")
	end
end
player:addEventListener("collision")

-- 
-- Add a basic player mover using 'enterFrame' event
--
function player.enterFrame( self )
	-- Make sure we are not too far right or left and if so, switch facing
	if( self.x >= right - 80 ) then 
		self.x = right - 80
		self.xScale = -1
	elseif( self.x <= left + 80 ) then 
		self.x = left + 80
		self.xScale = 1
	end

	-- get current velocity
	local vx,vy = self:getLinearVelocity()

	-- based on facing set x velocity and keep y velocity
	if( self.xScale > 0 ) then
		self:setLinearVelocity( speed, vy )
	else
		self:setLinearVelocity( -speed, vy )
	end
end
Runtime:addEventListener( "enterFrame",player)


--
-- Add touch listener to 'jump'
--
function player.touch( self,event)
	if( event.phase == "began" and not self.isJumping ) then
		self:applyLinearImpulse( 0, -15 * self.mass )
	   self.isJumping = true
		self:setSequence("jump")
		self:play()
		print("Jumped @ ", system.getTimer())
	end
end
Runtime:addEventListener( "touch", player )


