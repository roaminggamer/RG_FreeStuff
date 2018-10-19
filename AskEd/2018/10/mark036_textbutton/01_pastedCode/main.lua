io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
--require "ssk2.loadSSK"
--_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================
local widget = require( "widget" )

local winningLine
local winningText
local resetButton
local allowMoves = true

local spots = {}
local player = "X" -- Player X goes first 
local winPatterns = {}
winPatterns[1] = { 1, 2, 3, 4, 5 } -- horizontal row 1
winPatterns[2] = { 6, 7, 8, 9, 10 } -- horizontal row 2
winPatterns[3] = { 11, 12, 13, 14, 15 } -- horizontal row 3
winPatterns[4] = { 16, 17, 18, 19, 20 } -- horizontal row 4
winPatterns[5] = { 21, 22, 23, 24, 25 } -- horizontal row 5
winPatterns[6] = { 1, 6, 11, 16, 21 } -- vertical column 1
winPatterns[7] = { 2, 7, 12, 17, 22 } -- vertical column 2
winPatterns[8] = { 3, 8, 13, 18, 23 } -- vertical column 3
winPatterns[9] = { 4, 9, 14, 19, 24 } -- vertical column 4
winPatterns[10] = { 5, 10, 15, 20, 25 } -- vertical column 5
winPatterns[11] = { 1, 7, 13, 19, 25 } -- top left to bottom right diagonal
winPatterns[12] = { 21, 17, 13, 9, 5 } -- bottom left to top right diagonal

local function resetGame()
    for i = 1, #spots do
        spots[i].moveText.text = " "
        spots[i].moveType = nil
    end
    display.remove( winningLine )
    winningLine = nil
    display.remove( winningText )
    winningText = nil
    display.remove( winningText2 )
    winningText2 = nil
        display.remove( resetButton )
    resetButton = onPress
    player = "X"
    allowMoves = true
    end

local function gameOver( winningMove, currentPlayer )
    -- lets draw a line thru the winning numbers
    allowMoves = false
    if winningMove then
        local startX = spots[ winPatterns[ winningMove ][1] ].x
        local startY = spots[ winPatterns[ winningMove ][1] ].y
        local endX = spots[ winPatterns[ winningMove ][5] ].x
        local endY = spots[ winPatterns[ winningMove ][5] ].y
        winningLine = display.newLine( startX, startY, endX, endY )
        winningLine:setStrokeColor( 1, 0, 0, 0.5 )
        winningLine.strokeWidth = 50
        winningText = display.newText( "Bingo!", display.contentCenterX -50, display.contentHeight, display.contentCenterY -50, display.contentWidth +320, native.systemFontBold, 15)
        winningText2 = display.newText( "Bingo!", display.contentCenterX -50, display.contentHeight, display.contentCenterY -50, display.contentWidth +350, native.systemFontBold, 15)
    

    end
    
    resetButton = widget.newButton({
		label = "Reset",
        x = display.contentCenterX +120,
        y = display.contentHeight -320,
        font = native.systemFontBold,
        fontSize = 20,
        labelColor = { default = { 1,1,1}, over = { 1, 0, 0 } },
        onPress = resetGame
    })
	
    
    end
    
local function isGameOver( currentPlayer )
    local isWinner = false
    for i = 1, #winPatterns do
        if  spots[winPatterns[i][1]].moveType == currentPlayer and
                 spots[winPatterns[i][2]].moveType == currentPlayer and
                 spots[winPatterns[i][3]].moveType == currentPlayer and
                 spots[winPatterns[i][4]].moveType == currentPlayer and
               spots[winPatterns[i][5]].moveType == currentPlayer then
            -- we have a winner!
             isWinner = true
            gameOver( i, currentPlayer )
            break
        end
    end    
end

local function handleMove( event )
    if event.phase == "began" then
        if event.target.moveType == nil and allowMoves then
            event.target.moveText.text = player
            event.target.moveType = player  

            isGameOver( player )
        end
    end
    return true
