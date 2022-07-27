local fontStyles = {"Regular", "Black", "BlackItalic"}

local function randomStyle() 
	return fontStyles[math.random(1,3)]
end

for i = 1, 9 do
	local style = randomStyle()
	local font = "fonts_alt/Roboto-"..style..".ttf"
	local text = display.newText({text = font, font = font, fontSize = 22})
	text.anchorX = 0
	text.y = i*30
end