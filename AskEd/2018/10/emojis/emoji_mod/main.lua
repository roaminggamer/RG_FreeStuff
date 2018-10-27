io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- SSK Included for my convenience in this example
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
-- =====================================================
local isInBounds = ssk.easyIFC.isInBounds

-- =====================================================
-- String with unicode encodings in it from this page: 
-- https://apps.timwhitlock.info/emoji/tables/unicode
-- =====================================================
local uniString = "Hello😁😃" -- 7 characters?


-- =====================================================
-- 1. Print the string directly
-- =====================================================
local original = display.newText( uniString, centerX, top + 32, nil, 32 )


-- =====================================================
-- 2. Iterate over each 'letter' and print out 'byte()' value
-- =====================================================
local utf8 = require( "plugin.utf8" ) -- https://docs.coronalabs.com/plugin/utf8/index.html
local len = utf8.width( uniString )
print("len", len )

for charpos, codepoint in utf8.codes( uniString ) do
    print( charpos, codepoint )
end


-- =====================================================
-- 3. Using image I found here: https://github.com/Deveo/emojione-png-sprites
-- Make an interactive version of the 'sheet' to identify the cells by index.
-- (Original filenames: sprites-32.png and sprites-64.png respectively)
-- =====================================================
local cellIndex = display.newText( "hover over sheet to find index of 'emojis'", centerX, top + 130, nil, 32 )
local emojiImage = display.newRect( centerX, top + 170, 32, 32 )

local options = { width = 32, height = 32, numFrames = 43 ^ 2, sheetContentWidth = 1376, sheetContentHeight = 1376 }
local sheet = graphics.newImageSheet( "emojis.png", options )

local pages = {}
local allEmoji = {}

local function createPageInteracticeEmojiPage( num )
	local page = display.newGroup()
	pages[num] = page
	local startX = 16
	local startY = emojiImage.y + 50
	local index = (num-1) * 400 + 1
	local maxIndex = index + 400
	maxIndex = (maxIndex > 43 ^ 2) and (43 ^2) or maxIndex
	for col = 1, 20 do
		for row = 1, 20 do
			if( index <= maxIndex ) then
				local x = startX + (col-1) * 32
				local y = startY + (row-1) * 32
				local tmp = display.newImageRect( page, sheet, index, 32, 32 )
				tmp:setStrokeColor(1,0,0)
				tmp.x = x
				tmp.y = y
				tmp.index = index
				--
				index = index + 1
				--
				allEmoji[tmp] = tmp
			end
		end
	end
	return page
end
--
local function onRelease( event )
	local target = event.target
	for i = 1, #pages do
		pages[i].isVisible = false
	end	
	pages[target.num].isVisible = true
end
local function createEntireSet()
	local first
	for i = 1, 5 do
		local page = createPageInteracticeEmojiPage(i)
		page.isVisible = false
		local x = left + 50 + i * 100
		local y = emojiImage.y + 50 + 20 * 32 + 8
		local tmp = ssk.easyIFC:presetRadio( nil, "default", x, y, 40, 40, i, onRelease )
		tmp.num = i
		first = first or tmp
	end
	first:toggle()
end
--
local function onMouse( event )	
	for k, v in pairs( allEmoji ) do
		v.strokeWidth = 0
		if( v.parent.isVisible and isInBounds( event, v) ) then
			v.strokeWidth = 3 
			emojiImage.fill = { type = "image", sheet = sheet, frame = v.index }
			cellIndex.text = "index: " .. v.index
		end
	end
end; listen( "mouse", onMouse )
--
createEntireSet()

--createPageInteracticeEmojiPage(5)



-- =====================================================
-- WARNING - This example is a total hack, but the concept is sound 
--           and is a good starting point if you can find a way to 
--           automate the mapping of the emojis to codes.
-- 
--           You will also want to improve the way I assemble the string
--
-- 4. Hacky 'newEmojiText' function.
-- Roughly based on OLD signature of newText() with some changes.
--
-- display.neEmojiText( parent, text, x, y, font , fontSize, tween )
--
-- =====================================================
local emojiMap = {}
emojiMap[128513] = 294 -- I randomly mapped a emoji encoding to a index in the sheet
emojiMap[128515] = 423 -- I randomly mapped a emoji encoding to a index in the sheet
display.newEmojiText = function( parent, text, x, y, font, fontSize, tween ) 
	parent = parent or display.currentStage
	font = font or  native.systemFont 
	fontSize = fontSize or 32
	tween = tween or 2
	--
	local utf8 = require( "plugin.utf8" ) -- https://docs.coronalabs.com/plugin/utf8/index.html
	-- 
	local text = display.newGroup()
	parent:insert(text)
	local height = 0
	local curX = 0
	for charpos, codepoint in utf8.codes( uniString ) do
		local tmp 
		if( codepoint <= 255 ) then
			tmp = display.newText( text, string.char(codepoint), curX, 0, font, fontSize )
		else
			if( emojiMap[codepoint] ) then
				tmp = display.newImageRect( text, sheet, emojiMap[codepoint], fontSize, fontSize)
				tmp.x = curX
				tmp.y = 0
			else
				tmp = display.newRect( text, curX, 0, fontSize, fontSize)
			end

		end
		tmp.anchorX = 0
		tmp.anchorY = 0
		height = (height>tmp.contentHeight) and height or tmp.contentHeight		
		curX = curX + tmp.contentWidth + tween
	end
	text.x = x - curX/2 
	text.y = y - height/2
	return text
end

-- Draw emoji text below original example
display.newEmojiText( nil, uniString, centerX, original.y + 40, native.systemFont, 32, 0 )