end

local VerticalLine1 = display.newRect( display.contentCenterX - 150, display.contentCenterY + 85, 5, 305 )
VerticalLine1:setFillColor( 0.1, 0.1, 0.1 )
local VerticalLine2 = display.newRect( display.contentCenterX - 90, display.contentCenterY + 85, 5, 305)
VerticalLine2:setFillColor( 0.1, 0.1, 0.1 )
local VerticalLine3 = display.newRect( display.contentCenterX - 30, display.contentCenterY + 85, 5, 305 )
VerticalLine3:setFillColor( 0.1, 0.1, 0.1 )
local VerticalLine4 = display.newRect( display.contentCenterX +30, display.contentCenterY + 85, 5, 305 )
VerticalLine4:setFillColor( 0.1, 0.1, 0.1 )
local VerticalLine5 = display.newRect( display.contentCenterX +90, display.contentCenterY + 85, 5, 305 )
VerticalLine5:setFillColor( 0.1, 0.1, 0.1 )
local VerticalLine6 = display.newRect( display.contentCenterX +150, display.contentCenterY + 85, 5, 305 )
VerticalLine6:setFillColor( 0.1, 0.1, 0.1 )
local HorizontalLine1 = display.newRect( display.contentCenterX, display.contentCenterY -80, 305, 35 )
HorizontalLine1 : setFillColor( 0, 0, 0 )
local HorizontalLine2 = display.newRect( display.contentCenterX, display.contentCenterY -5, 300, 5 )
HorizontalLine2:setFillColor( 0.1, 0.1, 0.1 )
local HorizontalLine3 = display.newRect( display.contentCenterX, display.contentCenterY + 55, 300, 5 )
HorizontalLine3:setFillColor( 0.1, 0.1, 0.1 )
local HorizontalLine4 = display.newRect( display.contentCenterX, display.contentCenterY + 115, 300, 5 )
HorizontalLine4:setFillColor( 0.1, 0.1, 0.1 )
local HorizontalLine5 = display.newRect( display.contentCenterX, display.contentCenterY + 175, 300, 5 )
HorizontalLine5:setFillColor( 0.1, 0.1, 0.1 )
local HorizontalLine6 = display.newRect( display.contentCenterX, display.contentCenterY + 235, 300, 5 )
HorizontalLine6:setFillColor( 0.1, 0.1, 0.1 )

local myText = display.newText( "B", 0, 0, native.systemFontBold, 60 )
myText:setFillColor( 0.1, 0.1, 0.1, 0.5 )
myText.anchorX = 0
myText.x = 20
myText.y = 205
local myText = display.newText( "B", 0, 0, native.systemFontBold, 60 )
myText:setFillColor( 0.1, 0.1, 0.1, 0.5 )
myText.anchorX = 0
myText.x = 20
myText.y = 265
local myText = display.newText( "B", 0, 0, native.systemFontBold, 60 )
myText:setFillColor( 0.1, 0.1, 0.1, 0.5 )
myText.anchorX = 0
myText.x = 20
myText.y = 325
local myText = display.newText( "B", 0, 0, native.systemFontBold, 60 )
myText:setFillColor( 0.1, 0.1, 0.1, 0.5 )
myText.anchorX = 0
myText.x = 20
myText.y = 385
local myText = display.newText( "B", 0, 0, native.systemFontBold, 60 )
myText:setFillColor( 0.1, 0.1, 0.1, 0.5 )
myText.anchorX = 0
myText.x = 20
myText.y = 445

