-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
--  main.lua (78/100)
-- =============================================================
-- Kernel: Robotron Movement
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
-- LOAD & INITIALIZE - SSK 2
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init()
_G.ssk.init( { launchArgs 				= ..., 
	            enableAutoListeners 	= true,
	            exportCore 				= true,
	            exportColors 			= true,
	            exportSystem 			= true,
	            exportSystem 			= true,
	            gameFont 				= "Prime.ttf",
	            debugLevel 				= 0 } )
-- =============================================================
-- KERNEL CODE BEGINS BELOW
-- =============================================================

-- =============================================================
-- Localizations
-- =============================================================
-- Common SSK Display Object Builders
local newRect 			= ssk.display.newRect
local newImageRect 	= ssk.display.newImageRect
local face 				= ssk.actions.face
local thrustForward	= ssk.actions.movep.thrustForward
local limitV			= ssk.actions.movep.limitV

-- Common SSK Helper Functions
local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
local normRot = math.normRot;local easyAlert = ssk.misc.easyAlert

-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale


-- =============================================================
-- Locals
-- =============================================================
local group 		= display.newGroup()
local player
local playerSize 	= 80
local half_sqrt2 	= math.sqrt(2)/2

-- ==
--    Start and Configure  physics
-- ==	
local physics = require "physics"
physics.start()
physics.setGravity(0,0)
--physics.setDrawMode("hybrid")


-- ==
--    Create primary object: Player
-- ==
player = newImageRect( group, centerX, centerY,  "images/kenney4.png",
	                    { size = playerSize }, { } )

player.isFixedRotation 	= true
player.speed 				= 500

-- ==
--    Add event listeners to primary object.
-- ==

-- onMovePlayer() - A custom listener to handle events from our
-- custom input (see below.)
function player.onMovePlayer( self, event )
	local vx = event.x * self.speed
	local vy = event.y * self.speed
	self:setLinearVelocity( vx, vy )

end; listen( "onMovePlayer", player )


-- enterFrame() - Check every frame to be sure player is still on screen.
function player.enterFrame( self, event )
	local minX = left + self.contentWidth/2
	local maxX = right - self.contentWidth/2
	local minY = top + self.contentWidth/2
	local maxY = bottom -  self.contentHeight/2
	
	if( self.x < minX ) then
		self.x = minX
	elseif( self.x > maxX ) then
		self.x = maxX
	end

	if( self.y < minY ) then
		self.y = minY
	elseif( self.y > maxY ) then
		self.y = maxY
	end

end; listen( "enterFrame", player )

-- ==
--    4. Create input object - A custom input than turns touches
--       input events specifying the player move:
--       up, up-and-right, right, down-and-right, 
--	      down, down-and-left, left, or up-and-left.
-- ==

-- Create a virtual touch pad 
--
local pad = newImageRect( group, left + 90, bottom - 90,  "images/omni_pad.png",
	                    	  { size = 150, stroke = _W_, strokeWidth = 2 } )

-- Add a custom listener to our touch pad that determines which of the eight
-- directions our touch represents.
--
-- Note: Why 'half_sqrt2' you ask?  Well, when we move at angles we want to
--       move at a total rate of player.speed.  To achieve that easily, we
--       simply set the <x,y> multipliers to a multiple of  0.7071 (half_sqrt2)
--       whenever the movement isn't up, right, down, or left.
--
-- TL;DR: It is a math trick.
--        
function pad.touch( self, event)

	-- Assume we are not moving to start
	local moving = false
	
	if( event.phase == "began" ) then

		-- We are moving
		moving = true

		-- Send all future events associated with this
		-- touch to this object's event listener.
		display.currentStage:setFocus( self, event.id )
		self.isFocus = true

	elseif( self.isFocus ) then

		if( event.phase == "ended" ) then

			-- Stop moving
			moving = false

			-- Stop sending touches to this object's listener.  
			-- The touch is over.
			display.currentStage:setFocus( self, nil )
			self.isFocus = false
		
		else
			-- Still moving
			moving = true
		end			
	end

	-- Now, we know if we're moving or not.
	--

	-- If we are, calculate the direction to move
	-- and post an appropriate move event.
	if( moving ) then
		local vec = diffVec( self, event )
		local angle = normRot(vector2Angle(vec))
		
		-- Based on the calculated angle dispatch a 
		-- move event with the proper < x, y > values

		-- Up
		if( angle < 0.5 * 45 ) then
			post( "onMovePlayer", { x = 0, y = -1 } )

		-- Up & Right
		elseif( angle < 1.5 * 45 ) then
			post( "onMovePlayer", { x = half_sqrt2, y = -half_sqrt2 } )

		-- Right
		elseif( angle < 2.5 * 45 ) then
			post( "onMovePlayer", { x = 1, y = 0 } )

		-- Down & Right
		elseif( angle < 3.5 * 45 ) then
			post( "onMovePlayer", { x = half_sqrt2, y = half_sqrt2 } )

		-- Down
		elseif( angle < 4.5 * 45 ) then
			post( "onMovePlayer", { x = 0, y = 1 } )

		-- Down & Left
		elseif( angle < 5.5 * 45 ) then
			post( "onMovePlayer", { x = -half_sqrt2, y = half_sqrt2 } )

		-- Left
		elseif( angle < 6.5 * 45 ) then
			post( "onMovePlayer", { x = -1, y = 0 } )

		-- Up & Left
		elseif( angle < 7.5 * 45 ) then
			post( "onMovePlayer", { x = -half_sqrt2, y = -half_sqrt2 } )

		-- Up
		else
			post( "onMovePlayer", { x = 0, y = -1 } )
		end

	-- If we are not moving, post a move event with 
	-- movements set to <0, 0>

	else
		post( "onMovePlayer", { x = 0, y = 0 } )
	end
	
	return false
end
pad:addEventListener("touch")
