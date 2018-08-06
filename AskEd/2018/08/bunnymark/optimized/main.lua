display.setStatusBar(display.HiddenStatusBar)
math.randomseed(os.time())
-- =============================================================
local assets = require("assets")
local meters = require "meters"
meters.create_fps(true)
meters.create_mem(true)
-- =============================================================
local centerX     = display.contentCenterX
local centerY     = display.contentCenterY
local fullw  = display.actualContentWidth
local fullh  = display.actualContentHeight
local left   = centerX - fullw/2
local right  = centerX + fullw/2
local top    = centerY - fullh/2
local bottom = centerY + fullh/2
-- =============================================================
local gravity 		= 1
local bunnyCount	= 0
local bunnies 		= {}
local ANIM_TIME	= 1000
local minY 			= top + 50
local maxY 			= bottom - 50
-- =============================================================
local getTimer 	= system.getTimer
local mRand 		= math.random
-- =============================================================
local group 		= display.newGroup()
local bunnyGroup 	= display.newGroup()
local textGroup 	= display.newGroup()

group:insert(bunnyGroup)
group:insert(textGroup)

local infoText = display.newText( textGroup, "", centerX, bottom - 15, native.systemFont, 20  )


--[[
local function animateBunny(bunnyImage)
	transition.moveTo(bunnyImage, {
		y = maxY,
		transition = easing.inQuad,
		time = ANIM_TIME,
		onComplete = function()
			transition.moveTo(bunnyImage, {
				y = minY,
				transition = easing.outQuad,
				time = ANIM_TIME,
				onComplete = function()
					animateBunny(bunnyImage)
				end,
			})
		end,
	})
end
--]]

local function spawnBunnies(num)
	for i = 1, num do
		local px = mRand(left, right)
		local py = minY
		local assetIndex = mRand(#assets.bunnies)
		local bunnyImage = display.newImage(bunnyGroup, assets.bunnies[assetIndex], px, py)
		bunnyImage.speedY = 0
		timer.performWithDelay( mRand(0, 1000), function() bunnies[#bunnies+1] = bunnyImage end )
	end
	bunnyCount = bunnyCount + num
end

-- Unified 'enterFrame' mover and hud update
-- Uses y-elements of movement algorith from here: https://github.com/pixijs/bunny-mark/blob/master/src/Bunny.js
-- Slightly modified to reduce probabilit the bunny will stop moving.
local function enterFrame()
	infoText.text = "Bunnies: " .. bunnyCount .. " Click to add more"
	--
	local bunny
	local bunnyY
	local bSpeedY
	for i = 1, #bunnies do
		bunny 	= bunnies[i]
		bunnyY 	= bunny.y
		bSpeedY 	= bunny.speedY
		--
      bunnyY 	= bunnyY + bSpeedY
      bSpeedY 	= bSpeedY + gravity
      --
      if( bunnyY > maxY ) then
			bSpeedY 	= -0.95 * bSpeedY
         bunnyY 	= maxY
         --
         bSpeedY 	= (mRand() <= 0.5) and bSpeedY or ( bSpeedY - mRand() * 10 )
      elseif( bunnyY < minY ) then
			bSpeedY 	= 0
			bunnyY 	= minY
		end
		--
		bunny.y 			= bunnyY
		bunny.speedY 	= bSpeedY
	end
end; Runtime:addEventListener("enterFrame", enterFrame)

local function onTouch(event)
	if event.phase == "ended" then
		spawnBunnies(500)
	end
end; Runtime:addEventListener("touch", onTouch)

