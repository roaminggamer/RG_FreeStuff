display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
io.output():setvbuf("no") -- Don't use buffer for console messages

local common			= require "common"

local maxFields = 8

local fields = {}
for i = 1, maxFields do
	local tmp = native.newTextField( common.centerX, common.top + 30 + 20 + (i-1) * 60, common.fullw - 120, 40  )	
	local label = display.newText( i, common.left + 10, tmp.y, native.systemFont, 32 )
	tmp.hasBackground = false
	local customFrame = display.newRoundedRect( tmp.x, tmp.y-1, common.fullw - 120 + 4, 40 + 4, 8)
	customFrame:setFillColor(0,0.2,0.2)
	customFrame:setStrokeColor(0,0.8,0.8)
	customFrame.strokeWidth = 2
	tmp.font = native.newFont( native.systemFontBold, 18 )
	tmp:setTextColor(1,1,0)

	label.anchorX = 0
	fields[#fields+1] = tmp
end
