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
local vscroller 	= require "scripts.vscroller"

local plugins 		= require "settings.plugins"

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

-- == Forward Declarations

local editPane_settingsPlugins = {}

-- Map Redraw Method
editPane_settingsPlugins.redraw = function( self )
	--print("editPane_settingsPlugins.redraw() ")

	local currentProject = projectMgr.current()
	if( not currentProject ) then 
		curSettings = {}
		curPlugins = {}
	else
		--table.dump(curSettings,nil,"curSettings")
		curSettings = currentProject.settings
		curPlugins = currentProject.plugins
	end	


	local isInitializing = true

	local content = self.content
	while ( content.numChildren > 0 ) do
		display.remove( content[1] )
	end

	local pluginGroup = display.newGroup()
	content:insert(pluginGroup)

	pluginGroup.y = top + settings.menuBarH
	pluginGroup.x = left

    local title = easyIFC:quickLabel( pluginGroup, "Select Plugins", fullw/2, 30, 
                                        settings.editPaneCommonTitleFont, 
                                        settings.editPaneCommonTitleFontSize, 
                                        settings.editPaneCommonTitleFontColor, 1 )



	local gap 		= 10
	local tween 	= 20
	local buttonW 	= (380+gap)/2
	local paneW1 	= 205 * 3 + 20
	local paneW2 	= 205 + 10
	
	local labelY 	= 20 + 50
	local label2Y 	= labelY --+ 30
	local listY 	= label2Y + 5

	local paneH 	= fullh - settings.menuBarH - listY - 20

	local totalWidth = paneW1 + paneW2 + tween

	-- Page Label
	--
	--local label = easyIFC:quickLabel( pluginGroup, "Plugins", totalWidth/2, labelY, settings.normalFont, 22, _W_) 

	-- List Labels
	--
	local label1 = easyIFC:quickLabel( pluginGroup, "Plugin Choices (click to add or remove)", totalWidth/2 - paneW1/4 - gap, label2Y, settings.boldFont, 16, _W_) 
	local label2 = easyIFC:quickLabel( pluginGroup, "Selected Plugins", totalWidth/2 + paneW2 + gap/2, label2Y, settings.boldFont, 16, _W_) 

	--
	-- Available plugins list
	--
	local frame = newRect( pluginGroup, 0 , listY + 8, 
		                   { w = paneW1, h = paneH, fill = _T_,
		                     stroke = hexcolor("#00703c"), strokeWidth = 2,
		                     anchorX = 0, anchorY = 0 } )	
	local frame2 = newRect( pluginGroup, 1 , listY + 8 + 1, 
		                   { w = paneW1-2, h = paneH-2, fill = _T_,
		                     stroke = _K_, strokeWidth = 1,
		                     anchorX = 0, anchorY = 0 } )	
	local srcScroller = vscroller.new( pluginGroup, frame.x, frame.y, paneW1, paneH, 
		                              { listener = scrollListener, hideBackground = true  } )
	frame:toFront()
	frame2:toFront()
	label1.x = frame.x + frame.contentWidth/2

	--
	-- Selected plugins list
	--
	local frame = newRect( pluginGroup, frame.x + paneW1 + tween, frame.y, 
		                   { w = paneW2, h = paneH, fill = _T_,
		                     stroke = hexcolor("#00703c"), strokeWidth = 2,
		                     anchorX = 0, anchorY = 0 } )	
	local frame2 = newRect( pluginGroup, frame.x + 1, frame.y + 1, 
		                   { w = paneW2-2, h = paneH-2, fill = _T_,
		                     stroke = _K_, strokeWidth = 1,
		                     anchorX = 0, anchorY = 0 } )	
	label2.x = frame.x + frame.contentWidth/2

	local dstScroller = vscroller.new( pluginGroup, frame.x, frame.y, paneW1, paneH, 
		                              { listener = scrollListener, hideBackground = true  } )
	dstScroller.blocks = {}
	frame:toFront()
	frame2:toFront()

	local function onTouch( self, event )
		--table.dump(self.details)
		--[[
	    if( event.phase == "began" ) then
	        self.isFocus = true
	    elseif( self.isFocus ) then 
	    	if( event.phase == "ended" ) then
	            self.isFocus = false
	            if( event.isClick ) then                                
	                if( self.clickAction ) then
	                	self:clickAction()
	                end
	            end
	        end            
	    end
	    --]]
    	if( event.phase == "ended" ) then
            self.isFocus = false
            if( event.isClick ) then                                
                if( self.clickAction ) then
                	self:clickAction( event )
                end
            end
        end            
	    return false
	end

	local startX = gap/2 + 10
	local curX = startX
	local curY = gap * 2
	local width = buttonW
	local height = 30
	local col = 1
	local maxCol = 3

	local list = plugins.get() 

    --
    --
    local allowSorting = false    
    local function sortList( scroller )
		local function compare(a,b)
			return string.lower(tostring(a.label.text)) < string.lower(tostring(b.label.text))
		end
    	table.sort(scroller.blocks,compare)
		for i = 1, #scroller.blocks do		    			
			--scroller.blocks[i].y = gap + (i-1) * (height + gap)
			--scroller:insert(scroller.blocks[i], true)
			if( isInitializing ) then
				scroller.blocks[i].alpha = 1
			end
			if( scroller.blocks[i].alpha ~= 0 ) then
				transition.to(  scroller.blocks[i], { y = gap + (i-1) * (height + gap), time = isInitializing and 0 or 150 })
			else
				scroller.blocks[i].y = gap + (i-1) * (height + gap)    			
    			scroller.blocks[i].alpha = 0
    			scroller.blocks[i].xScale = 0.01
    			scroller.blocks[i].yScale = 0.01
    			transition.to(  scroller.blocks[i], { alpha = 1, xScale = 1, yScale = 1, delay = isInitializing and 0 or 150, time = isInitializing and 0 or 150 })
    		end
		end
    end
    local function addBlockToScroller( scroller, srcBlock )

    	if( srcBlock.otherBlock ) then
    		srcBlock.strokeWidth = 0
		    srcBlock:setFillColor(unpack(hexcolor("#00703c")))
		    
		    -- Remove this plugin to the projects' plugins list
		    --
		    projectMgr.current().plugins[srcBlock.details.id] = nil
		    if( not isInitializing ) then
				post("onSaveProject")
			end

		    table.remove( scroller.blocks, table.indexOf( scroller.blocks, srcBlock.otherBlock ))
    		display.remove( srcBlock.otherBlock.shadowR )
    		display.remove( srcBlock.otherBlock.shadowB )
    		display.remove( srcBlock.otherBlock.buffer )
    		display.remove( srcBlock.otherBlock )
    		srcBlock.otherBlock	= nil

    		for i = 1, #scroller.blocks do		    			
    			--scroller.blocks[i].y = gap + (i-1) * (height + gap)
    			transition.to(  scroller.blocks[i], { y = gap + (i-1) * (height + gap), time = 150 })
    			transition.to(  scroller.blocks[i].buffer, { y = gap + (i-1) * (height + gap), time = 150 })

    			--scroller.blocks[i].xScale = 0.75
    		end

    		return
    	end

    	local block = display.newGroup()
    	block.y = gap + (#scroller.blocks) * (height + gap)
	    block.back = newRect( block, gap/2 + 5, 0, { w = width, h= height, fill = {0,1,0,0.25}, anchorY = 0, anchorX = 0, stroke = _G_ } )
	    block.back.details = srcBlock.details
	    block.label = easyIFC:quickLabel( block, srcBlock.details.name, block.back.x + width/2, block.back.y + height/2, settings.normalFont, 14, _W_) 
	    scroller:insert( block )

	    block.buffer = newImageRect( nil, block.x, block.y + 40, "images/fillT.png", { size = 40, anchorY = 0 } )
	    scroller:insert( block.buffer )


	    -- Add status circle so we know if the plugin is configured right
	    block.statusCircle = newImageRect( block, width - 3, height/2, "images/good.png", 
	    	                              { size = height - 4, fill = _G_ })
	    block.statusCircle.errorType = "none"
	    block.statusCircle.touch = function( self, event )
	    	local dialogs = ssk.dialogs
	    	if( event.phase == "began" ) then

				local function onClose( self, onComplete )
					ignore( "key", self )
					transition.to( self, { y = centerY + fullh, transition = easing.inBack, onComplete = onComplete } )
				end
				--table.dump(srcBlock.details)

				local dy1 = 50
				local dy2 = 40
				local width = 650
				local height = 350
				local ox = settings.editPaneCommonTextFieldWidth/4 - 60 
				local textFieldWidth = settings.editPaneCommonTextFieldWidth * 1.5
				local inputsGroup = display.newGroup()

				local plugin_config = util.getPluginConfigsByName( srcBlock.details.name )
				if( not plugin_config ) then 
					height = 55 
				elseif( self.errorType == "conflict" ) then
					height = 200
				else
					local count = 0
					if( curSettings.generate_android == "true" and plugin_config.android ) then
						count = count + #plugin_config.android
					end
					if( curSettings.generate_ios == "true" and plugin_config.ios ) then
						count = count + #plugin_config.ios
					end
					if( curSettings.generate_tvos == "true" and plugin_config.apple_tv ) then
						count = count + #plugin_config.apple_tv
					end
					if( plugin_config.all ) then
						count = count + #plugin_config.all
					end
					height = 55 + dy2 * (count+1)
					--print( count, height )

				end


				local function onBlocker( )
					print("BOOM")
					native.setKeyboardFocus( nil )
				end

				local dialog = dialogs.basic.create( nil, centerX, centerY, 
					{ fill = settings.color3, 
				 	  width = width,
				 	  height = height,
					  softShadow = true,
					  softShadowOX = 8,
					  softShadowOY = 8,
					  softShadowBlur = 6,
					  closeOnTouchBlocker = false, 
					  blockerFill = _DARKGREY_,
					  blockerAlpha = 0.25,
					  softShadowAlpha = 0.6,
					  blockerAlphaTime = 100,
					  blockerAction = onBlocker,
					  onClose = onClose,
					  style = 1 } )

				function dialog.key( self, event )  
					if( event.phase == "up" and event.keyName == "escape" ) then
						onClose( self, self.frame.close )
					end
					
				end; listen( "key", dialog )


				local closeB = newImageRect( dialog, -width/2 + 25, -height/2 + 25 , "images/bad.png", 
					{ 
						size = 40,
						fill = { 1, 0, 0 },
						touch = function( self, event ) 
							if( event.phase == "began" ) then
								onClose( dialog, dialog.frame.close )
							end
							return true
						end
					} )

				

	    		if( self.errorType == "none" ) then
	    			--easyAlert( "Plugin Is Configured", "It looks like you configured this plugin!", {{"OK"}})	    			
    				local title = easyIFC:quickLabel( dialog, srcBlock.details.name .. " Plugin Fully Configured", 0, -height/2 + 15, 
                                        settings.editPaneCommonTitleFont, 
                                        18, 
                                        settings.editPaneCommonTitleFontColor )
    				title.anchorY = 0
	    		
	    		elseif( self.errorType == "conflict" ) then
	    			--[[
	    			easyAlert( "Plugin(s) Conflict", 
	    				       "This plugin has a conflict (will not work with) one or more other plugins you have selected:\n\n"..
	    				       tostring(self.conflictNames) .. "\n\n" ..
	    				       "Tip: Some plugins require the Google Play Services plugin which conflicts with Pollfish and a few other plugins.", 
	    				       {{"OK"}})
					--]]
    				local title = easyIFC:quickLabel( dialog, srcBlock.details.name .. " Plugin Conflict", 0, -height/2 + 15, 
                                        settings.editPaneCommonTitleFont, 
                                        18, 
                                        settings.editPaneCommonTitleFontColor )
    				title.anchorY = 0

					local conflicts = 
					{
					    text 		= tostring(self.conflictNames),
					    x 	  		= -width/2 + 30,
					    y 	  		= 0,
					    width 		= width - 60,
					    font 		= settings.normalFont,
					    fontSize 	= 20
					}
					local list = display.newText( conflicts )
					list:setFillColor( 1, 0, 0 ) 
					list.anchorX = 0
					list.anchorY = 0.5
					--list.
					dialog:insert( list )

    			
    			elseif( self.errorType == "unconfigured" ) then
    				--[[
		    		if( srcBlock.details.name == "AdMob" ) then
	    				easyAlert( "Plugin Not Configured", 
	    					       "This plugin may require additional configuring.\n\n" ..
	    					       "Please click 'Advanced Settings' then 'Monetization' or 'Plugins' to configure this plugin.\n\n" ..
	    					       "Tip: The AdMob plugin requires either a banner ID or a interstitial ID.  If you only supply one, you will still get this warning.  You may ignore it.", 
	    					       {{"OK"}})

		    		else

	    				easyAlert( "Plugin Not Configured", 
	    					       "This plugin may require additional configuring.\n\n" ..
	    					       "Please click 'Advanced Settings' then 'Monetization' or 'Plugins' to configure this plugin.", 
	    					       {{"OK"}})
		    		end
		    		--]]

    				local title = easyIFC:quickLabel( dialog, srcBlock.details.name .. " Plugin Not Fully Configured", 0, -height/2 + 15, 
                                        settings.editPaneCommonTitleFont, 
                                        18, 
                                        settings.editPaneCommonTitleFontColor )
    				title.anchorY = 0
    			end

    			if( not ( self.errorType == "conflict" ) and plugin_config ) then
					local curX = 0
					local curY = 0

					-- Android
					if( curSettings.generate_android == "true" and plugin_config.android ) then
						for i = 1, #plugin_config.android do

							local label = easyIFC:quickLabel( inputsGroup, plugin_config.android[i][2], curX - ox, curY,
						                                        settings.defaultFont, 
						                                        settings.defaultFontSize, 
						                                        settings.defaultFontColor, 1 ) 

							local tmp = util.createTextEdit( inputsGroup, curX - ox + 5, curY,
							                                      textFieldWidth, 
							                                      settings.editPaneCommonTextFieldHeight, 
							                                      settings.defaultFont,
							                                      settings.defaultFontSize, 	                                      
							                                      "", "default", commonListener )
							tmp.settingID = plugin_config.android[i][1];quickPrep(tmp, nil, label )
							tmp.anchorX = 0
							curY = curY + dy2
						end
					end
					-- iOS
					if( curSettings.generate_ios == "true" and plugin_config.ios ) then
						for i = 1, #plugin_config.ios do

							local label = easyIFC:quickLabel( inputsGroup, plugin_config.ios[i][2], curX - ox, curY,
						                                        settings.defaultFont, 
						                                        settings.defaultFontSize, 
						                                        settings.defaultFontColor, 1 ) 

							local tmp = util.createTextEdit( inputsGroup, curX - ox + 5, curY,
							                                      textFieldWidth, 
							                                      settings.editPaneCommonTextFieldHeight, 
							                                      settings.defaultFont,
							                                      settings.defaultFontSize, 	                                      
							                                      "", "default", commonListener )
							tmp.settingID = plugin_config.ios[i][1];quickPrep(tmp, nil, label )
							tmp.anchorX = 0
							curY = curY + dy2
						end
					end
					-- Apple TV
					if( curSettings.generate_tvos == "true" and plugin_config.apple_tv ) then
						for i = 1, #plugin_config.apple_tv do

							local label = easyIFC:quickLabel( inputsGroup, plugin_config.apple_tv[i][2], curX - ox, curY,
						                                        settings.defaultFont, 
						                                        settings.defaultFontSize, 
						                                        settings.defaultFontColor, 1 ) 

							local tmp = util.createTextEdit( inputsGroup, curX - ox + 5, curY,
							                                      textFieldWidth, 
							                                      settings.editPaneCommonTextFieldHeight, 
							                                      settings.defaultFont,
							                                      settings.defaultFontSize, 	                                      
							                                      "", "default", commonListener )
							tmp.settingID = plugin_config.apple_tv[i][1];quickPrep(tmp, nil, label )
							tmp.anchorX = 0
							curY = curY + dy2
						end
					end

					-- All
					if( plugin_config.all ) then
						for i = 1, #plugin_config.all do

							local label = easyIFC:quickLabel( inputsGroup, plugin_config.all[i][2], curX - ox, curY,
						                                        settings.defaultFont, 
						                                        settings.defaultFontSize, 
						                                        settings.defaultFontColor, 1 ) 

							local tmp = util.createTextEdit( inputsGroup, curX - ox + 5, curY,
							                                      textFieldWidth, 
							                                      settings.editPaneCommonTextFieldHeight, 
							                                      settings.defaultFont,
							                                      settings.defaultFontSize, 	                                      
							                                      "", "default", commonListener )
							tmp.settingID = plugin_config.all[i][1];quickPrep(tmp, nil, label )
							tmp.anchorX = 0
							curY = curY + dy2
						end
					end

					dialog:insert(inputsGroup)
					inputsGroup.y = -curY/2 + dy2
					--print(inputsGroup.contentHeight)
				end
				easyIFC.easyFlyIn( dialog, { delay = 250, time = 500, sox = 0, soy = fullh } )

	    	end
	    	return true
	   	end; block.statusCircle:addEventListener( "touch")
	    if( util.plugin_hasConfig( srcBlock.details ) ) then
		    block.statusCircle.count = easyIFC:quickLabel( block, mRand(0,5), block.statusCircle.x+1.5, block.statusCircle.y+1, 
		                                        settings.normalFont, 
		                                        13, 
		                                        _K_ )
		    block.statusCircle.count.isVisible = false

		    block.statusCircle.timer = function( self )
		    	if( not isValid(self) ) then return end

		    	local hasConflict, conflictNames = util.plugin_hasConflict(srcBlock.details)
		    	local unconfiguredCount = util.plugin_isConfigured(srcBlock.details)

		    	if( hasConflict ) then
		    		self.count.isVisible = false
		    		self.fill = { type = "image", filename = "images/bad.png" }
		    		self:setFillColor(unpack(_R_))
		    		self.errorType = "conflict"
		    		self.conflictNames = conflictNames

		    	elseif(  unconfiguredCount == 0 ) then
		    		self.count.isVisible = false
		    		self.fill = { type = "image", filename = "images/good.png" }
		    		self:setFillColor(unpack(_G_))
		    		self.errorType = "none"
		    	else
		    		self.count.text = unconfiguredCount
		    		self.count.isVisible = true
		    		self.fill = { type = "image", filename = "images/circle.png" }
		    		self:setFillColor(unpack(_Y_))
		    		self.errorType = "unconfigured"
		    	end
		    	timer.performWithDelay( 500, block.statusCircle)	    	
		   	end; block.statusCircle:timer()
		end

	    --util.addShadow3( block, 8 )
	    --scroller:insert( block.shadowR )
	    --scroller:insert( block.shadowB )
	    dstScroller.addTouch( block, onTouch )

		function block.clickAction( self, event )
			if( event.phase == "ended" and event.isClick and self.statusCircle ) then
				self.statusCircle:touch( { phase = "began"} )
			end		
		end


	    srcBlock.otherBlock = block
	    srcBlock.strokeWidth = 1
	    srcBlock:setStrokeColor(0,1,0,0.5)
	    nextFrame( function() srcBlock:setFillColor(0,0.25,0,0.25) end )
	    --nextFrame( function() srcBlock:setFillColor(unpack(hexcolor("#00703c"))) end )
	    --table.dump(block.back.details,nil,"addBlockToScroller")

	    scroller.blocks[#scroller.blocks+1] = block

	    -- Add this plugin to the projects' plugins list
	    --
	    --table.dump(projectMgr.current(),nil,tostring(srcBlock.details.id))
	    projectMgr.current().plugins[srcBlock.details.id] = srcBlock.details
	    if( not isInitializing ) then
	    	post("onSaveProject")
	    end

	    block.alpha = 0

	    sortList( scroller )
	    --table.dump(scroller)
	    --print(scroller:getView().numChildren)

    	--dstScroller
    end

	for i = 1, #list do
		local label = easyIFC:quickLabel( nil, list[i].name, curX, curY, settings.boldFont, 16, _W_, 0) 
		srcScroller:insert( label )
		curY = curY + gap * 2

		local choices = list[i].choices

		for j = 1, #choices do
		    local tmp = newRect( nil, curX, curY, { w = width, h= height, fill = hexcolor("#00703c"), anchorY = 0, anchorX = 0 } )
		    local label = easyIFC:quickLabel( nil, choices[j].name, tmp.x + width/2, tmp.y + height/2, settings.normalFont, 14, _W_) 
		    tmp.label = label

		    util.addShadow3( tmp )
		    tmp.details = choices[j]
		    srcScroller:insert( tmp )
		    srcScroller:insert( tmp.shadowR )
		    srcScroller:insert( tmp.shadowB )
		    tmp.shadowR:toBack()
		    tmp.shadowB:toBack()
		    srcScroller:insert( label )
		    srcScroller.addTouch( tmp, onTouch )
		    function tmp.clickAction( self )
		    	addBlockToScroller( dstScroller, self )		
		    end

		    -- Is this plugin already in the 'list', if so, auto-select it
		    --
			if( projectMgr.current().plugins[choices[j].id] ) then
				addBlockToScroller( dstScroller, tmp )	
			end

		    col = col + 1
		    curX = curX + width + gap
		    if( col > maxCol ) then
		    	col = 1
		    	curX = startX
		    	curY = curY + height + gap
		    end
		end

		-- Enable sorting now that we are done filling the list
		--
		allowSorting = true


		col = 1
		curX = startX
		if( #choices % maxCol == 0 ) then
			curY = curY + gap
		else
			curY = curY + height + gap * 2
		end		
	end
	local buffer = newRect( nil, curX, curY, { w = width, h = gap, fill = _T_, anchorY = 0, anchorX = 0 } )
	srcScroller:insert( buffer )

	pluginGroup.x = left + (fullw - totalWidth) / 2
	--print( left, pluginGroup.x, fullw, settings.rightPaneW, totalWidth )
	isInitializing = false

end

-- ==
--
-- ==
function editPane_settingsPlugins.tmp(  )
end

return editPane_settingsPlugins 