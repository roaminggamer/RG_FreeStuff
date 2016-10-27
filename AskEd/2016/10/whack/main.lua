-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
-- BEGIN ANSWER
-- =============================================================

-- Table to track moles
local moles = {}

-- Score Counter
local score = 0

-- Score Label
local scoreLabel = display.newText( "Score: 0", 
	                                 display.contentCenterX, 
	                                 display.contentCenterY - 
	                                 display.actualContentHeight/2 + 50, 
                                    native.systemFontBold, 36 )

-- Handle for last timer
local lastTimer

-- Function to select a mole
local function selectNewMole( subtractOne )
	if (lastTimer) then 
		timer.cancel( lastTimer )
	end

	-- Player never tapped mole, take away a point
	if( subtractOne ) then
		score = score - 1
		scoreLabel.text = "Score: " .. score
	end

	-- Clear all moles
	for i = 1, #moles do
		moles[i]:setFillColor( 1, 0, 0 )
		moles[i].isBlue = false
	end

	-- Choose a random mole and make it blue
	local moleNum = math.random( 1, #moles )
	moles[moleNum]:setFillColor( 0, 0, 1 )
	moles[moleNum].isBlue = true

	-- Select a new mole in 1.5 seconds
	lastTimer = timer.performWithDelay( 1500, function() selectNewMole(true) end )
end


-- Common touch listener for moles
local touch = function( self, event )
	if( event.phase == "began" ) then

		if( self.isBlue ) then
			-- Right mole, get a point
			self.isBlue = false
			score = score + 1
			selectNewMole()
		else
			-- Wrong mole, lose a point
			score = score - 1
		end
	end
	scoreLabel.text = "Score: " .. score
	return true
end


-- Create the 'moles'
local moleSize 	= 120
local moleSpacing = 160
local startX 	= display.contentCenterX  - moleSpacing
local startY 	= display.contentCenterY  - moleSpacing
for i = 1, 3 do
	for j = 1, 3 do
		local mole = display.newRect( startX + (i-1) * moleSpacing, 
			                           startY + (j-1) * moleSpacing,
			                           moleSize, moleSize)
		-- Start all moles as red
		mole:setFillColor( 1, 0, 0 )

		-- Add common touch listener to this mole
		mole.touch = touch
		mole:addEventListener( "touch" )

		-- Save the mole in our list
		moles[#moles+1] = mole
	end
end



selectNewMole()


-- =============================================================
-- END ANSWER
-- =============================================================

