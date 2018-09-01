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
-- == Uncomment following lines if you need  physics
--local physics = require "physics"
--physics.start()
--physics.setGravity(0,10)
--physics.setDrawMode("hybrid")

-- == Uncomment following line if you need widget library
--local widget = require "widget"

-- =====================================================
local back = display.newImageRect( "protoBackX.png", 720, 1386 )
back.x = display.contentCenterX
back.y = display.contentCenterY
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end
-- =====================================================
local camera = display.newGroup()

local canExplode = true

local explodeObject
local zoomTo
local revertCamera

zoomTo = function ( obj, time )
	local zz = 3
	local zx, zy = cx - obj.x * zz, cy - obj.y * zz
	transition.to( camera, { time = time, x = zx, y = zy, xScale = zz, yScale = zz } )
end

revertCamera = function( time )
	local function onComplete()
		canExplode = true
	end
	transition.to( camera, { time = time, x = 0, y = 0, xScale = 1, yScale = 1, onComplete = onComplete } )
end

explodeObject = function( obj )
	if( not canExplode ) then return end
	canExplode = false

	zoomTo( obj, 1500 )

	local function onComplete()
		display.remove(obj)
		revertCamera( 500 )
	end

	transition.to( obj, { delay = 1500, rotation = 360 * 4, alpha = 0, time = 2000, onComplete = onComplete } )
end

local function onTouch( self, event )
	if( event.phase == "ended") then
		self:removeEventListener('touch')
		explodeObject( self )
	end
	return true
end

for i = 1, 10 do
	local tmp = display.newRect( camera, left + math.random( 40, fullw - 40), top  + math.random( 40, fullh - 40), 40, 40 )
	tmp.touch = onTouch
	tmp:addEventListener("touch")
end