io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
local ssk = require "ssk2.loadSSK"
ssk.init()
-- =====================================================
local physics = require "physics"
physics.start()
physics.setGravity(0,0)
--physics.setDrawMode("hybrid")
-- =====================================================

local example = require "scripts.ex1"

example.run()