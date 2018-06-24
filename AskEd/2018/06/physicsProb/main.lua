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
physics.setGravity(0,0)
physics.setDrawMode("hybrid")


local group = display.newGroup()

local leftWall = display.newRect(group,0,0,5, display.contentHeight )
local rightWall = display.newRect (group,display.contentWidth, 0, 5, display.contentHeight)
local topWall = display.newRect (group,0, 0, display.contentWidth, 5)
local bottomWall = display.newRect (group,0, display.contentHeight, display.contentWidth, 5)
topWall.anchorX = 0
leftWall.anchorY = 0
leftWall.anchorX = 0
rightWall.anchorY = 0
bottomWall.anchorY = 0
bottomWall.anchorX = 0
local player = display.newRect( group,display.contentCenterX,740, 280, 401 )
physics.addBody (leftWall, "static", { bounce = 0.2} )
physics.addBody (rightWall, "static", { bounce = 0.2} )
physics.addBody (topWall, "static", { bounce = 0.2} )
physics.addBody (bottomWall, "static", { bounce = 0.2} )
physics.addBody( player ,"dynamic", {density=3.0, bounce=0.2})

local function reset()
	print('resetting')
	player.x = cx
	player.y = cy
end


--[[
local function tiltGravity( event )
	print(event.xGravity, event.yGravity, event.isShake )
	physics.setGravity( 40 * event.xGravity, 40 * event.yGravity )
	if event.isShake then
		reset()
	end
end; Runtime:addEventListener("accelerometer", tiltGravity)
--]]

local function fakeTilt( event )
	print(event.xGravity, event.yGravity, event.isShake )
	physics.setGravity( 40 * event.xGravity, 40 * event.yGravity )
	if event.isShake then
		reset()
	end
end

timer.performWithDelay( 250, 
	function()
		local event = {}
		event.xGravity = math.random(-100,100)/100
		event.yGravity = math.random(-100,100)/100
		
		event.isShake = false
		--event.isShake = math.random(1,100) > 90
				
		fakeTilt(event)
	end, -1 )
