display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
io.output():setvbuf("no") -- Don't use buffer for console messages
system.activate("multitouch") 

----------------------------------------------------------------------
require "ssk2.loadSSK"
_G.ssk.init()
----------------------------------------------------------------------
local wb = require "scripts.wb"
wb.create()