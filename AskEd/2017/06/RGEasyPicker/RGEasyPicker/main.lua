-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- 					License
-- =============================================================
--[[
	Unless otherwise specified, 

	> You may use this material in a free or commercial game.
	> You may use this material in a free or commercial non-game app.
	> You need not credit the author (credits are still appreciated).
	
	> YOU MAY NOT distribute this in any other form, period.

	If someone sees you using it, or you want to share, tell people where you
	got it and let them get a copy on their own.  Giving away my work for free
	means I make no $, which means I can't afford to make good stuff like this.

	Thank You!
	Ed Maurina (aka The Roaming Gamer)
	http://roaminggamer.com
]]
-- =============================================================
-- Variables and goodies to make example easier to code and read.
-- =============================================================
display.setStatusBar(display.HiddenStatusBar)  
io.output():setvbuf("no") -- Don't use buffer for console messages
local w = display.contentWidth; local h = display.contentHeight; 
local centerX = display.contentCenterX; local centerY = display.contentCenterY
local fullw	= display.actualContentWidth; local fullh	= display.actualContentHeight
local left = 0 - (fullw - w)/2; local right = w + (fullw - w)/2
local top = 0 - (fullh - h)/2; local bottom = h + (fullh - h)/2
-- =============================================================


-- =============================================================
-- =============================================================
--
--                   THIS IS NOT THE EXAMPLE.  
--
--
--  This code lets you select which example to run.  So, don't 
--  worry too much if you don't understand everything I've done below.
--
-- =============================================================
-- =============================================================


--
-- The Samples are in the files we require below.
-- I wrapped them as modules to make them easy to run and select.
--
local pickerExample = {}
pickerExample[1] = require "pickerExample1"
pickerExample[2] = require "pickerExample2"
pickerExample[3] = require "pickerExample3"
pickerExample[4] = require "pickerExample4"

local startSample = 1
--
-- The following code draw some buttons to run one example at at time
-- So you can easily examine them without restarting.
--
local buttons = {}
local group = display.newGroup()
local function onTouch( self, event )
	if( event.phase == "ended" ) then
		for i = 1, #buttons do
			buttons[i]:setFillColor( 1,1,1 )
		end
		display.remove( group )
		group = display.newGroup()
		self:setFillColor( 0.5, 0.5, 0 )
		pickerExample[self.myNum].drawNotes( group )
		pickerExample[self.myNum].drawExample( group )
	end
	return true
end
local function drawButton( x, y, myNum )
	local button = display.newRect( x, y, 40, 40 )
	button.label = display.newText( myNum, x, y, native.systemFont, 22 )
	button.label:setFillColor(0,0,0)
	button.myNum = myNum
	button.touch = onTouch
	button:addEventListener( "touch" )
	buttons[#buttons+1] = button
end

for i = 1, #pickerExample do
	drawButton( left + i * 45, bottom - 25, i )
end

buttons[startSample]:setFillColor( 0.5, 0.5, 0 )
pickerExample[startSample].drawNotes( group )
pickerExample[startSample].drawExample( group )