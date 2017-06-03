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
	"This demonstrates the use of multiple pickers together.",
	"The pickers represent an RGBA code and modify the color",
	"of a sample block below the picker",
	"(Click buttons at bottom to select another example.)",
}

function public.drawNotes( group )

	for i = 1, #notes do
		local tmp = display.newText( group, notes[i], left + 20, top + i * 20, native.systemFont, 14 )
		tmp.anchorX = 0
	end
end


-- Create the numbers list ONCE and shuffle it
local numberList = {}
for i = 1, 256 do
	numberList[i] = i-1
end

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
						maskImg			= "images/pickerMask.png",
						maskW			= 128,
						maskH			= 32,
						spdBump 		= 1000,
						drag 			= 0.05
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

	local redPicker, greenPicker, bluePicker, alphaPicker
	local redOverlay, greenOverlay, blueOverlay, alphaOverlay
	local redFrame, greenFrame, blueFrame, alphaFrame
	local sampleChip

	local function onSpin( self )
		if( redPicker and greenPicker and bluePicker and sampleChip ) then
			local r = redPicker:getValue()
			local g = greenPicker:getValue()
			local b = bluePicker:getValue()
			local a = alphaPicker:getValue()
			print(r,g,b,a)
			sampleChip:setFillColor( r/255, g/255, b/255, a/255 )
		end
	end

	-- RED
	--
	redPicker, redOverlay, redFrame = newPicker( parentGroup, centerX - 120, centerY, 76, 80, numberList, onSpin )
	redOverlay:setFillColor( 0.5, 0, 0 )
	redPicker:setFillColor( 1, 0, 0 )
	redFrame:setStrokeColor( 1, 1, 1, 0.2 )
	redFrame.strokeWidth = 2
	redPicker:setIndex( math.random(1,256) )

	-- GREEN
	--
	greenPicker, greenOverlay, greenFrame = newPicker( parentGroup, centerX - 40, centerY, 76, 80, numberList, onSpin )
	greenOverlay:setFillColor( 0, 0.5, 0 )
	greenPicker:setFillColor( 0, 1, 0 )
	greenFrame:setStrokeColor( 1, 1, 1, 0.2 )
	greenFrame.strokeWidth = 2
	greenPicker:setIndex( math.random(1,256) )

	-- BLUE
	--
	bluePicker, blueOverlay, blueFrame = newPicker( parentGroup, centerX + 40, centerY, 76, 80, numberList, onSpin )
	blueOverlay:setFillColor( 0, 0, 0.5 )
	bluePicker:setFillColor( 0, 0, 1 )
	blueFrame:setStrokeColor( 1, 1, 1, 0.2 )
	blueFrame.strokeWidth = 2
	bluePicker:setIndex( math.random(1,256) )

	-- ALPHA
	--
	alphaPicker, alphaOverlay, alphaFrame = newPicker( parentGroup, centerX + 120, centerY, 76, 80, numberList, onSpin )
	alphaFrame:setStrokeColor( 1, 1, 1, 0.2 )
	alphaFrame.strokeWidth = 2
	alphaPicker:setIndex( 256 )

	sampleChip = display.newRect( parentGroup, centerX, centerY + 70, 320, 40 )
	onSpin()
end

return public