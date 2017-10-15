-- =============================================================
display.setStatusBar(display.HiddenStatusBar)  
io.output():setvbuf("no") 
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init( { useExternal = true } )
-- =============================================================

local physics = require "physics"
physics.start()
physics.setGravity(0,0)


-- Replace current SSK actions lib with local copy
ssk.actions.movep = require("movep")

-- Localize two new functions
local moveToward = ssk.actions.movep.toward
local thrustToward = ssk.actions.movep.thrustToward

local target = ssk.display.newImageRect( nil, centerX, centerY, "target.png", { size = 100, fill = _R_ }  )

local dude1 = ssk.display.newImageRect( nil, left + 50, centerY - 100, "dude.png", { size = 60, fill = _G_ }, {isSensor=true} )
local dude2 = ssk.display.newImageRect( nil, left + 50, centerY, "dude.png", { size = 60, fill = _G_ }, {isSensor=true} )
local dude3 = ssk.display.newImageRect( nil, left + 50, centerY + 100, "dude.png", { size = 60, fill = _G_ }, {isSensor=true} )
local dude4 = ssk.display.newImageRect( nil, right - 50, centerY - 100, "dude.png", { size = 60}, {isSensor=true} )
local dude5 = ssk.display.newImageRect( nil, right - 50, centerY, "dude.png", { size = 60}, {isSensor=true} )
local dude6 = ssk.display.newImageRect( nil, right - 50, centerY + 100, "dude.png", { size = 60}, {isSensor=true} )

moveToward( dude1, { angle = 120, rate = 150 } )
moveToward( dude2, { target = target, rate = 80 } )
moveToward( dude3, { angle = 60, rate = 150 } )

function dude4.enterFrame( self )
	thrustToward( self, { angle = -120, rate = 1 } )
end; listen("enterFrame", dude4)

function dude5.enterFrame( self )
	thrustToward( self, { target = target, rate = 1 } )
end; listen("enterFrame", dude5)

function dude6.enterFrame( self )
	thrustToward( self, { angle = -60, rate = 1 } )
end; listen("enterFrame", dude6)

