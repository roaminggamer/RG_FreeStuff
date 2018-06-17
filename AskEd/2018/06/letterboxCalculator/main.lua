io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableresListhotHelper("s") 
-- =====================================================
local menu = require("menu")
local createRecipe
local resList = {
   {320, 480},
   {640, 960},
   {1125, 2436},
   {2048, 2732},
	{1200, 1920},
	{1600, 2560},
   {1080, 1920},
   {640, 1136},
   {750, 1334},
   {768, 1024},
	{1536, 2048},	
	{400, 854},
	{480, 800},
	{480, 854},
	{600, 800},
	{540, 960},
	{600, 1024},
	{720, 1280},
	{768, 1280},
	{768, 1366},
	{800, 1280},
}
local function sortRes( a,b )
	return (a[1] == b[1]) and (a[2] < b[2]) or (a[1] < b[1])
end
table.sort( resList, sortRes )
--table.print_r(resList)
--
local sub = {}
for i = 1, #resList do
	sub[i] = resList[i][1] .. " x " .. resList[i][2]
end
local function onSelect(event)		
	local text = event.text
	local entry
	local parts = string.split(text," ")
	for i = 1,#resList do
		if( resList[i][1] == tonumber(parts[1]) and resList[i][2] == tonumber(parts[3]) ) then
			entry = resList[i]
		end
	end
	if( not entry ) then return end
	createRecipe(entry[1], entry[2])	
end
--
createRecipe = function( contentW, contentH  )
	print("Content Area: ", contentW, contentH )
	local contentAspectRatio = contentW/contentH

	local idealW = contentW
	local idealH = contentH

	local hBleed = 0
	local vBleed = 0

	for i = 1, #resList do			
		local targetW, targetH = resList[i][1], resList[i][2]		
		local widthRatio = targetW/contentW
		local heightRatio = targetH/contentH			
		local scale = math.min( widthRatio, heightRatio )		
		if( scale * idealW < targetW ) then
			local scale2 = targetW/(idealW * scale)
			idealW = math.ceil(idealW * scale2)
		end
		if( scale * idealH < targetH ) then
			local scale2 = targetH/(idealH * scale)
			idealH = math.ceil(idealH * scale2)
		end
	end
	if( idealW  % 2 ~= 0) then idealW = idealW + 1 end
	if( idealH  % 2 ~= 0) then idealH = idealH + 1 end
	local g = display.newGroup()
	g.x = 10000
	g.y = 10000
	local b = display.newRect( g, idealW/2, idealH/2, idealW, idealH)
	local s = display.newRect( g, idealW/2, idealH/2, contentW, contentH)
	b:setFillColor(unpack(_P_))
	s:setFillColor(unpack(_G_))
	nextFrame( function() display.save( g, { filename="ideal.png", baseDir=system.DocumentsDirectory, captureOffscreenArea=true} ) end )
	nextFrame( function() display.remove( g ) end, 100 )
	print( contentW, contentH, idealW, idealH )
	return contentW, contentH, idealW, idealH
end
--
local menu = menu.Menu{ x = centerX, column_width = 400, columns = { "Select Content Area Resolution", sub } }
local stash = menu:StashDropdowns() -- temporarily set aside dropdowns to not throw off size calculations
menu.y = top + 10
menu:RestoreDropdowns(stash)
menu:addEventListener("menu_item", onSelect )
--
--createRecipe( 640, 960)
