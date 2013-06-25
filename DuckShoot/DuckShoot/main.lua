_G.w = display.contentWidth
_G.h = display.contentHeight

_G.centerX = w/2
_G.centerY = h/2

-- ==
--    round(val, n) - Rounds a number to the nearest decimal places. (http://lua-users.org/wiki/FormattingNumbers)
--    val - The value to round.
--    n - Number of decimal places to round to.
-- ==
function _G.round(val, n)
  if (n) then
    return math.floor( (val * 10^n) + 0.5) / (10^n)
  else
    return math.floor(val+0.5)
  end
end


function convertSecondsToTimer( seconds )
	local seconds = tonumber(seconds)
	local minutes = math.floor(seconds/60)
	local remainingSeconds = seconds - (minutes * 60)

	local timerVal = "" 

	if(remainingSeconds < 10) then
		timerVal =  minutes .. ":" .. "0" .. remainingSeconds
	else
		timerVal = minutes .. ":"  .. remainingSeconds
	end

	return timerVal
end


local startTime = -1
local lastTime = startTime

local botLayer = display.newGroup()
local midLayer = display.newGroup()
local topLayer = display.newGroup()


local timer = display.newText( topLayer, "0:00", 0, 0, native.systemFont, 32)
timer.x = centerX - w/4
timer.y = 60


local score = display.newText( topLayer, 0, 0, 0, native.systemFont, 32)
score.x = centerX + w/4
score.y = 60


local function onEnterFrame( event )

	local curTime = event.time

	if(startTime == -1) then
		startTime = curTime
	end
	
	local delta = curTime - lastTime

	if( delta >= 1000 ) then
		lastTime = curTime
		--print( convertSecondsToTimer( (curTime-lastTime)/1000 ) ) 
		--print( lastTime/1000 ) 
		local newTime = convertSecondsToTimer( round(lastTime/1000) )
		timer.text = newTime
		--print(  )
	end
end

Runtime:addEventListener( "enterFrame", onEnterFrame )

local bar = display.newRect( midLayer, 0, 0, w, 60 )
bar:setFillColor( 0, 0, 128 )
bar.x = centerX
bar.y = centerY + 60

local ping = audio.loadSound("ping.wav")

local function onTouch( self, event )
	if(event.phase == "ended") then
		transition.to( self, { yScale  = 0.05, time = 100, y = self.y + self.height/2 } )
		audio.play( ping )
		score.text = score.text + 1
	end
	return true
end


local function newDuck( y, delay )

	local duck = display.newImageRect( botLayer, "duck.png",80, 63 )
	duck.x = w + w/4
	duck.y = y

	duck.x0 = duck.x
	duck.y0 = duck.y

	duck.touch = onTouch

	duck:addEventListener( "touch", duck )

	local onComplete

	onComplete = function( obj )
		obj.x = obj.x0
		obj.y = obj.y0
		obj.xScale = 1
		obj.yScale = 1
		transition.to( obj, { x = -w/4, time = 6000, onComplete = onComplete } )
	end

	transition.to( duck, { x = -w/4, time = 6000, delay = delay, onComplete = onComplete } )

end

newDuck( centerY, 0 )
newDuck( centerY, 1000 )
newDuck( centerY, 2000 )
newDuck( centerY, 3000 )
newDuck( centerY, 4000 )
newDuck( centerY, 5000 )


