-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local bg = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
bg:setFillColor(1,1,1)

local text1 = display.newText({
					text = "",
					x = display.contentCenterX,
					y = 100,
					width = 300,
					font = "fonts/AvenirLTStd-Roman.otf",
					fontSize = 20,
					align = "left"
				})
text1:setFillColor(0.2)




local input1 = native.newTextField(display.contentCenterX, 50, 300, 30)
input1:addEventListener("userInput", function(event)

	if(event.phase == "editing") then 
	
		text1.text = event.target.text
	
	end

end)