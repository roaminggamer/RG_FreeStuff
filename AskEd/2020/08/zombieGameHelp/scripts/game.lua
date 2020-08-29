-- Game Module
local game = {}

-- Requires
local common 	= require "scripts.common"
local player 	= require "scripts.player"
local zombie 	= require "scripts.zombie"
local terrain 	= require "scripts.terrain"

-- Locals
local layers
local lastTimer 
local arrowSize = 120

-- Forward Declarations
local onTouchArrow
local onTouchFireButton


-- Methods (Function accessible from outside module)
game.create = function( group )
	group 				= group or display.currentStage
	--
	game.destroy()
	--
	layers = display.newGroup()
	layers.underlay = display.newGroup()
	layers.content = display.newGroup()
	layers.overlay = display.newGroup()
	layers:insert(layers.underlay)
	layers:insert(layers.content)
	layers:insert(layers.content)
	group:insert( layers )

	-- Create random terrain
	terrain.create( layers.underlay )

	-- Create the player
	common.thePlayer = player.create( layers.content )


	-- Create input arrow, and fire listeners
	local leftArrow = display.newImageRect( layers.overlay, "images/kenney/arrowLeft.png", arrowSize, arrowSize )
	leftArrow.x = left + 0.5 * arrowSize
	leftArrow.y = bottom - arrowSize
	leftArrow.touch = onTouchArrow
	leftArrow.dir = "left"
	leftArrow:addEventListener("touch")

	local rightArrow = display.newImageRect( layers.overlay, "images/kenney/arrowRight.png", arrowSize, arrowSize )
	rightArrow.x = leftArrow.x + 1.25 * arrowSize
	rightArrow.y = leftArrow.y
	rightArrow.touch = onTouchArrow
	rightArrow.dir = "right"
	rightArrow:addEventListener("touch")

	local upArrow = display.newImageRect( layers.overlay, "images/kenney/arrowUp.png", arrowSize, arrowSize )
	upArrow.x = leftArrow.x + 0.625 * arrowSize
	upArrow.y = rightArrow.y - 0.625 * arrowSize
	upArrow.touch = onTouchArrow
	upArrow.dir = "up"
	upArrow:addEventListener("touch")

	local downArrow = display.newImageRect( layers.overlay, "images/kenney/arrowDown.png", arrowSize, arrowSize )
	downArrow.x = upArrow.x
	downArrow.y = rightArrow.y + 0.625 * arrowSize
	downArrow.touch = onTouchArrow
	downArrow.dir = "down"
	downArrow:addEventListener("touch")

	-- Create fire button from RoamingGamer Icon
	local fireButton = display.newImageRect( layers.overlay, "images/rg.png", 128, 128 )
	fireButton.x = right - 128
	fireButton.y = bottom - 128
	fireButton.touch = onTouchFireButton
	fireButton:addEventListener("touch")

	-- Create four zombies (obviously this is pretty basic)
	zombie.create( layers.content, left + 40, centerY )
	zombie.create( layers.content, right - 40, centerY, 180 )
	zombie.create( layers.content, centerX, top + 40, 90 )
	zombie.create( layers.content, centerX, bottom - 40, 270 )
end

function game.destroy(  )
	if( lastTimer ) then
		timer.cancel( lastTimer )
		lastTimer = nil
	end

	if( layers ) then
		display.remove( layers )
		layers = nil
	end

	common.thePlayer = nil

	common.zombies = {}
end


-- (Private) function (only visible inside this module)
-- Shared touch listener for arrow keys
onTouchArrow = function( self, event )
	if( event.phase == "began" ) then
		post( "onMove", { dir = self.dir } )
		print( "onTouchArrow", self.dir )
	end
	return true
end

-- Shared touch listener for arrow keys
onTouchFireButton = function( self, event )
	if( event.phase == "began"  ) then
		print( "onTouchFireButton", event.phase)
		post( "onFire" )
	end
	return true
end



return game