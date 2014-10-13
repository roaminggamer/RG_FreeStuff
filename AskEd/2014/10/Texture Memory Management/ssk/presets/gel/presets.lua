-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- Buttons Presets
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
--
-- =============================================================
--
-- labelsInit.lua - Create Label Presets
--
local mgr = require "ssk.interfaces.buttons"
local imagePath = "ssk/presets/gel/images/"
local gameFont = gameFont or native.systemFont


local function colorConverter( inColor )
	local c1 = '0x' .. string.sub( inColor, 1, 2)
	local c2 = '0x' .. string.sub( inColor, 3, 4)
	local c3 = '0x' .. string.sub( inColor, 5, 6)

	return { tonumber(c1)/256, tonumber(c2)/256, tonumber(c3)/256, 1 }
end

local function convertSet( aSet )
	for i = 1, #aSet do
		aSet[i] = colorConverter( aSet[i] )
	end
end


local colorSets = {}

local aSet = {}
colorSets[#colorSets+1] = aSet
aSet[1] = 'B21911'
aSet[2] = 'F0FF4B'
aSet[3] = 'FF3D31'
aSet[4] = '1373CC'
aSet[5] = '1A69B2'
convertSet(aSet)


local aSet = {}
colorSets[#colorSets+1] = aSet
aSet[1] = 'B26C11'
aSet[2] = 'FFAE48'
aSet[3] = 'FFA531'
aSet[4] = '0075B2'
aSet[5] = '31B8FF'
convertSet(aSet)

local aSet = {}
colorSets[#colorSets+1] = aSet
aSet[1] = 'ADFF25'
aSet[2] = 'E2E821'
aSet[3] = 'FFEC31'
aSet[4] = 'E8C221'
aSet[5] = 'FFBF25'
convertSet(aSet)

local aSet = {}
colorSets[#colorSets+1] = aSet
aSet[1] = '1273BF'
aSet[2] = '0C4D7F'
aSet[3] = '189AFF'
aSet[4] = '062640'
aSet[5] = '158BE5'
convertSet(aSet)

local aSet = {}
colorSets[#colorSets+1] = aSet
aSet[1] = 'BF6800'
aSet[2] = '7F4500'
aSet[3] = 'FF8A00'
aSet[4] = '402300'
aSet[5] = 'E57C00'
convertSet(aSet)

local aSet = {}
colorSets[#colorSets+1] = aSet
aSet[1] = '61CC30'
aSet[2] = '8F998B'
aSet[3] = 'FFFE29'
aSet[4] = '9174FF'
aSet[5] = '6268CC'
convertSet(aSet)

local aSet = {}
colorSets[#colorSets+1] = aSet
aSet[1] = '44A0B2'
aSet[2] = 'FF94C1'
aSet[3] = '7AE9FF'
aSet[4] = 'CCC04F'
aSet[5] = 'F4DF1D'
convertSet(aSet)

local aSet = {}
colorSets[#colorSets+1] = aSet
aSet[1] = '8A47B2'
aSet[2] = 'FFDA98'
aSet[3] = 'CF7EFF'
aSet[4] = '51CC89'
aSet[5] = '50B27D'
convertSet(aSet)

local aSet = {}
colorSets[#colorSets+1] = aSet
aSet[1] = 'FF4631'
aSet[2] = 'E82C47'
aSet[3] = 'FF3DBA'
aSet[4] = 'D92CE8'
aSet[5] = 'B631FF'
convertSet(aSet)

local aSet = {}
colorSets[#colorSets+1] = aSet
aSet[1] = '0D94FF'
aSet[2] = '0CC0E8'
aSet[3] = '00FFE8'
aSet[4] = '0CE896'
aSet[5] = '0DFF60'
convertSet(aSet)



for i = 1, #colorSets do 
	local aSet = colorSets[i]
	for j = 1, #aSet do

		-- ============================
		-- ========= Push BUTTON
		-- ============================
		local params = 
		{ 
			labelColor			= {1,1,1,1},
			labelSize			= 16,
			labelFont			= gameFont,
			labelOffset          = {0,1},
			unselImgSrc  		= imagePath .. "push.png",
			selImgSrc    		= imagePath .. "pushOver.png",
			emboss              = false,	
			unselImgFillColor   = aSet[j],
			selImgFillColor     = aSet[j],
		}
		mgr:addButtonPreset( "gel_" .. i .. "_" .. j, params )


		-- ============================
		-- ======= Check Box (Toggle Button)
		-- ============================
		local params = 
		{ 
			unselImgSrc  = imagePath .. "check.png",
			selImgSrc    = imagePath .. "checkOver.png",
			labelOffset   = { 0, 35 },
			unselImgFillColor   = aSet[j],
			selImgFillColor     = aSet[j],
		}
		mgr:addButtonPreset( "gelcheck_" .. i .. "_" .. j, params )

		-- ============================
		-- ======= Radio Button 
		-- ============================
		local params = 
		{ 
			unselImgSrc  = imagePath .. "radio.png",
			selImgSrc    = imagePath .. "radioOver.png",
			labelOffset   = { 0, 35 },
			unselImgFillColor   = aSet[j],
			selImgFillColor     = aSet[j],
		}
		mgr:addButtonPreset( "gelradio_" .. i .. "_" .. j, params )


		-- ============================
		-- ======= Horizontal Slider
		-- ============================
		local params = 
		{ 
			unselImgSrc  = imagePath .. "trackHoriz.png",
			selImgSrc    = imagePath .. "trackHorizOver.png",
			unselKnobImg = imagePath .. "thumbHoriz.png",
			selKnobImg   = imagePath .. "thumbHorizOver.png",
			kw           = 29,
			kh           = 19,
			unselImgFillColor   = aSet[j],
			selImgFillColor     = aSet[j],
			unselKnobImgFillColor   = aSet[j%#aSet+1],
			selKnobImgFillColor     = aSet[j%#aSet+1],
		}
		mgr:addButtonPreset( "gelslider_" .. i .. "_" .. j, params )
	end
end
