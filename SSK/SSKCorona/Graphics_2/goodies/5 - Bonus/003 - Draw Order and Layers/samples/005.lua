-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- Load SSK Globals & Libraries
--
require "ssk.globals"
require "ssk.loadSSK"


local group = display.newGroup()

group.title = "SSK Quick Layers"

-- Local Variables
local h				= display.contentHeight
local w				= display.contentWidth
local centerX		= display.contentCenterX
local centerY		= display.contentCenterY

-- 1. Create 5 layers (bottom-to-top)
local layer = ssk.display.quickLayers( group, '1', '2', '3', '4', '5' )

local function createSkeleton()
	local skel = display.newImageRect( layer[math.random(2,4)],  "images/skel.png", 80, 80 )

	skel.x = -100
	skel.y = math.random( 40, h - 40 )
	transition.to( skel, { x = w + 100, time = math.random( 8000, 9000 ) } )
end

local function createFoliage( num )
	for i = 1, num do
		local foliage = display.newImageRect( layer[math.random(2,4)], "images/foliage" .. math.random(1,4) .. ".png", 100, 100 )
		foliage.x = math.random( 20, w - 20 )
		foliage.y = math.random( 20, h - 20 )
	end		
end


-- 1. Setting random seed so example always looks the same each time
local seed = math.random(1,1000)
seed = 668
--print(seed)
math.randomseed( seed ) 

-- 2. Create a background Image
local backImage = display.newImage( layer[1], "images/mudback.png" )
backImage.x = centerX
backImage.y = centerY

-- 3. Create Some Trees and Shrubs
createFoliage(20)

-- 4. Create (fake) HUD/Interface
local interface = display.newImage( layer[5], "images/hud.png" )
interface.x = centerX
interface.y = centerY

-- 5. Create overlay to hide unused screen space
local overlay = display.newImage( layer[5], "images/overlay.png" )
overlay.x = centerX
overlay.y = centerY

-- 6. Start making skeleons
timer.performWithDelay( 600, createSkeleton, -1 ) -- Throw balls forever

return group
