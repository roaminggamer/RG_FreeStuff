-- =============================================================
-- main.lua
-- =============================================================
io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar


-- === GOTCHA 1
-- === GOTCHA 1 (NO LONGER A PROBLEM?)
-- === GOTCHA 1
--[[
local gotcha = require "gotcha1"
print("----------------------------")
gotcha.init()
gotcha.test()
print("----------------------------")
gotcha.save( "case1" )
gotcha.load( "case1" )
gotcha.test()
--]]


-- === GOTCHA 2
-- === GOTCHA 2
-- === GOTCHA 2
--[[
local gotcha = require "gotcha2"
print("----------------------------")
gotcha.init()
--gotcha.test()
gotcha.test2()
print("----------------------------")
gotcha.save( "case2" )
gotcha.load( "case2" )
--gotcha.test()
--gotcha.test2()
print("----------------------------")
gotcha.test3()
--]]


-- === GOTCHA 3
-- === GOTCHA 3
-- === GOTCHA 3
--[[
local gotcha = require "gotcha3"
print("----------------------------")
gotcha.init()
gotcha.test()
gotcha.test2()
--]]

--[[
print("----------------------------")
gotcha.save( "case2" )
gotcha.load( "case2" )
gotcha.test()
gotcha.test2()
--]]

--[[
gotcha.save2( "case3" )
gotcha.load2( "case3" )
gotcha.test()
--]]