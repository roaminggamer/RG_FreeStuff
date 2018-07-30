-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init()
-- =============================================================
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
-- =============================================================
local physics = require "physics"
physics.start()
physics.setGravity(0,10)
--physics.setDrawMode("hybrid")

display.setDefault( "magTextureFilter", "nearest" )

local sceneGroup = display.newGroup()
local game = require "scripts.game"
game.create( sceneGroup, { level = 1, maxLevels = 2 } )

--transition.to( sceneGroup, { y=100,time=10000})

--display.setDefault( "magTextureFilter", "linear" )

--local xml = require("xml").newParser()
--local out = xml:loadFile( "levels/dungeon.tsx"  )
--table.print_r(out)
--table.dump(out.properties)
--table.print_r(out.child[2])

--local out2 = xml:toXml( nil, out  )

--print(out2)

--local xmlText = io.readFile( "levels/dungeon.tsx", system.ResourceDirectory )
--print(out)

