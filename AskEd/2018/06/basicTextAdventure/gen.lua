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
local dummyPage =
[[
local page = {}
page.title = "_TITLE_"
page.content = "_CONTENT_"
page.choices = {
_CHOICES_}
return page
]]

function public.run( numPages )
	for i = 1, numPages do
		local page = dummyPage		
		page = strGSub( page, "_TITLE_", "Page " .. i)
		page = strGSub( page, "_CONTENT_", ssk.misc.getLorem( mRand(50, 300), "\\n\\n", true ) )
		local numChoices = mRand(2,3)
		local choices = ""
		for j = 1, numChoices do
			local to = mRand(1,numPages)
			while(to == i) do
				to = mRand(1,numPages)
			end
			choices = choices .. '{ "Go To Page ' .. to .. '", ' .. to .. '},\n'
		end
		page = strGSub( page, "_CHOICES_", choices )
		--print(page)
		local path = files.resource.getPath("pages/page" .. i .. ".lua")
		files.util.writeFile( page, path )
	end
	
end



return public