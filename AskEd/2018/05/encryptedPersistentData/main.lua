io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
require "ssk2.loadSSK"
_G.ssk.init()
-- =====================================================
-- =====================================================
local tests = require "tests"

--tests.one( "bob" )
--tests.two()
tests.three( "bob" )