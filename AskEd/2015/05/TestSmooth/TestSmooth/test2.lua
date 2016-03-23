local getTimer = system.getTimer

local cloud = display.newImage( "cloud.png", 300, 100)
cloud.xScale = 0.4
cloud.yScale = 0.4

local w = cloud.width
local haftW = cloud.width * 0.5
local speed = 200 -- move from right to left
local lastTime = getTimer( )

local function frameUpdate( event )
	local currentTime = getTimer( )
	local dt = currentTime - lastTime
	lastTime = currentTime

	local dx = speed * dt / 1000

	cloud.x = cloud.x - dx

	if (cloud.x < -haftW ) then
		cloud.x = display.contentWidth + w 
	end
end

Runtime:addEventListener( "enterFrame", frameUpdate )