local myText = display.newText( "I", 0, 0, native.systemFontBold, 60 )
myText:setFillColor( 0.1, 0.1, 0.1, 0.5 )
myText.anchorX = 0
myText.x = 90
myText.y = 205
local myText = display.newText( "I", 0, 0, native.systemFontBold, 60 )
myText:setFillColor( 0.1, 0.1, 0.1, 0.5 )
myText.anchorX = 0
myText.x = 90
myText.y = 265
local myText = display.newText( "I", 0, 0, native.systemFontBold, 60 )
myText:setFillColor( 0.1, 0.1, 0.1, 0.5 )
myText.anchorX = 0
myText.x = 90
myText.y = 325
local myText = display.newText( "I", 0, 0, native.systemFontBold, 60 )
myText:setFillColor( 0.1, 0.1, 0.1, 0.5 )
myText.anchorX = 0
myText.x = 90
myText.y = 385
local myText = display.newText( "I", 0, 0, native.systemFontBold, 60 )
myText:setFillColor( 0.1, 0.1, 0.1, 0.5 )
myText.anchorX = 0
myText.x = 90
myText.y = 445

local myText = display.newText( "N", 0, 0, native.systemFontBold, 60 )
myText:setFillColor( 0.1, 0.1, 0.1, 0.5 )
myText.anchorX = 0
myText.x = 140
myText.y = 205
local myText = display.newText( "N", 0, 0, native.systemFontBold, 60 )
myText:setFillColor( 0.1, 0.1, 0.1, 0.5 )
myText.anchorX = 0
myText.x = 140
myText.y = 265
local myText = display.newText( "N", 0, 0, native.systemFontBold, 60 )
myText:setFillColor( 0.1, 0.1, 0.1, 0.5 )
myText.anchorX = 0
myText.x = 140
myText.y = 325
local myText = display.newText( "N", 0, 0, native.systemFontBold, 60 )
myText:setFillColor( 0.1, 0.1, 0.1, 0.5 )
myText.anchorX = 0
myText.x = 140
myText.y = 385
local myText = display.newText( "N", 0, 0, native.systemFontBold, 60 )
myText:setFillColor( 0.1, 0.1, 0.1, 0.5 )
myText.anchorX = 0
myText.x = 140
myText.y = 445

local myText = display.newText( "G", 0, 0, native.systemFontBold, 60 )
myText:setFillColor( 0.1, 0.1, 0.1, 0.5 )
myText.anchorX = 0
myText.x = 195
myText.y = 205
local myText = display.newText( "G", 0, 0, native.systemFontBold, 60 )
myText:setFillColor( 0.1, 0.1, 0.1, 0.5 )
myText.anchorX = 0
myText.x = 195
myText.y = 265
local myText = display.newText( "G", 0, 0, native.systemFontBold, 60 )
myText:setFillColor( 0.1, 0.1, 0.1, 0.5 )
myText.anchorX = 0
myText.x = 195
myText.y = 325
local myText = display.newText( "G", 0, 0, native.systemFontBold, 60 )
myText:setFillColor( 0.1, 0.1, 0.1, 0.5 )
myText.anchorX = 0
myText.x = 195
myText.y = 385
local myText = display.newText( "G", 0, 0, native.systemFontBold, 60 )
myText:setFillColor( 0.1, 0.1, 0.1, 0.5 )
myText.anchorX = 0
myText.x = 195
myText.y = 445

local myText = display.newText( "O", 0, 0, native.systemFontBold, 60 )
myText:setFillColor( 0.1, 0.1, 0.1, 0.5 )
myText.anchorX = 0
myText.x = 255
myText.y = 205
local myText = display.newText( "O", 0, 0, native.systemFontBold, 60 )
myText:setFillColor( 0.1, 0.1, 0.1, 0.5 )
myText.anchorX = 0
myText.x = 255
myText.y = 265
local myText = display.newText( "O", 0, 0, native.systemFontBold, 60 )
myText:setFillColor( 0.1, 0.1, 0.1, 0.5 )
myText.anchorX = 0
myText.x = 255
myText.y = 325
local myText = display.newText( "O", 0, 0, native.systemFontBold, 60 )
myText:setFillColor( 0.1, 0.1, 0.1, 0.5 )
myText.anchorX = 0
myText.x = 255
myText.y = 385
local myText = display.newText( "O", 0, 0, native.systemFontBold, 60 )
myText:setFillColor( 0.1, 0.1, 0.1, 0.5 )
myText.anchorX = 0
myText.x = 255
myText.y = 445

