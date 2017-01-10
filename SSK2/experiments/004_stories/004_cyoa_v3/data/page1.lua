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

local text 			= 
	"Standing in the back door, you look out over your yard at the woods beyond.  At first you see nothing, but as your eyes adjust you notice a faint flickering glow far back in the trees.<br><br>" ..
	"Did a plane or helicopter crash?  Should you call the police?  Maybe you should try to help?  You need to decide.  Seconds could mean the difference between life and death if someone is in trouble.<br><br>" ..
	"- [Call the police and wait]. <br>" ..
	"- [Run into the woods and see if you can help]. <br>" ..
	"- {Grab a flashlight and approach the glow with caution}."
local words 		= parser.decode( text )
local tokens 		= parser.identifyTokens( words, {} ) 
parser.addTarget( tokens, "Call the police and wait", "page2" )
parser.addTarget( tokens, "Run into the woods and see if you can help", "page3" )
parser.addTarget( tokens, "Grab a flashlight and approach the glow with caution", "page4" )

page = { words = words, tokens = tokens }


return page

--[[
page = {}
page.words = { { word = "bob", }}
]]