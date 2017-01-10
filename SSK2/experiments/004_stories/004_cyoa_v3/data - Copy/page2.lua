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

local page = {}

local text = "This is PAGE TWO <br><br>  Go to #start, [page 2], #page3, " ..
             "or to [page four] @actionWord. {An action phrase}."

local words 	= parser.decode( text )
local tokens 	= parser.identifyTokens( words ) 
local page		= { words = words, tokens = tokens}

parser.addTarget( tokens, "start", "start" )
parser.addTarget( tokens, "page 2", "page2" )
parser.addTarget( tokens, "page3", "page3" )
parser.addTarget( tokens, "page four", "page4" )

return page
