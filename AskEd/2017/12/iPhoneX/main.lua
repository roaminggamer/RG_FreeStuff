-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
--  main.lua
-- =============================================================
-- Start (code/comments)
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
-- LOAD & INITIALIZE - SSK 2
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init( { launchArgs 				= ..., 
	            enableAutoListeners 	= true,
	            exportCore 				= true,
	            exportColors 			= true,
	            exportSystem 			= true,
	            measure					= false,
	            useExternal				= true,
	            gameFont 				= native.systemFont,
	            debugLevel 				= 0 } )

-- =============================================================
-- Localizations (My standard set; not all used in this example)
-- =============================================================
-- Commonly used Lua Functions
local getTimer          = system.getTimer
local mRand					= math.random
local mAbs					= math.abs
--
-- Common SSK Display Object Builders
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers
--
-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist
--
-- Common SSK Helper Functions
local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
local normRot = math.normRot;local easyAlert = ssk.misc.easyAlert
--
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale
-- =============================================================

display.setDefault( "background", 0.25, 0.25, 0.25 )

local iPhoneNames = {}
for k,v in pairs(_G) do
	if( string.match( k, "iPhone") ) then
		iPhoneNames[#iPhoneNames+1] = k
	end
end
table.sort( iPhoneNames )

local curY = top + 10

if( oniPhoneX ) then curY = curY + 60 end

local label = easyIFC:quickLabel( nil, "onDevice",  left + 20, curY, nil, 24, _W_, 0, 0 )
label:setFillColor(unpack( (onDevice and _G_ or _R_ )))
curY = curY + 30
local label = easyIFC:quickLabel( nil, "onSimulator",  left + 20, curY, nil, 24, _W_, 0, 0 )
label:setFillColor(unpack( (onSimulator and _G_ or _R_ )))
curY = curY + 30
local label = easyIFC:quickLabel( nil, "------------------------------",  left + 20, curY, nil, 24, _W_, 0, 0 )
curY = curY + 30


for i = 1, #iPhoneNames do
	local name = iPhoneNames[i]
	local isOn = _G[name]
	local label = easyIFC:quickLabel( nil, name,  left + 20, curY, nil, 24, _W_, 0, 0 )
	label:setFillColor(unpack( (isOn and _G_ or _R_ )))
	curY = curY + 30
end


local platformName            = system.getInfo("platformName") 
local platform                = system.getInfo("platform")
local platformEnvironment     = system.getInfo("environment")
local targetAppStore          = system.getInfo("targetAppStore")
local architectureInfo        = system.getInfo("architectureInfo")
local model                   = system.getInfo("model")

local label = easyIFC:quickLabel( nil, "------------------------------",  left + 20, curY, nil, 24, _W_, 0, 0 )
curY = curY + 30
local label = easyIFC:quickLabel( nil, "platformName: " .. tostring(platformName),  left + 20, curY, nil, 24, _W_, 0, 0 )
curY = curY + 30
local label = easyIFC:quickLabel( nil, "platform: " .. tostring(platform),  left + 20, curY, nil, 24, _W_, 0, 0 )
curY = curY + 30
local label = easyIFC:quickLabel( nil, "platformEnvironment: " .. tostring(platformEnvironment),  left + 20, curY, nil, 24, _W_, 0, 0 )
curY = curY + 30
local label = easyIFC:quickLabel( nil, "targetAppStore: " .. tostring(targetAppStore),  left + 20, curY, nil, 24, _W_, 0, 0 )
curY = curY + 30
local label = easyIFC:quickLabel( nil, "architectureInfo: " .. tostring(architectureInfo),  left + 20, curY, nil, 24, _W_, 0, 0 )
curY = curY + 30
local label = easyIFC:quickLabel( nil, "model: " .. tostring(model),  left + 20, curY, nil, 24, _W_, 0, 0 )
curY = curY + 30
