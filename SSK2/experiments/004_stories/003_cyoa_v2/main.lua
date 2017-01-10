-- =============================================================
-- main.lua
-- =============================================================
-- Sans Interfaces - i.e. Without a framework.
-- =============================================================
_G.isLandscape = false
_G.fontColors = {}

----------------------------------------------------------------------
--	1. Requires
----------------------------------------------------------------------
local composer = require "composer"

require "ssk2.loadSSK"
_G.ssk.init( { launchArgs = ..., 
	            gameFont = "AdelonSerial", 
	            math2DPlugin = false,
	            debugLevel = 0 } )



_G.gamelayers 			= require( "scripts.gamelayers" )
_G.things  				= require "scripts.things"
_G.objects 				= require "scripts.objects"
_G.player 				= require "scripts.player"
_G.rooms 				= require "scripts.rooms"
_G.dialogs				= require "scripts.dialogs"
_G.funcs				= require "scripts.funcs"

local storyInterface 	= require "scripts.storyInterface"

----------------------------------------------------------------------
--	2. Initialization
----------------------------------------------------------------------
io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

----------------------------------------------------------------------
-- 3. Declarations
----------------------------------------------------------------------

-- SSK 
local isInBounds		= ssk.easyIFC.isInBounds
local newCircle 		= ssk.display.circle
local newRect 			= ssk.display.rect
local newImageRect 		= ssk.display.imageRect
local easyIFC			= ssk.easyIFC
local ternary			= _G.ternary
local quickLayers  		= ssk.display.quickLayers

local angle2Vector 		= ssk.math2d.angle2Vector
local vector2Angle 		= ssk.math2d.vector2Angle
local scaleVec 			= ssk.math2d.scale
local addVec 			= ssk.math2d.add
local subVec 			= ssk.math2d.sub
local getNormals 		= ssk.math2d.normals

-- Lua and Corona
local mAbs 				= math.abs
local mPow 				= math.pow
local mRand 			= math.random
local getInfo			= system.getInfo
local getTimer 			= system.getTimer
local strMatch 			= string.match
local strFormat 		= string.format

----------------------------------------------------------------------
--	Locals
----------------------------------------------------------------------
local layers = gamelayers.get()

----------------------------------------------------------------------
-- 4. Definitions
----------------------------------------------------------------------

----------------------------------------------------------------------
-- 5. Execution
----------------------------------------------------------------------
--[[
local butT = newRect(layers.blocking, centerX, h - 45, { w = w, h = 30, fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 1} )
local butB = newRect(layers.blocking, centerX, h - 15, { w = w, h = 30, fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 1} )


-- Misc
local miscOffset = misc.y - misc.contentHeight/2 + 10
local tmp = easyIFC:quickLabel(layers.blocking, "StatusMsg |", 5, miscOffset, system.nativeFont, 14, _BLACK_ )
tmp.anchorX = 0

local tmp = easyIFC:quickLabel(layers.blocking, "H Points |", 85, miscOffset, system.nativeFont, 14, _RED_ )
tmp.anchorX = 0
local tmp = easyIFC:quickLabel(layers.blocking, "Mgc Points |", 150, miscOffset, system.nativeFont, 14, _BLUE_ )
tmp.anchorX = 0
local tmp = easyIFC:quickLabel(layers.blocking, "Amount Gold", 230, miscOffset, system.nativeFont, 14, _YELLOW_ )
tmp.anchorX = 0

-- Buttons (Top Row)
-- 
easyIFC:presetPush( layers.blocking, "default", 50 , butT.y, 90, 25, "Use", nil )
easyIFC:presetPush( layers.blocking, "default", centerX , butT.y, 90, 25, "Examine", nil )
easyIFC:presetPush( layers.blocking, "default", w - 50 , butT.y, 90, 25, "Drop", nil )

-- Buttons (Bot Row)
-- 
easyIFC:presetPush( layers.blocking, "default", 50 , butB.y, 90, 25, "Inventory", nil )
easyIFC:presetPush( layers.blocking, "default", centerX , butB.y, 90, 25, "Stats", nil )
easyIFC:presetPush( layers.blocking, "default", w - 50 , butB.y, 90, 25, "Map", nil )

--]]


--player:inventoryAdd( "Strange Stone", 1 )
--player:inventoryAdd( "gold", 10 )
--player:inventoryAdd( "gems", 16 )

--[[
player:inventoryAdd( "rock", 1 )
player:inventoryAdd( "Sword of Destiny", 1 )
player:inventoryAdd( "goobers", 666 )

while( player:inventoryHasFreeEntries() ) do
	player:inventoryAdd( "z_item" .. string.format("%3.3d", mRand(1,999)), mRand(1,999) )
end
--]]
--table.dump(player.myInventory)
--table.print_r(player:getInventoryTable())

--local twineParser = require "scripts.twineParser"
--twineParser.readTwine( "story/WizardIsleBeach.txt")


----[[
-- EDO 
storyInterface.create()

require "story.wi_beach.wi_beach"
require ("story.wi_beach.wi_beach_listeners").init()

rooms.init()
rooms.showRoom("wi_beach_start")
--rooms.showRoom("wi_beach_cave")

post("onUpdateInventory")
-- EDO 
--]]
