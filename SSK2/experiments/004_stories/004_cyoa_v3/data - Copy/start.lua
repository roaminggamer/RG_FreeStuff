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
local values = require "scripts.values"

local page = {}
--[[
local text = "This is the START <BR><br>  Go to #page1, [page 2], #page3, " ..
             "or to [page four] @actionWord. {An action phrase}."
]]



local page = {}

local text 			= "This is the START BEGAN == TRUE<br>Go to #page1"
local words 		= parser.decode( text )
local tokens 		= parser.identifyTokens( words, {} ) 
local expression 	= values.genExpression( "began, eq, true" )
parser.addTarget( tokens, "page1", "page1" )
parser.addTarget( tokens, "page 2", "page2" )
parser.addTarget( tokens, "page3", "page3" )
parser.addTarget( tokens, "page four", "page4" )
page[1]		= { expression = expression, words = words, tokens = tokens }


local text 			= "This is the START BEGAN == FALSE<br>Go to [page 2]"
local words 		= parser.decode( text )
local tokens 		= parser.identifyTokens( words, {} ) 
local expression 	= values.genExpression( "began, eq, false" )
parser.addTarget( tokens, "page1", "page1" )
parser.addTarget( tokens, "page 2", "page2" )
parser.addTarget( tokens, "page3", "page3" )
parser.addTarget( tokens, "page four", "page4" )
page[2]		= { expression = expression, words = words, tokens = tokens }

local text 			= "This is the START AWESOME == TRUE<br>Go to #page3"
local words 		= parser.decode( text )
local tokens 		= parser.identifyTokens( words, {} ) 
local expression 	= values.genExpression( "awesome, eq, true" )
parser.addTarget( tokens, "page1", "page1" )
parser.addTarget( tokens, "page 2", "page2" )
parser.addTarget( tokens, "page3", "page3" )
parser.addTarget( tokens, "page four", "page4" )
page[3]		= { expression = expression, words = words, tokens = tokens }


table.print_r( page )


return page

--[[

page = {}
page.words = { { word = "bob", }}



]]