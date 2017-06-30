io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init()

-- Localizations
local newRect = ssk.display.newRect
local newCircle = ssk.display.newCircle
local angle2Vector = ssk.math2d.angle2Vector
local scaleVec = ssk.math2d.scale
local mFloor = math.floor

-- =============================================================
-- Example Begins - Uses SSK2 library!
-- =============================================================
local clockGroup = display.newGroup()
clockGroup.x = centerX
clockGroup.y = centerY

-- Draw Dial Marks
local degPerTick = 360/12
for i = 1, 12 do
	local vec = angle2Vector( (i-1) * degPerTick, true )
	vec =  scaleVec( vec, 270 )
	newRect( clockGroup, vec.x, vec.y, { w = 8, h = 24, rotation = (i-1) * degPerTick} )
end

local back = newRect( nil, centerX, centerY, { w = fullw, h = fullh, fill = _B_, alpha = 0.15 } )
local hourHand = newRect( clockGroup, 0, 0, { w = 32, h = 180, anchorY = 1, fill = _W_ } )
local minHand  = newRect( clockGroup, 0, 0, { w = 16, h = 220, anchorY = 1, fill = _LIGHTGREY_ } )
local secHand  = newRect( clockGroup, 0, 0, { w = 6, h = 240, anchorY = 1, fill = _GREY_ } )
local dialCenter = newCircle( clockGroup, 0, 0, { radius = 40, stroke = _DARKERGREY_, strokeWidth = 6 } )

function back.enterFrame( self )
	local tt = os.date("*t")
	hourHand.rotation = tt.hour * 360/12
	minHand.rotation = tt.min * 360/60
	secHand.rotation = mFloor( tt.sec * 360/60 )

end; listen( "enterFrame", back )


local timeTable = os.date("*t")
table.dump(timeTable)

