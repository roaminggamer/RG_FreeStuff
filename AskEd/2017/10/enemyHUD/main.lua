-- =============================================================
-- main.lua
-- =============================================================
-- 
-- =============================================================
io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

local enemyHUD 	= require "enemyHUD" 

local mRand 	= math.random
local cw 		= display.contentWidth
local ch 		= display.contentHeight

-- 1. Create some render layers to keep things nicely sorted
local contentLayer 	= display.newGroup()
local hudLayer 		= display.newGroup()

-- 2. Create a HUD
enemyHUD.create( hudLayer, nil, nil, 45, display.contentHeight * 1.5 )

-- 3. Randomly Create Enemies (forever)
local createEnemy
createEnemy = function()
	local tmp = display.newCircle( contentLayer, 100, 100, 5 )	
	tmp:setFillColor( 1, 0 , 0 )

	local delta = 1 -- 0.5 --2.5

	local startX = display.contentCenterX - cw * delta
	local startY = display.contentCenterY + mRand( -ch * delta, ch * delta)
	local endX = display.contentCenterX + cw * delta
	local endY = display.contentCenterY + mRand( -ch * delta, ch * delta)

	tmp.x = startX
	tmp.y = startY

	local function onComplete(self)
		enemyHUD.ignoreObject( self )
		display.remove(self)
	end

	transition.to( tmp, { x = endX, y = endY, time = 10000, onComplete = onComplete })

	-- Add the enemy to the HUD for watching
	enemyHUD.watchObject( tmp, { 1, 0, 0, 0.5  } )

	timer.performWithDelay( 1500, createEnemy )
end

createEnemy()
