-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Eds Awesome Tool (a free SSK2 PRO co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
--   Last Updated: 06 JAN 2017
-- =============================================================

_G.print = function() end
-- =============================================================
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
require "scripts.widgetFix"

require "ssk2.loadSSK"
_G.ssk.init( { launchArgs 				= ..., 
	            gameFont 				= "Raleway-Light.ttf",
	            measure 					= false,
	            math2DPlugin 			= false,
	            enableAutoListeners 	= true,
	            exportColors 			= true,
	            exportCore 				= true,
	            exportSystem 			= true,
	            debugLevel 				= 0 } )

--table.dump(ssk.display)
--require("strict")  -- install strict.lua to track globals etc.
-- =============================================================
-- =============================================================
-- =============================================================
_G.toolVersion 			= 2017.019
_G.supportURL 				= "http://roaminggamer.com/makegames/eat-lean/"
local logoDelay			= 1000
local logoTime				= 2000

require "presets.eat.presets"

local frame

-- =============================================================
-- =============================================================
-- =============================================================
local util 				= require "scripts.util"
local settings 			= require "scripts.settings"
local projectMgr 		= require "scripts.projectMgr"
local frameMaker 		= require "scripts.frameMaker"

local toolSettings 		= require "scripts.toolSettings"
local contentInstaller 	= require "scripts.contentInstaller"

-- =============================================================
-- Default Settings
-- =============================================================
local keyString = "a1b]c2doeEfjg)h-iujFkllrm*nxoDpMqbr9sAthuZv!wPxUyNzBALByC?DOE`FHGVH_I4JIK>LaM~N|OCP#Q;R{SQTtU<VRW$X5YcZe1X2g3,4n5Y6%708(9G0}!d@ #J$q%&^+&p*/(.)S_3+7-^=8`v~k @,i.[<s>T[z]W{:}f/=?m;w:K|6"
ssk.security.loadKeyFromKeyString(keyString)
local setDefault = toolSettings.setDefault
--local setDefault = toolSettings.set

--setDefault( "lastVersion", 			0.0 )
setDefault( "contentInstalled", 	false )
setDefault( "contentInstalled", 	false )
print( "          Version == ", toolSettings.get( "lastVersion" ) )
print( "Content Installed == ", toolSettings.get( "contentInstalled" ) )
-- =============================================================
-- =============================================================

-- =============================================================
-- Set Up Tool Events
-- =============================================================
require "scripts.toolEvents"

--==
-- Splash
--==
local splash = display.newGroup()
splash.back = display.newRect( splash, centerX, centerY, 20000, 20000 )
splash.back:setFillColor(0)

splash.logo = display.newImageRect( splash, "logo_free.png", 400, 400 )
splash.logo.x = centerX
splash.logo.y = centerY - 60
splash.icon = display.newImageRect( splash, "images/commonIcons/rg144.png", 144, 144 )
splash.icon.x = centerX
splash.icon.y = centerY + 60
local ver = display.newText( splash, "Build: " .. string.format("%4.3f", _G.toolVersion), left, bottom, settings.normalFont, 14 )
ver.anchorX = 0
ver.anchorY = 1


-- =============================================================
-- Default Settings
-- =============================================================
local function runTool()
	local function onComplete( )
		display.remove(splash)
		frame = frameMaker.create( nil )
		if( projectMgr.last() ) then
			--nextFrame( function() post("onSettingsAddons")  end, 100 )
			--nextFrame( function() post("onConfigureBasic")  end, 100 )
			--nextFrame( function() post("onSettingsPlugins")  end, 100 )
			--nextFrame( function() post("onConfigureAdvanced")  end, 100 )
			--nextFrame( function() post("onManageProjects")  end, 100 )
		end
	end

	transition.to( splash.logo, { delay = logoDelay, x = right + 500, time = logoTime, transition = easing.inOutBack } )
	transition.to( splash.icon, { delay = logoDelay, x = left - 500, time = logoTime, transition = easing.inOutBack, onComplete = onComplete } )
end
--runTool()

-- =============================================================
-- =============================================================
-- =============================================================
print( tonumber(toolSettings.get( "lastVersion" ) ) or 0 )

----------------------------------------------------------------------
--	1. Install content if necessary, including updates
----------------------------------------------------------------------
--[[
setDefault( "lastVersion", 			1.0 )
setDefault( "contentInstalled", 	false )
]]
-- Check to see if this is an update, if so force re-install of content.
if( _G.toolVersion < ( tonumber(toolSettings.get( "lastVersion" ) ) or 0) ) then
	ssk.misc.easyAlert( "Installed Old Version?",
		       "You seem to have installed an old version of the tool on your machine.\n\n" ..
		       "This tool does not support installing old versions over an existing installation.\n\n" ..
		       "Please install the latest version and try again, or if you really need to install an old version visit our site for help.",
				{ { "Quit and Install New Version", function() os.exit() end },
				  { "Go To Our Site", 
				    function()
				    	system.openURL(_G.supportURL)
				    	nextFrame( function() os.exit() end, 500 )
				    end } }  )
else
	local sourceMissing = false	
	-- Check to see if this is an update, if so force re-install of content.
	if( _G.toolVersion > ( tonumber(toolSettings.get( "lastVersion" ) ) or 0) ) then
		toolSettings.set( "contentInstalled", false )

	-- Be sure sources folder exists
	elseif( contentInstaller.check() == false ) then
		toolSettings.set( "contentInstalled", false )
		sourceMissing = true
	end

	local installRequired = (not toolSettings.get( "contentInstalled" ) )

	if( installRequired ) then
		local function doInstall()
			local function onComplete( success )
				if( success ) then
					toolSettings.set( "lastVersion", _G.toolVersion ) 
					toolSettings.set( "contentInstalled", true ) 

					ssk.misc.easyAlert( "Thank You",
										"The installation has completed!  Please press OK to start the tool.",
										{ { "OK", 
											function() 
												runTool()
											end } }  )
				else
					ssk.misc.easyAlert( "Oh Darn!",
										"Something went wrong with the tool preparation.\n\n" ..
										"Please be sure you have the latest version and try again.\n\n" ..
										"If the installation fails again, please get support at our site.\n\n",
										{ { "Quit and Try Again", function() os.exit() end },
										  { "Go To Our Site", 
										    function()
										    	system.openURL(_G.supportURL)
										    	nextFrame( function() os.exit() end, 500 )
										    end } }  )
				end
			end

			contentInstaller.run( onComplete )
		end

		print("INSTALL REQUIRED")
		print("INSTALL REQUIRED")
		print("INSTALL REQUIRED")

		if( sourceMissing ) then
			ssk.misc.easyAlert( "Deleted Content?",
				       "It looks like you had this tool installed and deleted some files it depends on to run.\n\n" ..
				       "I can fix that.\n\n" ..
				       "May I take a moment to re-install the required content?",
				       {
							{ "Go To Support",
							   function()
							    	system.openURL(_G.supportURL)
							    	nextFrame( function() os.exit() end, 500 )
							    end },
				       		{ "No", function() os.exit() end },							    
				       		{ "Yes", doInstall } }  )	
		else
			ssk.misc.easyAlert( "First Run or New Version",
						        "It looks like this is a new or updated installation.\n\n" ..
						        "May I take a moment to install some required content?",
						        { { "No", function() os.exit() end }, { "Yes", doInstall } }  )
				      		
		end

	else 
		runTool()
	end

end

-- HACK - Allows 'off clicks' to clear native text seletion
local tmp = display.newRect( centerX, centerY, 20000, 20000 )
tmp.touch = function()
	native.setKeyboardFocus(nil)
	return false
end; tmp:addEventListener("touch")
tmp:toBack()

-- HACK2 - Fixes 'resizer' flooding
local lastResize 
local function doOnResize()
	lastResize = nil
	post("onResize")
end
local function resize()
	if(lastResize) then 
		timer.cancel(lastResize)
	end
	lastResize = timer.performWithDelay( 100, doOnResize )
end; listen("resize", resize)

