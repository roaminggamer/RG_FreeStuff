io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
local back = display.newImageRect( "protoBackX.png", 720, 1386 )
back.x = display.contentCenterX
back.y = display.contentCenterY
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end

-- =====================================================
-- ANSWER BELOW
-- =====================================================
local cx = display.contentCenterX
local cy = display.contentCenterY
local fullw = display.actualContentWidth
local fullh = display.actualContentHeight

local mRand = math.random

local group = display.newGroup()

local min = mRand(100, 300)
local max = mRand(100, 300)

for i = 1, 50 do
   local tmp = display.newCircle( group, cx + mRand( -min, max ), cy + mRand( -min, max), 10 )
   tmp:setFillColor( 0, mRand(10,100)/100, mRand(10,100)/100 )
end

local function findGroupBounds( g )
	local gBounds =  { xMin = math.huge, xMax = -math.huge, yMin = math.huge, yMax = -math.huge }
	for i = 1, g.numChildren do
		local bounds = g[i].contentBounds 
		gBounds.xMin = (gBounds.xMin < bounds.xMin) and gBounds.xMin or bounds.xMin
		gBounds.xMax = (gBounds.xMax > bounds.xMax) and gBounds.xMax or bounds.xMax
		gBounds.yMin = (gBounds.yMin < bounds.yMin) and gBounds.yMin or bounds.yMin
		gBounds.yMax = (gBounds.yMax > bounds.yMax) and gBounds.yMax or bounds.yMax
	end
	return gBounds
end

local gBounds = findGroupBounds( group )

local groupCenterX = gBounds.xMin + (gBounds.xMax - gBounds.xMin)/2
local groupCenterY = gBounds.yMin + (gBounds.yMax - gBounds.yMin)/2

local tmp = display.newCircle( groupCenterX, groupCenterY, 10)
tmp:setFillColor(1,0,0)

local edges = display.newRect( groupCenterX, groupCenterY, (gBounds.xMax - gBounds.xMin), (gBounds.yMax - gBounds.yMin)  )
edges:setFillColor(0,0,0,0)
edges:setStrokeColor(1,0,0)
edges.strokeWidth = 4