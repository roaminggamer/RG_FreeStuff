io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================
-- =====================================================
-- =====================================================
local back = display.newImageRect( "protoBackX.png", 720, 1386 )
back.x = display.contentCenterX
back.y = display.contentCenterY
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end
-- =====================================================
-- =====================================================
local newImageRect = ssk.display.newImageRect
local getTimer = system.getTimer

local blocks = {}

local blockSize = 80

local fallRate = 150

local yStart = centerY - 1.5 * blockSize
local yMax = centerY + 1.5 * blockSize

local function overlaps( obj1, obj2, ox, oy )
	ox = ox or 0
	oy = oy or 0
	local bounds1 = obj1.contentBounds
	local bounds2 = obj2.contentBounds
	local hOverlap = ( ( bounds2.xMax + ox >= bounds2.xMin and bounds2.xMax + ox <= bounds2.xMax) or
	                   ( bounds2.xMin + ox <= bounds2.xMax and bounds2.xMax + ox >= bounds2.xMax) ) 

	local bOverlap = ( ( bounds2.yMax + oy >= bounds2.yMin and bounds2.yMax + oy <= bounds2.yMax) or
	                   ( bounds2.yMin + oy <= bounds2.yMax and bounds2.yMax + oy >= bounds2.yMax) ) 
	
	return hOverlap and bOverlap
end

local function overlapTest(obj, ox, oy)
	local overlapped = false	
	for k,v in pairs( blocks ) do
		if( obj ~= v ) then
			overlapped = overlapped or overlaps( obj, v, ox, oy )
		end
	end
	return overlapped
end

local xPos = {}
xPos[1] = centerX - 2.5 * blockSize
xPos[2] = centerX - 1.5 * blockSize
xPos[3] = centerX - 0.5 * blockSize
xPos[4] = centerX + 0.5 * blockSize
xPos[5] = centerX + 1.5 * blockSize
xPos[6] = centerX + 2.5 * blockSize

local createBlock

local function onEnterFrame( self )
	if( not self.isMoving ) then 
		ignoreList( { "enterFrame" }, self )
		return 
	end	
	--
	if(self.move) then
		if( self.move == "left" and self.col > 0 ) then
			self.x = self.x - blockSize
		end
		if( self.move == "right" and self.col < 8 ) then
			self.x = self.x + blockSize
		end
	end
	self.move = nil
	--
	local curT = getTimer()
	local dt = curT - self.lastT
	self.lastT = curT
	--
	if( dt <= 0 ) then return end
	local dy = fallRate * dt/1000
	self.y = self.y + dy
	--
	if( self.y >= yMax ) then
		self.isMoving = false
		ignore("enterFrame",self)
		self.y = yMax
	end
	if( overlapTest( self ) ) then
		self.isMoving = false
		ignore("enterFrame",self)
	end
end

local function onKey( self, event  )
	local keyName = event.keyName 
	local phase = event.phase
	if( phase == "down") then
		if( keyName == "left" ) then
			self.move = "left"			
		elseif( keyName == "right" ) then
			self.move = "right"
		elseif( keyName == "down" ) then
			self.move = "down"
		end
	end	
end

createBlock = function( col )
   local block = newImageRect( nil, xPos[col], yStart, "fillW.png", { size = blockSize } )   
   block.isMoving = true
   block.lastT = getTimer()
   --
   block.enterFrame = onEnterFrame 
   listen( "enterFrame", block  )
   block.key = onKey 
   listen( "key", block  )
   --
   block.col = col
   blocks[col] = block
end

createBlock( 3 )

timer.performWithDelay( 1000, function() createBlock(3) end )