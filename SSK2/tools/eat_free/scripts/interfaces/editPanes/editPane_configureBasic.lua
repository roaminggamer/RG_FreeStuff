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

local function commonListener( self, event )
	local id = self.settingID	
	local phase = event.phase 
	if( curSettings and 
		(phase == "editing" or phase == "ended" or phase == "submitted" ) ) then
		curSettings[id] = tostring(self.text)
		post("onSaveProject")
		if( phase == "ended" or phase == "submitted" ) then
			--table.dump(curSettings,nil, "editPane_configureBasic - commonListener()")			
			--post("onSaveProject")
		end
	end
	return true
end

local function quickPrep( textField, label )
	--print(textField.settingID)
	local id = textField.settingID	
	if( not curSettings ) then return end	
	if( curSettings[id] ) then 
		--table.dump(curSettings)
		textField.text = tostring(curSettings[id] )
	end

	local defaultSettings = require 'scripts.defaultSettings'
	local helpRecord = defaultSettings.getHelp( textField.settingID )
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

local editPane_configureBasic = {}

local rightAdjust = 150
local colOffset = 205
local dy1 = 50
local dy2 = 40
local ox = settings.editPaneCommonTextFieldWidth


-- Map Redraw Method
editPane_configureBasic.redraw = function( self )
	--print("editPane_configureBasic.redraw() ")

	local currentProject = projectMgr.current()
	if( not currentProject ) then 
		curSettings = {}
	else
		--table.dump(curSettings,nil,"curSettings")
		curSettings = currentProject.settings
	end	

	local content = self.content
	while ( content.numChildren > 0 ) do
		display.remove( content[1] )
	end

	local currentGroup

    local title = easyIFC:quickLabel( content, "Basic Settings", left + fullw/2, top + settings.menuBarH + 30, 
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
		if( choice == "Summary" ) then
			editPane_configureBasic.summary( currentGroup, x, y )

		elseif( choice == "Orientation / Resolution / Scaling" ) then
			editPane_configureBasic.orientation_resolution_scaling( currentGroup, x, y )


		elseif( choice == "Icons & Launch Images" ) then
			editPane_configureBasic.icons_launch( currentGroup, x, y )			

		elseif( choice == "Build Targets" ) then
			editPane_configureBasic.build_targets( currentGroup, x, y )			

		end
	end

	local radioGroup = display.newGroup()
	content:insert( radioGroup )
	local labels = { "Summary", "Orientation / Resolution / Scaling", "Icons & Launch Images", "Build Targets", }
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
		--firstB = tmp
		util.addShadow(tmp)
	end	

	radioGroup.x = centerX - radioGroup.contentWidth/2
	nextFrame( function() firstB:toggle() end )
end


function editPane_configureBasic.summary( group, x, y )

	local currentProject = projectMgr.current()
	y = y + dy2 * 1.5

	x = x - settings.editPaneCommonTextFieldWidth


	local function summaryListener( self, event )
		local id = self.fieldName	
		local phase = event.phase 
		if( curSettings and 
			(phase == "editing" or phase == "ended" or phase == "submitted" ) ) then
			currentProject[id] = tostring(self.text)
			post("onSaveProject")
			if( phase == "ended" or phase == "submitted" ) then
			end
		end
		return true
	end

    --
    -- Project Name
    --
	local label = easyIFC:quickLabel( group, "Name:", x - ox, y,
                                        settings.editPaneCommonLabelFont, 
                                        settings.editPaneCommonLabelFontSize, 
                                        settings.editPaneCommonLabelFontColor, 1 ) 

	local nameField = util.createTextEdit( group, x - ox + 5, y,
	                                      settings.editPaneCommonTextFieldWidth * 4, 
	                                      settings.editPaneCommonTextFieldHeight, 
	                                      settings.editPaneCommonTextFieldFont,
	                                      settings.editPaneCommonTextFieldFontSize, 	                                      
	                                      currentProject.name, "default", summaryListener )   
	nameField.anchorX = 0
	nameField.fieldName = "name"

    --
    -- Project Summary
    --
    y = y + dy2 
	local label = easyIFC:quickLabel( group, "Summary:", x - ox, y,
                                        settings.editPaneCommonLabelFont, 
                                        settings.editPaneCommonLabelFontSize, 
                                        settings.editPaneCommonLabelFontColor, 1 ) 

	local summary = native.newTextBox( x - ox + 5, y - 8, 
		                               settings.editPaneCommonTextFieldWidth * 4, 
		                               settings.editPaneCommonTextFieldHeight * 10 )
	summary.anchorX = 0
	summary.anchorY = 0
	summary.text = currentProject.summary
	summary.fieldName = "summary"
	summary.isEditable = true
	summary.userInput = summaryListener
	summary:addEventListener( "userInput" )
    summary.font = native.newFont( settings.editPaneCommonTextFieldFont )
    summary.size = settings.editPaneCommonTextFieldFontSize
	group:insert(summary)

    function summary.onTextFieldVisiblity( self, event )
    	if( autoIgnore( "onTextFieldVisiblity", self ) ) then return end
    	if( self.isVisible == nil ) then
    		ignore( "onTextFieldVisiblity", self )
    		return
    	end
    	self.isVisible = (event.phase == "show")
    end; listen( "onTextFieldVisiblity", summary )


	
end

function editPane_configureBasic.orientation_resolution_scaling( group, x, y )

	local leftGroup = display.newGroup()
	group:insert( leftGroup )
	leftGroup.x = -colOffset + rightAdjust

	local rightGroup = display.newGroup()
	group:insert( rightGroup )
	rightGroup.x = colOffset + rightAdjust

	local childGroup
	y = y + dy2 * 1.5
	local startY = y
	local startY2 = y + dy2 * 2

	
	local function onResolutionMethod( self, choice )
		--print("You chose " .. choice )
		display.remove(childGroup)
		childGroup = display.newGroup()
		leftGroup:insert( childGroup )

		local y = startY2

		if( choice == "Device List" ) then
			y = y + dy2
			local label = easyIFC:quickLabel( childGroup, "Devices", x - ox, y,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 
			                       
			util.drawDropdownMenu( childGroup, x - ox + 5, y,
			                       settings.editPaneCommonTextFieldWidth,
			                       settings.editPaneCommonTextFieldHeight,
			                       { 
			                       		maxEntries 	= 7.5, 	                       		
			                       		curChoice 	= "iPhone 5",
			                       		--throwEvent 	= true,
			                       		choicesIn 	= 
			                       		{ 
				                       		"iPhone 4",
				                       		"iPhone 5",
				                       		"iPhone 6",
				                       		"iPhone 6+",
				                       		"iPad Air",
				                       		"iPad Pro",
				                       		"Kindle Fire",
				                       		"TV/Console",			                       		
			                       		},
			                       		--onChoice = onChoice,
			                       		settingsTbl = curSettings, 
			                       		fieldName = 'deviceResolution',
			                       		label 	  = label,
			                       } )


		elseif( choice == "Common Resolutions" ) then
			y = y + dy2
			local label = easyIFC:quickLabel( childGroup, "Common Resolutions", x - ox, y,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 
			util.drawDropdownMenu( childGroup, x - ox + 5, y,
			                       settings.editPaneCommonTextFieldWidth,
			                       settings.editPaneCommonTextFieldHeight,
			                       { 
			                       		maxEntries 	= 7.5, 	                       		
			                       		curChoice 	= "640 x 960",
			                       		--throwEvent 	= true,
			                       		choicesIn 	= 
			                       		{ 
			                       			"320 x 480", 
				                       		"320 x 568", 
				                       		"640 x 960",
				                       		"640 x 1136",
				                       		"750 x 1334",
				                       		"768 x 1024",
				                       		"800 x 1280",
				                       		"1080 x 1920",
				                       		"1536 x 2048",
				                       		"2048 x 2732",
			                       		},
			                       		--onChoice = onChoice,
			                       		settingsTbl = curSettings, 
			                       		fieldName = 'commonResolution',
			                       		label 	  = label,
		                       } )


		else
			y = y + dy2
			local text = "Width / Height"
			if( choice == "Smart Pixel" ) then
				text = "Ideal " .. text
			end
			local label = easyIFC:quickLabel( childGroup, text, x - ox, y,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			local widthField = util.createTextEdit( childGroup, x - ox + 5, y,
			                                      settings.editPaneCommonTextFieldWidth/2 - 5, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "640", "number", commonListener ) 
			widthField.settingID = "resolution_width"
			if( choice == "Smart Pixel") then
				widthField.settingID = "smartpixel_ideal_width"				
			end
			widthField.anchorX = 0
			quickPrep(widthField, label)
			
			local heightField = util.createTextEdit( childGroup, 
				                                  x - ox + 10 + settings.editPaneCommonTextFieldWidth/2, y,
			                                      settings.editPaneCommonTextFieldWidth/2 - 5, 
			                                      settings.editPaneCommonTextFieldHeight, 
			                                      settings.defaultFont,
			                                      settings.defaultFontSize, 	                                      
			                                      "960", "number", commonListener )  
			heightField.settingID = "resolution_height"
			if( choice == "Smart Pixel") then
				heightField.settingID = "smartpixel_ideal_height"				
			end
			heightField.anchorX = 0
			quickPrep(heightField, label)
		end

		--
		-- EFM
		--
		if( choice ~= "Smart Pixel" ) then
			y = y + dy2
			local label = easyIFC:quickLabel( childGroup, "Scaling", x - ox, y,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			util.drawDropdownMenu( childGroup, x - ox + 5, y,
			                       settings.editPaneCommonTextFieldWidth,
			                       settings.editPaneCommonTextFieldHeight,
			                       { 
			                       		maxEntries 	= 7.5, 	                       		
			                       		curChoice 	= "letterbox",
			                       		--throwEvent 	= true,
			                       		choicesIn 	= 
			                       		{ 
				                       		"adaptive",
				                       		"letterbox",
				                       		"none",
				                       		"zoomEven",
				                       		"zoomStretch",
			                       		},
			                       		--onChoice = onChoice,
			                       		settingsTbl = curSettings, 
			                       		fieldName = 'scaling',
			                       		label 	  = label,
		                       } )

			--
			-- EFM
			--
			y = y + dy2
			local label = easyIFC:quickLabel( childGroup, "xAlign", x - ox, y,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			util.drawDropdownMenu( childGroup, x - ox + 5, y,
			                       settings.editPaneCommonTextFieldWidth,
			                       settings.editPaneCommonTextFieldHeight,
			                       { 
			                       		maxEntries 	= 7.5, 	                       		
			                       		curChoice 	= "center",
			                       		--throwEvent 	= true,
			                       		choicesIn 	= 
			                       		{ 
				                       		"center",
				                       		"left",
				                       		"right",
			                       		},
			                       		--onChoice = onChoice,
			                       		settingsTbl = curSettings, 
			                       		fieldName = 'x_align',
			                       		label 	  = label,
		                       } )

			--
			-- EFM
			--
			y = y + dy2
			local label = easyIFC:quickLabel( childGroup, "yAlign", x - ox, y,
		                                        settings.defaultFont, 
		                                        settings.defaultFontSize, 
		                                        settings.defaultFontColor, 1 ) 

			util.drawDropdownMenu( childGroup, x - ox + 5, y,
			                       settings.editPaneCommonTextFieldWidth,
			                       settings.editPaneCommonTextFieldHeight,
			                       { 
			                       		maxEntries 	= 7.5, 	                       		
			                       		curChoice 	= "center",
			                       		--throwEvent 	= true,
			                       		choicesIn 	= 
			                       		{ 
				                       		"center",
				                       		"bottom",
				                       		"top",
			                       		},
			                       		--onChoice = onChoice,
			                       		settingsTbl = curSettings, 
			                       		fieldName = 'y_align',
			                       		label 	  = label,
		                       } )

		end


	end


	--
	-- Orientation
	--
	y = startY
	local label = easyIFC:quickLabel( leftGroup, "Orientation", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( leftGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 7.5, 	                       		
	                       		curChoice 	= "Portrait",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"Portrait",
		                       		"Landscape",
	                       		},
	                       		--onChoice = onChoice,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'orientation',
	                       		label 	  = label,
	                       } )

	--
	-- Orientation Flipping
	--
	y = y + dy2 
	local label = easyIFC:quickLabel( leftGroup, "Allow Flipping", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( leftGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 7.5, 	                       		
	                       		curChoice 	= "false",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onChoice,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'allow_flipping',
	                       		label 	  = label,
	                       } )
	


	y = y + dy2 
	local label = easyIFC:quickLabel( leftGroup, "Resolution", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	local tmp = util.drawDropdownMenu( leftGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 7.5, 	                       		
	                       		curChoice 	= "Smart Pixel",
	                       		throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"Device List",
		                       		"Common Resolutions",
		                       		"User Defined",
		                       		"Smart Pixel",
	                       		},
	                       		onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'resolution_selection_method',
	                       		label 	  = label,
	                       } )


	onResolutionMethod( nil, tmp.label.text )

	--
	-- EFM
	--
	y = startY
	local label = easyIFC:quickLabel( rightGroup, "Enable Image Scaling", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( rightGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 7.5,	                       		
	                       		curChoice 	= "false",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onResolutionMethod,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'dyanamic_image_scaling_en',
	                       		label 	  = label,
	                       } )
	--
	-- EFM
	--
	y = y + dy2
	local label = easyIFC:quickLabel( rightGroup, "Use @2x If Screen Scale >=", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	local versionCode = util.createTextEdit( rightGroup, x - ox + 5, y,
	                                      settings.editPaneCommonTextFieldWidth, 
	                                      settings.editPaneCommonTextFieldHeight, 
	                                      settings.defaultFont,
	                                      settings.defaultFontSize, 	                                      
	                                      "1", "number", commonListener )  
	
	versionCode.settingID = "image_scaling_2x"
	versionCode.anchorX = 0
	quickPrep(versionCode, label)

	y = y + dy2
	local label = easyIFC:quickLabel( rightGroup, "Use @3x If Screen Scale >=", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	local versionCode = util.createTextEdit( rightGroup, x - ox + 5, y,
	                                      settings.editPaneCommonTextFieldWidth, 
	                                      settings.editPaneCommonTextFieldHeight, 
	                                      settings.defaultFont,
	                                      settings.defaultFontSize, 	                                      
	                                      "1", "number", commonListener )  
	
	versionCode.settingID = "image_scaling_3x"
	versionCode.anchorX = 0
	quickPrep(versionCode, label)

	y = y + dy2
	local label = easyIFC:quickLabel( rightGroup, "Use @4x If Screen Scale >=", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	local versionCode = util.createTextEdit( rightGroup, x - ox + 5, y,
	                                      settings.editPaneCommonTextFieldWidth, 
	                                      settings.editPaneCommonTextFieldHeight, 
	                                      settings.defaultFont,
	                                      settings.defaultFontSize, 	                                      
	                                      "1", "number", commonListener )  
	
	versionCode.settingID = "image_scaling_4x"
	versionCode.anchorX = 0
	quickPrep(versionCode, label)


end


function editPane_configureBasic.build_targets( group, x, y )

	y = y + dy2 * 1.5
	local startY = y

	x = x + 120

	local function onChooseTargets( self, choice, fieldName )
		--print( self, choice, fieldName )
		local currentProject = projectMgr.current()
		if( currentProject.settings.generate_android == "false" and
			currentProject.settings.generate_ios == "false" and
			currentProject.settings.generate_apple_tv == "false" and
			currentProject.settings.generate_desktop_osx == "false" and
			currentProject.settings.generate_desktop_win32 == "false" and
			currentProject.settings.generate_chromebook == "false" ) then

			nextFrame( 
				function()
					if( self.x0 ) then
						transition.cancel( self.label )
						self.label.x = self.label.x0
						self.label.y = self.label.y0
					end
					self.label.x0 = self.label.x
					self.label.y0 = self.label.y
					ssk.misc.easyShake( self.label, 10, 200 )
					self.label.text = "true"
					currentProject.settings[fieldName] = "true"
					post("onSaveProject")
				end )
			
		end
	end

	--
	-- Generation Targets
	--
	-- Android
	y = startY
	local label = easyIFC:quickLabel( group, "Android", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( group, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 7.5, 	                       		
	                       		curChoice 	= "true",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		onChoice = onChooseTargets,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'generate_android',
	                       		label 	  = label,
	                       } )
	-- iOS
	y = y + dy2 
	local label = easyIFC:quickLabel( group, "iOS", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( group, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 7.5, 	                       		
	                       		curChoice 	= "true",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		onChoice = onChooseTargets,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'generate_ios',
	                       		label 	  = label,
	                       } )

	-- Apple TV
	y = y + dy2 
	local label = easyIFC:quickLabel( group, "Apple TV", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( group, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 7.5, 	                       		
	                       		curChoice 	= "true",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		onChoice = onChooseTargets,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'generate_apple_tv',
	                       		label 	  = label,
	                       } )


	-- OS X Desktop
	y = y + dy2
	local label = easyIFC:quickLabel( group, "OSX Desktop", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( group, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 7.5, 	                       		
	                       		curChoice 	= "true",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		onChoice = onChooseTargets,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'generate_desktop_osx',
	                       		label 	  = label,
	                       } )

	-- Win32 Desktop
	y = y + dy2 
	local label = easyIFC:quickLabel( group, "Win32 Desktop", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( group, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 7.5, 	                       		
	                       		curChoice 	= "true",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		onChoice = onChooseTargets,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'generate_desktop_win32',
	                       		label 	  = label,
	                       } )

	-- Chrome Book
	--[[
	y = y + dy2 
	local label = easyIFC:quickLabel( group, "Chrome Book", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 

	util.drawDropdownMenu( group, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 7.5, 	                       		
	                       		curChoice 	= "true",
	                       		--throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"true",
		                       		"false",
	                       		},
	                       		--onChoice = onChoice,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'generate_chromebook',
	                       		label 	  = label,
	                       } )
	--]]	                       
end



function editPane_configureBasic.icons_launch( group, x, y )

	local leftGroup = display.newGroup()
	group:insert( leftGroup )
	leftGroup.x = -colOffset + rightAdjust

	local rightGroup = display.newGroup()
	group:insert( rightGroup )
	rightGroup.x = colOffset + rightAdjust

	y = y + dy2 * 1.5
	local startY = y

	local lastIcon 

	local function onChooseIcon( self, choice )
		display.remove( lastIcon )
		if( choice == "yes" ) then
			lastIcon = newImageRect( leftGroup, centerX - 120, startY + 190, "images/commonIcons/corona.png", { size = 240, stroke = _DARKGREY_ } )
		elseif( choice == "custom" ) then
		end
	end


	-- EFM
	--
	y = startY
	local label = easyIFC:quickLabel( leftGroup, "Provide Icons", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 
                       

	util.drawDropdownMenu( leftGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 7.5, 	                       		
	                       		curChoice 	= "no",
	                       		throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"no",
		                       		"yes",
		                       		--"custom",
	                       		},
	                       		onChoice = onChooseIcon,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'provide_icons',
	                       		label 	  = label,
	                       } )
	if( curSettings.provide_icons == "yes" ) then
		onChooseIcon( nil, "yes" )
	end
	
	--
	-- Default Width / Height
	--
	local lastLaunchImage

	local function onChooseLaunchImage( self, choice )
		display.remove( lastLaunchImage )
		if( choice == "yes" ) then
			lastLaunchImage = newImageRect( rightGroup, centerX - 120, startY + 190, "images/commonIcons/Default.png", 
				                           { scale = 0.6,  w = 320, h = 480, stroke = _DARKGREY_ } )
			if( curSettings.orientation == "Landscape" ) then
				lastLaunchImage.rotation = 90
			end
		elseif( choice == "custom" ) then
		end
	end


	y = startY
	local label = easyIFC:quickLabel( rightGroup, "Provide Launch Images", x - ox, y,
                                        settings.defaultFont, 
                                        settings.defaultFontSize, 
                                        settings.defaultFontColor, 1 ) 



	util.drawDropdownMenu( rightGroup, x - ox + 5, y,
	                       settings.editPaneCommonTextFieldWidth,
	                       settings.editPaneCommonTextFieldHeight,
	                       { 
	                       		maxEntries 	= 7.5, 	                       		
	                       		curChoice 	= "no",
	                       		throwEvent 	= true,
	                       		choicesIn 	= 
	                       		{ 
		                       		"no",
		                       		"yes",
	                       		},
	                       		onChoice = onChooseLaunchImage,
	                       		settingsTbl = curSettings, 
	                       		fieldName = 'provide_launch_images',
	                       		label 	  = label,
	                       } )

	if( curSettings.provide_launch_images == "yes" ) then
		onChooseLaunchImage( nil, "yes" )
	end



end



return editPane_configureBasic 