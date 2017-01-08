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
local util 				= require "scripts.util"
local settings 			= require "scripts.settings"
local projectMgr 		= require "scripts.projectMgr"
local editPane_new 		= require "scripts.interfaces.editPanes.editPane_new"
local editPane_manage 	= require "scripts.interfaces.editPanes.editPane_manage"
local editPane_docs		= require "scripts.interfaces.editPanes.editPane_docs"
local editPane_options	= require "scripts.interfaces.editPanes.editPane_options"
local editPane_about	= require "scripts.interfaces.editPanes.editPane_about"

local editPane_configureBasic	= require "scripts.interfaces.editPanes.editPane_configureBasic"
local editPane_configureAdvanced	= require "scripts.interfaces.editPanes.editPane_configureAdvanced"
local editPane_settingsPlugins	= require "scripts.interfaces.editPanes.editPane_settingsPlugins"

-- == Forward Declarations

-- ==
-- 	 	create([ ]group [, params ] ] ) - Primary edit pane builder
-- ==
local function create( frame, params )
	group = group or display.currentStage
	params = params or {}

	--table.dump(params.record,nil,"editPane.create()")

	-- Destroy any existing menu bar
	frame.layers:purge("editPane")

	-- Make a new editPane container
	local editPane = display.newGroup()
	frame.layers.editPane:insert(editPane)

	-- Track current uid (only valid in UI and World editing modes)
	--
	editPane.current_uid = params.uid

	-- Track the 'editing mode'
	--
	editPane.current_mode = params.mode

	local touchListener

	editPane.background = newRect( editPane, left, top, 
		                   { w = 10000, h = 10000, 
		                     anchorX = 0, anchorY = 0, 		                     
		                     fill = settings.editPaneFill,
		                     touch = touchListener		                     
		                   } )

	editPane.contentUnderlay = display.newGroup()
	editPane:insert( editPane.contentUnderlay )

	editPane.content = display.newGroup()
	editPane.contentUnderlay:insert( editPane.content )


	--if( params.mode ) then
		--local tmp = easyIFC:quickLabel( editPane, params.mode .. " mode", centerX, bottom - 15, nil, 12, _G_ )
		--tmp.anchorX = 0
		--tmp.anchorY = 0
	--end

	function editPane.destroy( self )
		if( self.destroyed ) then return end
		if( self.mouse ) then
			ignore("mouse", self )
			self.mouse = nil			
		end
		if( self.onMouseDrop ) then
			ignore("onMouseDrop", self )
			self.onMouseDrop = nil			
		end		
		display.remove( self )
		self.destroyed = true
	end

	--
	-- NEW PROJECT
	--
	if( params.mode == "new" ) then
		editPane.redraw = editPane_new.redraw		
		editPane:redraw()
	--
	-- LOAD (manage) PROJECT MODES
	--
	elseif( params.mode == "manage" ) then
		editPane.redraw = editPane_manage.redraw		
		editPane:redraw()

	--
	-- MISC MODES
	--
	elseif( params.mode == "docs" ) then
		editPane.redraw = editPane_docs.redraw		
		editPane:redraw()

	elseif( params.mode == "options" ) then
		editPane.redraw = editPane_options.redraw		
		editPane:redraw()

	elseif( params.mode == "about" ) then
		editPane.redraw = editPane_about.redraw		
		editPane:redraw()

	elseif( params.mode == "configureBasic" ) then
		editPane.redraw = editPane_configureBasic.redraw		
		editPane:redraw()

	elseif( params.mode == "configureAdvanced" ) then
		editPane.redraw = editPane_configureAdvanced.redraw		
		editPane:redraw()



	elseif( params.mode == "settingsPlugins" ) then
		editPane.redraw = editPane_settingsPlugins.redraw		
		editPane:redraw()

	end

	return editPane
end


return create 