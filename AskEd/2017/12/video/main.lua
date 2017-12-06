-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
local cx = display.contentCenterX
local cy = display.contentCenterY

local vide = native.newVideo( cx, cy, display.actualContentWidth, display.actualContentHeight )
vide:load("video.mp4")
vide:play()