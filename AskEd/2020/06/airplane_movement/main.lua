io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
-- =====================================================
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
--ssk.easyIFC.generateButtonPresets( nil, true )
-- =====================================================
--if( ssk.misc.countLocals ) then ssk.misc.countLocals(1) end
-- =====================================================

local mRand = math.random

local physics = require "physics"
physics.start()
physics.setGravity(0,0)
-- physics.setDrawMode("hybrid")

-- Create a set of display groups to contain the different display objects in the 'game'
local layers = ssk.display.quickLayers( group,  "underlay",  "world",  "gems", "content", "interfaces" )

-- Create a background image
local back = ssk.display.newImageRect( layers.underlay, centerX, centerY, "images/protoBackX.png", 
									{ w = 720,  h = 1386, rotation = fullw>fullh and 90 })

-- My 'airplane' prototype, will move 'forward' continously and wrap to the opposite side of the screen when it gets there.
local player = ssk.display.newImageRect( layers.player, centerX, centerY, "images/arrow.png", { w = 40, h = 40, faceAngle = 0 }, { radius = 18 } )

local wrapProxy = ssk.display.newImageRect( layers.content, centerX, centerY, "images/fillT.png", { w = fullw + 80, h = fullh + 80 } )

function player.enterFrame( self )
	ssk.actions.face( self, { angle = self.faceAngle, rate = 180 } )
    ssk.actions.move.forward( self, { rate = 150 } )
    ssk.actions.scene.rectWrap( self, wrapProxy )
end; listen( 'enterFrame', player )

-- Add touch listener to background that let's us 're-aim' player.
function back.touch( self, event )
	--if( event.phase ~= 'began' ) then return false end
	local vec = ssk.math2d.diff( player, event )
	player.faceAngle = ssk.math2d.vector2Angle( vec )
	return false
end; back:addEventListener( 'touch' )

-- Add score label
local scoreLabel = display.newText( layers.interfaces, "0", right - 150, top + 50, "Roboto-Light.ttf", 50 )
local score = 0


-- Add a spawner to create some 'gems'
local allGems = {}
local function spawnGem()
	local gems = { 'blue.png', 'green.png', 'orange.png', 'pink.png', 'red.png', 'white.png', 'yellow.png' }	
	while( table.count(allGems) <  15 ) do
		local function collision( self, event )		
			if( event.phase == "began" ) then
				if( not event.other.isGem ) then
					score = score + 1
					scoreLabel.text = score
				end
				allGems[self] = nil
				display.remove(self)			
			end
			return false
		end

		local gem = ssk.display.newImageRect( layers.gems, mRand(left + 40, right - 40), mRand( top + 40, bottom - 40), "images/" .. gems[mRand(1,7)], 
			                                  { size = 40, collision = collision, isGem = true }, 
			                                  { isSensor = true } )
		allGems[gem] = gem
	end
end
timer.performWithDelay( 30, spawnGem, -1 )







