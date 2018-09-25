io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================
-- =====================================================
-- SUPER QUICK BINGO EXAMPLE USING SSK 2: https://roaminggamer.github.io/RGDocs/pages/SSK2/
-- =====================================================
local layers = ssk.display.quickLayers( nil,  
	"background",  
	"content",
	"board" )

local font = "TitanOne-Regular.ttf"

-- Forward Declare Functions
local resetGame
local checkIfPlayerHasNum
local checkForWin
local selectNewBall
local populateBoard

local justWon = false
local gameIsRunning 	= false

-- Set this to 25 for a fast game when checking logic
local maxNumbers = 80 -- 80 -- must be evenly divisible by 5

local back = ssk.display.newImageRect( layers.background, centerX, centerY, "protoBackX.png", 
	                                    { w = 720, h = 1386 } )

-- Create 'bingo balls' bag once, fill it, then shuffle it.
local bingoBalls = ssk.shuffleBag.new()
for i = 1, maxNumbers do
	bingoBalls:insert(i)
end
bingoBalls:shuffle()

-- Bingo Game Label
local label = display.newText( layers.content, "Tap To Start", centerX, top + 50, font, 30 )
label:setFillColor(unpack(_G_))


-- Create a 'selected' bingo ball markers
local markers = {}
local rows = 5
local cols = maxNumbers/rows 
local markerSize = 38
local startX = centerX - markerSize * cols/2 + markerSize/2
local curX = startX
local curY = top + 140
for row = 1, rows do
	for col = 1, cols do
		local tmp = display.newText( layers.content, #markers+1, curX, curY, font, 20 )
		markers[#markers+1] = tmp
		tmp:setFillColor( unpack(_GREY_) )
		curX = curX + markerSize
	end
	curY = curY + markerSize
	curX = startX
end

-- Create a blank player board
local grid = {}
local rows = 5
local cols = 5
local markerSize = math.floor(w/5)
local startX = centerX - markerSize * cols/2 + markerSize/2
local curX = startX
local curY = centerY - 100

for row = 1, rows do
	for col = 1, cols do
		local tmp = display.newText( layers.content, "-", curX, curY, font, 40 )		
		grid[#grid+1] = tmp
		tmp.value = 0
		tmp.has = false
		tmp:setFillColor( unpack(_GREY_) )
		curX = curX + markerSize
	end
	curY = curY + markerSize
	curX = startX
end


checkIfPlayerHasNum = function( num )
	for i = 1, 25 do
		if ( grid[i].value == num ) then
			grid[i]:setFillColor(unpack(_G_))
			grid[i].has = true
		end
	end
end

checkForWin = function()
	-- Check rows
	for row = 1, 5 do		
		local wins = true
		for col = 1, 5 do
			local index = (row-1) * 5 + col
			if( index ~= 13 ) then
				wins = wins and grid[index].has
			end
		end
		if( wins ) then return true end
	end

	-- Check cols
	for col = 1, 5 do		
		local wins = true
		for row = 1, 5 do
			local index = (row-1) * 5 + col
			if( index ~= 13 ) then
				wins = wins and grid[index].has
			end
		end
		if( wins ) then return true end
	end

	--Check Diagonals
	if( grid[1].has and grid[7].has and grid[19].has and grid[25].has ) then
		return true 
	end
	if( grid[7].has and grid[9].has and grid[17].has and grid[21].has ) then
		return true 
	end

	return false
end

selectNewBall = function ()
	local num =  bingoBalls:get()
	--
	label.text = "New Ball: " .. tostring( num )
	label:setFillColor( 1,1,1 )
	--
	markers[num]:setFillColor(unpack(_W_))
	--
	checkIfPlayerHasNum( num )
	--
	if( checkForWin() ) then
		gameIsRunning = false
	   label.text = "YOU WIN! (Tap To Reset)"
	   label:setFillColor(unpack(_O_))	
	   justWon = true
	 end

end

resetGame = function()	
	-- Mark as NOT running
	gameIsRunning = false

	label.text = "Tap To Start"
	label:setFillColor(unpack(_G_))	

	
	--	Reset color of 'selected' balls marker
	for i = 1, #markers do
		markers[i]:setFillColor( unpack(_GREY_) )
	end

	--Shuffle 'bingo balls'
	bingoBalls:shuffle()

	-- Select 75 random numbers
	for i = 1, 25 do
		grid[i].value = 0
		grid[i].text = "-"
		grid[i].has = false
		grid[i]:setFillColor( unpack(_GREY_) )
	end
end

populateBoard = function()
	-- Create bag of numbers to use for populating our bingo grid.
	local cellNumbers = ssk.shuffleBag.new()
	for i = 1, maxNumbers do
		cellNumbers:insert(i)
	end
	cellNumbers:shuffle()
	
	-- Select 75 random numbers
	for i = 1, 25 do
		if( i == 13 ) then
			local num = cellNumbers:get()
			grid[i].value = 0
			grid[i].text = "FREE"
			grid[i]:setFillColor( unpack(_G_) )
		else
			local num = cellNumbers:get()
			grid[i].value = num
			grid[i].text = num
			grid[i]:setFillColor( unpack(_GREY_) )
		end
		
	end
end


function back.touch( self, event )
	if( event.phase ~= "ended" ) then return false end


	if( justWon ) then
		justWon = false
		resetGame()
	
	elseif( gameIsRunning ) then 		
		selectNewBall()	
	else
		label.text = "Tap To Choose Random Bingo Ball"
		label:setFillColor(unpack(_W_))
		populateBoard()
		gameIsRunning = true

	end
end; back:addEventListener( "touch" )


resetGame()