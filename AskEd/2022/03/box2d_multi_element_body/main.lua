io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
local cx     = display.contentCenterX
local cy     = display.contentCenterY
local fullw  = display.actualContentWidth
local fullh  = display.actualContentHeight
local left   = cx - fullw/2
local right  = cx + fullw/2
local top    = cy - fullh/2
local bottom = cy + fullh/2

local physics = require "physics"
physics.start()
physics.setGravity(0,10)
--physics.setDrawMode("hybrid")

local back = display.newImageRect( "protoBackX.png", 720, 1386 )
back.x = cx
back.y = cy
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end

-- Setup collision filter/masks in advance using collision calculator from SSK2
-- SSK2: https://roaminggamer.github.io/RGDocs/pages/SSK2/libraries/cc/
-- Solar2D has a similar feature, but I can't remember its name right now
-- so I'm using my own code for this one part of the example.
require "cc"
local myCC = ssk.ccmgr.newCalculator()
myCC:addName( "player" ) -- You can have up to 16 named filters/masks.
myCC:addName( "ground" )
myCC:addName( "wheel" )
myCC:addName( "crate" )  
myCC:collidesWith( "player", { "crate", "ground" } )
myCC:collidesWith( "crate", { "ground", "crate" } )
myCC:collidesWith( "wheel", { "ground", "crate" } )

local ground = display.newImageRect( "fillW.png", 700, 50 )
ground.x = cx
ground.y = cy + 250
ground:setFillColor(0,0.4,0)
physics.addBody( ground, "static", { friction = 1, filter = myCC:getCollisionFilter( "ground" ) } )

local blocker = display.newImageRect( "fillW.png", 50, 50 )
blocker.x = cx - 325
blocker.y = cy + 200
blocker:setFillColor(0,0.4,0)
physics.addBody( blocker, "static", { friction = 1, filter = myCC:getCollisionFilter( "ground" ) } )


local crate = display.newImageRect( "boxCrate.png", 40, 40 )
crate.x = cx + 150
crate.y = cy
physics.addBody( crate, "dynamic", { friction = 0.5, filter = myCC:getCollisionFilter( "crate" )   } )

local crate = display.newImageRect( "boxCrate.png", 20, 20 )
crate.x = cx - 100
crate.y = cy
physics.addBody( crate, "dynamic", { friction = 0.5, filter = myCC:getCollisionFilter( "crate" )   } )

local crate = display.newImageRect( "boxCrate.png", 20, 20 )
crate.x = cx + 100
crate.y = cy
physics.addBody( crate, "dynamic", { friction = 0.5, filter = myCC:getCollisionFilter( "crate" )   } )


local player = display.newImageRect( "girl.png", 80, 90 )
player.x = cx
player.y = cy
local girlBodyShape = { 0,-37, 37,-10, 23,34, -23,34, -37,-10 }
physics.addBody( player, "dynamic", { friction = 1, shape = girlBodyShape, filter = myCC:getCollisionFilter( "player" )   } )
player.isFixedRotation = true


-- local wheel = display.newImageRect( "fillT.png", 40, 40 ) -- use this for an invisible while
local wheel = display.newImageRect( "rg256.png", 40, 40 )
wheel.x = cx
wheel.y = cy + 32
physics.addBody( wheel, "dynamic", { radius = 20, friction = 7, filter = myCC:getCollisionFilter( "wheel" )  } )
player:toFront()

local pivotJoint = physics.newJoint( "pivot", wheel, player, wheel.x, wheel.y )
pivotJoint.maxMotorTorque = 100000
pivotJoint.isMotorEnabled = true

-- Use keyboard left/right arrows to turn wheel
local wheelSpeed = 600

-- require SSK2 string.* and table.* extensions to get table.dump() function
require "extensions.string"
require "extensions.table" 

-- https://docs.coronalabs.com/api/event/key/descriptor.html
local function onKeyEvent( event )
	-- table.dump(event)
	if( event.phase == "up") then
		if( event.keyName == "left" ) then
			pivotJoint.motorSpeed = pivotJoint.motorSpeed - wheelSpeed
		end
		if( event.keyName == "right" ) then
			pivotJoint.motorSpeed = pivotJoint.motorSpeed + wheelSpeed
		end
	else
		if( event.keyName == "left" ) then
			pivotJoint.motorSpeed = pivotJoint.motorSpeed + wheelSpeed
		end
		if( event.keyName == "right" ) then
			pivotJoint.motorSpeed = pivotJoint.motorSpeed - wheelSpeed
		end
	end
    return false
end
Runtime:addEventListener( "key", onKeyEvent )
