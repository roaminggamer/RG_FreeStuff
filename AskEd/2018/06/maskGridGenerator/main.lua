io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
ssk.meters.create_fps(true)
ssk.meters.create_mem(true)
--ssk.misc.enableresListhotHelper("s") 
-- =====================================================

local function createMasks( width, height, rows, cols )
	local group = display.newGroup()
	local cellw = width/cols
	local cellh = height/rows

	local mask

	local function drawCell( row, col )
		display.remove( mask )
		mask = display.newGroup()
		local back = display.newRect( mask, 0, 0, width, height )
		back.anchorX = 0
		back.anchorY = 0
		back:setFillColor(0,0,0)
		local cell = display.newRect( mask, (col-1) * cellw, (row-1) * cellh, cellw, cellh )
		cell.anchorX = 0
		cell.anchorY = 0
		local frame = display.newRect( mask, 2, 2, width-4, height-4 )
		frame.anchorX = 0
		frame.anchorY = 0
		frame:setFillColor(0,0,0,0)
		frame:setStrokeColor(0,0,0)
		frame.strokeWidth = 3
	end
	local delay = 100
	for row = 1, rows do
		for col = 1, cols do
			local i, j = row, col
			timer.performWithDelay( delay, 
				function()
					drawCell( i, j )
					nextFrame( function() display.save( mask, { filename="mask_" .. i .. "_" .. j .. "_.png", baseDir=system.DocumentsDirectory, captureOffscreenArea=true} ) end )
				end )
			delay = delay + 100
		end
	end
end

local function useMasks( img, width, height, rows, cols )
	local progress = display.newText( "", centerX, top + 5 )
	progress.anchorY = 0
	local max = rows * cols
	local parts = {}
	local delay = 100
	for row = 1, rows do
		for col = 1, cols do
			local i, j = row, col
			timer.performWithDelay( delay, 
				function()			
					local part = display.newImageRect( img, width, height )			
					part.x = centerX
					part.y = centerY
					local mask = graphics.newMask( "masks/mask_" .. i .. "_" .. j .. "_.png" )
					part:setMask( mask )
					parts[#parts+1] = part
					if( #parts == max ) then
						progress.text = "Ready!"
					else
						progress.text = round( (#parts/max) * 100) .. "% ready"
					end					
					--
					ssk.misc.addSmartDrag( part, { toFront = true, retval = true } )
				end )
			delay = delay + 100
		end
	end
end

--createMasks( 600, 480, 3, 3 )
useMasks( "Amsterdam.png", 600, 480, 3, 3 )
