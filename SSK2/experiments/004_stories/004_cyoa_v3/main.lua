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

-- =============================================================
-- Localizations
-- =============================================================
-- Lua
local mAbs = math.abs;local mPow = math.pow;local mRand = math.random
local getInfo = system.getInfo; local getTimer = system.getTimer
local strMatch = string.match; local strFormat = string.format
local strGSub = string.gsub; local strSub = string.sub

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
--
-- Specialized SSK Features
local actions = ssk.actions


----------------------------------------------------------------------
-- 4. Experiments
----------------------------------------------------------------------
local values	= require "scripts.values"
local parser 	= require "scripts.parser"
local story 	= require "data.story"

--table.print_r(story.start.words)


values.addFlag( "began", false )
values.addFlag( "won" )
values.addFlag( "awesome", false )

--print( values.getType("began"), values.getValue("began") )
--print( values.getType("won"), values.getValue("won") )
--print( values.equal("won", false) )
--print( values.notequal("won", true) )

local exp1 = 
	{  
		-- sub-expression 1 
		{
			{ "began", "eq", false }, -- AND 
			{ "won", "eq", false }, 
		},

		-- OR
		-- sub-expression 2 
		{
			{ "awesome", "eq", true }
		},
	}



-- began, eq, false; won, eq, false : awesome, eq, true

local exp2 = values.genExpression( "began, eq, false; won, eq, false : awesome, eq, true" )

table.print_r( exp1 )
table.print_r( exp2 )
print( "Is True?", values.evaluate( exp1 ) )
print( "Is True?", values.evaluate( exp2 ) )

parser.loadStory( story )

table.print_r( story )

local group = parser.gotoPage( "page1" )

local function onNavigate( event )
	--print("Entering onNavigate")
	--table.dump(event)
	if( event.target and string.len( event.target ) > 0 ) then
		group = parser.gotoPage( event.target, group )
	end
end; listen( "onNavigate", onNavigate )


timer.performWithDelay( 5000,
	function()
		print("BEGAN == true")
		values.setValue( "began", true )
		--values.setValue( "awesome", false )
	end )


timer.performWithDelay( 10000,
	function()
		print("AWESOME == true")
		--values.setValue( "began", true )
		values.setValue( "awesome", true )
	end )

