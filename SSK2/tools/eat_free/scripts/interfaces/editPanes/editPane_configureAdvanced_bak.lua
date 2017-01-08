-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Eds Awesome Tool (a free SSK2 PRO co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
--   Last Updated: 06 JAN 2017
-- =============================================================
-- ==
--    Localizations
-- ==
-- Corona & Lua
--
local mAbs = math.abs;local mRand = math.random;local mDeg = math.deg;
local mRad = math.rad;local mCos = math.cos;local mSin = math.sin;
local mAcos = math.acos;local mAsin = math.asin;local mSqrt = math.sqrt;
local mCeil = math.ceil;local mFloor = math.floor;local mAtan2 = math.atan2;
local mPi = math.pi
local pairs = pairs;local getInfo = system.getInfo;local getTimer = system.getTimer
local strFind = string.find;local strFormat = string.format;local strFormat = string.format
local strGSub = string.gsub;local strMatch = string.match;local strSub = string.sub
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
local normRot = ssk.misc.normRot;local easyAlert = ssk.misc.easyAlert
--
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale
-- Forward Declarations
local RGFiles = ssk.files
-- =============================================================
-- =============================================================
-- =============================================================
local util 			= require "scripts.util"
local settings 		= require "scripts.settings"
local projectMgr 	= require "scripts.projectMgr"


local curSettings
local curPlugins

local function commonListener( self, event )
	local id = self.settingID	
	local phase = event.phase 
	
	if( curSettings and 
		(phase == "editing" or phase == "ended" or phase == "submitted" ) ) then
		curSettings[id] = tostring(self.text)		
		post("onSaveProject")
		
		if( phase == "ended" or phase == "submitted" ) then
			--table.dump(curSettings,nil, "editPane_configureAdvanced - commonListener()")			
			--post("onSaveProject")
		end
	end
	return true
end

local function quickPrep( textField, default, label )
	local id = textField.settingID	
	if( not curSettings ) then return end	

	if( curSettings[id] and string.len(tostring(curSettings[id])) > 0 ) then 
		textField.text = tostring(curSettings[id] )

	elseif( default ) then
		curSettings[id] = default
		textField.text = tostring(curSettings[id])
		post("onSaveProject")
	end
	
	local defaultSettings = require 'scripts.defaultSettings'
	--print(id, helpRecord)
	local helpRecord = defaultSettings.getHelp( id )
	if( label and helpRecord ) then
		function label.touch( self, event )
			if( event.phase == "ended" ) then
				--print("help me with", fieldName )
				util.infoPopup( helpRecord, label.text )
			end
		end; label:addEventListener( "touch" )
	end	
end



--[[
local function onSelectedSetting( self, choice )
	print( "onSelectedSetting() ", choice )
	--table.dump(self)
	--if( self.fieldName ) then print( self.fieldName ) end
end
--]]


-- == Forward Declarations

local editPane_configureAdvanced = {}

local rightAdjust = 150
local colOffset = 205
local dy1 = 50
local dy2 = 40
local ox = settings.editPaneCommonTextFieldWidth


-- Map Redraw Method
editPane_configureAdvanced.redraw = function( self )
	--print("editPane_configureAdvanced.redraw() ")

	local currentProject = projectMgr.current()
	if( not currentProject ) then 
		curSettings = {}
		curPlugins = {}
	else
		--table.dump(curSettings,nil,"curSettings")
		curSettings = currentProject.settings
		curPlugins = currentProject.plugins
	end	

	local content = self.content
	while ( content.numChildren > 0 ) do
		display.remove( content[1] )
	end

	local currentGroup

    local title = easyIFC:quickLabel( content, "Advanced Settings", left + fullw/2, top + settings.menuBarH + 30, 
                                        settings.editPaneCommonTitleFont, 
                                        settings.editPaneCommonTitleFontSize, 
                                        settings.editPaneCommonTitleFontColor )

	--
	-- 
	--
	local y = title.y + dy1	
	--local y = top + settings.menuBarH + dy1	
	local x = left + fullw/2

	local function onChooseCategory( event )
		--table.dump(event)
		
		local choice = event.target:getText()
		--print(choice)
		
		display.remove(currentGroup)
		currentGroup = display.newGroup()
		content:insert(currentGroup)
		if( choice == "FPS / Shaders / Debug" ) then
			editPane_configureAdvanced.fps_shaders_debug( currentGroup, x, y )

		elseif( choice == "Android" ) then
			editPane_configureAdvanced.android( currentGroup, x, y )

		elseif( choice == "iOS" ) then
			editPane_configureAdvanced.ios( currentGroup, x, y )

		elseif( choice == "Desktop" ) then
			editPane_configureAdvanced.desktop( currentGroup, x, y )

		elseif( choice == "Exclusions" ) then
			editPane_configureAdvanced.exclusions( currentGroup, x, y )

		elseif( choice == "Monetization" ) then
			editPane_configureAdvanced.moneyIDs( currentGroup, x, y )			

		elseif( choice == "Plugins" ) then
			editPane_configureAdvanced.plugins( currentGroup, x, y )			

		end
	end

	local radioGroup = display.newGroup()
	content:insert( radioGroup )
	local labels = { }
	
	-- Add options based on selected targets
	if( curSettings.generate_android  == "true" or settings.generate_chromebook == "true" ) then
		labels[#labels+1] = "Android"
	end
	
	if( curSettings.generate_ios  == "true" ) then
		labels[#labels+1] = "iOS"
	end
	
	if( curSettings.generate_desktop_osx  == "true" or curSettings.generate_desktop_win32  == "true" ) then
		labels[#labels+1] = "Desktop"
	end

	labels[#labels+1] = "FPS / Shaders / Debug"
	labels[#labels+1] = "Exclusions"
	if( util.usingMonetizers( currentProject ) ) then
		labels[#labels+1] = "Monetization"
	end
	if( util.usingAnalytics( currentProject ) or
		util.usingAttribution( currentProject ) or
		util.usingIAP( currentProject ) or
		util.usingSocial( currentProject ) or
		util.usingUtils( currentProject ) ) then
		labels[#labels+1] = "Plugins"
	end
	--local labels = { "Android", "iOS", "Desktop", "FPS / Shaders / Debug", "Exclusions", "Monetization", "Plugins", "Addons" }
	local tweenX 		= 10
	local bufferX 		= 10
	local buttonWidth 	= 130
	local buttonHeight 	= settings.editPaneCommonTextFieldHeight 
	local curX = left + tweenX + buttonWidth/2
	local curX = left
	local firstB
	for i = 1, #labels do
		local lbl = display.newText( labels[i], -10000, -10000, settings.boldFont, settings.defaultFontSize   )
		local lbw = lbl.contentWidth
		display.remove(lbl)
		local lbw = lbl.contentWidth
		display.remove(lbl)
		buttonWidth = bufferX * 2 + lbw
		--print( "buttonWidth", i, buttonWidth)
		lbw = nil
		curX = curX + buttonWidth/2
		local tmp = easyIFC:presetRadio( radioGroup, "default", curX, y,  
				                             buttonWidth, settings.editPaneCommonTextFieldHeight, 
				                             labels[i], onChooseCategory, 
				                             { labelSize = settings.defaultFontSize, labelFont = settings.boldFont } )	
		curX = curX + buttonWidth/2 + tweenX 


		firstB = firstB or tmp
		--firstB = tmp -- EDOCHI
		--if( i == 5 ) then firstB = tmp end -- EDOCHI
	end	

	radioGroup.x = centerX - radioGroup.contentWidth/2
	nextFrame( function() firstB:toggle() end )
end

function editPane_configureAdvanced.fps_shaders_debug( group, x, y )

	local childGroup = display.newGroup()
	group:insert(childGroup)
	y = y + dy2 * 1.5
	local startY = y

	x = x + 120


	--
	-- EFM
	--
	y = startY
	local label = easyIFC:quickLabel( childGroup, "Frame Rate", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( childGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "60",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"30",
		                       		"60",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'frame_rate',
	                       		label 	  = label,
	                       } )
	--
	-- EFM
	--
	y = y + dy2
	local label = easyIFC:quickLabel( childGroup, "Shader Precision", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( childGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "auto",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"auto",
		                       		"lowp",
		                       		"mediump",
		                       		"highp",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'shader_precision',
	                       		label 	  = label,
	                       } )
	--
	-- EFM
	--
	y = y + dy2
	local label = easyIFC:quickLabel( childGroup, "Show Runtime Errors", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( childGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "auto",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"auto",
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'show_runtime_errors',
	                       		label 	  = label,
	                       } )
	--
	-- Debug Info Stripping
	--
	y = y + dy2
	local label = easyIFC:quickLabel( childGroup, "Never Strip Debug Info", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( childGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "false",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'never_strip_debug_info',
	                       		label 	  = label,
	                       } )
--
--
--
	--
	-- Enable Composer Debug
	--
	y = y + dy2
	local label = easyIFC:quickLabel( childGroup, "Composer Debug Enable", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( childGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "false",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'composer_is_debug',
	                       		label 	  = label,
	                       } )

	--
	-- Composer Recycle on Low Memory
	--
	y = y + dy2
	local label = easyIFC:quickLabel( childGroup, "Composer Recycle On Low Memory", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( childGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "true",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'composer_recycle_on_low_memory',
	                       		label 	  = label,
	                       } )


	--
	-- Composer Recycle On Scene Change
	--
	y = y + dy2
	local label = easyIFC:quickLabel( childGroup, "Composer Recycle On Scene Change", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( childGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "false",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'composer_recycle_on_scene_change',
	                       		label 	  = label,
	                       } )



end




function editPane_configureAdvanced.desktop( group, x, y )

	local leftGroup = display.newGroup()
	group:insert( leftGroup )
	leftGroup.x = -colOffset + rightAdjust

	local rightGroup = display.newGroup()
	group:insert( rightGroup )
	rightGroup.x = colOffset + rightAdjust

	y = y + dy2 * 1.5
	local startY = y

	-- EFM
	--
	y = startY
	local label = easyIFC:quickLabel( leftGroup, "Default Mode", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 
                       

	util.drawDropdownMenu( leftGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "normal",
	                       		throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"fullscreen",
		                       		"normal",
		                       		"minimized",
		                       		"maximized",
		                       		"windowed",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'desktop_default_mode',
	                       		label 	  = label,
	                       } )

	
	--
	-- Default Width / Height
	--
	y = y + dy2 
	local label = easyIFC:quickLabel( leftGroup, "Default Width / Height", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	local defaultWidthField = util.createTextEdit( leftGroup, x - ox + 5, y,
	                                      settings.editPaneCommonTextFieldWidth/2 - 5, 
	                                      settings.editPaneCommonTextFieldHeight, 
	                                      settings.defaultFont,
	                                      settings.defaultFontSize, 	                                      
	                                      "540", "default", commonListener )  
	defaultWidthField.settingID = "desktop_default_width"
	defaultWidthField.anchorX = 0
	quickPrep(defaultWidthField, nil, label)
	local defaultHeightField = util.createTextEdit( leftGroup, 
		                                  x - ox + 10 + settings.editPaneCommonTextFieldWidth/2, y,
	                                      settings.editPaneCommonTextFieldWidth/2 - 5, 
	                                      settings.editPaneCommonTextFieldHeight, 
	                                      settings.defaultFont,
	                                      settings.defaultFontSize, 	                                      
	                                      "960", "default", commonListener )  
	defaultHeightField.settingID = "desktop_default_height"
	defaultHeightField.anchorX = 0
	quickPrep(defaultHeightField, nil, label)

	--
	-- Default Width / Height
	--
	y = y + dy2 
	local label = easyIFC:quickLabel( leftGroup, "Minimum Width / Height", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	local minWidthField = util.createTextEdit( leftGroup, x - ox + 5, y,
	                                      settings.editPaneCommonTextFieldWidth/2 - 5, 
	                                      settings.editPaneCommonTextFieldHeight, 
	                                      settings.defaultFont,
	                                      settings.defaultFontSize, 	                                      
	                                      "540", "default", commonListener )  
	minWidthField.settingID = "desktop_min_width"
	minWidthField.anchorX = 0
	quickPrep(minWidthField, nil, label)
	local minHeightField = util.createTextEdit( leftGroup, 
		                                  x - ox + 10 + settings.editPaneCommonTextFieldWidth/2, y,
	                                      settings.editPaneCommonTextFieldWidth/2 - 5, 
	                                      settings.editPaneCommonTextFieldHeight, 
	                                      settings.defaultFont,
	                                      settings.defaultFontSize, 	                                      
	                                      "960", "default", commonListener )  
	minHeightField.settingID = "desktop_min_height"
	minHeightField.anchorX = 0
	quickPrep(minHeightField, nil, label)

	--
	-- EFM
	--
	y = y + dy2
	local label = easyIFC:quickLabel( leftGroup, "Resizeable", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( leftGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "true",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'desktop_resizable',
	                       		label 	  = label,
	                       } )

	--
	-- EFM
	--
	y = y + dy2
	local label = easyIFC:quickLabel( leftGroup, "Enable Close Button", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( leftGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "true",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'desktop_enable_close_button',
	                       		label 	  = label,
	                       		
	                       } )

	--
	-- EFM
	--
	y = y + dy2
	local label = easyIFC:quickLabel( leftGroup, "Enable Minimize Button", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( leftGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "true",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'desktop_enable_minimize_button',
	                       		label 	  = label,
	                       } )

	--
	-- EFM
	--
	y = y + dy2
	local label = easyIFC:quickLabel( leftGroup, "Enable Maximize Button", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 


	util.drawDropdownMenu( leftGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "true",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'desktop_enable_maximize_button',
	                       		label 	  = label,
	                       } )

	--
	-- EFM
	--
	y = y + dy2
	local label = easyIFC:quickLabel( leftGroup, "Suspend When Mimimized", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( leftGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "true",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'desktop_suspend_when_minimized',
	                       		label 	  = label,
	                       } )

	--
	-- EFM
	--
	y = startY
	local label = easyIFC:quickLabel( rightGroup, "Show Window Title", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( rightGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "false",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'desktop_show_window_title',
	                       		label 	  = label,
	                       } )


	--
	-- EFM
	--
	y = y + dy2 
	local label = easyIFC:quickLabel( rightGroup, "Title Text", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	local titleText = util.createTextEdit( rightGroup, x - ox + 5, y,
	                                      settings.editPaneCommonTextFieldWidth, 
	                                      settings.editPaneCommonTextFieldHeight, 
	                                      settings.defaultFont,
	                                      settings.defaultFontSize, 	                                      
	                                      "", "default", commonListener )  
	titleText.settingID = "desktop_title_text"
	titleText.anchorX = 0
	quickPrep(titleText, nil, label)
	
end




function editPane_configureAdvanced.exclusions( group, x, y )
	local currentProject = projectMgr.current()
	--
	-- Exclusions
	--
	-- == All
	y = y + dy2 * 1.5
	local label = easyIFC:quickLabel( group, "All", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	local excludeAll = util.createTextEdit( group, x - ox + 5, y,
	                                      settings.editPaneCommonTextFieldWidth * 2.5, 
	                                      settings.editPaneCommonTextFieldHeight, 
	                                      settings.defaultFont,
	                                      settings.defaultFontSize, 	                                      
	                                      "", "default", commonListener )  
	excludeAll.settingID = "exclude_all"
	excludeAll.anchorX = 0
	quickPrep(excludeAll, "*secret.txt,*.pdf", label )

	-- == Android
	if( currentProject.settings.generate_android == "true" ) then
		y = y + dy2 
		local label = easyIFC:quickLabel( group, "Android", x - ox, y,
	                                        settings.defaultFont, 
	                                        settings.defaultFontSize, 
	                                        settings.defaultFontColor, 1 ) 

		local excludeAndroid = util.createTextEdit( group, x - ox + 5, y,
		                                      settings.editPaneCommonTextFieldWidth * 2.5, 
		                                      settings.editPaneCommonTextFieldHeight, 
		                                      settings.defaultFont,
		                                      settings.defaultFontSize, 	                                      
		                                      "", "default", commonListener )  
		excludeAndroid.settingID = "exclude_android"
		excludeAndroid.anchorX = 0
		quickPrep(excludeAndroid,"Icon.png,*@2x.png,music/*.m4a", label )
	end

	-- == iOS
	if( currentProject.settings.generate_ios == "true" ) then
		y = y + dy2 
		local label = easyIFC:quickLabel( group, "iOS", x - ox, y,
	                                        settings.defaultFont, 
	                                        settings.defaultFontSize, 
	                                        settings.defaultFontColor, 1 ) 

		local excludeiOS = util.createTextEdit( group, x - ox + 5, y,
		                                      settings.editPaneCommonTextFieldWidth * 2.5, 
		                                      settings.editPaneCommonTextFieldHeight, 
		                                      settings.defaultFont,
		                                      settings.defaultFontSize, 	                                      
		                                      "", "default", commonListener )  
		excludeiOS.settingID = "exclude_ios"
		excludeiOS.anchorX = 0
		quickPrep(excludeiOS,"Icon-*dpi.png,music/*.ogg", label )
	end

	-- == tvOS
	if( currentProject.settings.generate_apple_tv == "true" ) then
		y = y + dy2 
		local label = easyIFC:quickLabel( group, "tvOS", x - ox, y,
	                                        settings.defaultFont, 
	                                        settings.defaultFontSize, 
	                                        settings.defaultFontColor, 1 ) 

		local excludeTVOS = util.createTextEdit( group, x - ox + 5, y,
		                                      settings.editPaneCommonTextFieldWidth * 2.5, 
		                                      settings.editPaneCommonTextFieldHeight, 
		                                      settings.defaultFont,
		                                      settings.defaultFontSize, 	                                      
		                                      "", "default", commonListener )  
		excludeTVOS.settingID = "exclude_tvos"
		excludeTVOS.anchorX = 0
		quickPrep(excludeTVOS,"Icon-*dpi.png,music/*.ogg", label )
	end

	-- == OS X
	if( currentProject.settings.generate_desktop_osx == "true" ) then
		y = y + dy2 
		local label = easyIFC:quickLabel( group, "OS X", x - ox, y,
	                                        settings.defaultFont, 
	                                        settings.defaultFontSize, 
	                                        settings.defaultFontColor, 1 ) 

		local excludeOSX = util.createTextEdit( group, x - ox + 5, y,
		                                      settings.editPaneCommonTextFieldWidth * 2.5, 
		                                      settings.editPaneCommonTextFieldHeight, 
		                                      settings.defaultFont,
		                                      settings.defaultFontSize, 	                                      
		                                      "", "default", commonListener )  
		excludeOSX.settingID = "exclude_osx"
		excludeOSX.anchorX = 0
		quickPrep(excludeOSX,"Default*.png,Icon*.png,Icon*.ico,Icon*.icns", label )
	end

	-- == Win
	if( currentProject.settings.generate_desktop_win32 == "true" ) then
		y = y + dy2 
		local label = easyIFC:quickLabel( group, "Win", x - ox, y,
	                                        settings.defaultFont, 
	                                        settings.defaultFontSize, 
	                                        settings.defaultFontColor, 1 ) 

		local excludeWin = util.createTextEdit( group, x - ox + 5, y,
		                                      settings.editPaneCommonTextFieldWidth * 2.5, 
		                                      settings.editPaneCommonTextFieldHeight, 
		                                      settings.defaultFont,
		                                      settings.defaultFontSize, 	                                      
		                                      "", "default", commonListener )  
		excludeWin.settingID = "exclude_win"
		excludeWin.anchorX = 0
		quickPrep(excludeWin,"Default*.png,Icon*.png,Icon*.ico,Icon*.icns", label )
	end

end



function editPane_configureAdvanced.android( group, x, y )

	local leftGroup = display.newGroup()
	group:insert( leftGroup )
	leftGroup.x = -colOffset + rightAdjust

	local rightGroup = display.newGroup()
	group:insert( rightGroup )
	rightGroup.x = colOffset + rightAdjust

	y = y + dy2 * 1.5
	local startY = y

	--
	-- Version Code
	--
	y = startY
	local label = easyIFC:quickLabel( leftGroup, "Version Code", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	local versionCode = util.createTextEdit( leftGroup, x - ox + 5, y,
	                                      settings.editPaneCommonTextFieldWidth, 
	                                      settings.editPaneCommonTextFieldHeight, 
	                                      settings.defaultFont,
	                                      settings.defaultFontSize, 	                                      
	                                      "", "number", commonListener )  
	
	versionCode.settingID = "android_version_code"
	versionCode.anchorX = 0
	quickPrep(versionCode, nil, label )

	--
	-- Minimum SDK
	--
	y = y + dy2 
	local label = easyIFC:quickLabel( leftGroup, "Min SDK", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	local minSDK = util.createTextEdit( leftGroup, x - ox + 5, y,
	                                      settings.editPaneCommonTextFieldWidth, 
	                                      settings.editPaneCommonTextFieldHeight, 
	                                      settings.defaultFont,
	                                      settings.defaultFontSize, 	                                      
	                                      "14", "number", commonListener )  
	minSDK.settingID = "android_min_sdk"
	minSDK.anchorX = 0
	quickPrep(minSDK, nil, label )


	--
	-- EFM
	--
	y = y + dy2 
	local label = easyIFC:quickLabel( leftGroup, "Large Heap", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 
                     
	util.drawDropdownMenu( leftGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "true",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'android_large_heap',
	                       		label 	  = label,
	                       } )
	--
	-- EFM
	--
	y = y + dy2
	local label = easyIFC:quickLabel( leftGroup, "Uses Expansion Files", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 
	util.drawDropdownMenu( leftGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "false",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'android_uses_expansion_files',
	                       		label 	  = label,
	                       } )
	


	--
	-- EFM
	--
	y = y + dy2
	local label = easyIFC:quickLabel( leftGroup, "Read-Only File Access", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( leftGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "true",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'android_readonly_file_access',
	                       		label 	  = label,
	                       } )

	--
	-- EFM
	--
	y = y + dy2
	local label = easyIFC:quickLabel( leftGroup, "Is Game", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( leftGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "true",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'android_is_game',
	                       		label 	  = label,
	                       } )
	--
	-- EFM
	--
	y = startY
	local label = easyIFC:quickLabel( rightGroup, "Supports Small Screens", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( rightGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "auto",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"auto",
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'android_supports_small_screens',
	                       		label 	  = label,
	                       } )

	--
	-- EFM
	--
	y = y + dy2
	local label = easyIFC:quickLabel( rightGroup, "Supports Normal Screens", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( rightGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "auto",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"auto",
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'android_supports_normal_screens',
	                       		label 	  = label,
	                       } )

	--
	-- EFM
	--
	y = y + dy2
	local label = easyIFC:quickLabel( rightGroup, "Supports Large Screens", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( rightGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "auto",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"auto",
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'android_supports_large_screens',
	                       		label 	  = label,
	                       } )

	--
	-- EFM
	--
	y = y + dy2
	local label = easyIFC:quickLabel( rightGroup, "Supports Extra Large Screens", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( rightGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "auto",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"auto",
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'android_supports_xlarge_screens',
	                       		label 	  = label,
	                       } )

	--
	-- EFM
	--
	y = y + dy2
	local label = easyIFC:quickLabel( rightGroup, "Supports TV", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

		util.drawDropdownMenu( rightGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "false",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'android_supports_tv',
	                       		label 	  = label,
	                       } )


	
end


function editPane_configureAdvanced.ios( group, x, y )

	local leftGroup = display.newGroup()
	group:insert( leftGroup )
	leftGroup.x = -colOffset + rightAdjust
	leftGroup.x = rightAdjust


	--
	-- Bundle Display Name
	--
	y = y + dy2 * 1.5
	local label = easyIFC:quickLabel( leftGroup, "Bundle Display Name", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	local bundleDisplayName = util.createTextEdit( leftGroup, x - ox + 5, y,
	                                      settings.editPaneCommonTextFieldWidth, 
	                                      settings.editPaneCommonTextFieldHeight, 
	                                      settings.defaultFont,
	                                      settings.defaultFontSize, 	                                      
	                                      "", "default", commonListener )  
	bundleDisplayName.settingID = "ios_bundle_display_name"
	bundleDisplayName.anchorX = 0
	quickPrep(bundleDisplayName, nil, label )

	--
	-- Bundle Name
	--
	y = y + dy2 
	local label = easyIFC:quickLabel( leftGroup, "Bundle Name", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	local bundleName = util.createTextEdit( leftGroup, x - ox + 5, y,
	                                      settings.editPaneCommonTextFieldWidth, 
	                                      settings.editPaneCommonTextFieldHeight, 
	                                      settings.defaultFont,
	                                      settings.defaultFontSize, 	                                      
	                                      "", "default", commonListener )  
	bundleName.settingID = "ios_bundle_name"
	bundleName.anchorX = 0
	quickPrep(bundleName, nil, label )

	--
	-- Minimum iOS Version
	--
	y = y + dy2 
	local label = easyIFC:quickLabel( leftGroup, "Min iOS Version", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	local minVersion = util.createTextEdit( leftGroup, x - ox + 5, y,
	                                      settings.editPaneCommonTextFieldWidth, 
	                                      settings.editPaneCommonTextFieldHeight, 
	                                      settings.defaultFont,
	                                      settings.defaultFontSize, 	                                      
	                                      "", "number", commonListener )  
	minVersion.settingID = "ios_min_version"
	minVersion.anchorX = 0
	quickPrep(minVersion, nil, label )

	--
	-- EFM
	--
	y = y + dy2 
	local label = easyIFC:quickLabel( leftGroup, "Exit On Suspend", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( leftGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "false",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'ios_exit_on_suspend',
	                       		label 	  = label,
	                       } )

	--
	-- EFM
	--
	y = y + dy2
	local label = easyIFC:quickLabel( leftGroup, "Icon is Pre-Rendered", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( leftGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "true",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'ios_icon_is_prerendered',
	                       		label 	  = label,
	                       } )

	--
	-- EFM
	--
	y = y + dy2
	local label = easyIFC:quickLabel( leftGroup, "Hide Status Bar", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( leftGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "true",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'ios_hide_status_bar',
	                       		label 	  = label,
	                       } )

	--
	-- Debug Info Stripping
	--
	y = y + dy2
	local label = easyIFC:quickLabel( leftGroup, "Skip PNG Crush", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( leftGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "false",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'ios_skip_png_crush',
	                       		label 	  = label,
	                       } )

	
end


function editPane_configureAdvanced.moneyIDs( group, x, y )

	y = y + dy2 * 1
	local startY = y

	local currentGroup 
	local amazonStoreIDs
	local appleStoreIDs
	local appleTVIDs
	local googlePlayIDs


	local function onChooseStore( event )
		--table.dump(event)
		
		local choice = event.target:getText()
		--print(choice)
		
		display.remove(currentGroup)
		currentGroup = display.newGroup()
		group:insert(currentGroup)

		if( choice == "Amazon Store" ) then
			amazonStoreIDs()			
		
		elseif( choice == "iOS Ad IDs" ) then
			appleStoreIDs()			
		
		elseif( choice == "Apple TV Ad IDs" ) then
			appleTVIDs()			

		elseif( choice == "Android Ad IDs" ) then
			googlePlayIDs()			
		end
	end

	local radioGroup = display.newGroup()
	group:insert( radioGroup )
	--local labels = { "Amazon Store",  "iOS Ad IDs",  "Apple TV Ad IDs", "Android Ad IDs" }
	--local labels = { "iOS Ad IDs", "Apple TV Ad IDs", "Android Ad IDs" }
	local labels = {}
	if( curSettings.generate_ios == "true" ) then labels[#labels+1] = "iOS Ad IDs" end
	if( curSettings.generate_android == "true" ) then labels[#labels+1] = "Android Ad IDs" end	
	if( curSettings.generate_apple_tv == "true" ) then labels[#labels+1] = "Apple TV Ad IDs" end
	local tweenX 		= 10
	local bufferX 		= 10
	local buttonWidth 	= 130
	local buttonHeight 	= settings.editPaneCommonTextFieldHeight 
	local curX = left + tweenX + buttonWidth/2
	local curX = left + tweenX
	local firstB
	for i = 1, #labels do
		local lbl = display.newText( labels[i], -10000, -10000, settings.defaultFont, settings.defaultFontSize   )
		local lbw = lbl.contentWidth
		display.remove(lbl)
		local lbw = lbl.contentWidth
		display.remove(lbl)
		buttonWidth = bufferX * 2 + lbw
		--print( "buttonWidth", i, buttonWidth)
		lbw = nil
		curX = curX + buttonWidth/2
		local tmp = easyIFC:presetRadio( radioGroup, "default", curX, y,  
				                             buttonWidth, settings.editPaneCommonTextFieldHeight, 
				                             labels[i], onChooseStore, 
				                             { labelSize = settings.defaultFontSize, labelFont = settings.defaultFont } )	
		curX = curX + buttonWidth/2 + tweenX 
		firstB = firstB or tmp
		--firstB = tmp -- EDOCHI
		--if( i == 4 ) then firstB = tmp end -- EDOCHI
	end	

	radioGroup.x = centerX - radioGroup.contentWidth/2
	nextFrame( function() firstB:toggle() end )


	y = y + dy2 * 1
	local startY = y

	appleStoreIDs = function()
		local curRow = 0
		local cols = 0		
		local textFieldWidth = 2*settings.editPaneCommonTextFieldWidth/3
		local dx = 310

		local curX = x
		local curY = startY

		local childGroup = display.newGroup()
		currentGroup:insert( childGroup )

		local function nextXY( )
			if( curRow == 0 ) then 
				cols = cols + 1
			end
			curRow = curRow + 1
			if( curRow > 8) then
				curX = curX + dx
				curY = startY
				curRow = 0				
			else
				curY = curY + dy2
			end
		end

		if( curSettings.generate_ios == "true" and curPlugins.monetization_adbuddiz_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "AdBuddiz Publisher Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_adbuddiz_publisher_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end


		if( curSettings.generate_ios == "true" and curPlugins.monetization_adcolony_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "AdColony API Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_adcolony_api_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end

		--[[
		if( curSettings.generate_android == "true" and curPlugins.monetization_adbuddiz_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "AdBuddiz Rewarded Publisher Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize - 3.5, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_adbuddiz_rewarded_publisher_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		--]]

		if( curSettings.generate_ios == "true" and curPlugins.monetization_admob_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "AdMob Banner App ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_admob_banner_app_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.monetization_admob_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "AdMob Interstitial App ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_admob_interstitial_app_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.monetization_applovin_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "AppLovin SDK Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_applovin_sdk_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.monetization_appnext_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Appnext Placement ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_appnext_placement_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.monetization_appodeal_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Appodeal App Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_appodeal_app_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.monetization_chartboost_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "ChartBoost API Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_chartboost_api_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end

		if( curSettings.generate_ios == "true" and curPlugins.monetization_corona_ads_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Corona Ads Placement ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize - 2, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_corona_ads_placement_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.monetization_fan_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "FAN Placment ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_fan_placement_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.monetization_inmobi_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "InMobi Banner ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_inmobi_banner_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.monetization_inmobi_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "InMobi Interstitial ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_inmobi_interstitial_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.monetization_kidoz_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Kidoz Publisher ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_kidoz_publisher_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.monetization_kidoz_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Kiddoz Security Token", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_kidoz_security_token";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.monetization_mediabrix_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "MediaBrix App ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_mediabrix_app_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.monetization_peanuts_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Peanut Labs User ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_peanutlabs_user_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.monetization_peanuts_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Peanut Labs App Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_peanutlabs_app_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.monetization_peanuts_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Peanut Labs App ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "number", commonListener )
			tmp.settingID = "ads_ios_peanutlabs_app_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.monetization_personaly_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Persona.ly App Hash", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_personaly_app_hash";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.monetization_personaly_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Persona.ly User ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_personaly_user_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.monetization_pollfish_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Pollfish API Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_pollfish_api_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.monetization_revmob_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "RevMob App ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_revmob_app_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.monetization_superawesome_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "SuperAwesome Placement ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize - 3, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_superawesome_placement_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.monetization_supersonic_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Supersonic App Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_supersonic_app_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.monetization_stripe_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Stripe Secret Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_stripe_secret_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.monetization_stripe_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Stripe Public Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_stripe_publishable_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end

		if( curSettings.generate_ios == "true" and curPlugins.monetization_trial_pay_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Trial Pay App Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_trial_pay_app_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end

		if( curSettings.generate_ios == "true" and curPlugins.monetization_trial_pay_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Trial Pay SID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_trial_pay_sid";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end


		if( curSettings.generate_ios == "true" and curPlugins.monetization_vungle_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Vungle App Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_ios_vungle_app_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end		
		if( cols == 3 ) then
			childGroup.x = childGroup.x - 100
		elseif( cols == 2 ) then
			childGroup.x = childGroup.x
		elseif( cols == 1 ) then
			childGroup.x = childGroup.x + 140
			if( curRow > 0 ) then
				childGroup.y = childGroup.y + ((9-curRow)*dy2)/2
			end
		end

	end

	amazonStoreIDs = function()
		local y = startY

		local label = easyIFC:quickLabel( currentGroup, "AdMob Banner", x - ox, y,
	                                        settings.defaultFont, 
	                                        settings.defaultFontSize, 
	                                        settings.defaultFontColor, 1 ) 

		local tmp = util.createTextEdit( currentGroup, x - ox + 5, y,
		                                      settings.editPaneCommonTextFieldWidth * 2.5, 
		                                      settings.editPaneCommonTextFieldHeight, 
		                                      settings.defaultFont,
		                                      settings.defaultFontSize, 	                                      
		                                      "", "default", commonListener )
		tmp.settingID = "apple_tv_admob_banner";quickPrep(tmp, nil, label )
		tmp.anchorX = 0
		--
		--
		y = y + dy2
		local label = easyIFC:quickLabel( currentGroup, "AdMob Interstitial", x - ox, y,
	                                        settings.defaultFont, 
	                                        settings.defaultFontSize, 
	                                        settings.defaultFontColor, 1 ) 

		local tmp = util.createTextEdit( currentGroup, x - ox + 5, y,
		                                      settings.editPaneCommonTextFieldWidth * 2.5, 
		                                      settings.editPaneCommonTextFieldHeight, 
		                                      settings.defaultFont,
		                                      settings.defaultFontSize, 	                                      
		                                      "", "default", commonListener )
		tmp.settingID = "apple_tv_admob_interstitial";quickPrep(tmp, nil, label )
		tmp.anchorX = 0
		--
		--
		y = y + dy2
		local label = easyIFC:quickLabel( currentGroup, "AppLovin SDK Key", x - ox, y,
	                                        settings.defaultFont, 
	                                        settings.defaultFontSize, 
	                                        settings.defaultFontColor, 1 ) 

		local tmp = util.createTextEdit( currentGroup, x - ox + 5, y,
		                                      settings.editPaneCommonTextFieldWidth * 2.5, 
		                                      settings.editPaneCommonTextFieldHeight, 
		                                      settings.defaultFont,
		                                      settings.defaultFontSize, 	                                      
		                                      "", "default", commonListener )
		tmp.settingID = "apple_tv_applovin";quickPrep(tmp, nil, label )
		tmp.anchorX = 0

		--
		--
		y = y + dy2
		local label = easyIFC:quickLabel( currentGroup, "RevMob Media ID", x - ox, y,
	                                        settings.defaultFont, 
	                                        settings.defaultFontSize, 
	                                        settings.defaultFontColor, 1 ) 

		local tmp = util.createTextEdit( currentGroup, x - ox + 5, y,
		                                      settings.editPaneCommonTextFieldWidth * 2.5, 
		                                      settings.editPaneCommonTextFieldHeight, 
		                                      settings.defaultFont,
		                                      settings.defaultFontSize, 	                                      
		                                      "", "default", commonListener )
		tmp.settingID = "apple_tv_revmob";quickPrep(tmp, nil, label )
		tmp.anchorX = 0

		--
		--
		y = y + dy2
		local label = easyIFC:quickLabel( currentGroup, "Vungle App ID", x - ox, y,
	                                        settings.defaultFont, 
	                                        settings.defaultFontSize, 
	                                        settings.defaultFontColor, 1 ) 

		local tmp = util.createTextEdit( currentGroup, x - ox + 5, y,
		                                      settings.editPaneCommonTextFieldWidth * 2.5, 
		                                      settings.editPaneCommonTextFieldHeight, 
		                                      settings.defaultFont,
		                                      settings.defaultFontSize, 	                                      
		                                      "", "default", commonListener )
		tmp.settingID = "apple_tv_vungle";quickPrep(tmp, nil, label )
		tmp.anchorX = 0
	end


	appleTVIDs = function()
		local curRow = 0
		local cols = 0		
		local textFieldWidth = 2*settings.editPaneCommonTextFieldWidth/3
		local dx = 310

		local curX = x
		local curY = startY

		local childGroup = display.newGroup()
		currentGroup:insert( childGroup )

		local function nextXY( )
			if( curRow == 0 ) then 
				cols = cols + 1
			end
			curRow = curRow + 1
			if( curRow > 8) then
				curX = curX + dx
				curY = startY
				curRow = 0				
			else
				curY = curY + dy2
			end
		end

		if( curSettings.generate_apple_tv == "true" and curPlugins.monetization_applovin_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "AppLovin SDK Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_apple_tv_applovin_sdk_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end

		if( curSettings.generate_apple_tv == "true" and curPlugins.monetization_appodeal_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Appodeal App Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_apple_tv_appodeal_app_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()

		end
		if( cols == 3 ) then
			childGroup.x = childGroup.x - 100
		elseif( cols == 2 ) then
			childGroup.x = childGroup.x
		elseif( cols == 1 ) then
			childGroup.x = childGroup.x + 140
			if( curRow > 0 ) then
				childGroup.y = childGroup.y + ((9-curRow)*dy2)/2
			end
		end

	end

	googlePlayIDs = function()
		local curRow = 0
		local cols = 0		
		local textFieldWidth = 2*settings.editPaneCommonTextFieldWidth/3
		local dx = 310

		local curX = x
		local curY = startY

		local childGroup = display.newGroup()
		currentGroup:insert( childGroup )

		local function nextXY( )
			if( curRow == 0 ) then 
				cols = cols + 1
			end
			curRow = curRow + 1
			if( curRow > 8) then
				curX = curX + dx
				curY = startY
				curRow = 0				
			else
				curY = curY + dy2
			end
		end


		if( curSettings.generate_android == "true" and curPlugins.monetization_adbuddiz_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "AdBuddiz Publisher Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_adbuddiz_publisher_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end

		if( curSettings.generate_android == "true" and curPlugins.monetization_adcolony_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "AdColony API Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_adcolony_api_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end



		--[[
		if( curSettings.generate_android == "true" and curPlugins.monetization_adbuddiz_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "AdBuddiz Rewarded Publisher Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize - 3.5, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_adbuddiz_rewarded_publisher_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		--]]
		if( curSettings.generate_android == "true" and curPlugins.monetization_admob_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "AdMob Banner App ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_admob_banner_app_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_android == "true" and curPlugins.monetization_admob_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "AdMob Interstitial App ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_admob_interstitial_app_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_android == "true" and curPlugins.monetization_applovin_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "AppLovin SDK Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_applovin_sdk_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_android == "true" and curPlugins.monetization_appnext_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Appnext Placement ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_appnext_placement_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_android == "true" and curPlugins.monetization_appodeal_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Appodeal App Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_appodeal_app_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end

		if( curSettings.generate_android == "true" and curPlugins.monetization_chartboost_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "ChartBoost API Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_chartboost_api_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end

		if( curSettings.generate_android == "true" and curPlugins.monetization_corona_ads_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Corona Ads Placement ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize - 2, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_corona_ads_placement_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_android == "true" and curPlugins.monetization_fan_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "FAN Placment ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_fan_placement_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_android == "true" and curPlugins.monetization_inmobi_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "InMobi Banner ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_inmobi_banner_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_android == "true" and curPlugins.monetization_inmobi_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "InMobi Interstital ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_inmobi_interstitial_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_android == "true" and curPlugins.monetization_kidoz_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Kidoz Publisher ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_kidoz_publisher_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_android == "true" and curPlugins.monetization_kidoz_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Kiddoz Security Token", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_kidoz_security_token";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_android == "true" and curPlugins.monetization_mediabrix_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "MediaBrix App ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_mediabrix_app_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_android == "true" and curPlugins.monetization_peanuts_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Peanut Labs User ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_peanutlabs_user_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_android == "true" and curPlugins.monetization_peanuts_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Peanut Labs App Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_peanutlabs_app_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_android == "true" and curPlugins.monetization_peanuts_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Peanut Labs App ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "number", commonListener )
			tmp.settingID = "ads_android_peanutlabs_app_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_android == "true" and curPlugins.monetization_personaly_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Persona.ly App Hash", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_personaly_app_hash";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_android == "true" and curPlugins.monetization_personaly_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Persona.ly User ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_personaly_user_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_android == "true" and curPlugins.monetization_pollfish_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Pollfish API Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_pollfish_api_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_android == "true" and curPlugins.monetization_revmob_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "RevMob App ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_revmob_app_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_android == "true" and curPlugins.monetization_superawesome_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "SuperAwesome Placement ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize - 3, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_superawesome_placement_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_android == "true" and curPlugins.monetization_supersonic_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Supersonic App Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_supersonic_app_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_android == "true" and curPlugins.monetization_stripe_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Stripe Secret Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_stripe_secret_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_android == "true" and curPlugins.monetization_stripe_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Stripe Public Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_stripe_publishable_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_android == "true" and curPlugins.monetization_trial_pay_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Trial Pay App Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_trial_pay_app_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end

		if( curSettings.generate_android == "true" and curPlugins.monetization_trial_pay_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Trial Pay SID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_trial_pay_sid";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		
		if( curSettings.generate_android == "true" and curPlugins.monetization_vungle_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Vungle App Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "ads_android_vungle_app_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( cols == 3 ) then
			childGroup.x = childGroup.x - 100
		elseif( cols == 2 ) then
			childGroup.x = childGroup.x
		elseif( cols == 1 ) then
			childGroup.x = childGroup.x + 140
			if( curRow > 0 ) then
				childGroup.y = childGroup.y + ((9-curRow)*dy2)/2
			end
		end

	end

end

function editPane_configureAdvanced.plugins( group, x, y )

	y = y + dy2 * 1
	local startY = y

	local currentGroup 
	
	local analyticsSettings
	local attributionSettings
	local iapSettings
	local iapBadgerSettings
	local socialSettings
	local utilitiesSettings


	local function onChooseStore( event )
		--table.dump(event)
		
		local choice = event.target:getText()
		--print(choice)
		
		display.remove(currentGroup)
		currentGroup = display.newGroup()
		group:insert(currentGroup)

		if( choice == "Analytics" ) then
			analyticsSettings()
		
		elseif( choice == "Attribution" ) then
			attributionSettings()
		
		elseif( choice == "IAP General" ) then
			iapSettings()

		elseif( choice == "IAP Badger" ) then
			iapBadgerSettings()

		elseif( choice == "Social" ) then
			socialSettings()

		elseif( choice == "Utilities" ) then
			utilitiesSettings()
		end
	end

	local radioGroup = display.newGroup()
	group:insert( radioGroup )
	--local labels = { "Amazon Store",  "iOS Ad IDs",  "Apple TV Ad IDs", "Android Ad IDs" }
	local currentProject = projectMgr.current()
	local labels = {}	
	if( util.usingAnalytics( currentProject ) ) then
		labels[#labels+1] = "Analytics"		
	end
	if( util.usingAttribution( currentProject ) ) then
		labels[#labels+1] = "Attribution"
	end
	if( util.usingIAP( currentProject ) ) then
		labels[#labels+1] = "IAP General"		
	end
	--[[
	if( util.usingMonetizers( currentProject  ) ) then
		labels[#labels+1] = "IAP Badger"		
	end
	--]]
	if( util.usingSocial( currentProject ) ) then
		labels[#labels+1] = "Social"		
	end
	if( util.usingUtils( currentProject ) ) then
		labels[#labels+1] = "Utilities"		
	end


	table.dump( currentProject, nil, '********************** labels')
	table.dump( labels, nil, '********************** labels')




	local tweenX 		= 10
	local bufferX 		= 10
	local buttonWidth 	= 130
	local buttonHeight 	= settings.editPaneCommonTextFieldHeight 
	local curX = left + tweenX + buttonWidth/2
	local curX = left + tweenX
	local firstB
	for i = 1, #labels do
		local lbl = display.newText( labels[i], -10000, -10000, settings.defaultFont, settings.defaultFontSize   )
		local lbw = lbl.contentWidth
		display.remove(lbl)
		local lbw = lbl.contentWidth
		display.remove(lbl)
		buttonWidth = bufferX * 2 + lbw
		--print( "buttonWidth", i, buttonWidth)
		lbw = nil
		curX = curX + buttonWidth/2
		local tmp = easyIFC:presetRadio( radioGroup, "default", curX, y,  
				                             buttonWidth, settings.editPaneCommonTextFieldHeight, 
				                             labels[i], onChooseStore, 
				                             { labelSize = settings.defaultFontSize, labelFont = settings.defaultFont } )	
		curX = curX + buttonWidth/2 + tweenX 
		firstB = firstB or tmp
		--firstB = tmp -- EDOCHI
		--if( i == 4 ) then firstB = tmp end -- EDOCHI
	end	

	radioGroup.x = centerX - radioGroup.contentWidth/2
	nextFrame( function() firstB:toggle() end )

		
	y = y + dy2 * 1
	local startY = y

	analyticsSettings = function()
		local curRow = 0
		local cols = 0		
		local textFieldWidth = 2*settings.editPaneCommonTextFieldWidth/3
		local dx = 340

		local curX = x
		local curY = startY

		local childGroup = display.newGroup()
		currentGroup:insert( childGroup )

		local function nextXY( )
			if( curRow == 0 ) then 
				cols = cols + 1
			end
			curRow = curRow + 1
			if( curRow > 7) then
				curX = curX + dx
				curY = startY
				curRow = 0				
			else
				curY = curY + dy2
			end
		end

		-- =======================
		-- Flurry Legacy
		-- =======================
		if( curSettings.generate_android == "true" and curPlugins.flurry_plugin_legacy  ) then
			local label = easyIFC:quickLabel( childGroup, "Flurry (legacy) Key [Android]", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "analytics_android_flurry_legacy_api_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.flurry_plugin_legacy  ) then
			local label = easyIFC:quickLabel( childGroup, "Flurry (legacy) Key [iOS]", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "analytics_ios_flurry_legacy_api_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end

		-- =======================
		-- Flurry Analytics
		-- =======================
		if( curSettings.generate_android == "true" and curPlugins.flurry_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Flurry Key [Android]", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "analytics_android_flurry_api_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.flurry_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Flurry Key [iOS]", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "analytics_ios_flurry_api_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end



		-- =======================
		-- Google Analytics 
		-- =======================
		if( curSettings.generate_android == "true" and curPlugins.google_analytics_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Google Analytics App Name [Android]", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "analytics_android_google_app_name";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_android == "true" and curPlugins.google_analytics_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Google Analytics Tracking ID [Android]", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "analytics_android_google_tracking_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end

		if( curSettings.generate_ios == "true" and curPlugins.google_analytics_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Google Analytics App Name [iOS]", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "analytics_ios_google_app_name";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.google_analytics_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Google Analytics Tracking ID [iOS]", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "analytics_ios_google_tracking_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end

		-- =======================
		-- Parse
		-- =======================
		if( curSettings.generate_android == "true" and curPlugins.parse_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Parse App ID [Android]", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "analytics_android_parse_app_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_android == "true" and curPlugins.parse_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Parse REST Key [Android]", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "analytics_android_parse_rest_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end

		if( curSettings.generate_ios == "true" and curPlugins.parse_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Parse App ID [iOS]", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "analytics_ios_parse_app_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.parse_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Parse REST Key [iOS]", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "analytics_ios_parse_rest_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end

		----------------------------	
		----------------------------
		----------------------------
		if( cols == 2 ) then
			childGroup.x = childGroup.x + 20
		elseif( cols == 1 ) then
			childGroup.x = childGroup.x + 140
			if( curRow > 0 ) then
				childGroup.y = childGroup.y + ((9-curRow)*dy2)/2
			end
		end
	end

	attributionSettings = function()
		local curRow = 0
		local cols = 0		
		local textFieldWidth = 2*settings.editPaneCommonTextFieldWidth/3
		local dx = 340

		local curX = x
		local curY = startY

		local childGroup = display.newGroup()
		currentGroup:insert( childGroup )

		local function nextXY( )
			if( curRow == 0 ) then 
				cols = cols + 1
			end
			curRow = curRow + 1
			if( curRow > 7) then
				curX = curX + dx
				curY = startY
				curRow = 0				
			else
				curY = curY + dy2
			end
		end

		-- =======================
		-- Kochava
		-- =======================
		if( curSettings.generate_android == "true" and curPlugins.kochava_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Kochava App ID [Android]", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "attribution_kochava_android_app_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.kochava_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Kochava App ID [iOS]", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "attribution_kochava_ios_app_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end

		----------------------------	
		----------------------------
		----------------------------
		if( cols == 2 ) then
			childGroup.x = childGroup.x + 20
		elseif( cols == 1 ) then
			childGroup.x = childGroup.x + 140
			if( curRow > 0 ) then
				childGroup.y = childGroup.y + ((9-curRow)*dy2)/2
			end
		end
	end


	iapSettings = function()
		local curRow = 0
		local cols = 0		
		local textFieldWidth = 2*settings.editPaneCommonTextFieldWidth/3
		local dx = 340

		local curX = x
		local curY = startY

		local childGroup = display.newGroup()
		currentGroup:insert( childGroup )

		local function nextXY( )
			if( curRow == 0 ) then 
				cols = cols + 1
			end
			curRow = curRow + 1
			if( curRow > 7) then
				curX = curX + dx
				curY = startY
				curRow = 0				
			else
				curY = curY + dy2
			end
		end

		-- =======================
		-- Fortumo
		-- =======================
		if(  ( curSettings.generate_android == "true" or curSettings.generate_ios == "true" ) and 
			 curPlugins.iap_fortumo_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Fortumo Service ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "iap_fortumo_service_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if(  ( curSettings.generate_android == "true" or curSettings.generate_ios == "true" ) and 
			 curPlugins.iap_fortumo_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Fortumo App Secret", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "iap_fortumo_app_secret";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end

		-- =======================
		-- Google IAP
		-- =======================
		if(  ( curSettings.generate_android == "true" or curSettings.generate_ios == "true" ) and 
			 curPlugins.iap_google_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Google Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "iap_google_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end



		----------------------------	
		----------------------------
		----------------------------
		if( cols == 2 ) then
			childGroup.x = childGroup.x + 20
		elseif( cols == 1 ) then
			childGroup.x = childGroup.x + 140
			if( curRow > 0 ) then
				childGroup.y = childGroup.y + ((9-curRow)*dy2)/2
			end
		end
	end




	iapBadgerSettings = function()
		local curRow = 0
		local cols = 0		
		local textFieldWidth = 2*settings.editPaneCommonTextFieldWidth/3
		local dx = 310

		local curX = x
		local curY = startY

		local childGroup = display.newGroup()
		currentGroup:insert( childGroup )

		local function nextXY( force )
			if( curRow == 0 or force ) then 
				cols = cols + 1
			end
			curRow = curRow + 1
			if( curRow > 7) then
				curX = curX + dx
				curY = startY
				curRow = 0				
			else
				curY = curY + dy2
			end
		end		
		-- =======================
		-- Android Requirements
		-- =======================
		if(  curSettings.generate_android == "true" and curPlugins.iap_badger_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Google Key", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "iap_google_key";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end

		-- =======================
		-- Salt
		-- =======================
		if(  curSettings.generate_android == "true" and curPlugins.iap_badger_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Salt", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "iap_badger_salt";quickPrep(tmp, math.getUID(8) )
			tmp.anchorX = 0
			nextXY()
		end

		-- =======================
		-- Settings Filename
		-- =======================
		if(  curSettings.generate_android == "true" and curPlugins.iap_badger_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "File Name", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "iap_badger_filename";quickPrep(tmp, "badgerSave.txt", label)
			tmp.anchorX = 0
			nextXY()
		end

		nextXY()
		local label = easyIFC:quickLabel( childGroup, "WIP (IAP Badger Editor Coming Soon)", curX - ox, curY,
	                                        settings.defaultFont, 
	                                        settings.defaultFontSize * 2, 
	                                        settings.defaultFontColor ) 

		----------------------------	
		----------------------------
		----------------------------
		if( cols == 3 ) then
			childGroup.x = childGroup.x - 100
		elseif( cols == 2 ) then
			childGroup.x = childGroup.x
		elseif( cols == 1 ) then
			childGroup.x = childGroup.x + 140
			if( curRow > 0 ) then
				childGroup.y = childGroup.y + ((9-curRow)*dy2)/2
			end
		end

	end



	socialSettings = function()
		local curRow = 0
		local cols = 0		
		local textFieldWidth = 2*settings.editPaneCommonTextFieldWidth/3
		local dx = 340

		local curX = x
		local curY = startY

		local childGroup = display.newGroup()
		currentGroup:insert( childGroup )

		local function nextXY( )
			if( curRow == 0 ) then 
				cols = cols + 1
			end
			curRow = curRow + 1
			if( curRow > 7) then
				curX = curX + dx
				curY = startY
				curRow = 0				
			else
				curY = curY + dy2
			end
		end

		-- =======================
		-- Facecebook V4
		-- =======================
		if( ( curSettings.generate_android == "true" or  curSettings.generate_ios == "true" ) and 
			  curPlugins.social_facebookv4_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Facebook V4 App ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "social_facebook_v4_app_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end

		----------------------------	
		----------------------------
		----------------------------
		if( cols == 2 ) then
			childGroup.x = childGroup.x + 20
		elseif( cols == 1 ) then
			childGroup.x = childGroup.x + 140
			if( curRow > 0 ) then
				childGroup.y = childGroup.y + ((9-curRow)*dy2)/2
			end
		end
	end


	utilitiesSettings = function()
		local curRow = 0
		local cols = 0		
		local textFieldWidth = 2*settings.editPaneCommonTextFieldWidth/3
		local dx = 340

		local curX = x
		local curY = startY

		local childGroup = display.newGroup()
		currentGroup:insert( childGroup )

		local function nextXY( )
			if( curRow == 0 ) then 
				cols = cols + 1
			end
			curRow = curRow + 1
			if( curRow > 7) then
				curX = curX + dx
				curY = startY
				curRow = 0				
			else
				curY = curY + dy2
			end
		end

		-- =======================
		-- Corona Splash Control
		-- =======================
		if(  curPlugins.utilities_corona_splash_control_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Enable Corona Splash", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			util.drawDropdownMenu( childGroup, x - ox + 5, y,
	                       textFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 12.5, 	                       		
	                       		curChoice 	= "false",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'utilities_corona_splash_control_enable',
	                       		label 	  = label,
	                       } )
			nextXY()
			local label = easyIFC:quickLabel( childGroup, "Splash Screen Image", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "utilities_corona_splash_control_image";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end


		-- =======================
		-- Google Drive
		-- =======================
		if(  curPlugins.util_googledrive_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Google Drive Client ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "utilities_googledrive_client_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if(  curPlugins.util_googledrive_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Google Drive Client Secret", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "utilities_googledrive_client_secret";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if(  curPlugins.util_googledrive_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Google Drive Client Redirect URL", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "utilities_googledrive_redirect_url";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end



		-- =======================
		-- Hockey App
		-- =======================
		if( curSettings.generate_android == "true" and curPlugins.hockeyapp_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Hockey App ID [Android]", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "utilities_android_hockeyapp_app_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end
		if( curSettings.generate_ios == "true" and curPlugins.hockeyapp_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Hockey App ID [iOS]", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "utilities_ios_hockeyapp_app_id";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end

		-- =======================
		-- iCloud
		-- =======================
		if( ( curSettings.generate_ios == "true" or 
			  curSettings.generate_apple_tv == "true" or 
			  curSettings.generate_desktop_osx == "true" )  and 
			  curPlugins.util_icloud_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "iCloud KV Store ID", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "utilities_icloud_kvstore_identifier";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end


		-- =======================
		-- VK
		-- =======================
		if( ( curSettings.generate_ios == "true" or 
			  curSettings.generate_android == "true" )  and 
			  curPlugins.util_vk_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "VK Scheme", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "utilities_vk_scheme";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end

		-- =======================
		-- Steam Works
		-- =======================
		if( ( curSettings.generate_desktop_osx == "true" or 
			  curSettings.generate_desktop_win32 == "true" )  and 
			  curPlugins.util_steamworks_plugin  ) then
			local label = easyIFC:quickLabel( childGroup, "Steam AppName", curX - ox, curY,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local tmp = util.createTextEdit( childGroup, curX - ox + 5, curY,
			                                      textFieldWidth, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "", "default", commonListener )
			tmp.settingID = "utilities_steamworks_appname";quickPrep(tmp, nil, label )
			tmp.anchorX = 0
			nextXY()
		end





		----------------------------	
		----------------------------
		----------------------------
		if( cols == 2 ) then
			childGroup.x = childGroup.x + 20
		elseif( cols == 1 ) then
			childGroup.x = childGroup.x + 140
			if( curRow > 0 ) then
				childGroup.y = childGroup.y + ((9-curRow)*dy2)/2
			end
		end
	end



end


return editPane_configureAdvanced 