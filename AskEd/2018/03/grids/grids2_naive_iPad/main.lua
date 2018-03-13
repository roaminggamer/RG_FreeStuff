io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
--
local w = display.contentWidth; local h = display.contentHeight
local fullw = display.actualContentWidth; local fullh = display.actualContentHeight
local centerX = display.contentCenterX; local centerY = display.contentCenterY
local left = centerX - fullw/2; local right = centerX + fullw/2
local top = centerY - fullh/2; local bottom = centerY + fullh/2
--
local _Y_ = { 1, 1, 0, 0.25 }
local _G_ = { 0, 1, 0, 0.25 }
local _GREY_ = { 0.25, 0.25,  0.25, 0.25 }
--
local onTouch

--
-- Grid Creation Helper
--
local function createGrid( group, x, y, cols, rows, cellSize )
	group = group or display.currentStage
	x = x or centerX
	y = y or centerY
	cols = cols or 8
	rows = rows or 12
	cellSize = cellSize or 80
	--
	local grid = display.newGroup()
	group:insert( grid )
	--
	local startX = -(cols * cellSize)/2 + cellSize/2
	local startY = -(rows * cellSize)/2 + cellSize/2
	local curX   = startX
	local curY   = startY
	--
	for row = 1, rows do		
		for col = 1, cols do
			local tmp = display.newRect( grid, curX, curY, cellSize-4, cellSize-4)
			--
			tmp:setFillColor( unpack(_GREY_) )
			tmp:setStrokeColor( unpack(_Y_) )
			tmp.strokeWidth = 2
			tmp.row = row
			tmp.col = col
			tmp.touch = onTouch
			tmp:addEventListener("touch")
			--
			curX = curX + cellSize
		end
		curX = startX
		curY = curY + cellSize
	end
	--
	grid.x = x
	grid.y = y
	--
	return grid
end

--
-- Super basic touch handler to give some feedback
--
onTouch = function( self, event ) 
   if( event.phase ~= "ended" ) then return end
   --
   local parent = self.parent
   for i = 1, parent.numChildren do
   	local obj = parent[i]
   	obj:setFillColor( unpack(_GREY_) )
   end
   --
   self:setFillColor( unpack(_G_) )
   --
   print("Row: ", self.row, " Col: ", self.col )
   --
   return false
end

--
-- Start Example
--

-- 1. Add prototype background so you can see 
--    how this behaves at different resolutoins.
--local tmp = display.newImageRect( "protoBackX.png", 720, 1386 )
--tmp.x = centerX
--tmp.y = centerY

-- 2. Create Grid - createGrid( group, x, y, cols, rows, cellSize )
createGrid( nil, centerX, centerY, 24, 32, 64 )