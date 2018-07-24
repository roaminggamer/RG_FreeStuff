io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
local cx     = display.contentCenterX
local cy     = display.contentCenterY
local fullw  = display.actualContentWidth
local fullh  = display.actualContentHeight
local left   = cx - fullw/2
local right  = cx + fullw/2
local top    = cy - fullh/2
local bottom = cy + fullh/2
-- =====================================================
-- =====================================================
local swipeTray = require "swipeTray"

local group = display.newGroup()

local frame = display.newRect( group, cx, cy, fullw - 50, fullh - 50 )
frame.alpha = 0.2
frame.strokeWidth = 4
frame:setStrokeColor(0,1,0)
frame:setFillColor(0,0,0,0)

local tray = swipeTray.new( group, cx, cy, fullw - 50, fullh - 50,
	                        { minScale 		= 0.1, 
	                          scaleDist 	= 500,
	                          centerDelay 	= 100,
	                          centerTime 	= 500,
	                          snapDelay 	= 500,
	                          selectedWidth = 30 } )

for i = 1, 10 do
	local page = display.newGroup()
	local frame = display.newRect( page, 0, 0, 200, 200 )
	frame:setFillColor(0.25, 0.25, 0.25)
	frame:setStrokeColor(1,1,0)
	frame.strokeWidth = 4


	local tmp = display.newImageRect( page, (i%2==0) and "images/rg.png" or "images/corona.png", 100, 100 )
	tray:add( page )

	function page.onSelected( self, event )
		for k,v in pairs( event ) do
			print(k,v)
		end
		print( "-------------------------- @ ", system.getTimer() )
		tmp:setFillColor(math.random(2,10)/10,math.random(2,10)/10,math.random(2,10)/10)
	end

end
--]]


