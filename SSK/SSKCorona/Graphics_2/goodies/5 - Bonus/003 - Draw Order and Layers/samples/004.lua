-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================

local group = display.newGroup()

group.title = "Fake 2.5D Layering"

-- Local Variables
local h				= display.contentHeight
local w				= display.contentWidth
local centerX		= display.contentCenterX
local centerY		= display.contentCenterY

-- ==
--    round(val, n) - Rounds a number to the nearest decimal places. (http://lua-users.org/wiki/FormattingNumbers)
--    val - The value to round.
--    n - Number of decimal places to round to.
-- ==
function _G.round(val, n)
  if (n) then
    return math.floor( (val * 10^n) + 0.5) / (10^n)
  else
    return math.floor(val+0.5)
  end
end



-- 1. Create 12 layers (bottom-to-top)
local layer = {}

for i = 1, 12 do
	layer[i] = display.newGroup()
	group:insert(layer[i])
end


local function createSkeleton()

	local x = -100
	local y = math.random( 40, h - 40 )
	
	local layerNum = round( y / 32 ) + 1 
	--print( layerNum )
	local myLayer = layer[layerNum]	

	local skel = display.newImageRect( myLayer, "images/skel.png", 80, 80 )

	skel.x = x
	skel.y = y

	transition.to( skel, { x = w + 100, time = math.random( 8000, 9000 ) } )
end

local function createFoliage( num )
	for i = 1, num do

		local x = math.random( 20, w - 20 )
		local y =  math.random( 20, h - 20 )

		local layerNum = round( y / 32 ) + 2 
		--print( layerNum )
		local myLayer = layer[layerNum]	

		local foliage = display.newImageRect( myLayer, "images/foliage" .. math.random(1,4) .. ".png", 100, 100 )

		foliage.x = x
		foliage.y = y
	end		
end


-- 2. Setting random seed so example always looks the same each time
local seed = math.random(1,1000)
seed = 422
--print(seed)
math.randomseed( seed ) 

-- 3. Create a background Image
local backImage = display.newImage( layer[1], "images/mudback.png" )
backImage.x = centerX
backImage.y = centerY

-- 4. Create Some Trees and Shrubs
createFoliage(20)

-- 5. Create (fake) HUD/Interface
local interface = display.newImage( layer[12], "images/hud.png" )
interface.x = centerX
interface.y = centerY

-- 6. Create overlay to hide unused screen space
local overlay = display.newImage( layer[12], "images/overlay.png" )
overlay.x = centerX
overlay.y = centerY

-- 7. Start making skeleons
timer.performWithDelay( 600, createSkeleton, -1 ) -- Throw balls forever

return group