for i = 1, 25 do
    spots[i] = display.newRect( 0, 0, 55, 55)
    spots[i]:setFillColor( 0.2,0.2,0.2,0.3 )
    spots[i].x = ( i - 1 ) % 5 * 60 + 40
    spots[i].y = math.floor( ( i - 1 ) / 5 ) * 60 + 205
    spots[i].moveText = display.newText( " ", spots[i].x, spots[i].y, native.systemFontBold, 60)
    spots[i].moveType = nil

    spots[i]:addEventListener( "touch", handleMove )
end

    local myPlayer1 = display.newImageRect("free.png", 55, 55)
myPlayer1.x = 160
myPlayer1.y = 325

for i = 1, 25 do
    spots[i] = display.newRect( 0, 0, 55, 55)
    spots[i]:setFillColor( 0.2,0.2,0.2,0.1 )
    spots[i].x = ( i - 1 ) % 5 * 60 + 40
    spots[i].y = math.floor( ( i - 1 ) / 5 ) * 60 + 205
    spots[i].moveText = display.newText( " ", spots[i].x, spots[i].y, native.systemFontBold, 60)
    spots[i].moveType = nil

    spots[i]:addEventListener( "touch", handleMove )
end

    local B = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 }
local I = { 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 }
local N = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45 }
local G = { 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58 ,59, 60 }
local O = { 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75 }

math.randomseed( os.time() )  -- Seed the pseudo-random number generator

local function shuffleTable( t )

    if ( type(t) ~= "table" ) then
        print( "WARNING: shuffleTable() function expects a table" )
        return false
    end

    local j

    for i = #t, 2, -1 do
        j = math.random( i )
        t[i], t[j] = t[j], t[i]
    end
    return t
end
shuffleTable( B )
shuffleTable( I )
shuffleTable( N )
shuffleTable( G )
shuffleTable( O )

local B_spots = {}
local I_spots = {}
local N_spots = {}
local G_spots = {}
local O_spots = {}

for i = 1, 5 do
    B_spots[i] = display.newText( B[i],  45, i * 105, native.systemFontBold, 28 )
    B_spots[i] : setFillColor(1, 1, 1 )
    I_spots[i] = display.newText( I[i], 100, i * 105, native.systemFontBold, 28 )
    B_spots[i] : setFillColor(1, 1, 1 )
    N_spots[i] = display.newText( N[i], 160, i * 105, native.systemFontBold, 28 )
    B_spots[i] : setFillColor(1, 1, 1 )
    G_spots[i] = display.newText( G[i], 220, i * 105, native.systemFontBold, 28 )
    B_spots[i] : setFillColor(1, 1, 1 )
    O_spots[i] = display.newText( O[i], 280, i * 105, native.systemFontBold, 28 )
    B_spots[i] : setFillColor(1, 1, 1 )
    B_spots[i].y = math.floor( ( i - 1 ) / 1 ) * 60 + 205
    I_spots[i].y = math.floor( ( i - 1 ) / 1 ) * 60 + 205
    N_spots[i].y = math.floor( ( i - 1 ) / 1 ) * 60 + 205
    G_spots[i].y = math.floor( ( i - 1 ) / 1 ) * 60 + 205
    O_spots[i].y = math.floor( ( i - 1 ) / 1 ) * 60 + 205
    B_spots[i].moveType = nil
    I_spots[i].moveType = nil
    N_spots[i].moveType = nil
    G_spots[i].moveType = nil
    O_spots[i].moveType = nil
    spots[i]:addEventListener( "touch", handleMove )
end
N_spots[3].text = " "  


resetButton2 = widget.newButton({
        label = "Reset",
        x = display.contentCenterX +120,
        y = display.contentHeight -320,
        font = native.systemFontBold,
        fontSize = 20,
        labelColor = { default = { 1,1,1}, over = { 1, 0, 0 } },
        onPress = resetGame
    })
    
