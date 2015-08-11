display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
io.output():setvbuf("no") -- Don't use buffer for console messages

local testBack = display.newImageRect( "protoBack.png", 380, 570)
testBack.x = display.contentCenterX
testBack.y = display.contentCenterY