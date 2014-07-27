local w = display.contentWidth
local h = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

local mRand = math.random


local function createRandomList( count )
	local list = {}
	for i = 1, count do
		local entry = { x = centerX + mRand( -w/2, w/2 ), 
		                y = centerY + mRand( -h/2, h/2), 
		                time = mRand( 4000, 8000 ) }
		list[i] = entry
	end
	list[#list+1] = { x = centerX, y = centerY }
	return list
end

local function moveRandomly( self )

	if(self.index > #self.myList) then return end
	local entry = self.myList[self.index]
	self.index = self.index + 1
	transition.to( self, { x = entry.x, y = entry.y, entry.time, onComplete = self.move } )
end

local function doTest( color )
	local obj = display.newCircle(0,0, 20)
	obj:setFillColor(unpack(color))
	obj.myList = createRandomList( 20 )

	obj.move = moveRandomly
	obj.index = 1

	obj:move()
end



doTest( { 1, 1, 0 } )
timer.performWithDelay( 1000, function() doTest( { 1, 0, 0 } ) end )
timer.performWithDelay( 2000, function() doTest( { 1, 0, 1 } ) end )
timer.performWithDelay( 3000, function() doTest( { 0, 1, 1 } ) end )