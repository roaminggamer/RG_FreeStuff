local assets = require("assets")

display.setStatusBar(display.HiddenStatusBar)

math.randomseed(os.time())

local ANIM_TIME = 1000
local INITIAL_Y = display.safeScreenOriginY + 50
local FINAL_Y = display.safeActualContentHeight + display.safeScreenOriginY - 50

local group = display.newGroup()
local bunnyGroup = display.newGroup()
local textGroup = display.newGroup()

local infoText = display.newText({
	text = "",
})
infoText.x = display.contentCenterX
infoText.y = display.safeActualContentHeight + display.safeScreenOriginY - 15

textGroup:insert(infoText)

group:insert(bunnyGroup)
group:insert(textGroup)

local bunnyCount = 0
local lastTimestampMs
local frameCounter = 0
local fps = 0

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
		local px = math.random(display.screenOriginX, display.actualContentWidth)
		local py = INITIAL_Y
		local assetIndex = math.random(#assets.bunnies)
		local bunnyImage = display.newImage(assets.bunnies[assetIndex], px, py)

		timer.performWithDelay(math.random(0, 1000), function() animateBunny(bunnyImage) end)

		bunnyGroup:insert(bunnyImage)
	end

	bunnyCount = bunnyCount + num
end

local function onTouch(event)
	local phase = event.phase

	if phase == "ended" then
		spawnBunnies(500)
	end
end

local function updateInfo(event)
    frameCounter = frameCounter + 1
    local currentTimestampMs = system.getTimer()

    if (not lastTimestampMs) then
        lastTimestampMs = currentTimestampMs
    end

    -- Calculate actual fps approximately four times every second
    if (frameCounter >= (display.fps / 4)) then
        local deltaMs = currentTimestampMs - lastTimestampMs
        fps = math.floor(frameCounter / (deltaMs / 1000))
        frameCounter = 0
        lastTimestampMs = currentTimestampMs
    end

	infoText.text = "Bunnies: " .. bunnyCount .. " Fps: " .. fps .. " Click to add more"
end

Runtime:addEventListener("touch", onTouch)
Runtime:addEventListener("enterFrame", updateInfo)
