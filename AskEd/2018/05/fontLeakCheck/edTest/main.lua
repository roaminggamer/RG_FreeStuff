io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
require "ssk2.loadSSK"
_G.ssk.init()
local back = display.newImageRect( "protoBackX.png", 720, 1386 )
back.x = display.contentCenterX
back.y = display.contentCenterY
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end
ssk.meters.create_fps(true)
ssk.meters.create_mem(true)

-- =====================================================
-- TEST BELOW
-- =====================================================
local startTest
local test
local purgeMem
--
local font 		= "Playball.ttf"
local running  = false
local content 
local buttons = display.newGroup()
local words = ssk.misc.getLorem( 300 )
words = string.split( words, " " )
--table.dump(words)
--

local function start()
	print("STARTING")
	if( group ) then return end
	--	
	group = display.newGroup()
	group:toBack()
	back:toBack()
	--
	function group.enterFrame()
		if( not running ) then return end
		--
		local tmp = display.newText( group, words[math.random(1,#words)], centerX, centerY, font )
		tmp:setFillColor( unpack(randomColor()) )
		--
		local vec = ssk.math2d.angle2Vector( math.random(0,359), true )
		vec = ssk.math2d.scale( vec, 1000 )
		--
		transition.to( tmp, { x = tmp.x + vec.x, y = tmp.y + vec.y, time = 500, xScale = 12, yScale = 12, onComplete = display.remove } )
	end; listen( "enterFrame", group )
	--
	running = true
end

local function stop()
	print("STOPING")
	if( not group ) then return end
	--
	running = false
	--
	ignore( "enterFrame", group )
	--
	display.remove( group )
	group = nil

end

ssk.display.newRect( buttons, centerX, bottom, { w = fullw, h = 80, fill = _O_, anchorY = 1 } )
ssk.easyIFC:presetPush( buttons, "default", centerX - 100, bottom - 40, 120, 60, "Start", start )
ssk.easyIFC:presetPush( buttons, "default", centerX + 100, bottom - 40, 120, 60, "Stop", stop )

