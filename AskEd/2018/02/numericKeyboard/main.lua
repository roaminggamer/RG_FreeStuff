io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- 
local build = system.getInfo("build")
local tmp = display.newText( "Made With Corona Build: " .. tostring(build), 60, 100, native.systemFontB, 18  )
tmp.anchorX = 0
tmp.anchorY = 0
--
local defaultField = native.newTextField( 150, 150, 180, 30 )
defaultField.inputType = "number"

native.setKeyboardFocus( defaultField )
