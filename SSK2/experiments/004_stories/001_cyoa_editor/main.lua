io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
-- main.lua -- REQUIRES SSK2 PRO TO RUN
-- =============================================================
local versionText = "v002 - 08 JAN 2017" 

----------------------------------------------------------------------
--	1. Requires
----------------------------------------------------------------------
require "ssk2.loadSSK"
_G.ssk.init( { launchArgs = ..., 
	            gameFont = native.systemFont, 
	            math2DPlugin = false,
	            debugLevel = 0 } )


local composer 	= require "composer" 

--display.setDefault( "background", unpack( hexcolor("#80caf6") ) )
--display.setDefault( "background", unpack( hexcolor("#dbf5cf") ) )

--require "presets.fastpack.presets"
--require "presets.superpack.presets"

----------------------------------------------------------------------
--	2. Initialization
----------------------------------------------------------------------
	io.output():setvbuf("no") 
if( not onSimulator ) then 
	display.setStatusBar(display.HiddenStatusBar) 
	system.activate("multitouch") 
end	
--local physics = require "physics"
--physics.start()
--physics.setGravity(0,0)
--physics.setDrawMode("hybrid")


local function initPersist()
	local persist = ssk.persist
	persist.setDefault("editorSettings.json", "autoSave", true )
end

----------------------------------------------------------------------
-- 3. Execution
----------------------------------------------------------------------
composer.gotoScene( "ifc.editorScene" )
--composer.gotoScene( "ifc.readerScene" )

--[[ Notes

  Parts:
  	- page
	- stage (place to show current page)

]]



--local editor = require "scripts.editor"
--editor.create()


local function showVersionLabel(release)
	print(release)
	local easyIFC   	= ssk.easyIFC
	local label 		= easyIFC:quickLabel( nil, "  " .. release, left, bottom - 18, gameFont, 12, _W_, 0 )	
	label.enterFrame 	= function( self ) self:toFront() end
	listen(	"enterFrame",	label )
end
showVersionLabel(versionText)


