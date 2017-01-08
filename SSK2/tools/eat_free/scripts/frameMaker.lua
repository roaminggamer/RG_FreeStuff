-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Eds Awesome Tool (a free SSK2 PRO co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
--   Last Updated: 06 JAN 2017
-- =============================================================
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

local frameMaker = {}

-- == Forward Declarations
local destroyFrame
local setMode
local getMode

local createMenuBar
local createEditPane


-- ==
-- 	 	create([ ]group [, params ] ] ) - Primary frame builder
-- ==
function frameMaker.create( group, params )
	group = group or display.currentStage
	params = params or {}

	-- Create a new 'frame' parent group.
	local frame = display.newGroup()
	group:insert(frame)

	-- Create all the necessary layers for the editor
	--
	frame.layers = quickLayers( frame, 
		"background",

		"editPane",
		"menuBar"
		)

	-- Set initial mode as: 'none'
	--
	frame.currentMode = "none"

	-- Add a background color
	newRect( frame.layers.background, left, top, 
             { w = display.contentWidth, h = display.contentHeight, 
               anchorX = 0, anchorY = 0, 
               fill = settings.backgroundColor 
             } )

	-- Attach methods various methods (defined later in the module)
	--
	frame.destroy 			= destroyFrame
	frame.setMode 			= setMode
	frame.getMode 			= getMode
	frame.createMenuBar 	= createMenuBar
	frame.createEditPane 	= createEditPane

	-- These listeners allow other modules to remotely call into the frame maintenance methods.
	--

	-- == Load Project
	function frame.onLoadProject( self, event )
		frame:setMode( "load" )
	end; listen( "onLoadProject", frame )

	-- == New Project
	function frame.onNewProject( self, event )
		frame:setMode( "new" )
	end; listen( "onNewProject", frame )

	-- == Manage Projects
	function frame.onManageProjects( self, event )
		frame:setMode( "manage" )
	end; listen( "onManageProjects", frame )

	-- == Dpcs
	function frame.onDocs( self, event )
		frame:setMode( "docs" )
	end; listen( "onDocs", frame )

	-- == Tool Options
	function frame.onToolOptions( self, event )
		frame:setMode( "options" )
	end; listen( "onToolOptions", frame )

	-- == About
	function frame.onAbout( self, event )
		frame:setMode( "about" )
	end; listen( "onAbout", frame )

	-- == Project Settings
	function frame.onConfigureBasic( self, event )
		frame:setMode( "configureBasic" )
	end; listen( "onConfigureBasic", frame )

	-- == Project Settings
	function frame.onConfigureAdvanced( self, event )
		frame:setMode( "configureAdvanced" )
	end; listen( "onConfigureAdvanced", frame )


	function frame.onSettingsPlugins( self, event )
		frame:setMode( "settingsPlugins" )
	end; listen( "onSettingsPlugins", frame )

	function frame.onSettingsAddons( self, event )
		frame:setMode( "settingsAddons" )
	end; listen( "onSettingsAddons", frame )

	-- On 'finalize' stop listeneing for the above events.
	--
	util.addFinalize( frame,
		function( obj )
			local events = 
			{ 
				"onNewProject", 
				"onLoadProject", 

				"onManageProjects",
				"onDocs",
				"onToolOptions",
				"onAbout",

				"onConfigureBasic",
				"onConfigureAdvanced",
				"onSettingsPlugins",
				"onSettingsAddons",

				"onEditMapObject",
			}
			for i = 1, #events do
				if( obj[events[i]] ) then
					ignore( events[i], obj )
					obj[events[i]] = nil
				end
			end
		end )

	-- Set mode to  "init" to initialize interfaces and load the project manager
	--
	frame:setMode( "init" )

	-- Now, either:
	--
	-- 1. Go right to the 'new project' interface (first run only), or
	-- 2. Load and show the last project the user was editing.
	--
	----[[
	local lastProjectUID = projectMgr.last()
	if(  not lastProjectUID ) then
		frame:setMode( "new" )
	else
		projectMgr.load( lastProjectUID )
		frame:setMode( "configureBasic" )		
	end
	--]]
	--table.dump(projectMgr.current())
	--print( "INITIALIZING last project == ",  projectMgr.last() )

	return frame
end

