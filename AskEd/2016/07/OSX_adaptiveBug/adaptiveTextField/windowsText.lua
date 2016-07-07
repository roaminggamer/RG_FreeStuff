--[[
************************************************************************************
windowsText module for Corona SDK
Copyright (c) 2015 Jason Schroeder
http://www.jasonschroeder.com
http://www.twitter.com/schroederapps
************************************************************************************

ABOUT THE MODULE:
This module was created to "fake" native text input on the Corona Simulator
for Windows, which as of July 2015 does not support the native.newTextBox() and
native.newTextField() APIs. You are welcome to modify it as needed, but
it is set up to "just work" by requiring it into your Corona project. Once required,
the module will check to see if the project is running in the Windows simulator,
and if it is, it will overwrite native.newTextBox() and native.newTextField()
with these non-native Windows simulator-compatible functions. These modified functions
are fully compatible with all syntax and methods of their native counterparts, 
so you will not need to alter your code at all to support them.

************************************************************************************

HOW TO USE THE MODULE:

1.) Place windowsText.lua (this file) in your project's root directory
	(where your main.lua resides)

2.) Require the module by placing the following code in your main.lua:
	local windowsText = require("windowsText")

3.) That's it! Calling native.newTextField() or native.newTextBox() will now
	work in the Windows Simulator just like it does on-device or in OS X.

4.) If you want to use these non-native textFields or textBoxes outside the 
	Windows simulator, you can optionally call windowsText.enable() to overwrite
	the native functions. You can revert back to the native APIs by calling
	windowsText.disable() if you wish.

************************************************************************************
]]--

------------------------------------------------------------------------------------
-- CREATE WINDOWSTEXT LIBRARY & FORWARD DECLARE LOCALS
------------------------------------------------------------------------------------
local windowsText = {}
local pressed = {} -- table to keep track of actively pressed keys

-- positioning variables:
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenTop = math.floor(display.screenOriginY)
local screenLeft = math.floor(display.screenOriginX)
local screenBottom = display.contentHeight - screenTop
local screenRight = display.contentWidth - screenLeft
local screenWidth = screenRight - screenLeft
local screenHeight = screenBottom - screenTop

-- private function variables:
local keyListener, makeOverlay, newFont

