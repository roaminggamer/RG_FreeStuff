-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The user wanted to create a system where he could detect whether he'd picked", 
	"up a key or not.  I elaborated on this to make a HUD system counting keys", 
	"the player had picked up.",
	"1. Tap any place on the screen to move the player",
	"2. Collide with keys to pick them up and update the HUD."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end

--
-- 1. Set up physics
local physics = require "physics"
physics.start()
physics.setGravity( 0, 0 )


-- 2. Create a hud with three keys
-- 
local keysCollected = 0
local maxKeys 		= 3
local onKeys 		= {}
local offKeys 		= {}

local function updateHUD()
	for i = 1, maxKeys do
		onKeys[i].isVisible  = (keysCollected >= i)
		offKeys[i].isVisible = (i > keysCollected)
	end
end

for i = 1, maxKeys do
	onKeys[i] = display.newImageRect( "hud_keyYellow.png", 44, 40 )
	onKeys[i].x = 50 + 50 * i 
	onKeys[i].y = 200

	offKeys[i] = display.newImageRect( "hud_keyYellow_disabled.png", 44, 40 )
	offKeys[i].x = 50 + 50 * i 
	offKeys[i].y = 200
end

updateHUD()

-- 3. Create a simple player
-- 
local player = display.newImageRect( "yellow_round.png", 40, 40 )
player.x = display.contentCenterX - 200
player.y = display.contentCenterY
physics.addBody( player )

-- 4. A Runtime touch listener to do the moving
-- 
local function onMoveTouch( event )
	if( event.phase == "began" ) then
		transition.to( player, { x = event.x, y = event.y, time = 1500 } )
	end
	return true
end

Runtime:addEventListener( "touch", onMoveTouch )

-- 5. Create random keys and add 'collision events' to them to do 'pickup'
--
for i = 1, maxKeys do
	local key = display.newImageRect( "keyYellow.png", 30, 30 )
	key.x = display.contentCenterX + math.random( 0, 200 )
	key.y = display.contentCenterY + 100 + math.random( 0, 200 )
	physics.addBody( key )
	key.isSensor = true

	key.collision = function( self, event ) 
		if( event.phase == "began"  and event.other == player ) then
			timer.performWithDelay(1,
				function()
					display.remove( self )
					keysCollected = keysCollected + 1
					updateHUD()
				end )
		end
		return true
	end
	key:addEventListener("collision")
end