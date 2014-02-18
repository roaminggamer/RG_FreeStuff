-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- Template #3 - (Nearly) Empty Shell
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

--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

local widget = require "widget"
widget.setTheme( "theme_ios" )

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------

-- Variables
local scrollHeight = 1024
local scrollBox

-- Local Function & Callback Declarations
local gameLogic = {}

-- =======================
-- ====================== Initialization
-- =======================
function gameLogic:createScene( screenGroup )

	--
	-- 1. Create the example
	-- 
	ssk.buttons:presetPush( screenGroup, "default", centerX, 80, 
							200, 40, "Test Button", nil  )


	--
	-- 2. Show the code that made it
	-- 
	scrollBox = widget.newScrollView
	{
		top = centerY, left = 0,
		width = w, height = h/2,
		scrollWidth = w, scrollHeight = scrollHeight,
		maskFile = "images/scrollmask2.png"
	}

	local code = ''
	code = code .. '--\n'
	code = code .. '-- A push-button in one line of code!\n'
	code = code .. '--\n'
	code = code .. 'ssk.buttons:presetPush( screenGroup, "default", centerX, 80,\n'
	code = code ..  '                        200, 40, "Test Button", nil  )'
	responseText = display.newText(code, 0,0,w, scrollHeight, "Courier New", 12)
	responseText:setReferencePoint( display.TopLeftReferencePoint )
	responseText.x, responseText.y = 0, 0
	responseText:setTextColor(0)
	scrollBox:insert( responseText )
	scrollBox:scrollToTop()


end

-- =======================
-- ====================== Cleanup
-- =======================
function gameLogic:destroyScene( screenGroup )
	scrollBox:removeSelf()
	scrollBox = nil
end


return gameLogic