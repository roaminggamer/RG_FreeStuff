-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"This demonstrates how to adjust 'dragging' code for objects in scaled groups.", 
	"",
	"1. Tap the buttons to change the group scale.",
	"2. Drag the green object to see scaled dragging.",
	"3. Drag the red object to see unscaled dragging."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


--
-- 1. Create group for scaling
local group = display.newGroup()
group.anchorChildren = true
group.x = display.contentCenterX
group.y = display.contentCenterY

--
-- 2. Implement good and bad draggers
local function unscaledDrag( self, event )
	local id = event.id
	if( event.phase == "began" ) then
		self.x1 = self.x
		self.y1 = self.y
		display.getCurrentStage():setFocus( self, id )
		self.isFocus = true
		return true

	elseif( self.isFocus ) then
		if( event.phase == "moved" ) then
			self.x = self.x1 + event.x - event.xStart
			self.y = self.y1 + event.y - event.yStart
		
		elseif( event.phase == "ended" ) then
			display.getCurrentStage():setFocus( self, nil )
			self.isFocus = false
			self.x = self.x0
			self.y = self.y0			
		end
		return true
	end
	return false
end

local function scaleAwareDrag( self, event )
	local id = event.id

	-- Figure out current total scale as applied to objects parent(s)
	local xScale = 1
	local yScale = 1
	local parent = self.parent
	while( parent ) do
		xScale = xScale * parent.xScale
		yScale = yScale * parent.yScale
		parent = parent.parent
	end

	if( event.phase == "began" ) then
		self.x1 = self.x
		self.y1 = self.y
		display.getCurrentStage():setFocus( self, id )
		self.isFocus = true
		return true

	elseif( self.isFocus ) then
		if( event.phase == "moved" ) then
			-- Adjust movement to be aware of scaling in x and y
			self.x = self.x1 + (event.x - event.xStart)/xScale
			self.y = self.y1 + (event.y - event.yStart)/yScale
		
		elseif( event.phase == "ended" ) then
			display.getCurrentStage():setFocus( self, nil )
			self.isFocus = false
			self.x = self.x0
			self.y = self.y0			
		end
		return true
	end
	return false
end


-- 3. Create two objects for dragging, using the two different draggers`
-- 
local tmp = display.newImageRect( group, "yellow_round.png", 80, 80 )
tmp.x = display.contentCenterX
tmp.y = display.contentCenterY - 40
tmp.x0 = tmp.x
tmp.y0 = tmp.y
tmp:setFillColor(1,0,0)
tmp.touch = unscaledDrag
tmp:addEventListener( "touch" )

local tmp = display.newImageRect( group, "yellow_round.png", 80, 80 )
tmp.x = display.contentCenterX 
tmp.y = display.contentCenterY + 120
tmp.x0 = tmp.x
tmp.y0 = tmp.y
tmp:setFillColor(0,1,0)
tmp.touch = scaleAwareDrag
tmp:addEventListener( "touch" )


--
-- 4. Make a functional, but simple touch handler
local buttons = {}
local function onTouch( self, event )
	if( event.phase == "ended" ) then
		for k,v in pairs( buttons ) do
			v.label:setFillColor(1,1,1)
		end
		self.label:setFillColor(0,1,0)
		local newScale = tonumber(self.label.text)
		print(newScale)
		group.xScale = newScale
		group.yScale = newScale
	end
	return true
end

--
-- 5. Make Scale Selection Buttons
for i = 1, 8 do
	local button = display.newRect( display.contentCenterX - 270 + i * 60, display.contentHeight - 30, 50, 50 )
	button:setFillColor(0.25,0.25,0.25)
	button.label = display.newText( 0.5 + (i-1) * 0.25, button.x, button.y , native.systemFont, 22 )
	if( 0.5 + (i-1) * 0.25 == 1 ) then button.label:setFillColor(0,1,0) end
	buttons[button] = button
	button.touch = onTouch
	button:addEventListener("touch")
end


