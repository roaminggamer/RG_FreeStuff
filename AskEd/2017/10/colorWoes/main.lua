-- =============================================================
display.setStatusBar(display.HiddenStatusBar)  
io.output():setvbuf("no") 
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init( { useExternal = true } )
-- =============================================================
local vScroller  	= ssk.vScroller
local easyIFC = ssk.easyIFC
local newRect = ssk.display.newRect
-- =============================================================
local pipSize = 80
local rf,gf,bf 
local rt,gt,bt
local count = 1
-- =============================================================
local scroller = vScroller.new( group, centerX, top + fullh/4,
	{ 	w 				= fullw, 
		h 				= fullh/2, 
	  	autoScroll	= true,
	  	backFill 	= _DARKERGREY_,
	  	scrollBuffer = 20  } )

local function textListener(self,event)
	if( not self.text or string.len(self.text) == 0 ) then return end
	if( not tonumber(self.text) ) then return end
	self.orig = tonumber(self.text)
	self.colorVal = tonumber(self.text)
	self.colorVal = self.colorVal/255
	self.field.text = string.format("%s: %1.6f", self.prefix, self.colorVal )
end

local fw = (fullw-50)/3
local fh = 30
rf = native.newTextField( centerX - fw - 10, centerY + 140, fw, fh )
rf.placeholder = "0..255"
gf = native.newTextField( centerX, centerY + 140, fw, fh )
gf.placeholder = "0..255"
bf = native.newTextField( centerX + fw + 10, centerY + 140, fw, fh )
bf.placeholder = "0..255"

rt = display.newText( "R", rf.x, rf.y + fh * 1.5, "Lato-Black.ttf", 24 )
gt = display.newText( "G", gf.x, gf.y + fh * 1.5, "Lato-Black.ttf", 24 )
bt = display.newText( "B", bf.x, bf.y + fh * 1.5, "Lato-Black.ttf", 24 )
rf.field = rt
gf.field = gt
bf.field = bt
rf.prefix = "R"
gf.prefix = "G"
bf.prefix = "B"
rf.userInput = textListener
gf.userInput = textListener
bf.userInput = textListener
rf:addEventListener("userInput")
gf:addEventListener("userInput")
bf:addEventListener("userInput")

--[[
rf.text = "1"
gf.text = "2"
bf.text = "3"
native.setKeyboardFocus(rf)
native.setKeyboardFocus(gf)
native.setKeyboardFocus(bf)
--]]


local group
local pip

local function drawPip( )
	display.remove(group)
	group = display.newGroup()
	pip = newRect( group, centerX, centerY + 65, 
		{ size = pipSize, 
		fill = { rf.colorVal, gf.colorVal, bf.colorVal} } )
end

local function testPip()
	local function onColorSampleEvent( event )
	local ir,ig,ib = round(rf.colorVal,6), round(gf.colorVal,6), round(bf.colorVal,6)
	local sr,sg,sb = round(event.r ,6), round(event.g ,6),round(event.b ,6)
	local mAbs = math.abs

	table.dump( rf )
	table.dump( gf )
	table.dump( bf )

	local match = mAbs(ir-sr)< 0.005 and mAbs(ig-sg)< 0.005 and mAbs(ib-sb)< 0.005

	print(ir,ig,ib)
	print(sr,sg,sb)
	print(match)
	
	local tmp = display.newText( "Test # " .. count, centerX, bottom-10, "Lato-Black.ttf", 24 )
	tmp.text = tmp.text .. " " .. (match and "CORRECT" or "INCORRECT?" )
	tmp:setFillColor(unpack(_LIGHTGREY_))
	scroller:insertContent( tmp, { ox = 10, autoScroll = true} )
	local tmp = display.newText( string.format("Input: { %d,  %d,  %d }", round(ir*255),round(ig*255),round(ib*255)), centerX, bottom-10, "Lato-Black.ttf", 24 )
	tmp:setFillColor(unpack(_LIGHTGREY_))
	scroller:insertContent( tmp, { ox = 10, autoScroll = true} )
	local tmp = display.newText( string.format("Result: { %d,  %d,  %d }", round(sr*255),round(sg*255),round(sb*255)), centerX, bottom-10, "Lato-Black.ttf", 24 )
	tmp:setFillColor(unpack(_LIGHTGREY_))
	scroller:insertContent( tmp, { ox = 10, autoScroll = true} )
	scroller:insertContent( pip, { ox = 10, autoScroll = true} )
	local tmp = display.newText( "----------------------------------------------", centerX, bottom-10, "Lato-Black.ttf", 24 )
	tmp:setFillColor(unpack(_LIGHTGREY_))
	scroller:insertContent( tmp, { ox = 10, autoScroll = true} )

	count = count + 1  
end
                              
	display.colorSample( pip.x, pip.y, onColorSampleEvent )
end

local function onVerify( event )
	drawPip()
	testPip()
end
local vb = easyIFC:presetPush( nil, "default", centerX, gf.y + 100, 200, 40, "Verify Color", onVerify )
function vb.enterFrame( self )
	self:enable()
	if( string.len(rf.text) == 0 or tonumber(rf.text) == nil ) then self:disable() end
	if( string.len(gf.text) == 0 or tonumber(gf.text) == nil ) then self:disable() end
	if( string.len(bf.text) == 0 or tonumber(bf.text) == nil ) then self:disable() end
end; listen("enterFrame",vb)
