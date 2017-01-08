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

local frame

-- == Forward Declarations
local onHMouse
local onVMouse
local onTrayMouse
local proxyTouch
local onButtonTouch
local createDropDownMenu


-- ==
-- 	 	create([ ]group [, params ] ] ) - Primary menuBar builder
-- ==
local function create( frame, params )
	group = group or display.currentStage
	params = params or {}

	-- Destroy any existing menu bar
	--
	frame.layers:purge("menuBar")

	-- Make a new menuBar container
	--
	local menuBar = display.newGroup()
	frame.layers.menuBar:insert(menuBar)

	-- Back Background
	menuBar.bar = newRect( menuBar, left, top, 
		                   { w = 10000, h = settings.menuBarH, 
		                     anchorX = 0, anchorY = 0, 		                     
		                     fill = settings.menuBarFill,		                     
		                   } )

	-- Project Name
	if( params.mode == "ui" or params.mode == "world" ) then 
		menuBar.projectName = easyIFC:quickLabel( menuBar, "Project: " .. (projectMgr.current().name or "Untitled Project"), fullw - 10, settings.menuBarH/2, 
													settings.menuBarFont, settings.menuBarFontSize, settings.menuBarFontColor, 1 )
	end

	-- Bar Shadow
	menuBar.shadow = newImageRect( menuBar, 0, settings.menuBarH,
		                              "images/gradientTB.png",
		                   { w = 10000, h = settings.shadowW,
		                     anchorX = 0, anchorY = 0, alpha = settings.shadowAlpha
		                   } )
	menuBar.shadow.blendMode = "multiply"

	-- Add RG Icon

	local icon = newImageRect( menuBar, 1, 1, "images/commonIcons/rg30.png", 
		                      { size = settings.menuBarH-2, anchorX = 0, anchorY = 0,
		                      touch = 
		                      function( self, event ) 
								if( event.phase == "ended" ) then 
		                      		system.openURL(_G.supportURL)
		                      	end
		                      	return true
		                       end } )

	-- Build the menubar horizontal buttons
	local menuSettings = {}

	--
	-- New
	--
	menuSettings[#menuSettings+1] = 
	{ 
		text 			= "Project",
		children = 
		{
			{ text = "New", 	eventName = "onNewProject" },
			--{ text = "Manage", 	eventName = "onManageProjects" },
			--{ text = "Save", 	eventName = "onSaveProject" },
		},
		action = function() print("Project") end
	}

	if( projectMgr.countProjects() > 0 ) then
		menuSettings[#menuSettings].children[#menuSettings[#menuSettings].children+1] = { text = "Manage", 	eventName = "onManageProjects" }
	end

	--
	-- Generate and Preview
	--
	if( params.mode ~= "new" and params.mode ~= "manage" ) then

		menuSettings[#menuSettings+1] =  { text = "Separator" }
		menuSettings[#menuSettings+1] = { text = "Generate", eventName = "onGenerate" }
		menuSettings[#menuSettings+1] =  { text = "Separator" }
		menuSettings[#menuSettings+1] = { text = "Plugins", eventName = "onSettingsPlugins" }
		menuSettings[#menuSettings+1] = { text = "Basic Settings", eventName = "onConfigureBasic" }
		menuSettings[#menuSettings+1] = { text = "Advanced Settings", eventName = "onConfigureAdvanced" }
	end

	menuSettings[#menuSettings+1] =  { text = "Separator" }

	--
	-- HELP
	--
	menuSettings[#menuSettings+1] = 
	{ 
		text 			= "Help",
		children = 
		{

			{ text = "About", 	action = 
				function() 
					easyAlert("EAT Lean", 
						      "Release: " .. string.format("%4.3f", _G.toolVersion), 
						      { {"OK"}, 
						      } ) 
				end },

			{ text = "Docs (external)", action = function() system.openURL(_G.supportURL) end },

			{ text = "Open Special Folders", 	action = 
				function() 
					easyAlert("Open Special Folders", 
						      "There are a number of special folders associated with EAT:\n\n" ..
						      " > Gen Folder - EAT generates to this folder.\n" ..
						      " > Assets Folder - EAT stores art & assets for generation here.\n" ..
						      " > DB Folder - EAT stores your projects database here.\n\n" ..
						      "For your convenience, you may open any of the above folders from here.",
						      {
						      	{"DB Folder", function() RGFiles.desktop.explore(settings.EATStorage) end },
						      	{"Assets Folder", function() RGFiles.desktop.explore( RGFiles.documents.getRoot() ) end },
						      	{"Generation Folder", function() RGFiles.desktop.explore(settings.EATGenFolder) end },
						      	{"Never Mind" },
						      } ) 
				end },

		},
		action = function() print("Help") end
	}			

	createDropDownMenu( menuBar,  settings.menuBarH + settings.menuBarHButtonTween, menuSettings )

	function menuBar.destroy( self )
		if( self.destroyed ) then return end
		display.remove( self )
		self.destroyed = true
	end

	return menuBar
end



-- ==
--
-- ==
-- Horizontal Button Mouse Event Listener
onHMouse = function( self, event )
	if ( autoIgnore( "mouse", self ) ) then return end
	if ( isInBounds( event, self ) ) then
		if ( self.parent.proxy.isFocus ) then
			self:setFillColor(unpack(settings.menuBarHButtonTouchFill))
			if( not self.child or not self.child.isVisible ) then
				local buttons = self.parent.proxy.buttons
				for i = 1, #buttons do
					if( buttons[i].child ) then
						buttons[i].child.isVisible = (buttons[i].child == self.child )
					end
				end
			end
		else
			self:setFillColor(unpack(settings.menuBarHButtontHoverFill))
		end		
	else
		self:setFillColor(unpack(_T_))
	end
	return false
end

-- ==
--
-- ==
-- Vertical Button Mouse Event Listener
onVMouse = function( self, event )
	if ( autoIgnore( "mouse", self ) ) then return end
	if ( self.parent.isVisible and isInBounds( event, self ) ) then
		self:setFillColor(unpack(settings.menuBarChildButtonHoverFill))
		if(event.type == "up") then
			--print(table.dump(self.params))
			if( self.params.eventName ) then
				post( self.params.eventName )
			end
			if( self.params.action ) then
				self.params.action()
			end

		end
	else
		self:setFillColor(unpack(_T_))
	end
	return false
end

-- ==
--
-- ==
-- Tray Mouse Listener
onTrayMouse = function( self, event )
	if ( autoIgnore( "mouse", self ) ) then return end
	if ( self.parent.isVisible and isInBounds( event, self ) ) then
		self.myButton:setFillColor(unpack(settings.menuBarHButtonTouchFill))
	end
	return false
end



-- ==
--
-- ==
-- Proxy Touch Event Listener
proxyTouch = function( self, event )
	local phase = event.phase
	if ( phase == "began" ) then
		display.getCurrentStage():setFocus(self, event.id)
		self.isFocus = true		
		return false
	elseif ( self.isFocus ) then
		if phase == "ended" or phase == "cancelled" then
			self.isFocus = false
			display.getCurrentStage():setFocus(nil, event.id)
			
			-- EFM this is part of the code to modify for keeping tray open
			----[[
			for i = 1, #self.buttons do
				local button = self.buttons[i]
				button:setFillColor(unpack(_T_))
				if( button.child ) then
					button.child.isVisible = false
				end
				if( isInBounds( event, button ) ) then
					--table.dump(button.params)
					if( button.params.eventName ) then
						post( button.params.eventName )
					end
					if( button.params.action ) then
						button.params.action()
					end
				end
			end
			--]]
		end
	end
	return true
end

-- ==
--
-- ==
-- Horizontal Button Touch Event Listener
onButtonTouch = function( self, event )
	local phase = event.phase
	if ( phase == "began" ) then
		self:setFillColor(unpack(settings.menuBarHButtonTouchFill))
		if( self.child ) then
			self.child.isVisible = true
		end
	end
	return true
end

-- ==
--
-- ==
-- Draw dropdown (child) menu helper
drawChild = function( self )
	local params 	= self.params
	local menuBar 	= self.parent
	local children 	= params.children

	if( not children ) then return end

	--table.dump( params )

	local child = display.newGroup()
	menuBar:insert(child)

	local labels = {}
	local buttons = {}

	local maxWidth = 0

	-- Create the labels
	for i = 1, #children do
		labels[i] = easyIFC:quickLabel( child, children[i].text, 0, 0, settings.menuBarChildFont, settings.menuBarChildFontSize, settings.menuBarChildFontColor, 0 )
	end

	-- Create the proportionally sized buttons
	for i = 1, #children do
		buttons[i] = newImageRect( child, 0, 0, "images/fillW.png",
			                            { w = 10 , h = settings.menuBarChildButtonH, 
			                              anchorX = 0, anchorY = 0, alpha = 0.15, fill = _T_ } )

		buttons[i].params = children[i]
	end

	-- Create a child tray
	local curX = self.x 
	local curY = settings.menuBarH

	local totalHeight = 0
	for i = 1, #children do
		totalHeight = totalHeight + buttons[i].contentHeight
	end
	local tray = newImageRect( child, curX, curY - settings.shadowW, "images/fillW.png", 
		                         { w = 10, h = totalHeight + 2 * settings.menuBarChildTrayBuffer/3, 
		                           anchorX = 0, anchorY = 0, fill = settings.menuBarChildTrayFill,
		                           touch = function() return true end } )
	tray.myButton = self
	tray.mouse = onTrayMouse
	listen( "mouse", tray )

	-- Attach cleanup code to the tray for safety-sake
	util.addFinalize( tray,
		function( obj )
			if( obj.mouse ) then 
				ignore("mouse",obj)
				obj.mouse = nil
			end
		end )


	-- Position elements and attach listeners
	curY = curY + settings.menuBarChildTrayBuffer/2
	for i = 1, #children do
		buttons[i].x = curX + 2
		buttons[i].y = curY
		buttons[i]:toFront()
		labels[i]:toFront()
		labels[i].x = curX + settings.menuBarChildLabelIndent
		labels[i].y = curY + buttons[i].contentHeight/2
		curY = curY + buttons[i].contentHeight

		buttons[i].mouse = onVMouse
		listen( "mouse", buttons[i] )
		-- Attach cleanup code to the buttons for safety-sake
		util.addFinalize( buttons[i],
			function( obj )
				if( obj.mouse ) then 
					ignore("mouse",obj)
					obj.mouse = nil
				end
			end )

		maxWidth = (labels[i].contentWidth > maxWidth) and labels[i].contentWidth or maxWidth
	end

	-- Create the shortcut labels
	for i = 1, #children do
		if( children[i].shortcut ) then
			--print(children[i].shortcut)
			local tmp = easyIFC:quickLabel( child, children[i].shortcut, 0, 0, 
				                            settings.menuBarFont, settings.menuBarFontSize, 
				                            settings.menuBarFontColor, 0 )
			tmp.x = labels[i].x + maxWidth + settings.menuBarChildTrayBuffer
			tmp.y = labels[i].y

		end
	end

	local tmpWidth = child.contentWidth + settings.menuBarChildTrayBuffer
	tray:scale( tmpWidth/tray.contentWidth, 1 )
	for i = 1, #buttons do
		buttons[i]:scale( (tray.contentWidth - 4)/buttons[i].contentWidth, 1 )
	end

	tray.border = newImageRect( child, tray.x, tray.y, "images/fillT.png", 
		                         { w = tray.contentWidth, h = tray.contentHeight, 
		                           anchorX = 0, anchorY = 0, 
		                           stroke = { 0, 0, 0, settings.shadowAlpha },
		                           strokeWidth = 1,
		                           touch = function() return true end } )


	tray.shadowR = newImageRect( child, tray.x + tray.contentWidth+1, tray.y+1, "images/gradientLR.png", 
		                         { w = settings.shadowW * 1, h = tray.contentHeight + settings.shadowW * 1, 
		                           anchorX = 0, anchorY = 0, fill = _K_,
		                           alpha = settings.shadowAlpha,
		                           touch = function() return true end } )
	--tray.shadowR.fill.effect = "filter.blur"
	tray.shadowR.blendMode = "multiply"
	tray.shadowB = newImageRect( child, tray.x+1, tray.y + tray.contentHeight+1, "images/gradientTB.png", 
		                         { w = tray.contentWidth + settings.shadowW * 1, h = settings.shadowW * 1, 
		                           anchorX = 0, anchorY = 0, fill = _K_,
		                           alpha = settings.shadowAlpha,
		                           touch = function() return true end } )
	--tray.shadowB.fill.effect = "filter.blur"
	tray.shadowB.blendMode = "multiply"



	child.isVisible = false
	self.child = child

	return child
end

-- ==
--
-- ==
createDropDownMenu = function( menuBar, x, params )
	local labels = {}	
	local buttons = {}

	-- Create the labels
	for i = 1, #params do
		if(params[i].text == "Separator") then
			labels[i] = newRect( menuBar, 0, 0, { w = 1, h = settings.menuBarH - 8, fill = _K_, alpha = 0.75, anchorX = 0 } )
		else
			labels[i] = easyIFC:quickLabel( menuBar, params[i].text, 0, 0, settings.menuBarFont, settings.menuBarFontSize, settings.menuBarFontColor, 0 )
		end
	end
	-- Create the proportionally sized buttons
	for i = 1, #params do
		local width = labels[i].contentWidth + settings.menuBarHLabelBuffer
		buttons[i] = newImageRect( menuBar, 0, 0, "images/fillW.png",
			                            { w = width, h = settings.menuBarH, anchorX = 0, anchorY = 0, alpha = 0.15, fill = _T_ } )
	end

	-- Position elements and attach listeners
	local curX = x
	local labelY = settings.menuBarH/2

	for i = 1, #params do
		buttons[i].x = curX
		labels[i]:toFront()
		labels[i].x = curX + settings.menuBarHLabelBuffer/2
		labels[i].y = labelY
		curX = curX + buttons[i].contentWidth + settings.menuBarHButtonTween

		buttons[i].params = params[i]

		if( params[i].text ~= "Separator" ) then
			buttons[i].mouse = onHMouse
			buttons[i].touch = onButtonTouch		
			listen( "mouse", buttons[i] )
			buttons[i]:addEventListener("touch")

			-- Attach cleanup code to the buttons for safety-sake
			util.addFinalize( buttons[i],
				function( obj )
					if( obj.mouse ) then 
						ignore("mouse",obj)
						obj.mouse = nil
					end
				end )

			drawChild( buttons[i] )
		end
	end

	-- Create a 'touch proxy' for initiating drop-downs
	local totalWidth = 0
	for i = 1, #params do
		totalWidth = totalWidth + buttons[i].contentWidth + settings.menuBarHButtonTween
	end
	menuBar.proxy = newImageRect( menuBar, x, 0, "images/fillT.png", 
		                         { w = totalWidth, h = settings.menuBarH, 
		                           anchorX = 0, anchorY = 0,
		                           touch = proxyTouch } )
	menuBar.proxy.buttons = buttons
end


return create 