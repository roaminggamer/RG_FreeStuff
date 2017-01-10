-- =============================================================
-- main.lua
-- =============================================================
-- =============================================================
_G.isLandscape = false

----------------------------------------------------------------------
--	1. Requires
----------------------------------------------------------------------

require "ssk2.loadSSK"
_G.ssk.init( { launchArgs = ..., 
	            gameFont = "AdelonSerial", 
	            math2DPlugin = false,
	            debugLevel = 0 } )


local composer = require "composer"

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
-- 4. Experiments
----------------------------------------------------------------------
local coronaTwine 	= require "coronaTwine"
local values		= require "scripts.values"
local parser 		= require "scripts.parser"
local pu 			= require "scripts.parse_utils"

--local passageTable = coronaTwine.stage1Parser( "twineSamples/sample1.txt" )
--local passageTable = coronaTwine.stage1Parser( "twineSamples/twine2_test.txt" )

--local story = parser.loadStory( passageTable )
--table.print_r( story )


--local data = pu.extractTwineData( "twineSamples/sample1.txt" )
local data = pu.extractTwineData( "twineSamples/twine2_test.txt" )
local story = pu.createStory( data )


--table.print_r( story )

pu.setStory( story )

--local words = pu.getWords( story, "start" )
--table.print_r( words )


local function willEnterPage( event )
	print(event.name,event.target,event.time)
	--table.dump(event)
end; listen( "willEnterPage", willEnterPage )

local function didEnterPage( event )
	print(event.name,event.target,event.time)
	--table.dump(event)
end; listen( "didEnterPage", didEnterPage )

local function willExitPage( event )
	print(event.name,event.target,event.time)
	--table.dump(event)
end; listen( "willExitPage", willExitPage )

local function didExitPage( event )
	print(event.name,event.target,event.time)
	--table.dump(event)
end; listen( "didExitPage", didExitPage )



local group = pu.displayPage( "Start" )

local function onNavigate( event )
	--table.dump(event)
	group = pu.displayPage( event.target, group  )
end; listen( "onNavigate", onNavigate )
