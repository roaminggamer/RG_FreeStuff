display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
io.output():setvbuf("no") -- Don't use buffer for console messages

require "ssk.loadSSK"  -- Load a minimized version of the SSK library (just the bits we'll use)

local _R_ = { 1,0,0 }
local _G_ = { 0,1,0 }
local _B_ = { 0,0,1 }
local _Y_ = { 1,1,0 }
local _P_ = { 1,0,1 }

local common			= require "common"
local size = 80
local group

local function onResize()
	display.remove( group )
	group = display.newGroup()
	local flash = display.newRect( group, 0, 0, 10000, 10000)
	transition.to( flash, { alpha = 0, time = 500})
	local ul = display.newRect(group, common.left, common.top, size, size )
	ul.anchorX = 0
	ul.anchorY = 0
	ul:setFillColor( unpack( _R_ ) )
	local ur = display.newRect(group, common.right, common.top, size, size )
	ur.anchorX = 1
	ur.anchorY = 0
	ur:setFillColor( unpack( _G_ ) )
	local lr = display.newRect(group, common.right, common.bottom, size, size )
	lr.anchorX = 1
	lr.anchorY = 1
	lr:setFillColor( unpack( _B_ ) )
	local ll = display.newRect(group, common.left, common.bottom, size, size )
	ll.anchorX = 0
	ll.anchorY = 1
	ll:setFillColor( unpack( _Y_ ) )

	local options = 
	{
	    text = "",
	    x = 200,
	    y = 100,
	    width = fullw - 200,
	    font = native.systemFont,   
	    fontSize = 64,
	}	 
	local myText = display.newText( options )
	myText.anchorX = 0
	myText.anchorY = 0
	group:insert(myText)
	--
	myText.text = myText.text .. "w       = " 	.. w .."\n"
	myText.text = myText.text .. "h       = " 	.. h .."\n"
	myText.text = myText.text .. "centerX = " .. centerX .."\n"
	myText.text = myText.text .. "centerY = " .. centerY .."\n"
	myText.text = myText.text .. "fullw   = " 	.. fullw .."\n"
	myText.text = myText.text .. "fullh   = " 	.. fullh .."\n"
	myText.text = myText.text .. "left    = " 	.. left .."\n"
	myText.text = myText.text .. "right   = " 	.. right .."\n"
	myText.text = myText.text .. "top     = " 	.. top .."\n"
	myText.text = myText.text .. "bottom  = " 	.. bottom .."\n"

end
onResize()
listen("resize", onResize)
local function onKey( event )
	if( event.phase == "up" ) then
	   onResize()
	end
end; listen("key", onKey)

