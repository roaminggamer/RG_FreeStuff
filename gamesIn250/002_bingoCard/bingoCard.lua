-- =====================================================
-- Module Begins
-- =====================================================
local public = {}

function public.create( group, x, y, params )
	group = group or display.currentStage
	params = params or {}
	--
	local maxNumbers 	= params.maxNumbers or maxNumbers
	local cellColors 	= {}
	cellColors[1] 		= params.cellColor1 or hexcolor("FFFFFF")
	cellColors[2] 		= params.cellColor2 or hexcolor("808080")	
	local numberColor = params.numberColor or hexcolor("000000")	
	local strokeColor = params.strokeColor or hexcolor("00FF00")
	local bingoColor = params.bingoColor or hexcolor("FFFFFF")
	local cellSize 	= params.cellSize or 112
	local cellTween 	= params.cellTween or 120
	local strokeWidth = params.strokeWidth or 6
	local maxNumbers 	= params.maxNumbers or 80
	maxNumbers = (maxNumbers < 25) and 25 or maxNumbers
	--
	local gameIsRunning = true
	--
	local numbers = params.numbers or {1,2,3,4,5, 6,7,8,9,10, 11,12,-1,14,15, 16,17,18,19,20, 21,22,23,24,25 }
	--
	if( params.randomize ) then
		local tmp = {}
		for i = 1, maxNumbers do
			tmp[i] = i
		end
		table.shuffle( tmp )
		numbers = {}
		for i = 1, 25 do
			numbers[i] = tmp[i]
		end
		numbers[13] = -1
	end
	--
	--
	local board = params.board or display.newGroup()
	group:insert(board)
	board.x = x
	board.y = y
	--
	local function resetGame()
		while( board.numChildren > 0 ) do
			display.remove(board[1])
		end
		--
		params.randomize = true
		params.board = board
		--
		public.create( group, x, y, params )
	end
	--
	local cells 	= {}
	local startX 	= -2 * cellTween
	local startY 	= -2 * cellTween
	local curX 		= startX
	local curY 		= startY
	local num 		= 1
	local resetButton 
	--
	local bingoLabel = display.newText( board, "BINGO", 0, startY - cellSize, "Lato-Black.ttf", math.ceil(cellSize/2) )
	bingoLabel:setFillColor(unpack(bingoColor))
	bingoLabel.isVisible = false
	--
	local function allCellsSelected( ... )
		local selected = true
		for _, index in ipairs(arg) do
        	selected = selected and cells[index].selected
		end
		return selected
	end
	--
	local function touch( self, event )
		if( event.phase == "ended" ) then
			self.selected = not self.selected

			if( self.selected ) then
				self.strokeWidth = strokeWidth
			else
				self.strokeWidth = 0
			end
			
			-- Check for bingo
			resetButton.isVisible = false
			resetButton.label.isVisible = false
			if( -- ROWS 
				 allCellsSelected(1,2,3,4,5) or
				 allCellsSelected(6,7,8,9,10) or
				 allCellsSelected(11,12,13,14,15) or
				 allCellsSelected(16,17,18,19,20) or
				 allCellsSelected(21,22,23,24,25) or
				 -- COLS
				 allCellsSelected(1,6,11,16,21) or
				 allCellsSelected(2,7,12,17,22) or
				 allCellsSelected(3,8,13,18,23) or
				 allCellsSelected(4,9,14,19,24) or
				 allCellsSelected(5,10,15,20,25) or

				 -- DIAGONALS
				 allCellsSelected(1,7,13,19,25) or
				 allCellsSelected(5,9,13,17,21) ) then
				resetButton.isVisible = true
				--
				bingoLabel.isVisible = true
				resetButton.isVisible = true
				resetButton.label.isVisible = true
				--
				gameIsRunning = false
			end
		end
	end
	--
	for row = 1, 5 do
		for col = 1, 5 do
			local cell = display.newRect( board, curX, curY, cellSize, cellSize )
			cells[num] = cell
			--
			cell.number = numbers[num]
			cell.row = row
			cell.col = col
			--
			if( num == 13 ) then
				cell.label = display.newText( board, "FREE", curX, curY, "Lato-Black.ttf", math.ceil(cellSize/3) )
				cell.label:setFillColor(unpack(numberColor))
				cell.strokeWidth = strokeWidth				
				cell:setStrokeColor(unpack(strokeColor))
				cell.selected = true
			else
				cell.label = display.newText( board, numbers[num], curX, curY, "Lato-Black.ttf", math.ceil(cellSize/3) )
				cell.label:setFillColor(unpack(numberColor))
				cell.strokeWidth = 0
				cell:setStrokeColor(unpack(strokeColor))
				cell.touch = touch
				cell:addEventListener("touch")
				cell.selected = false
			end
			--
			if( math.isEven(num) ) then
				cell:setFillColor(unpack(cellColors[2]))
			else
				cell:setFillColor(unpack(cellColors[1]))
			end
			curX = curX + cellTween
			num = num + 1
		end
		curX = startX
		curY = curY + cellTween
	end
	--
	resetButton = display.newImageRect( board, "fillT.png", 100, 60 )
	resetButton.x = 0
	resetButton.y = curY
	resetButton.isVisible = false
	resetButton.label = display.newText( board, "RESET", resetButton.x, resetButton.y, "Lato-Black.ttf", 24 )
	resetButton.label:setFillColor(1,1,1)
	resetButton.label.isVisible = false
	--
	function resetButton.touch( self, event )
		if( event.phase == "ended" and gameIsRunning == false ) then
			timer.performWithDelay(1,  resetGame )
		end
		return false
	end
	resetButton:addEventListener("touch")


	return board
end


return public
