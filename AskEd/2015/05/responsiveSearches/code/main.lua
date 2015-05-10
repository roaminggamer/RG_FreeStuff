display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
io.output():setvbuf("no") -- Don't use buffer for console messages

local com 			= require "common"
local meter 		= require "meter"
local wordList		= require "wordList"
local searchField	= require "searchField"
local example		= require "example"

meter.create_fps()

searchField.create()

example.init(20)
example.start()
--example.run( 1000 )
