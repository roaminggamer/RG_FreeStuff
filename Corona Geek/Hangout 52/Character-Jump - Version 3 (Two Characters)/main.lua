-- -------------------------------------
-- main.lua
-- -------------------------------------
display.setStatusBar( display.HiddenStatusBar )

-- -------------------------------------
-- Locals that control some demo features
-- -------------------------------------
local _W = display.contentWidth
local _H = display.contentHeight

local characterSize = 45 -- Controls size of characters
local jumpForce = -1000  -- Controls magnitude of jump 

-- -------------------------------------
-- Requires
-- -------------------------------------
local physics = require "physics"
physics.start()
--physics.setDrawMode( "hybrid" )

local math2d = require "math2d" -- https://github.com/roaminggamer/SSKCorona



-- -------------------------------------
-- buildScene() - This function builds background, ground, and side objects.
-- -------------------------------------
local function buildScene()
	local background = display.newImage( "background.jpg" )

	local ground = display.newImage( "ground.png" )
	ground:setReferencePoint( display.BottomLeftReferencePoint )
	ground.x, ground.y = 0, 320 -- a compact way of assigning property values

	local groundShape = { -240,-20, 240,-20, 240,20, -240,20 }
	physics.addBody( ground, "static", { friction=3.0, density=1.0, bounce=0.0, shape=groundShape } )

	-- create a rectangular object that is the height of the screen to serve as a left wall
	-- the rectangles reference point is in the center, so find the center point for the height
	-- of the screen and then set y to that value
	local leftWall = display.newRect(0, 0, 1, _H)
	leftWall.x = 0
	leftWall.y = _H/2
	physics.addBody( leftWall, "static", {density = 1.0, friction = 0.3, bounce = 0.2} )

	local rightWall = display.newRect(0, 0, 1, _H)
	rightWall.x = _W
	rightWall.y = _H/2
	physics.addBody( rightWall, "static", {density = 1.0, friction = .6, bounce = 0.2} )

	-- create the same size rectangular object and place it at the top of the screen
	local topWall = display.newRect(0, 0, _W, 1)
	topWall.x = _W / 2
	topWall.y = 1
	physics.addBody( topWall, "static", {density = 1.0, friction = 0.6, bounce = 0.2} )
end


-- -------------------------------------
-- charactertouch() - 'Table' listener used by characters to respond to touches by jumping.
-- -------------------------------------
local function charactertouch( self,  event )
	if ( event.phase == "began" ) then		
			
		local vec = math2d.sub( self, event  )

		print(vec.x,vec.y)
			
		vec = math2d.normalize( vec )			

		print(vec.x,vec.y)
			
		vec = math2d.scale( vec, jumpForce * self.mass ) -- M

		print(vec.x,vec.y, "=====\n")
			
		self:applyForce( vec.x, vec.y, self.x, self.y ) 

	end
	return true
end

-- -------------------------------------
-- createCharacter() - Creates a character object and adds the 'touch' event listener to it.
-- -------------------------------------
local function createCharacter(x,y)
	local tmp = display.newImageRect( "character.png", characterSize, characterSize ) --EFM
	tmp.x = x
	tmp.y = y
	physics.addBody( tmp, { friction=0.1, density=0.6, bounce=0.1, radius=characterSize/2 } ) --EFM
	tmp.isFixedRotation = true
	print("tmp.mass", tmp.mass)
	tmp.touch = charactertouch
	tmp:addEventListener( "touch", tmp )
	return tmp
end


-- -------------------------------------
-- Create and Start demo
-- -------------------------------------
buildScene()
createCharacter( _W/2 - characterSize, 230 )
createCharacter( _W/2  + characterSize, 230 )