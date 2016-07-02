io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
local physics = require "physics"
physics.start()
physics.setDrawMode("hybrid")
----------------------------------------------
-- RELAVENT CODE FOLLOWS
----------------------------------------------

-- Note: aShape1.png and aShape.2.png are same image, copied to avoid 're-use' issues in bug demo.


-- As it should work - Body matches shape
local ok = display.newImageRect( "aShape1.png", 160, 160  )
ok.x = display.contentCenterX - 150
ok.y = display.contentCenterY

local outline1 = graphics.newOutline( 2, "aShape1.png" )
physics.addBody( ok, "static", { outline = outline1 } )


-- Demonstrating bug - Body does not match shape
local bug = display.newImageRect( "aShape2.png", 160, 160  )
bug.x = display.contentCenterX + 150
bug.y = display.contentCenterY

bug.yScale = -1 -- This is done BEFORE body, so it should be seen, but it is ignored...

local outline2 = graphics.newOutline( 2, "aShape2.png" )
physics.addBody( bug, "static", { outline = outline2 } )
