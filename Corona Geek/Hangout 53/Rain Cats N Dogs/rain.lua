-----------------------------------------------------------------------------------------
--
-- rain.lua
-- V. Sergeyev, pydevside@gmail.com
-- http://pythondvside.com
--
-----------------------------------------------------------------------------------------
local screenW, screenH = display.contentWidth, display.contentHeight

local rain = {}
local rain_mt = { __index = rain }

-- EnterFrame handler
function rain.rainHandler( e )
	for i = 1, rain.group.numChildren, 1 do
		if rain.group[i].name == "rainDrop" then
			local drop = rain.group[i]
			drop.rotation = drop.rotation + drop.myRot
			if drop.y < rain.rainFloor then
				drop.x = drop.x + rain.rainRight * rain.dropLength*math.cos(rain.rainAngle) * rain.rainSpeed
				drop.y = drop.y + rain.dropLength * rain.rainSpeed
			else
				drop.x = drop.x0
				drop.y = drop.y0
			end
		end
	end
end

-- Constructor
function rain.new(group, config)
    rain.group = group

    -- Config
	rain.rainAngle = math.rad(config.angle or 45)
	rain.rainRight = -1
	if config.toRight then
		rain.rainRight = 1
	end
	rain.rainSpeed = 0.1 -- config.speed or 0.5
	rain.rainFloor = screenH - (config.floor or 0)
	rain.dropLength = config.length or 100
	rain.dropWidth = config.width or 1
	rain.dropAlpha = 1 -- config.alpha or 0.1
	rain.dropColor = 255 -- config.color or 255
	local dropsCount = 15 -- config.count or 50

    -- Drops
	for i = 1, dropsCount, 1 do
		local dy =  math.random(screenH+100)
		local x, y = i*10 - rain.rainRight*(screenW*math.cos(rain.rainAngle)), -50-dy
		local drop = display.newImage( "cd" .. math.random(1,4) .. ".png" )
		drop:scale(1.5, 1.5)
		drop.myRot = math.random( -5, 5 )
		--display.newLine(x, y, x + rain.rainRight * rain.dropLength*math.cos(rain.rainAngle), y + rain.dropLength)
		drop.x0, drop.y0 = x, y
		drop.name = "rainDrop"
		group:insert(drop)
	end

	if not config.silent then
		local rainSound = config.sound or audio.loadStream("rain.wav")		
		local dcsound = config.sound or audio.loadStream("catndogs.wav")

		audio.setVolume( 0.15, {channel = 1 } )
		audio.setVolume( 0.55, {channel = 2 } )
		audio.play(rainSound, {loops=-1, channel = 1})
		audio.play(dcsound, {loops=-1, channel = 2})

	end

	Runtime:addEventListener( "enterFrame", rain.rainHandler )
end

return rain

----------------
-- End.
----------------