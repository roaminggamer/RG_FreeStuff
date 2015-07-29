-- =============================================================
-- main.lua
-- =============================================================
io.output():setvbuf("no") 
display.setStatusBar(display.HiddenStatusBar)  
----------------------------------------------------------------------
-- IGNORE ABOVE
----------------------------------------------------------------------


local logo = display.newImageRect( "coronaLogo.png", 100, 100 )
logo.x = 150
logo.y = 150
logo.fill.effect = "filter.linearWipe"
logo.fill.effect.direction = { 1, 1 }
logo.fill.effect.smoothness = 1
logo.fill.effect.progress = 0.0


local smile = display.newImageRect( "yellow_round.png", 100, 100 )
smile.x = 350
smile.y = 150
smile.fill.effect = "filter.linearWipe"
smile.fill.effect.direction = { -1, -1 }
smile.fill.effect.smoothness = 1
smile.fill.effect.progress = 0.0


transition.to( logo.fill.effect, { progress = 1, time = 5000 })
transition.to( smile.fill.effect, { progress = 1, time = 5000 })

