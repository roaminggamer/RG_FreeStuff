-- =============================================================
-- Localizations
-- =============================================================
-- Commonly used Lua & Corona Functions
local getTimer = system.getTimer; local mRand = math.random
local mAbs = math.abs; local mFloor = math.floor; local mCeil = math.ceil
local strGSub = string.gsub; local strSub = string.sub
-- Common SSK Features
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers
local easyIFC = ssk.easyIFC;local persist = ssk.persist
local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
local normRot = math.normRot;local easyAlert = ssk.misc.easyAlert
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale
local RGTiled = ssk.tiled; local files = ssk.files
local factoryMgr = ssk.factoryMgr; local soundMgr = ssk.soundMgr
--if( ssk.misc.countLocals ) then ssk.misc.countLocals(1) end

local public = {}

function public.run( numPages )

	-- load all data
	local pages = {}
	for i = 1, numPages do
		pages[i] = require( "pages.page" .. i )
	end
	--table.dump(pages)

	-- forward declare function names and locals
	local showPage
	local group

	-- define page showing function
	showPage = function( num ) 
		-- Delete old group and prepare new one
		display.remove(group)
		group = display.newGroup()
		
		-- Get page data
		local page = pages[num]
		table.dump(page)

		-- Draw title and text content
		local options = 
		{
		    text = page.title .. "\n\n" .. page.content,     
		    x = left + 20,
		    y = top,
		    width = fullw - 40,
		    font = native.systemFont,   
		    fontSize = 32,
		}
		local pageText = display.newText( options )
		group:insert(pageText)
		pageText.anchorX = 0
		pageText.anchorY = 0

		-- Draw choice buttons
		local bw = 160
		local bh = 40 
		local curY = pageText.y + pageText.contentHeight + 2 * bh
		local curX = centerX - (#page.choices*bw)/2 + bw/2
		for i = 1, #page.choices do
			local choice = page.choices[i]
			local buttonText = choice[1]
			local toPage = choice[2]

			easyIFC:presetPush( group, "default", curX, curY, bw-20, bh, buttonText,
				function() 
					--print(toPage)
					showPage( tonumber(toPage) )
				end )
			curX = curX + bw
		end
	end
	showPage(1)
end



return public