-- =============================================================
-- Ask Ed 2016
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================
display.setStatusBar(display.HiddenStatusBar) 

-- True edges of screen (regardless of scaling mode in config.lua)
local left    = 0-(display.actualContentWidth - display.contentWidth)/2
local top     = 0-(display.actualContentHeight - display.contentHeight)/2
local right   = display.contentWidth + (display.actualContentWidth - display.contentWidth)/2
local bottom  = display.contentHeight + (display.actualContentHeight - display.contentHeight)/2
local centerX = display.contentCenterX
local centerY = display.contentCenterY

local colors = {}
colors[1] = { 1, 0, 0 }
colors[1] = { 0, 1, 0 }
colors[2] = { 0, 0, 1 }
colors[3] = { 1, 1, 0 }
colors[4] = { 1, 0, 1 }
colors[5] = { 0, 1, 1 }

local mRand 		= math.random

local pipScale = 1/10

--
-- Some display groups/containers
--
local content        = display.newGroup()
local minimapFrame   = display.newContainer( 100, 100 )
local minimap        = display.newGroup()


minimapFrame.x = right - 50
minimapFrame.y = top + 50

local tmp = display.newRect( minimapFrame, 0, 0, 100, 100 )
tmp:setFillColor(0.1,0.1,0.1)

local tmp = display.newRect( minimapFrame, 0, 0, 99, 99 )
tmp:setFillColor(0,0,0,0)
tmp:setStrokeColor(1,1,1)
tmp.strokeWidth = 3

minimapFrame:insert( minimap )
minimap.xScale = 1/10
minimap.yScale = 1/10


local function pipEnterFrame( self )
   if( self.removeSelf == nil or
       not self.myObj or 
       self.myObj.removeSelf == nil ) then
       Runtime:removeEventListener( "enterFrame", self )
       return
   end
   self.x = self.myObj.x - centerX
   self.y = self.myObj.y - centerY
end


local function randomMover( self )
   local toX = mRand( left - 500, right + 500)
   local toY = mRand( top - 500 , bottom + 500 )
   transition.to( self, { x = toX, y = toY, time = 2000, onComplete = self } )
end


local function createTestObj()
   local size = mRand(10, 20)  
   
   -- Object to track
   local obj = display.newCircle( content, centerX, centerY, size/2 )
   obj.size = size
   obj.color = mRand(1, #colors)
   obj:setFillColor( unpack( colors[obj.color] ) )
   obj.onComplete = randomMover
   
   -- Minimap pip   
   local pip = display.newCircle( minimap, obj.x - centerX, obj.y - centerY, size/2 )
   pip:setFillColor( unpack( colors[obj.color] ) )
   pip.myObj = obj
   pip.enterFrame = pipEnterFrame
   Runtime:addEventListener( "enterFrame", pip )   
      
   randomMover( obj )      
end
   
for i = 1, 3 do
   timer.performWithDelay( 250 * (i-1), createTestObj )
end