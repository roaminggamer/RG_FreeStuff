io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
local back = display.newImageRect( "protoBackX.png", 720, 1386 )
back.x = display.contentCenterX
back.y = display.contentCenterY
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end
-- =====================================================
-- =====================================================

local dtLabel = display.newText( 0, display.contentCenterX, display.contentCenterY, nil, 100 )

local function runForDuration( duration, onComplete )
	local t = os.date( '*t' )
	local startTime = os.time(t)

	dtLabel.text = 0
	
	local function waiting()
		local t = os.date( '*t' )
		local curTime = os.time(t)
		
		local deltaTime = curTime - startTime
		dtLabel.text = deltaTime

		if( deltaTime >= duration ) then
			dtLabel.text = duration
			if( onComplete ) then 
				onComplete() 
			end
		else 
			timer.performWithDelay( 100, waiting )
		end
	end

	waiting()
end

local function finished()
	dtLabel.text = "DONE!"
end

runForDuration( 2, finished )