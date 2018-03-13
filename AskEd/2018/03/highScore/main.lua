-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init( { } )
-- =============================================================

ssk.persist.setDefault( "score.json", "highScore", 0 )

-- =============================================================
local score = 0

local pGet = ssk.persist.get 
local pSet = ssk.persist.set

local scoreLabel = display.newText( "Score: " .. tostring(score), 100, 150 )
scoreLabel.anchorX = 0

local highScoreLabel = display.newText( "High Score: " .. tostring(pGet("score.json", "highScore")), display.contentCenterX, 150 )
highScoreLabel.anchorX = 0

local function checkForNewHighScore()
	if( score > pGet("score.json", "highScore") ) then
		pSet("score.json", "highScore", score )
		highScoreLabel.text = "High Score: " .. tostring(pGet("score.json", "highScore"))
	end
end


local button = display.newCircle( display.contentCenterX, display.contentCenterY +200, 50 )

function button.touch( self, event )
	if( event.phase == "began" ) then
		score = score + 1
		scoreLabel.text = "Score: " .. tostring(score)
		checkForNewHighScore()
	end
	return false
end

button:addEventListener("touch")
