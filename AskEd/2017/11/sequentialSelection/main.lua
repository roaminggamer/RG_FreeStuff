-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
local cx = display.contentCenterX
local cy = display.contentCenterY

local buttons = {}

local function onTap( self )
	-- Get number of this object
	local myNum = self.num

	-- Check if order of selection has been violated
	local violatedOrder = false
	for i = myNum-1, 1, -1 do
		local button = buttons[i]
		if( not button.selected ) then
			violatedOrder = true
		end
	end

	-- Handle violated or not violated
	if( violatedOrder ) then
		for i = 1, myNum do
			local button = buttons[i]
			if( button.tap ) then
				buttons.tap = nil
				button:removeEventListener("tap")
			end
			button:setFillColor(1,0,0)
			button.selected = false
		end
	else
		local button = buttons[myNum]
		buttons.tap = nil
		button:removeEventListener("tap")
		button:setFillColor(0,1,0)
		button.selected = true
	end
	return true
end

local function prepExample()
	for i = 1, #buttons do
		if( buttons[i].tap ) then
			buttons[i]:removeEventListener("tap")		
		end
		buttons[i].num = i
		buttons[i].selected = false
		buttons[i]:setFillColor( 1,1,1 )
		buttons[i].tap = onTap
		buttons[i]:addEventListener("tap")
	end
end



-- Button 1
local button = display.newImageRect( "1.png", 100, 100 )
button.x = cx - 200
button.y = cy
buttons[#buttons+1] = button

-- Button 2
local button = display.newImageRect( "2.png", 100, 100 )
button.x = cx
button.y = cy
buttons[#buttons+1] = button

-- Button 3
local button = display.newImageRect( "3.png", 100, 100 )
button.x = cx + 200
button.y = cy
buttons[#buttons+1] = button

prepExample()	

--- To simplify 'reseting' example...
display.newText("Press Escape To Reset Example", cx, cy + 200)
local function onKey( event )
	if(event.keyName == "escape" and event.phase == "up" ) then
		prepExample()
	end
end
Runtime:addEventListener("key", onKey )
