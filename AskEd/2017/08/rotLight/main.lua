-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init()
-- =============================================================
local group = display.newGroup()
group.x = centerX
group.y = centerY
for i = 1, 10 do
	local light = ssk.display.newCircle( group, 0, -(100 + i * 15), { radius = 10, fill = _G_ })
end

local totalRot = 360 * 100
local rateRatio = 0.5

transition.to( group, { rotation = totalRot, time = rateRatio * totalRot, transition = easing.inOutCirc } )