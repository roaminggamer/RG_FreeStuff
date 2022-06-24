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
local label1_frame = display.newImageRect( "images/fillW.png", fullw/2 + 10, 1 )
label1_frame.x = cx
label1_frame:setFillColor( 0.2, 0.2, 0.2 )
local label1 = display.newText( { text = "Press Button To Start", x = cx, y = top + 20, font = native.systemFont, fontSize = 16, width = fullw/2 } )


local label2_frame = display.newImageRect( "images/fillW.png", fullw/2 + 10, 1 )
label2_frame.x = cx
label2_frame:setFillColor( 0.7, 0.2, 0.2 )
local label2 = display.newText( { text = "----------", x = cx, y = top + 40, font = native.systemFont, fontSize = 16, width = fullw/2 } )

local label3_frame = display.newImageRect( "images/fillW.png", fullw/2 + 10, 1 )
label3_frame.x = cx
label3_frame:setFillColor( 0.2, .7, 0.2 )
local label3 = display.newText( { text = "----------", x = cx, y = top + 60, font = native.systemFont, fontSize = 16, width = fullw/2 } )

local label4_frame = display.newImageRect( "images/fillW.png", fullw/2 + 10, 1 )
label4_frame.x = cx
label4_frame:setFillColor( 0.2, 0.2, 0.7 )
local label4 = display.newText( { text = "----------", x = cx, y = top + 80, font = native.systemFont, fontSize = 16, width = fullw/2 } )

local img = display.newImageRect( "images/fillW.png", 64, 64 )
img.x = cx
img.y = bottom - 50

local function resize_reposition()
	
	-- Resize label 1 frame and reposition it then label 1	
	label1_frame.height = label1.height + 40
	label1_frame.y = top + label1_frame.height/2 + 10
	label1.y = label1_frame.y

	-- Resize label 2 frame and reposition it then label 2
	label2_frame.height = label2.height + 40
	label2_frame.y = label1_frame.y + label1_frame.height/2 + label2_frame.height/2 + 10
	label2.y = label2_frame.y

	-- Resize label 3 frame and reposition it then label 2
	label3_frame.height = label3.height + 40
	label3_frame.y = label2_frame.y + label2_frame.height/2 + label3_frame.height/2 + 10
	label3.y = label3_frame.y

	-- Resize label 4 frame and reposition it then label 2
	label4_frame.height = label4.height + 40
	label4_frame.y = label3_frame.y + label3_frame.height/2 + label4_frame.height/2 + 10
	label4.y = label4_frame.y
end

resize_reposition()


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

		resize_reposition()

	end
	return True
end

button:addEventListener( "touch", onTouch )





