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
local settings 	= require "scripts.settings"
local projectMgr 	= require "scripts.projectMgr"
local vscroller 	= require "scripts.vscroller"

-- == Forward Declarations

local editPane_new = {}

local ox = settings.editPaneCommonTextFieldWidth 
local dy1 = 50
local dy2 = 40


-- Map Redraw Method
editPane_new.redraw = function( self )
	--print("editPane_new.redraw() ")
	-- Destroy all content in the later...
	local content = self.content
	while ( content.numChildren > 0 ) do
		display.remove( content[1] )
	end

	local nameField
	local projectOrientation
	local projectType 
	local projectSubtype
	local createButton

    local title = easyIFC:quickLabel( content, "New Project", left + fullw/2, top + settings.menuBarH + 80, 
                                        settings.editPaneCommonTitleFont, 
                                        settings.editPaneCommonTitleFontSize, 
                                        settings.editPaneCommonTitleFontColor ) 

    --
    -- Project Name
    --
    local y = title.y + dy1
	local label = easyIFC:quickLabel( content, "Name:", title.x - ox, y,
                                        settings.editPaneCommonLabelFont, 
                                        settings.editPaneCommonLabelFontSize, 
                                        settings.editPaneCommonLabelFontColor, 1 ) 

	nameField = util.createTextEdit( content, title.x - ox + 5, y,
	                                      settings.editPaneCommonTextFieldWidth * 2, 
	                                      settings.editPaneCommonTextFieldHeight, 
	                                      settings.editPaneCommonTextFieldFont,
	                                      settings.editPaneCommonTextFieldFontSize, 	                                      
	                                      projectMgr.getUniqueName(), "default" )   
	nameField.anchorX = 0



	--
	-- Project Type Callback
	--
	local drawSubChoice
	local function onSelectProjectType( self, choice )
		--print("You chose project type " .. choice )
		projectType = choice		
		drawSubChoice( choice )	
	end

	--
	-- Sub-Project Type
	--	
	y = y + dy2
	local subTypeY = y
	local subTypeLabel
	local subTypeDropDown

	drawSubChoice = function( choice )
		display.remove( subTypeLabel )
		if( subTypeDropDown and subTypeDropDown.label ) then
			display.remove( subTypeDropDown.label )
		end
		display.remove( subTypeDropDown )
		subTypeLabel = nil
		subTypeDropDown = nil
		projectSubtype = nil
		--print("Cleared projectSubtype", projectSubtype)

		local function onSelectSubtype( self, choice2 )
			projectSubtype = choice2
			--print("A Set projectSubtype ", projectSubtype)
		end

		if( choice == "Frameworks" ) then
			if( createButton ) then createButton.label.text = "Start" end
			projectSubtype = "Basic Starter"
			--print("B Set projectSubtype ", projectSubtype)
			subTypeLabel = easyIFC:quickLabel( content, "Framework:", title.x - ox, subTypeY,
	                                           settings.editPaneCommonLabelFont, 
	                                           settings.editPaneCommonLabelFontSize, 
	                                           settings.editPaneCommonLabelFontColor, 1 ) 

			local choicesIn =  {  "Basic Starter", "Standard Composer Framework", "Improved Composer Framework"  }

			subTypeDropDown = util.drawDropdownMenu( content, title.x - ox + 5, subTypeY,
			                       settings.editPaneCommonTextFieldWidth * 2,
			                       settings.editPaneCommonTextFieldHeight,
			                       { 
			                       		--sortChoices = true,
			                       		maxEntries 	= 10,
			                       		--allowHalfEntry = true,
			                       		curChoice 	= projectSubtype,
			                       		choicesIn 	= choicesIn,
			                       		onChoice = onSelectSubtype,
		                                buttonFont = settings.editPaneCommonLabelFont, 
		                                buttonFontSize = settings.editPaneCommonLabelFontSize, 
		                                buttonFontColor = settings.editPaneCommonLabelFontColor,
			                       } )
		end
	end

	onSelectProjectType( projectTypeButton, "Frameworks" )

	--
	-- Create Button
	--			
	local function onCreateButtonTouch( self, event )
		local phase = event.phase
		if ( phase == "began" ) then
			--self.alpha = 0.5
			self:setFillColor(unpack(hexcolor("#00aeef")))
			self.x0 = self.x
			self.y0 = self.y
			self.label.x0 = self.label.x
			self.label.y0 = self.label.y
			self.x = self.x0 + 1
			self.y = self.y0 + 1
			self.label.x = self.label.x0 + 1
			self.label.y = self.label.y0 + 1

			self.isFocus = true
			display.currentStage:setFocus( self, event.id )
		elseif( self.isFocus ) then
			local inBounds = isInBounds(event,self)			
			--self.alpha = (inBounds and 0.5 or 1)
			if( inBounds ) then
				self:setFillColor(unpack(hexcolor("#00aeef")))
				self.x = self.x0 + 1
				self.y = self.y0 + 1
				self.label.x = self.label.x0 + 1
				self.label.y = self.label.y0 + 1

			else
				self:setFillColor(unpack(hexcolor("#00703c")))
				self.x = self.x0
				self.y = self.y0
				self.label.x = self.label.x0
				self.label.y = self.label.y0
			end

			if(phase == "ended") then
				self:setFillColor(unpack(hexcolor("#00703c")))
				self.x = self.x0
				self.y = self.y0
				self.label.x = self.label.x0
				self.label.y = self.label.y0
				self.isFocus = false				
				display.currentStage:setFocus( self, nil )
				self.alpha = 1
				if( inBounds ) then
					--print( "onCreateButtonTouch()", projectType, projectSubtype )					

					if( projectType == "Frameworks" ) then
						local name = nameField.text
						if(name and name:len() == 0 ) then
							name = nil
						end
						local tmp = projectMgr.emptyProject( name, projectType, projectSubtype )
						post("onSaveProject")
						post("onConfigureBasic") 
					
					elseif( projectType == "Ask Ed" ) then
						--print("Generating: ", projectSubtype)
						local askEd = RGFiles.util.loadTable( RGFiles.resource.getPath( "askEd.txt ") )
						--table.dump(askEd)
						post( "onGenerate", { srcName = projectSubtype, src = askEd[projectSubtype], genType = "AskEd" } )


					end
					--]]
				end
			end
		end
		return true
	end	
	y = y + dy2 * 1.5
	createButton = newRect( content, left + fullw/2, y, 
								 {  w = settings.editPaneCommonTextFieldWidth, 
								    h = settings.editPaneCommonTextFieldHeight * 2,
								    fill = hexcolor("#00703c"), stroke = _K_, 
								    touch = onCreateButtonTouch } )

	createButton.label = easyIFC:quickLabel( content, "Start", createButton.x, y,
                                        settings.editPaneCommonLabelFont, 
                                        settings.editPaneCommonLabelFontSize, 
                                        settings.editPaneCommonLabelFontColor ) 
	util.addShadow( createButton )
end

-- ==
--
-- ==
function editPane_new.tmp(  )
end

return editPane_new 