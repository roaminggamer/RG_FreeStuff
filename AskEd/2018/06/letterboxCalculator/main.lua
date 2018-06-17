io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================
local menu = require("menu")
local createRecipe
local screens = {
   --{'iPhone3',  320,  480},
   {'iPhone4',  640,  960},
   {'iPhone5',  640,  1136},
   {'iPhone6',  750,  1334},
   {'iPhone6+', 1080, 1920},
   {'iPadMini', 768,  1024},
	{'iPadAir',  1536, 2048},
	{'iPadPro',  1536, 2048},

	{'medium1', 400, 854},
	{'medium2', 480, 800},
	{'medium3', 480, 854},
	{'medium4', 600, 800},

	{'high1', 540, 960},
	{'high2', 600, 1024},
	{'high3', 800, 1024},

	{'xhigh1', 720, 1280},
	{'xhigh2', 768, 1280},
	{'xhigh3', 768, 1366},
	{'xhigh4', 800, 1280},

	{'xxhigh 1', 1200, 1920},
	{'xxhigh 2', 1600, 2560}
}
local sub = {}
for i = 1, #screens do
	sub[i] = screens[i][1] .. " - " .. screens[i][2] .. " x " .. screens[i][3]
end
local function onSelect(event)		
	local text = event.text
	local entry
	local parts = string.split(text," ")
	print(parts[1])
	for i = 1,#screens do
		if( screens[i][1] == parts[1] ) then
			entry = screens[i]
		end
	end
	if( not entry ) then return end
	createRecipe(entry[2], entry[3])
	
end

local menu = menu.Menu{ x = centerX, column_width = 400, columns = { "Select Content Area Resolution", sub } }
local stash = menu:StashDropdowns() -- temporarily set aside dropdowns to not throw off size calculations
menu.y = top + 10
menu:RestoreDropdowns(stash)
menu:addEventListener("menu_item", onSelect )


createRecipe = function( contentW, contentH  )
	print("Content Area: ", contentW, contentH )
	local minW = contentW
	local maxW = 0
	local minH = contentH
	local maxH = 0
	local allScales = {}

	for i = 1, #screens do
		local targetW, targetH = screens[i][2], screens[i][3]		
		local scale1 = targetW/contentW
		local scale2 = targetH/contentH		
		local scale = scale2
		if( scale2 * contentW > targetW ) then
			scale = scale1
			-- scale 2 is overshoot
			local tmpW = contentW * scale2
			local tmpH = contentH * scale2
			maxW = (tmpW > maxW) and tmpW or maxW
			maxH = (tmpH > maxH) and tmpH or maxH
		else
			--scale 1 is overshoot
			local tmpW = contentW * scale1
			local tmpH = contentH * scale1
			maxW = (tmpW > maxW) and tmpW or maxW
			maxH = (tmpH > maxH) and tmpH or maxH
		end
		allScales[#allScales+1] = scale
	end

	-- remove scales < 1
	local tmp = allScales
	allScales = {}
	for k,v in pairs( tmp ) do
		if(v>1) then
			allScales[#allScales+1] = v
		end
	end
	-- Remove exact multiples
	local tmp = allScales
	allScales = {}
	for i = #tmp, 1, -1 do
		local keep = true
		local scale = tmp[i]
		for j = 1, i-1 do
			if(scale % tmp[j] == 0) then
				keep = false
			end
		end
		if( keep ) then
			allScales[#allScales+1] = scale
		end
	end
	table.sort(allScales)
	table.dump(allScales)

	local maxScale = allScales[#allScales]

	print( contentW, contentH, round(maxW), round(maxH) )

	print( contentW, contentH, round(contentW*maxScale), round(contentH*maxScale) )
end

createRecipe = function( contentW, contentH  )
	print("Content Area: ", contentW, contentH )
	local minW = contentW
	local maxW = 0
	local minH = contentH
	local maxH = 0
	local allScales = {}

	for i = 1, #screens do
		local targetW, targetH = screens[i][2], screens[i][3]		
		local scale1 = targetW/contentW
		local scale2 = targetH/contentH		
		local scale = scale2
		if( scale2 * contentW > targetW ) then
			scale = scale1
		end
		allScales[#allScales+1]	 = scale
	end
	table.sort(allScales)
	-- remove scales < 1
	local tmp = allScales
	allScales = {}
	for k,v in pairs( tmp ) do
		if(v>1) then
			allScales[#allScales+1] = v
		end
	end
	table.sort(allScales)
	-- Remove exact multiples
	local tmp = allScales
	allScales = {}
	for i = #tmp, 1, -1 do
		local keep = true
		local scale = tmp[i]
		for j = 1, i-1 do
			if(scale % tmp[j] == 0) then
				keep = false
			end
		end
		if( keep ) then
			allScales[#allScales+1] = scale
		end
	end
	table.sort(allScales)
	--table.dump(allScales)
	local maxScale = allScales[#allScales]
	local overshootScale = 1

	for i = 1, #screens do
		local targetW, targetH = screens[i][2], screens[i][3]		
		local scale1 = targetW/contentW
		local scale2 = targetH/contentH		
		local scale = scale2
		if( scale2 * contentW > targetW ) then
			if(scale1 == maxScale) then
				overshootScale = scale2
				print(scale1,scale2)
			end
		else
			if(scale2 == maxScale) then
				overshootScale = scale1
				print(scale1,scale2)
			end
		end
	end

	print("X", overshootScale, maxScale)

	print( contentW, contentH, round(contentW*maxScale), round(contentH*maxScale) )
end

print(display.contentScaleX)
createRecipe( 640, 960)



print(2%4)