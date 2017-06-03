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
local public = {}
local notes = {
	"This picker shows that the code can handle scaling.",
	"As you pick values from the list, the control will scale to that size.",
	"Notice that the picker works equally well at all scales.",
	"",
	"(Click buttons at bottom to select another example.)",
}

function public.drawNotes( group )

	for i = 1, #notes do
		local tmp = display.newText( group, notes[i], left + 20, top + i * 20, native.systemFont, 14 )
		tmp.anchorX = 0
	end
end


-- Create the numbers list ONCE and shuffle it
local helpers 		= require "helpers"
local numberList = { 0.5, 0.6, 0.7, 0.8, 1, 1.1, 1.2, 1.5 }


function public.drawExample( parentGroup )
	-- =============================================================
	-- EXAMPLE STARTS HERE
	-- =============================================================
	local RGEasyPicker 	= require "RGEasyPicker"

	local function newPicker( group, x, y, w, h, entries, onSpin )
		-- If not group is provided, default to current stage	
		--
		group = group or display.currentStage

		-- Create a rectangle and convert it to a picker
		--
		local picker = display.newRect( group, x, y, w, h )
		RGEasyPicker.create( group, picker, 
		              { 
						onSpin 			= onSpin,
			 			entries 		= entries,
			 			entrySpacing 	= 30,
						fontSize 		= 26,
						fontColor 		= {0,0,0},
						font 			= native.systemFont,
					   } )
			
		-- Put an overlay image on top of picker to make it more interesting 
		-- looking		
		local overlay = display.newImageRect( group, "images/pickerOverlay.png", w, h )
		overlay.x = picker.x
		overlay.y = picker.y

		-- Place a frame around the picker
		--
		local frame = display.newRect( group, picker.x, picker.y, w, h )
		frame:setFillColor(0,0,0,0)
		frame:setStrokeColor(0,0,0,1)
		frame.strokeWidth = 1

		return picker, overlay, frame
	end

	local scaleGroup = display.newGroup()
	parentGroup:insert( scaleGroup )
	scaleGroup.x = centerX
	scaleGroup.y = centerY

	local function onSpin( self )
		if( not self.demoLabel ) then
			self.demoLabel = display.newText( scaleGroup, "", self.x, self.y + self.contentHeight/2 + 20, native.systemFont, 16 )
		end
		self.demoLabel.text = "Entry Index: " .. self:getIndex() .. ";  Entry Value: " .. self:getValue()

		scaleGroup.xScale = tonumber( self:getValue() )
		scaleGroup.yScale = tonumber( self:getValue() )
	end

	local picker = newPicker( scaleGroup, 0, 0, 240, 80, numberList, onSpin )
	picker:setIndex(3)
end

return public