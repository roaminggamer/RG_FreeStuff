io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
-- =====================================================
-- Note: I am using SSK to get my shorthand screen positions.
-- It is not otherwise needed for this example.
-- =====================================================

--
-- Show center of screen
--
local hline = display.newLine( left, centerY, right, centerY )
hline.strokeWidth = 4
hline.alpha = 0.2
local vline = display.newLine( centerX, top, centerX, bottom )
vline.strokeWidth = 4
vline.alpha = 0.2



local img_names = { 
	{ "meteor1.png", "player.png", "ufo.png" },
	{ "enemy.png", "ufo.png" },
	{ "enemy.png", "meteor1.png", "meteor2.png", "player.png", "ufo.png" },
	{ "enemy.png", "meteor1.png", "meteor2.png", "ufo.png" },
}

local some_strings = { "ABCD", "EFG", "HIJKL", "MNOPQRST" }


-- Helper function to create centered row of evenly spaced objects
local function center_place_objs( objs, tweenX, y )
	local x = centerX - (#objs * tweenX)/2 + tweenX/2
	for i = 1, #objs do
		objs[i].x = x + (i-1) * tweenX
		objs[i].y = y
		print(objs[i].x,objs[i].y)
	end
end

--
-- 1. Place some centered rows of objects with a fixed minimum tween
--
-- 
local tween = 60
local y = centerY - 280
local tmp = {}
for row = 1, #img_names do
	for col = 1, #img_names[row] do
		local obj = display.newImage( "images/" .. img_names[row][col], centerX, centerY )
		obj:scale(0.35, 0.35)
		tmp[#tmp+1] = obj
	end
	center_place_objs( tmp, tween, y )
	y = y + tween
	tmp = {}
end

--
-- 2. Place some centered monospaced text
--
-- 
local tween = 40
local y = centerY - 40
local tmp = {}
for row = 1, #some_strings do
	for col = 1, string.len(some_strings[row]) do
		local letter = string.sub( some_strings[row], col, col )	
		local obj = display.newText( letter, 0, 0, "courier.ttf", tween )
		tmp[#tmp+1] = obj
	end
	center_place_objs( tmp, tween, y )
	y = y + tween
	tmp = {}
end

--
-- 3. Place some centered proportional sized text
--
-- 
local tween = 40
local y = centerY + 140
local tmp = {}
for row = 1, #some_strings do
	for col = 1, string.len(some_strings[row]) do
		local letter = string.sub( some_strings[row], col, col )	
		local obj = display.newText( letter, 0, 0, "War Eagle.ttf", tween )
		tmp[#tmp+1] = obj
	end
	center_place_objs( tmp, tween, y )
	y = y + tween
	tmp = {}
end
