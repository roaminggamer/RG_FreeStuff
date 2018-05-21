-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
require "ssk2.loadSSK"
_G.ssk.init()

local tapCount = 0

local background = display.newImageRect( "background.png", 360*2, 570*2 )
background.x = display.contentCenterX
background.y = display.contentCenterY

local tapText = display.newText( tapCount, display.contentCenterX, 20, native.systemFont, 40 )
tapText:setFillColor( 0, 0, 0 )

local platform = display.newImageRect( "platform.png", 300*2, 50*2 )
platform.x = display.contentCenterX
platform.y = display.contentHeight-25*2

local balloon = display.newImageRect( "balloon.png", 112*2, 112*2 )
balloon.x = display.contentCenterX
balloon.y = display.contentCenterY
balloon.alpha = 0.8

local physics = require( "physics" )
physics.start()

physics.addBody( platform, "static" )
physics.addBody( balloon, "dynamic", { radius=50*2, bounce=0.3 } )

local forceMag = 0.2
function balloon.tap( self, event )
	local vec = ssk.math2d.sub( self, event )
   vec = ssk.math2d.scale( vec, forceMag * self.mass )
   self:applyLinearImpulse( vec.x, vec.y, self.x, self.y )
	tapCount = tapCount + 1
	tapText.text = tapCount
end

balloon:addEventListener( "tap" )
