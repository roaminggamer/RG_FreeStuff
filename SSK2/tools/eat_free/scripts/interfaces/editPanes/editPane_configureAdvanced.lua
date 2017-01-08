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




return editPane_configureAdvanced 