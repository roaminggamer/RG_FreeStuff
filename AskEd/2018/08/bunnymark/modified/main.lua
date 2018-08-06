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
local bunnyCount = 0
local ANIM_TIME	= 1000
local INITIAL_Y 	= top + 50
local FINAL_Y 		= bottom - 50
-- =============================================================
local group 		= display.newGroup()
local bunnyGroup 	= display.newGroup()
local textGroup 	= display.newGroup()

group:insert(bunnyGroup)
group:insert(textGroup)

local infoText = display.newText( textGroup, "", centerX, bottom - 15, native.systemFont, 20  )
function infoText.enterFrame( self )
	infoText.text = "Bunnies: " .. bunnyCount .. " Click to add more"
end; Runtime:addEventListener( "enterFrame", infoText )

local function animateBunny(bunnyImage)
	transition.moveTo(bunnyImage, {
		y = FINAL_Y,
		transition = easing.inQuad,
		time = ANIM_TIME,
		onComplete = function()
			transition.moveTo(bunnyImage, {
				y = INITIAL_Y,
				transition = easing.outQuad,
				time = ANIM_TIME,
				onComplete = function()
					animateBunny(bunnyImage)
				end,
			})
		end,
	})
end

local function spawnBunnies(num)
	for i = 1, num do
		local px = math.random(left, right)
		local py = INITIAL_Y
		local assetIndex = math.random(#assets.bunnies)
		local bunnyImage = display.newImage(bunnyGroup, assets.bunnies[assetIndex], px, py)
		timer.performWithDelay(math.random(0, 1000), function() animateBunny(bunnyImage) end)
	end
	bunnyCount = bunnyCount + num
end

local function onTouch(event)
	if event.phase == "ended" then
		spawnBunnies(500)
	end
end; Runtime:addEventListener("touch", onTouch)