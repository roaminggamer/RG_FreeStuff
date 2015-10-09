display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
io.output():setvbuf("no") -- Don't use buffer for console messages


local _R_ = { 1,0,0 }
local _G_ = { 0,1,0 }
local _B_ = { 0,0,1 }
local _Y_ = { 1,1,0 }
local _P_ = { 1,0,1 }

local common			= require "common"
local size = 80

-- Hide buttons as per best feature supported by this device and OS version
--
common.easyAndroidUIVisibility()

local tmp = display.newLine( common.centerX, common.top, common.centerX, common.bottom )
tmp.strokeWidth = 2

local tmp = display.newLine( common.left, common.centerY, common.right, common.centerY )
tmp.strokeWidth = 2

local ul = display.newRect( common.left, common.top, size, size )
ul.anchorX = 0
ul.anchorY = 0
ul:setFillColor( unpack( _R_ ) )


local ur = display.newRect( common.right, common.top, size, size )
ur.anchorX = 1
ur.anchorY = 0
ur:setFillColor( unpack( _G_ ) )


local lr = display.newRect( common.right, common.bottom, size, size )
lr.anchorX = 1
lr.anchorY = 1
lr:setFillColor( unpack( _B_ ) )


local ll = display.newRect( common.left, common.bottom, size, size )
ll.anchorX = 0
ll.anchorY = 1
ll:setFillColor( unpack( _Y_ ) )

local c = display.newRect( common.centerX, common.centerY, size, size )
c:setFillColor( unpack( _P_ ) )
