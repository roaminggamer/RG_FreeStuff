io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- Require these just once in main.lua
require "extensions.string"
require "extensions.io"
require "extensions.table"
require "extensions.math"
require "extensions.display"
-- =====================================================
local cx     = display.contentCenterX
local cy     = display.contentCenterY
local fullw  = display.actualContentWidth
local fullh  = display.actualContentHeight
local left   = cx - fullw/2
local right  = cx + fullw/2
local top    = cy - fullh/2
local bottom = cy + fullh/2
-- =====================================================

-- Load CSV file as table of tables, where each sub-table is a row
local lines = io.readFileTable( "dummy.csv", system.ResourceDirectory )

local rows = {}

for i=1, #lines do	
	rows[#rows+1] = string.fromCSV(lines[i])
end

-- Debug step to see what we extracted from the CSV file
table.print_r(rows)


-- Make some labels, image, and rectangle to use as a button
local label1 = display.newText( "Press Button To Start", left + 10, top + 20,  native.systemFont, 16 )
label1.anchorX = 0 -- x-position is left side of label instead of defult horizontal centering (anchorX=0.5)

local label2 = display.newText( "----------", left + 10, top + 40,  native.systemFont, 16 )
label2.anchorX = 0 -- x-position is left side of label instead of defult horizontal centering (anchorX=0.5)

local label3 = display.newText( "----------", left + 10, top + 60,  native.systemFont, 16 )
label3.anchorX = 0 -- x-position is left side of label instead of defult horizontal centering (anchorX=0.5)

local label4 = display.newText( "----------", left + 10, top + 80,  native.systemFont, 16 )
label4.anchorX = 0 -- x-position is left side of label instead of defult horizontal centering (anchorX=0.5)

local img = display.newImageRect( "images/fillW.png", 64, 64 )
img.anchorX = 0
img.anchorY = 0
img.x = left + 10
img.y = top + 100


local button = display.newImageRect( "images/fillW.png", 128, 64 )
button.x = cx
button.y = cy
button:setFillColor( 0.5, 0.6, 0.9 )
button.label = display.newText( "push me", button.x, button.y,  native.systemFont, 16 )

local curRow = 0


local function onTouch( event )
	if( event.phase == "ended" ) then
		curRow = curRow + 1

		if( curRow <= #rows ) then
			table.print_r(rows[curRow])
			print(rows[curRow][1])
			label1.text = tostring(rows[curRow][1])
			label2.text = tostring(rows[curRow][3])
			label3.text = tostring(rows[curRow][4])
			label4.text = tostring(rows[curRow][5])
			img.fill = { type = "image", filename = tostring(rows[curRow][2]) }
		else
			label1.text = "Out of data"
			label2.text = "----------"
			label3.text = "----------"
			label4.text = "----------"
			img.fill = { type = "image", filename = "images/fillW.png" }
		end

	end
	return True
end

button:addEventListener( "touch", onTouch )