-- ==
-- 	 	destroyFrame( ) - Destroy the current frame and safely clean up.
-- ==
destroyFrame = function( self )
end


-- ==
-- 		getMode()
-- 	 	setMode( newMode [, params ] ) - Change the mode of the current
-- ==
getMode = function( self )
	return self.currentMode
end


setMode = function( self, newMode, uid )
	--EDOCHI post("onPreSetMode") -- WHAT DOES THIS DO?
	--print( "setMode()", newMode, uid )

	-- Update the mode tracking variables and determine if the mode was changed.
	--
	self.currentMode = newMode or self.currentMode 		
	local mode = self.currentMode

	-- Handle mode changes
	--
	local function destroyAll()
		self.menuBar:destroy()
		self.editPane:destroy()
	end
	
	-- == INIT - Called for first build
	if( mode == "init" ) then
		self:createMenuBar()
		self:createEditPane()
		destroyAll()

		projectMgr.initialize()

	-- == NEW - Specify Details and Create New Project
	elseif( mode == "new" ) then
		destroyAll()
		self:createMenuBar( { mode = "new" } )
		self:createEditPane( { mode = "new" } )

	-- == MANAGE - Load, Clone, Export, Delete existing project.
	--             Import project.
	--             Backup, Restore entire project DB.
	elseif( mode == "manage" ) then
		destroyAll()
		self:createMenuBar( { mode = "manage" } )
		self:createEditPane( { mode = "manage" } )

	-- == Tool Options - Configure the tool
	elseif( mode == "options" ) then
		destroyAll()
		self:createMenuBar( { mode = "options" } )
		self:createEditPane( { mode = "options" } )


	-- == Docs - Documentation
	elseif( mode == "docs" ) then
		destroyAll()
		self:createMenuBar( { mode = "docs" } )
		self:createEditPane( { mode = "docs" } )

	-- == About - Get current version, check for updates, activate license
	elseif( mode == "about" ) then
		destroyAll()
		self:createMenuBar( { mode = "about" } )
		self:createEditPane( { mode = "about" } )


	-- == LOAD - Load project
	elseif( mode == "load" ) then
		destroyAll()

		self:createMenuBar( { mode = "map" } )
		self.editPane:destroy()
		self:createEditPane( { mode = "map" } )

	-- == Show Current Map
	elseif( mode == "map" ) then
		destroyAll()

		self:createMenuBar( { mode = "map" } )
		self:createEditPane( { mode = "map" } )

	-- == Edit a UI
	elseif( mode == "ui" ) then
		destroyAll()

		self:createMenuBar( { mode = "ui", uid = uid } )
		self:createEditPane( { mode = "ui", uid = uid } )

	-- == Edit a World
	elseif( mode == "world" ) then
		destroyAll()

		self:createMenuBar( { mode = "world", uid = uid } )
		self:createEditPane( { mode = "world", uid = uid } )
	
	-- == Basic Configuration
	elseif( mode == "configureBasic" ) then
		destroyAll()
		self:createMenuBar( { mode = "configureBasic" } )
		self:createEditPane( { mode = "configureBasic" } )

	-- == Advanced Configuration
	elseif( mode == "configureAdvanced" ) then
		destroyAll()
		self:createMenuBar( { mode = "configureAdvanced" } )
		self:createEditPane( { mode = "configureAdvanced" } )


	-- == Plugins Project Settings
	elseif( mode == "settingsPlugins" ) then
		destroyAll()
		self:createMenuBar( { mode = "settingsPlugins" } )
		self:createEditPane( { mode = "settingsPlugins" } )

	-- == Addons
	elseif( mode == "settingsAddons" ) then
		destroyAll()
		self:createMenuBar( { mode = "settingsAddons" } )
		self:createEditPane( { mode = "settingsAddons" } )

	end
end


-- ==
-- 	 	createMenuBar( ) - Menubar builder
-- ==
createMenuBar = function( self, params )
	params = params or {}
	local create = require "scripts.interfaces.menuBar"
	self.menuBar = create( self, params )
end


-- ==
-- 	 	createEditPane( ) - Menubar builder
-- ==
createEditPane = function( self, params )
	params = params or {}
	local create = require "scripts.interfaces.editPane"
	self.editPane = create( self, params )
end



return frameMaker 