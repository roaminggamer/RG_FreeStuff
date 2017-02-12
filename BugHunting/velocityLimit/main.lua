-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
--  main.lua
-- =============================================================
-- Start (code/comments)
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)


local physics = require "physics"
physics.start()
physics.setGravity(0,0)

--  Not a bug!  We can control it here
physics.setScale( 900 )


local group = display.newGroup()

local cx = display.contentCenterX
local cy = display.contentCenterY

local obj = display.newCircle( group, cx, cy, 10)

physics.addBody( obj )

obj:setLinearVelocity(30000,0)

local function enterFrame()
	obj:applyForce( 100, 0, obj.x, obj.y )
	local vx, vy = obj:getLinearVelocity()
	print(vx)
	--group.x = -obj.x + display.actualContentWidth/2
end; Runtime:addEventListener("enterFrame",enterFrame)

