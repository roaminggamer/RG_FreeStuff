local _R_ = { 1,0,0 }
local _G_ = { 0,1,0 }
local _B_ = { 0,0,1 }
local _Y_ = { 1,1,0 }
local _P_ = { 1,0,1 }
local _GREY_ = { 0.2,0.2,0.2 }

local common			= require "common"
local size = 80

local function draw_stuff()
	local back = display.newRect( centerX, centerY, fullw, fullh )
	back:setFillColor( unpack( _GREY_ ) )

	local tmp = display.newLine( centerX, top, centerX, bottom )
	tmp.strokeWidth = 2

	local tmp = display.newLine( left, centerY, right, centerY )
	tmp.strokeWidth = 2

	local ul = display.newRect( left, top, size, size )
	ul.anchorX = 0
	ul.anchorY = 0
	ul:setFillColor( unpack( _R_ ) )


	local ur = display.newRect( right, top, size, size )
	ur.anchorX = 1
	ur.anchorY = 0
	ur:setFillColor( unpack( _G_ ) )


	local lr = display.newRect( right, bottom, size, size )
	lr.anchorX = 1
	lr.anchorY = 1
	lr:setFillColor( unpack( _B_ ) )


	local ll = display.newRect( left, bottom, size, size )
	ll.anchorX = 0
	ll.anchorY = 1
	ll:setFillColor( unpack( _Y_ ) )

	local c = display.newRect( centerX, centerY, size, size )
	c:setFillColor( unpack( _P_ ) )
end


local function v1()
	draw_stuff()
end

local function v2()
	display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
	io.output():setvbuf("no") -- Don't use buffer for console messages
	draw_stuff()
end

local function v3()
	display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
	io.output():setvbuf("no") -- Don't use buffer for console messages
	common.easyAndroidUIVisibility()
	timer.performWithDelay( 1000, draw_stuff )
end

v1()