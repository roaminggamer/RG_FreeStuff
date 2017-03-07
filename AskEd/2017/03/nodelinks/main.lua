io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

local mRand = math.random
local getTimer = system.getTimer

local left = display.contentCenterX - display.actualContentWidth/2
local right = left + display.actualContentWidth
local top = display.contentCenterY - display.actualContentHeight/2
local bottom = top + display.actualContentHeight

local nodes = {}
local lines = {}

local testCount = 15

local function enterFrame( )	

	-- Destroy all lines from last frame
	for i = 1, #lines do
		display.remove( lines[i])		
	end
	lines = {}
	
	-- Clean the nodes
	for i = 1, #nodes do
		nodes[i].linkedTo = {}
	end

	-- Draw new lines, but be efficient
	for i = 1, #nodes do
		local nodeA = nodes[i]
		for j = 1, #nodes do
			local nodeB = nodes[j]
			if( not nodeA.linkedTo[nodeB] ) then
				local line = display.newLine( nodeA.x, nodeA.y, nodeB.x, nodeB.y )
				nodeA.linkedTo[nodeB] = line
				nodeB.linkedTo[nodeA] = line
				line:toBack()
				line:setStrokeColor(mRand(),mRand(),mRand())
				line.strokeWidth = 2 
				lines[#lines+1] = line
			end
		end
	end
end

-- Not a great touch function so drag slowly
local function touch( self, event )
	self:toFront()
	self.x = event.x
	self.y = event.y 
	return true
end


-- Draw 'fake' nodes
for i = 1, testCount do
	local tmp = display.newImageRect( "circle.png", 50, 50  )
	
	tmp.x = mRand( left + 50, right - 50 )
	tmp.y = mRand( top + 50, bottom - 50 )

	tmp:setFillColor(mRand(),mRand(),mRand())

	tmp.touch = touch
	tmp:addEventListener("touch")

	nodes[#nodes+1] = tmp
end

Runtime:addEventListener( "enterFrame", enterFrame )
