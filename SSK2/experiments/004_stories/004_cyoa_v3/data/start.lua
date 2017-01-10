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


local page

local text 			= "You are {watching TV}, when suddenly you hear at loud roar followed by an ear-splitting @Boom!<br><br>You rush to the [back door] and throw it open."
local words 		= parser.decode( text )
local tokens 		= parser.identifyTokens( words, {} ) 
parser.addTarget( tokens, "watching TV", "" )
parser.addTarget( tokens, "Boom", "" )
parser.addTarget( tokens, "back door", "page1" )
page = { words = words, tokens = tokens }

return page

--[[
page = {}
page.words = { { word = "bob", }}
]]