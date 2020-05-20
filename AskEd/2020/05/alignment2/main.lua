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
-- Show center of screen divider
--
local vline = display.newLine( centerX, top, centerX, bottom )
vline.strokeWidth = 4
vline.alpha = 0.2


local img_names = { 
	{ "meteor1.png", "player.png", "ufo.png" },
	{ "enemy.png", "ufo.png" },
	{ "enemy.png", "meteor1.png", "meteor2.png", "player.png", "ufo.png" }	
}

local some_strings = { 
	"ABCD", 
	"EFG", 
	"H", 
	"IJKLMN" 
}

-- horizontal line Helper
local function draw_line( y ) 
	local hline = display.newLine( left, y, right, y )
	hline.strokeWidth = 4
	hline.alpha = 0.2
end


-- Helper function to create centered row of evenly spaced objects
local function center_place_objs( objs, tweenX, y )
	local x = centerX - (#objs * tweenX)/2 + tweenX/2
	for i = 1, #objs do
		objs[i].x = x + (i-1) * tweenX
		objs[i].y = y
		-- print(objs[i].x,objs[i].y)
	end
end

-- Helper function to create centered row objects with even spaces between them
local function proportional_placer( objs, edge_tweenX, y )
	local cumulativeWidth = 0
	for i = 1, #objs do
		cumulativeWidth = cumulativeWidth + objs[i].contentWidth
	end
	print (cumulativeWidth)
	cumulativeWidth = cumulativeWidth + (#objs-1) * edge_tweenX
	print (cumulativeWidth)
	local x = centerX - cumulativeWidth/2 
	for i = 1, #objs do
		x = x + objs[i].contentWidth/2 
		objs[i].x = x
		objs[i].y = y
		x = x + edge_tweenX + objs[i].contentWidth/2 
		-- print(objs[i].x,objs[i].y)
	end
end


--
-- 1. Place some centered rows of objects with a fixed minimum tween
--
-- 
local tween = 60
local y = centerY - 450
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
draw_line( y - tween/2 + 10 )
--
-- 2. Place some centered monospaced text
--
-- 
local tween = 40
local y = centerY - 260
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
draw_line( y - tween/2 + 10 )

--
-- 3. Place some centered proportional sized text
--
-- 
local tween = 40
local y = centerY - 80
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
draw_line( y - tween/2 + 10 )

--
-- 4. Place some centered proportional sized text but use proportional placer
--
-- 
local fontSize = 40
local tween = 5
local y = centerY + 100
local tmp = {}
for row = 1, #some_strings do
	for col = 1, string.len(some_strings[row]) do
		local letter = string.sub( some_strings[row], col, col )	
		local obj = display.newText( letter, 0, 0, "War Eagle.ttf", fontSize )
		tmp[#tmp+1] = obj
	end
	proportional_placer( tmp, tween, y )
	y = y + fontSize
	tmp = {}
end
draw_line( y - fontSize/2 + 10 )

--
-- 5. Place some centered rows of objects with proportional spacing.
--
-- 
local vert_tween = 60
local edge_tween = 10
local y = centerY + 300
local tmp = {}
for row = 1, #img_names do
	for col = 1, #img_names[row] do
		local obj = display.newImage( "images/" .. img_names[row][col], centerX, centerY )
		obj:scale(0.35, 0.35)
		tmp[#tmp+1] = obj
	end
	proportional_placer( tmp, edge_tween, y )
	y = y + vert_tween
	tmp = {}
end
