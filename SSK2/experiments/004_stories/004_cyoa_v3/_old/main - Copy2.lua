-- =============================================================
-- main.lua
-- =============================================================
-- =============================================================
_G.gameFont = "AdelonSerial"
_G.isLandscape = false

----------------------------------------------------------------------
--	1. Requires
----------------------------------------------------------------------
local composer = require "composer"
require "ssk.loadSSK"

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
local parser = require "scripts.parser"

local text1 = "This is a some sample text.<BR><br>  Go #north.  See an @apple.<br><br>  "
 .. "You see a [winding road]. Look at a @sign.  {Look north}."
local words1 	= parser.decode( text1 )
local tokens1 	= parser.identifyTokens( words1 ) 
local data1		= { words = words1, tokens = tokens1}

parser.addTarget( tokens1, "NORTH", "north_page" )
parser.addTarget( tokens1, "WINDING ROAD", "north_page" )

local text2 = "Success!  We Turned the page? #back"
local words2 	= parser.decode( text2 )
local tokens2 	= parser.identifyTokens( words2 ) 
local data2		= { words = words2, tokens = tokens2}
parser.addTarget( tokens2, "BACK", "start" )

local story = {}
story.start = data1
story.north_page = data2
parser.loadStory( story )

local group 	= parser.gotoPage( "start" )

local function onNavigate( event )
	print("Entering onNavigate")
	table.dump(event)
	if( event.target and string.len( event.target ) > 0 ) then
		group 	= parser.gotoPage( event.target, group )
	end
end; listen( "onNavigate", onNavigate )

--[[
local group 	= parser.displayPage( data1 )

local function onNavigate( event )
	print("Entering onNavigate")
	table.dump(event)
	if( event.target == "BACK" ) then
		group 	= parser.displayPage( data1, group )
	else		
		group 	= parser.displayPage( data2, group )
	end
end; listen( "onNavigate", onNavigate )
--]]

table.print_r(data1.tokens)
--table.print_r(data2)
