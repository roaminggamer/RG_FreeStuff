-- -------------------------------------
-- main.lua
-- -------------------------------------
display.setStatusBar( display.HiddenStatusBar )

-- get our screen dimensions
local _W = display.contentWidth
local _H = display.contentHeight

-- -------------------------------------
-- add in the physics engine
-- -------------------------------------
local physics = require "physics"
physics.start()
--physics.setDrawMode( "hybrid" )

local math2d = require "math2d" -- https://github.com/roaminggamer/SSKCorona

-- -------------------------------------
-- start adding items to the world
-- -------------------------------------
local background = display.newImage( "background.jpg" )

local ground = display.newImage( "ground.png" )
ground:setReferencePoint( display.BottomLeftReferencePoint )
ground.x, ground.y = 0, 320 -- a compact way of assigning property values

local groundShape = { -240,-20, 240,-20, 240,20, -240,20 }
physics.addBody( ground, "static", { friction=3.0, density=1.0, bounce=0.0, shape=groundShape } )

local characterSize = 45 --EFM

local character = display.newImageRect( "character.png", characterSize, characterSize ) --EFM
character.x = _W/2
character.y = 230
physics.addBody( character, { friction=0.1, density=0.6, bounce=0.1, radius=characterSize/2 } ) --EFM
character.isFixedRotation = true

-- -------------------------------------
-- create some boundaries
-- -------------------------------------
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


-- -------------------------------------
-- HANDLE TOUCH EVENTS
-- -------------------------------------
local massRelativeForce = -1000 * character.mass --EFM
print("character.mass", character.mass) --EFM
print("massRelativeForce == ", massRelativeForce ) --EFM

local function charactertouch( event )
	if ( event.phase == "began" ) then		

		local vec = math2d.sub( character, event  )

		print(vec.x,vec.y)
			
		vec = math2d.normalize( vec )			

		print(vec.x,vec.y)
			
		vec = math2d.scale( vec, massRelativeForce ) -- M

		print(vec.x,vec.y, "=====\n")
			
		character:applyForce( vec.x, vec.y, character.x, character.y ) 


	end
	return true
end

-- -------------------------------------
-- CREATE EVENT LISTENERS
-- -------------------------------------
character:addEventListener( "touch", charactertouch )

