io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
--require "ssk2.loadSSK"
--_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================
local cx     = display.contentCenterX
local cy     = display.contentCenterY
local fullw  = display.actualContentWidth
local fullh  = display.actualContentHeight
local left   = cx - fullw/2
local right  = cx + fullw/2
local top    = cy - fullh/2
local bottom = cy + fullh/2

local moveTime = 1 -- values below a frame duration default to 'takes one frame'
local moveRight
local moveLeft
local count = 0
local maxCount = 10000
local tmem = {} 
local mmem = {}
local times = {}

local function result()
	print("Texture Memory Delta: " .. (tmem[2]-tmem[1]) )
	print("   Main Memory Delta: " .. (mmem[2]-mmem[1]) )
	print("          Time Delta: " .. (times[2]-times[1]) )
end

local function countMem( entry )
	collectgarbage("collect") -- Collect garbage every frame to get 'true' current memory usage
	tmem[entry] = system.getInfo( "textureMemoryUsed" )
	mmem[entry] = collectgarbage( "count" )
	times[entry]  = system.getTimer()
	--
	print( entry .. " : Texture Memory: " .. tmem[entry] .. " @ " .. times[entry] )
	print( entry .. " :    Main Memory: " .. mmem[entry] .. " @ " .. times[entry] )
	--
	if( entry == 2 ) then result() end
end


moveRight = function( self )
	count = count + 1
	if( count > maxCount ) then
		countMem( 2 ) 
		return 
	end
	--
	self.x = right
	timer.performWithDelay( moveTime, function() moveLeft( self )  end )	
end

moveLeft = function( self )
	count = count + 1
	if( count > maxCount ) then
		countMem( 2 ) 
		return 
	end
	--
	self.x = left
	timer.performWithDelay( moveTime, function() moveRight( self )  end )
end

local obj = display.newCircle( left, cy, 20 )

-- Make first mem + time count
countMem(1)

-- Start ping-pong movement 
moveRight( obj )