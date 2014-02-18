-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- SSK Tester
-- =============================================================
-- This is a quick test of the current library.
--
-- Warning: Not all features are tested here!
-- =============================================================


--[[
local ccmgr = require "ssk.RGCC"

local myCC = ccmgr:newCalculator()

myCC:addName("player")
myCC:addName("enemy")
myCC:addName("player bullet")

myCC:collidesWith( "enemy", "player", "player bullet" )

myCC:dump()

--]]

require "ssk.RGCC"

local w = display.contentWidth
local h = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local displayWidth        = (display.contentWidth - display.screenOriginX*2)
local displayHeight       = (display.contentHeight - display.screenOriginY*2)
local unusedWidth    = display.actualContentWidth - w
local unusedHeight   = display.actualContentHeight -h

print(w,h,centerX, centerY, displayWidth, displayHeight)


local group = display.newGroup() 

local physics = require("physics")
physics.start()
physics.setGravity(0,9.8)
--physics.setDrawMode( "hybrid" )

local createBlock
local createBall

-- Easily set up collision filters with an SSK Collision Calculator
local myCC = ssk.ccmgr:newCalculator()

myCC:addNames( "block", "redBall", "greenBall" )
myCC:collidesWith( "redBall", "block"  )

createBall = function( x, y, r, color, type)
	local tmp = display.newCircle( group, x, y, r )
	tmp:setFillColor( unpack( color ) )
	physics.addBody( tmp, "dynamic", { radius = r, friction = 0.2, bounce = 0.85, filter = myCC:getCollisionFilter( type ) } )
	timer.performWithDelay( 1000, function() createBall(x, y, r, color, type) end )
end


createBlock = function( x, y, size, angle)
	local tmp = display.newRect( group, 0, 0, size, size)
	tmp.x = x
	tmp.y = y
	tmp:setFillColor( 0.5, 0.5, 0.5 )
	tmp:setStrokeColor( 1, 1, 0 )
	tmp.strokeWidth = 2
	tmp.rotation = angle
	physics.addBody( tmp, "static", { radius = r, friction = 0.2, bounce = 0.5, filter = myCC:getCollisionFilter( block ) } )
end

createBlock( centerX - 100, h - 20, 40, 10)
createBlock( centerX + 100, h - 20, 40, 0)

createBall( centerX - 100, 30, 10, {1,0,0}, "redBall" )
createBall( centerX + 100, 30, 10, {0,1,0}, "greenBall" )


myCC:dump()


