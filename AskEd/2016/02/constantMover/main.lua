-- =============================================================
-- Ask Ed 2016
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2016 (http://roaminggamer.com/)
-- =============================================================
-- https://forums.coronalabs.com/topic/61864-touch-and-hold-event/#entry320667
-- =============================================================

local function createLayers( group )
	parent = parent or display.currentStage
	params = params or {}
	print("Creating render layers.")

	local layers 		= display.newGroup()
	layers.underlay 	= display.newGroup()
	layers.world 		= display.newGroup()
	layers.content1 	= display.newGroup()
	layers.content2 	= display.newGroup()
	layers.content3 	= display.newGroup()
	layers.overlay 		= display.newGroup()


	layers:insert( layers.underlay )
	layers:insert( layers.world )
	layers:insert( layers.overlay )

	layers.world:insert( layers.content1 )
	layers.world:insert( layers.content2 )
	layers.world:insert( layers.content3 )

	--[[ Final Layer Order (bottom-to-top)
	\
	|---\underlay
	|
	|---\world 
	|   |
	|	|---\content1 
	|	|
	|	|---\content2
	|	|
	|	|---\content3
	|
	|---\overlay
	]]

	return layers
end

-- Initialize trackObj starting position
local function initCamera( trackObj )	
	-- Start tracking the players last X and Y positions.
	--
	trackObj.lx = trackObj.x 	-- 'Last' x-position.  
	trackObj.ly = trackObj.y 	-- 'Last' y-position.  
end

-- The simplest of 'cameras', this code merely moves the world the exact opposite distance
-- the trackObj did, every frame.  This keeps the trackObj in its initial position and makes it
-- look like the world is moving around the trackObj.
--
local function cameraListener( trackObj, world )	
	-- Calculate how far we moved last frame
	local dx = trackObj.x - trackObj.lx
	local dy = trackObj.y - trackObj.ly

	-- Save our new 'last' position
	--
	trackObj.lx = trackObj.x
	trackObj.ly = trackObj.y

	-- Move the world to keep the trackObj in it's initial (visual) position relative
	--
	world.x = world.x - dx
	world.y = world.y - dy
end

--
-- Shorthand helper variables
--
local w      = display.actualContentWidth
local h      = display.actualContentHeight
local cx     = display.contentCenterX
local cy     = display.contentCenterY
local left   = cx - w/2
local right  = cx + w/2
local top    = cy - h/2
local bottom = cy + h/2


-- =============================================================
--  Start of example (using above helper functions and variables)
-- =============================================================

-- Make a player
local layers = createLayers()
local player = display.newImageRect( layers.content2, "smiley.png", 60, 60 )
player.x = cx
player.y = cy
player.vx = 0
player.vy = 0

-- Add A Camera
initCamera( player )
local function enterFrame()
	cameraListener( player, layers.world )
end
Runtime:addEventListener( "enterFrame", enterFrame )

-- Add various objects to world
for i = 1, 3000 do
	local tmp = display.newImageRect( layers.content1, "smiley.png", 30, 30 )
	tmp.x = math.random( cx-1500, cx+1500 )
	tmp.y = math.random( cy-1500, cy+1500 )
	tmp:setFillColor(math.random(),math.random(),math.random())
	tmp.alpha = 0.5
end

-- Use enterFrame listener to move player
function player.enterFrame( self )
	self.x = self.x + self.vx
	self.y = self.y + self.vy
	--print(self.x, self.y, self.vx, self.vy)
end
Runtime:addEventListener( "enterFrame", player )

-- Add a touch listener to change player vx,vy
function player.touch( self, event )
	local phase  = event.phase	
	if( phase == "began" ) then
		if( event.x < cx - 100 ) then
			player.vx = -10
		elseif( event.x > cx + 100 ) then
			player.vx = 10
		end

		if( event.y < cy - 100 ) then
			player.vy = -10
		elseif( event.y > cx + 100 ) then
			player.vy = 10
		end
	elseif( phase == "ended") then
		player.vx = 0
		player.vy = 0
	end
end
Runtime:addEventListener( "touch", player )
