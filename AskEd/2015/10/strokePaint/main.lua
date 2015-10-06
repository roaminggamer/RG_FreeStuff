local dir = { "up", "down", "left", "right" }

--
-- Fill Tests
--
for i = 1, #dir do
	local paint = {
	    type = "gradient",
	    color1 = { 1, 0, 0 },
	    color2 = { 0, 1, 0 },
	    direction = dir[i]
	}
	local rect = display.newRect( i * 150, 200, 80, 80 )
	rect.fill = paint
	display.newText( "Fill " .. dir[i], rect.x, rect.y + 60, native.systemFont, 14 )
end


--
-- Stroke Tests
--
for i = 1, #dir do
	local paint = {
	    type = "gradient",
	    color1 = { 1, 0, 0 },
	    color2 = { 0, 1, 0 },
	    direction = dir[i]
	}
	local rect = display.newRect( i * 150, 400, 80, 80 )
	rect.stroke = paint
	rect.strokeWidth = 20
	display.newText( "Stroke " .. dir[i], rect.x, rect.y + 70, native.systemFont, 14 )
end
