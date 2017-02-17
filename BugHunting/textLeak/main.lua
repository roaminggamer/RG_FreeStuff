-- I'm seeing weird behavior in one of my tests during debug mode.
-- This is an attempt to track down the issue, which I suspect has to do with texture memory
--

--
-- Result: Looks more like a memory cleaning artifact and a stability issue. 
-- i.e. Values settle in min/max bounds, but do not climb continously.
--

--
-- Note: This is not exactly what I'm seeing in my game.
--

io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

local initial

local enforceStability = true 
local maxmmem = 0
local maxtmem = 0
local function getMem()
	collectgarbage("collect") -- Collect garbage every frame to get 'true' current memory usage
	local mmem = collectgarbage( "count" ) 
	local tmem = system.getInfo( "textureMemoryUsed" )

	if( maxmmem < mmem) then maxmmem = mmem end
	if( maxtmem < tmem) then maxtmem = tmem end
	if( not enforceStability ) then
		maxmmem = mmem
		maxtmem = tmem
	end
	return string.format( "%8.5f : %0.0f", maxmmem, maxtmem )
end

local group = display.newGroup()

local function enterFrame()
	--display.remove(group)
	--for i = 1, 1000 do
		group.alpha = 0
		group = display.newGroup()
		display.newText( group, getMem(), display.contentCenterX, display.contentCenterY, "Prime.ttf", 48 )

		function group.timer(self) display.remove(self) end 
		timer.performWithDelay( 5000, group )
	--end
end

Runtime:addEventListener( "enterFrame", enterFrame )

--timer.performWithDelay( 10000, function() maxmmem = 0; maxtmem = 0; end )