------------------------------------------------------------------------------------
-- SET UP US ENGLISH KEYBOARD KEY DEFINITIONS
-- (use this as template for other localized keyboards if needed)
------------------------------------------------------------------------------------
local US_English = {
	["1"] = {default = "1", shift = "!"},
	["2"] = {default = "2", shift = "@"},
	["3"] = {default = "3", shift = "#"},
	["4"] = {default = "4", shift = "$"},
	["5"] = {default = "5", shift = "%"},
	["6"] = {default = "6", shift = "^"},
	["7"] = {default = "7", shift = "&"},
	["8"] = {default = "8", shift = "*"},
	["9"] = {default = "9", shift = "("},
	["0"] = {default = "0", shift = ")"},
	["a"] = {default = "a", shift = "A"},
	["b"] = {default = "b", shift = "B"},
	["c"] = {default = "c", shift = "C"},
	["d"] = {default = "d", shift = "D"},
	["e"] = {default = "e", shift = "E"},
	["f"] = {default = "f", shift = "F"},
	["g"] = {default = "g", shift = "G"},
	["h"] = {default = "h", shift = "H"},
	["i"] = {default = "i", shift = "I"},
	["j"] = {default = "j", shift = "J"},
	["k"] = {default = "k", shift = "K"},
	["l"] = {default = "l", shift = "L"},
	["m"] = {default = "m", shift = "M"},
	["n"] = {default = "n", shift = "N"},
	["o"] = {default = "o", shift = "O"},
	["p"] = {default = "p", shift = "P"},
	["q"] = {default = "q", shift = "Q"},
	["r"] = {default = "r", shift = "R"},
	["s"] = {default = "s", shift = "S"},
	["t"] = {default = "t", shift = "T"},
	["u"] = {default = "u", shift = "U"},
	["v"] = {default = "v", shift = "V"},
	["w"] = {default = "w", shift = "W"},
	["x"] = {default = "x", shift = "X"},
	["y"] = {default = "y", shift = "Y"},
	["z"] = {default = "z", shift = "Z"},
	["space"] = {default = " ", shift = " "},
	["numPad1"] = {default = "1", shift = "1"},
	["numPad2"] = {default = "2", shift = "2"},
	["numPad3"] = {default = "3", shift = "3"},
	["numPad4"] = {default = "4", shift = "4"},
	["numPad5"] = {default = "5", shift = "5"},
	["numPad6"] = {default = "6", shift = "6"},
	["numPad7"] = {default = "7", shift = "7"},
	["numPad8"] = {default = "8", shift = "8"},
	["numPad9"] = {default = "9", shift = "9"},
	["numPad0"] = {default = "0", shift = "0"},
	["numPad+"] = {default = "+", shift = "+"},
	["numPad-"] = {default = "-", shift = "-"},
	["numPad*"] = {default = "*", shift = "*"},
	["numPad/"] = {default = "/", shift = "/"},
	["numPad="] = {default = "=", shift = "="},
	["numPad."] = {default = ".", shift = "."},
	["numPad,"] = {default = ",", shift = ","},
	["numPad("] = {default = "(", shift = ")"},
	["numPad)"] = {default = ")", shift = ")"},
	["`"] = {default = "`", shift = "~"},
	["-"] = {default = "-", shift = "_"},
	["="] = {default = "=", shift = "+"},
	["["] = {default = "[", shift = "{"},
	["]"] = {default = "]", shift = "}"},
	["\\"] = {default = "\\", shift = "|"},
	[";"] = {default = ";", shift = ":"},
	["'"] = {default = "'", shift = [["]]},
	[","] = {default = ",", shift = "<"},
	["."] = {default = ".", shift = ">"},
	["/"] = {default = "/", shift = "?"},
	["deleteBack"] = {default = "backspace", shift = "backspace"},
	["deleteForward"] = {default = "backspace", shift = "backspace"},
	["numPadEnter"] = {default= "enter", shift = "enter"},
	["enter"] = {default= "enter", shift = "enter"},
}

------------------------------------------------------------------------------------
-- DEFINE ACTIVE KEYBOARD SET
------------------------------------------------------------------------------------
local keyboard = US_English


--[[
************************************************************************************
** PUBLIC FUNCTIONS ****************************************************************
************************************************************************************
]]--

------------------------------------------------------------------------------------
-- CREATE SINGLE-LINE TEXT FIELD
------------------------------------------------------------------------------------
function windowsText.newTextField(centerX, centerY, width, height)
	
	-------------------------------------------
	-- Create TextField Object
	-------------------------------------------
	local object = display.newContainer(width, height)
	object.x, object.y = centerX, centerY
	object.text = ""
	object.placeholder = ""
	object.hasBackground = true
	object.align = "left"
	object.font = native.systemFont
	object.size = object.height * .8
	local color = {0, 0, 0, 1}
	
	local bg = display.newRect(object, 0, 0, width, height)
	bg.isHitTestable = true
	bg:setFillColor(1)
	
	local placeholder, text
	
	local function createTextObjects()
		display.remove(placeholder)
		object.placeholder = object.placeholder or ""
		placeholder = display.newText({
			parent = object,
			text = object.placeholder,
			x = 0,
			y = 0,
			width = object.width - 8,
			height = object.height,
			font = object.font,
			fontSize = object.size,
			align = object.align,
		})
		placeholder:setFillColor(0, 0, 0, .25)
		placeholder.isVisible = false

		display.remove(text)
		text = display.newText({
			parent = object,
			text = object.text,
			x = 0,
			y = 0,
			width = object.width - 8,
			height = object.height,
			font = object.font,
			fontSize = object.size,
			align = object.align,
		})
		text:setFillColor(color[1], color[2], color[3], color[4])
		
		text.font = object.font
		text.fontSize = object.size
		text.align = object.align
	end
	createTextObjects()
	
	-------------------------------------------
	-- Convert keystrokes to dispatched userInput events
	-------------------------------------------
	local function typeListener(event)
		local startPosition = string.len(text.text)
		local character = event.character
		local numDeleted = 0
		local dispatch = true
		if event.character == "backspace" then
			if string.len(object.text) <= 0 then dispatch = false end
			object.text = string.sub(object.text, 1, string.len(object.text) - 1)
			character = ""
			numDeleted = 1
		elseif event.character == "enter" then
			dispatch = false
			display.remove(object.overlay)
			object.endTouch("submitted")
		else
			startPosition = startPosition + 1
			object.text = object.text .. event.character
		end
		
		if dispatch then
			object:dispatchEvent({
				name = "userInput",
				target = object,
				phase = "editing",
				startPosition = startPosition,
				newCharacters = character,
				text = object.text,
				numDeleted = numDeleted,
			})
		end
	end
	
	-------------------------------------------
	-- End editing (touch off active textField)
	-------------------------------------------
	function object.endTouch(phase)
		object.phase = nil
		local phase = phase or "ended"
		object:dispatchEvent({target = object, phase = phase, name = "userInput"})
		Runtime:removeEventListener("windowsText", typeListener)
	end
	
	-------------------------------------------
	-- Start editing when textField is touched
	-------------------------------------------
	local function onTouch(event)
		if event.phase == "began" and object.phase == nil then
			object.phase = "began"
			object:dispatchEvent({target = object, phase = "began", name = "userInput"})
			Runtime:addEventListener("windowsText", typeListener)
			makeOverlay(object)
		end
	end
	object:addEventListener("touch", onTouch)
	
	-------------------------------------------
	-- Update textField visuals on enterFrame
	-------------------------------------------
	local function onEnterFrame(event)
		-- show/hide background
		bg.isVisible = object.hasBackground
		
		-- check for alignment, font, or font size changes
		if (text.align ~= object.align) or (object.size ~= text.fontSize) or (object.font ~= text.font) or (bg.height ~= object.height) or (bg.width ~= object.width) then
			bg.width, bg.height = object.width, object.height
			createTextObjects()
		end
		
		-- update displayed text & obscure if object.isSecure == true
		if object.isSecure then
			local tmpStr = ""
			for i = 1, string.len(object.text) do tmpStr = tmpStr .. "●" end
			text.text = tmpStr
		else
			text.text = object.text
		end
		
		-- show/hide placeholder
		if object.placeholder then
			placeholder.text = object.placeholder
			placeholder.isVisible = (string.len(object.text) <= 0)
		end
		
		-- check for height changes
		bg.height = object.height
		bg.width = object.width
		
	end
	Runtime:addEventListener("enterFrame", onEnterFrame)
	
	-------------------------------------------
	-- Object Methods
	-------------------------------------------	
	-- object:resizeFontToFitHeight()
	function object:resizeFontToFitHeight()
		object.size = object.height * .8
	end
	
	-- object:resizeHeightToFitFont()
	function object:resizeHeightToFitFont()
		object.height = object.size * 1.25
	end
	
	-- object:setTextColor()
	function object:setTextColor(r, g, b, a)
		local r = r or 0
		local g = g or 0
		local b = b or 0
		local a = a or 1
		color = {r, g, b, a}
		text:setFillColor(r, g, b, a)
	end
	
	-- object:setSelection()
	function object:setSelection()
		-- do nothing!
		-- this is a device-only method, so this is just a placeholder to avoid Runtime errors in the simulator.
	end
	
	-- object:setReturnKey()
	function object:setReturnKey()
		-- do nothing!
		-- this is a device-only method, so this is just a placeholder to avoid Runtime errors in the simulator.
	end
	
	-------------------------------------------
	-- Clean up Runtime listeners when textField is removed
	-------------------------------------------
	function object.finalize(event)
		Runtime:removeEventListener("enterFrame", onEnterFrame)
	end
	object:addEventListener("finalize")
	
	-------------------------------------------
	-- Return TextField object
	-------------------------------------------
	return object
end


------------------------------------------------------------------------------------
-- CREATE MULTI-LINE TEXT BOX
------------------------------------------------------------------------------------
function windowsText.newTextBox(centerX, centerY, width, height)
	
	-------------------------------------------
	-- Create TextBox Object
	-------------------------------------------
	local object = display.newContainer(width, height)
	object.x, object.y = centerX, centerY
	object.text = ""
	object.placeholder = ""
	object.hasBackground = true
	object.align = "left"
	object.font = native.systemFont
	object.size = screenWidth * .05
	local color = {0, 0, 0, 1}
	
	local bg = display.newRect(object, 0, 0, width, height)
	bg.isHitTestable = true
	bg:setFillColor(1)
	
	local placeholder, text
	
	local function createTextObjects()
		display.remove(placeholder)
		object.placeholder = object.placeholder or ""
		placeholder = display.newText({
			parent = object,
			text = object.placeholder,
			x = 0,
			y = 0,
			width = object.width - 8,
			height = object.height,
			font = object.font,
			fontSize = object.size,
			align = object.align,
		})
		placeholder:setFillColor(0, 0, 0, .25)
		placeholder.isVisible = false

		display.remove(text)
		text = display.newText({
			parent = object,
			text = object.text,
			x = 0,
			y = -object.height * .5,
			width = object.width - 8,
			font = object.font,
			fontSize = object.size,
			align = object.align,
		})
		text.anchorY = 0
		text:setFillColor(color[1], color[2], color[3], color[4])
		
		text.font = object.font
		text.fontSize = object.size
		text.align = object.align
	end
	createTextObjects()
	
	-------------------------------------------
	-- Convert keystrokes to dispatched userInput events
	-------------------------------------------
	local function typeListener(event)
		if object.isEditable then
			if object.phase == "began" then
				object:dispatchEvent({target = object, phase = "began", name = "userInput"})
				object.phase = "editing"
			end
			local startPosition = string.len(text.text)
			local character = event.character
			local numDeleted = 0
			local dispatch = true
			if event.character == "enter" then event.character = "\n" end
			if event.character == "backspace" then
				if string.len(object.text) <= 0 then dispatch = false end
				object.text = string.sub(object.text, 1, string.len(object.text) - 1)
				character = ""
				numDeleted = 1
			else
				startPosition = startPosition + 1
				object.text = object.text .. event.character
			end
		
			if dispatch then
				object:dispatchEvent({
					name = "userInput",
					target = object,
					phase = "editing",
					startPosition = startPosition,
					newCharacters = character,
					text = object.text,
					numDeleted = numDeleted,
				})
			end
		end
	end
	
	-------------------------------------------
	-- End editing (touch off active textBox)
	-------------------------------------------
	function object.endTouch()
		object.phase = nil
		object:dispatchEvent({target = object, phase = "submitted", name = "userInput"})
		object:dispatchEvent({target = object, phase = "ended", name = "userInput"})
		Runtime:removeEventListener("windowsText", typeListener)
	end
	
	-------------------------------------------
	-- Start editing when textBox is tapped
	-------------------------------------------
	local function onTap(event)
		if object.phase == nil then
			object.phase = "began"
			Runtime:addEventListener("windowsText", typeListener)
			makeOverlay(object)
		end
	end
	object:addEventListener("tap", onTap)
	
	-------------------------------------------
	-- Scroll textBox
	-------------------------------------------
	local function onTouch(event)
		local phase = event.phase
		if phase == "began" then
			transition.cancel(text)
			display.getCurrentStage():setFocus(object, event.id)
			text.yStart = text.y
		elseif phase == "moved" and text.yStart then
			local dy = event.y - event.yStart
			text.y = text.yStart + dy
		elseif phase == "ended" or phase == "cancelled" then
			text.yStart = nil
			if text.height < object.height then
				transition.to(text, {y = -object.height*.5, time = 200})
			else
				if text.y > -object.height*.5 then
					transition.to(text, {y = -object.height*.5, time = 200})
				elseif text.y + text.height < object.height*.5 then
					transition.to(text, {y = object.height*.5 - text.height, time = 200})
				end
			end
			display.getCurrentStage():setFocus(nil, event.id)
		end
		return true
	end
	object:addEventListener("touch", onTouch)
	
	-------------------------------------------
	-- Update textBox visuals on enterFrame
	-------------------------------------------
	local function onEnterFrame(event)
		-- show/hide background
		bg.isVisible = object.hasBackground
		
		-- check for alignment, font, or font size changes
		if (text.align ~= object.align) or (object.size ~= text.fontSize) or (object.font ~= text.font) or (bg.height ~= object.height) or (bg.width ~= object.width) then
			bg.width, bg.height = object.width, object.height
			createTextObjects()
		end
		
		-- update displayed text
		if text.text ~= object.text then
			text.text = object.text
			if text.contentHeight > object.height then
				text.y = -object.height*.5 - (text.contentHeight - object.height)
			else
				text.y = -object.height * .5
			end
		end
		
		-- show/hide placeholder
		if object.placeholder then
			placeholder.text = object.placeholder
			placeholder.isVisible = (string.len(object.text) <= 0)
		end
		
		-- check for height changes
		bg.height = object.height
		bg.width = object.width
		
	end
	Runtime:addEventListener("enterFrame", onEnterFrame)
	
	-------------------------------------------
	-- Object Methods
	-------------------------------------------	
	-- object:setTextColor()
	function object:setTextColor(r, g, b, a)
		local r = r or 0
		local g = g or 0
		local b = b or 0
		local a = a or 1
		color = {r, g, b, a}
		text:setFillColor(r, g, b, a)
	end
	
	-- object:setReturnKey()
	function object:setReturnKey()
		-- do nothing!
		-- this is a device-only method, so this is just a placeholder to avoid Runtime errors in the simulator.
	end
	
	-- object:setSelection()
	function object:setSelection()
		-- do nothing!
		-- this is a device-only method, so this is just a placeholder to avoid Runtime errors in the simulator.
	end
	
	-------------------------------------------
	-- Clean up Runtime listeners when textBox is removed
	-------------------------------------------
	function object.finalize(event)
		Runtime:removeEventListener("enterFrame", onEnterFrame)
	end
	object:addEventListener("finalize")
	
	-------------------------------------------
	-- Return textBox object
	-------------------------------------------
	return object
end



------------------------------------------------------------------------------------
-- ENABLE WINDOWSTEXT
------------------------------------------------------------------------------------
function windowsText.enable()
	native.newTextField0 = native.newTextField
	native.newTextField = windowsText.newTextField
	
	native.newTextBox0 = native.newTextBox
	native.newTextBox = windowsText.newTextBox
	
	native.newFont0 = native.newFont
	native.newFont = newFont
	
	Runtime:addEventListener("key", keyListener)
end

------------------------------------------------------------------------------------
-- DISABLE WINDOWSTEXT
------------------------------------------------------------------------------------
function windowsText.disable()
	if native.newTextField0 ~= nil then
		native.newTextField = native.newTextField0
	end
	if native.newTextBox0 ~= nil then
		native.newTextBox = native.newTextBox0
	end
	if native.newFont0 ~= nil then
		native.newFont = native.newFont0
	end
	Runtime:removeEventListener("key", keyListener)
end


--[[
************************************************************************************
** PRIVATE FUNCTIONS ****************************************************************
************************************************************************************
]]--

------------------------------------------------------------------------------------
-- INTERCEPT NATIVE.NEWFONT() CALLS
------------------------------------------------------------------------------------
function newFont(fontName)
	if system.getInfo("platformName") == "Win" then
		return fontName
	elseif native.newFont0 ~= nil then
		return native.newFont0(fontName)
	end
end

------------------------------------------------------------------------------------
-- LISTEN FOR KEYSTROKES AND DISPATCH CHARACTER
------------------------------------------------------------------------------------
function keyListener(event)
	local phase = event.phase
	local keyName = event.keyName
	local output
	
	if keyboard[keyName] and phase == "down" and not pressed[keyName] then
		local default = keyboard[keyName].default
		local shift = keyboard[keyName].shift
		if not default == "backspace" then
			pressed[keyName] = true
		end
		if event.isShiftDown then
			output = shift
		else
			output = default
		end
	elseif phase == "up" then
		pressed[keyName] = false
	end
	
	if output then
		Runtime:dispatchEvent({name = "windowsText", character = output})
		return true
	end
end

------------------------------------------------------------------------------------
-- MAKE OVERLAY TO INTERCEPT TOUCHES AROUND ACTIVE TEXT OBJECT
------------------------------------------------------------------------------------
function makeOverlay(object)
	local group = display.newGroup()
	
	local function closeOverlay(event)
		if event.phase == "began" then
			display.remove(group)
			group = nil
			object.endTouch()
		end
		return false
	end
	
	local bg = display.newRect(group, centerX, centerY, screenWidth, screenHeight)
	bg.isVisible = false
	bg.isHitTestable = true
	
	local x, y = object:localToContent(0, 0)
	local box = display.newRoundedRect(group, x, y, object.contentWidth, object.contentHeight, 8)
	box:setFillColor(1, 1, 1, 0)
	box.isHitTestable = true
	box.strokeWidth = 4
	box:setStrokeColor(0, 0, 1, .3)
	box:addEventListener("tap", function() return true end)
	box:addEventListener("touch", function() return true end)
	
	bg:addEventListener("tap", function() return true end)
	bg:addEventListener("touch", closeOverlay)
	
	object.overlay = group
end

--[[
************************************************************************************
** AUTO-ENABLE IN WINDOWS SIMULATOR & RETURN LIBRARY *******************************
************************************************************************************
]]--
if system.getInfo("platformName") == "Win" then windowsText.enable() end

return windowsText