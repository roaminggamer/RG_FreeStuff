----------------------------------------------------------------------
--	Example Game Module
----------------------------------------------------------------------
local example = {}

local physics  = require "physics"
local composer = require "composer" 

----------------------------------------------------------------------
-- Locals
----------------------------------------------------------------------
local content
local pauseGroup
local onPause
local onResume
local onMainMenu
local ball
local block
local myTimer
--
local w = display.contentWidth
local h = display.contentHeight
local fullw = display.actualContentWidth
local fullh = display.actualContentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local left = centerX - fullw/2
local right = centerX + fullw/2
local top = centerY - fullh/2
local bottom = centerY + fullh/2


----------------------------------------------------------------------
--	Methods
----------------------------------------------------------------------

-- ========================================
function example.create( sceneGroup )
	content = display.newGroup()
	sceneGroup:insert( content )

	physics.start()
	physics.setGravity(0,10)

	example.createInterface()
	example.createPauseableContent()
end

-- ========================================
function example.destroy( )

	ball = nil
	block = nil	
	-- Cancel repeating timer
	if( myTimer ) then
		timer.cancel( myTimer )
	end
	myTimer = nil

	display.remove( content )
	content = nil
	pauseGroup = nil
end

-- ========================================
function example.pause( )
	physics.pause()
	
	if( block ) then
		transition.pause( block )
	end

	if( myTimer ) then
		timer.pause( myTimer )
	end

	-- Create pause group and touch blocker
	pauseGroup = display.newGroup()
	content:insert(pauseGroup)
	pauseGroup.x = centerX
	pauseGroup.y = centerY
	local touchBlocker = display.newRect( pauseGroup, 0, 0, 10000, 1000 )
	touchBlocker:setFillColor(1,0,0)
	touchBlocker.alpha = 0.1
	touchBlocker.touch = function() return true end
	touchBlocker:addEventListener("touch")
	-- Create some buttons

	-- Create a pause button
	PushButton( pauseGroup, 0, -100 , "Resume", onResume, 
	            { labelColor = {0.8,0.8,0.2}, labelSize = 24, 
	            width = 160, height = 60 } )

	PushButton( pauseGroup, 0, 0 , "Main Menu", onMainMenu, 
	            { labelColor = {0.8,0.8,0.2}, labelSize = 24, 
	            width = 160, height = 60 } )


end

-- ========================================
function example.resume( )	
	physics.start()

	if( block ) then
		transition.resume( block )
	end

	if( myTimer ) then
		timer.resume( myTimer )
	end

	display.remove(pauseGroup)
	pauseGroup = nil
end

-- ========================================
-- Create an interface for the play scene
-- ========================================
function example.createInterface()
	-- Create a simple background
	local back = display.newImageRect( content, "images/protoBack.png", 380*2, 570*2 )
	back.x = centerX
	back.y = centerY
	if(w>h) then back.rotation = 90 end

	-- Create a label showing which scene this is
	local label = display.newText( content, "Play", centerX, 40, native.systemFont, 60 )
	label:setFillColor( 0.2, 0.8, 0.2  )

	-- Create a pause button
	PushButton( content, left + 85, top + 35 , "Pause", onPause, 
	            { labelColor = {0.8,0.8,0.2}, labelSize = 24, 
	            width = 160, height = 60 } )
end

-- ========================================
-- Create content we can 'pause' as an example
-- ========================================
function example.createPauseableContent( )

	-- 
	-- Physics Stuff
	-- 
	local ground = display.newRect( content, centerX, centerY + 160, fullw, 80 )
	ground:setFillColor( 0, 1, 0, 0.5 )
	physics.addBody( ground, "static", { bounce = 0.1} )

   ball = display.newCircle( content, centerX, centerY, 20 )
	ball:setFillColor( 1, 1, 0, 0.5 )
	physics.addBody( ball, "dynamic", { bounce = 0.1, radius = 20 } )

	myTimer = timer.performWithDelay( 3000,
		function() 
			ball:applyLinearImpulse( 0, -10 * ball.mass, ball.x, ball.y )
		end, -1 )

   block = display.newRect( content, left + 20, centerY- 200, 40, 40 )
	block:setFillColor( 0, 1, 1, 0.5 )
	function block.onComplete( self )
		self.x = left + 20
		transition.to( self, { x = right - 20, time = 2000, onComplete = self } )
	end
	transition.to( block, { x = right - 20, time = 2000, onComplete = block } )
	
end



--
-- Buttons Listeners
--
onMainMenu = function( self, event )
	local options =
	{
		effect = "fromTop", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 500,
		params =
		{
			arg1 = "value", 
			arg2 = 0
		}
	}
	composer.gotoScene( "ifc.mainMenu", options  )	
	return true

end


onPause = function( self, event )
   example.pause()
	return true
end

onResume = function( self, event )
   example.resume()
	return true
end

return example