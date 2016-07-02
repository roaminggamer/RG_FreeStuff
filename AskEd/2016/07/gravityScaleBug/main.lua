io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
local physics = require "physics"
physics.start()
physics.setDrawMode("hybrid")
----------------------------------------------
-- RELAVENT CODE FOLLOWS
----------------------------------------------

-- As it should work
local ok = display.newRect( display.contentCenterX - 100, display.contentCenterY - 200, 40, 40  )
physics.addBody( ok )
ok.gravityScale = 0


-- Demonstrating bug
local bug = display.newRect( display.contentCenterX + 100, display.contentCenterY - 200, 40, 40  )
bug.gravityScale = 0
physics.addBody( bug )
bug.gravityScale = 0 -- ignored and square falls
