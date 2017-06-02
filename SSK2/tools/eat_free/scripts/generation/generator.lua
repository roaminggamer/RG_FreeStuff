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
local settings 	= require "scripts.settings"
local projectMgr 	= require "scripts.projectMgr"
local frameMaker 	= require "scripts.frameMaker"
local genUtil 		= require( "scripts.generation.genUtil" )

local generationEnabled = true

local generator = {}

-- ========================================================
-- ========================================================
-- ========================================================
function generator.runFixed( srcName, src, genType )
	local pu 	  	= require( "scripts.generation.packageUtil" )

	print("generator.runFixed( " .. tostring(srcName) .. " )")


	--
	-- Touch blocker during generation....
	--
	post("onTextFieldVisiblity", { phase = "hide" } ) -- hackery to hide text fields
	generationEnabled 	= false
	local blockerGroup = display.newGroup()
	blockerGroup.steps = 0

	local blocker = newRect( blockerGroup, centerX, centerY, { size = 10000, fill = _K_, alpha = 0.1, touch = function() return true end } )
	transition.to( blocker, { alpha = 0.95, time = 100 } )
	local title = easyIFC:quickLabel( blockerGroup, "Generating", centerX, centerY - 50,
                                        settings.editPaneCommonTitleFont, 
                                        settings.editPaneCommonTitleFontSize, 
                                        settings.editPaneCommonTitleFontColor )

	local msg = easyIFC:quickLabel( blockerGroup, "", centerX, centerY + 50,
                                        settings.editPaneCommonTitleFont, 
                                        settings.editPaneCommonTitleFontSize/2, 
                                        settings.editPaneCommonTitleFontColor )

	function blockerGroup.onSetGenSteps( self, event )
		blockerGroup.steps = event.count
		ignore("onSetGenSteps", self )
	end;listen( "onSetGenSteps", blockerGroup )	
	
	function blockerGroup.onGenerateStep( self, event )
		blockerGroup.steps = blockerGroup.steps - 1
		if( blockerGroup.steps <= 0 ) then
			ignore("onGenerateStep", self )
			function self.onComplete( self )
				display.remove(self)
				generationEnabled 	= true
				post("onTextFieldVisiblity", { phase = "show" } ) -- hackery to re-show hidden text fields
			end
			transition.to( blockerGroup, { alpha = 0.1, delay = 500, time = 100, onComplete = self })
		end
		msg.text = event.details
	end;listen( "onGenerateStep", blockerGroup )




	-- Prep the project for generation...
	local generatedData = genUtil.getEmptyProjectData()

	local gamePath = RGFiles.util.repairPath( settings.EATGenFolder .. "/" .. util.cleanFileName( srcName ) )
	generatedData.gamePath = gamePath

	local images 	= "sources/" .. genType .. "Images/"
	local sounds 	= "sources/" .. genType .. "Sounds/"

	local tasks = {}

	-- Create Game Folder
	--
	genUtil.createGameFolder( generatedData, {}, tasks )

	--table.dump(src.source)
	local function createFolders( source )
		for k,v in pairs( source ) do
			if( type(v) == "table") then
				pu.createFolder( generatedData, k)
				createFolders(v)
				print(k)
			end
		end		
	end
	createFolders( src.source )
	genUtil.createFolders( generatedData, {}, tasks )

	-- Copy images & sounds
	--
	for k, v in pairs(src.images) do		
		pu.cloneFile( generatedData, "documents", images .. v, k )
		print(images .. v)

	end
	for k, v in pairs(src.sounds) do		
		pu.cloneFile( generatedData, "documents", sounds .. v, k )
		print(sounds .. v)

	end
	--genUtil.cloneFolders( generatedData, {}, tasks )
	genUtil.cloneFiles( generatedData, {}, tasks )

	-- Create the source files
	local function createSource( path, source )
		for k,v in pairs( source ) do
			if( type(v) == "table") then
				--pu.createFolder( generatedData, k)
				createSource(k,v)
			else
				if( path == "" ) then
					--print( k )
					pu.addGC( generatedData, v, k  )
				else
					--print( path .. "/" .. k )
					pu.addGC( generatedData, v, path .. "/" .. k  )
				end
			end
		end		
	end
	createSource( "", src.source )

	--[[
pu.addGC( generatedData, generate_config_lua( "config.lua", currentProject ), "config.lua"  )
--]]

	genUtil.saveContent( generatedData, {}, tasks )

	----[[
	local stepDelay = 1200
	for i = 1, #tasks do
		local curTask = tasks[i]
		timer.performWithDelay( i * stepDelay, curTask )
	end
	--]]

end	


-- ========================================================
-- ========================================================
-- ========================================================
function generator.parseSpecial( generatedData, specialContent )
	print( "generator.parseSpecial() ", generatedData, specialContent )

	table.dump(specialContent)

	local pu 	  	= require( "scripts.generation.packageUtil" )

	-- Add any folders that need to be created.
	--
	--table.dump(src.source)
	local function createFolders( source )
		for k,v in pairs( source ) do
			if( type(v) == "table") then
				pu.createFolder( generatedData, k)
				createFolders(v)
				--print( "Create folder", k)
			end
		end		
	end
	createFolders( specialContent.source )

	--[[
	-- Copy images & sounds
	--
	for k, v in pairs(src.images) do		
		pu.cloneFile( generatedData, "documents", images .. v, k )
		print(images .. v)

	end
	for k, v in pairs(src.sounds) do		
		pu.cloneFile( generatedData, "documents", sounds .. v, k )
		print(sounds .. v)

	end
	--]]

	-- Add any source files that need to be generated.
	local function createSource( path, source )
		for k,v in pairs( source ) do
			if( type(v) == "table") then
				--pu.createFolder( generatedData, k)
				createSource(k,v)
			else
				if( path == "" ) then
					--print( k )
					pu.addGC( generatedData, v, k  )
				else
					--print( path .. "/" .. k )
					pu.addGC( generatedData, v, path .. "/" .. k  )
				end
			end
		end		
	end
	createSource( "", specialContent.source )
end	


-- ========================================================
-- ========================================================
-- ========================================================
function generator.run( )
	print("generator.run()")

	local currentProject = projectMgr.current()
	--table.print_r(projectMgr.current())
	--table.dump(currentProject,nil,"GENERATING PROJECT")

	-- Abort if no project selected
	if( not currentProject ) then 
		print("No Current Project")
		return
	end

	-- Ensure project base path (folder) exists
	--

	-- Prep the project for generation...
	local generatedData = genUtil.getEmptyProjectData()

	-- Run project generator (CURRENTLY ONLY ONE; MAY BE VARATIONS LATER)
	--
	local projectPackage = require "scripts.generation.packages.default"
	projectPackage.generate( generatedData, currentProject )

	--table.print_r(generatedData)

	--
	-- Touch blocker during generation....
	--
	post("onTextFieldVisiblity", { phase = "hide" } ) -- hackery to hide text fields
	generationEnabled 	= false
	local blockerGroup = display.newGroup()
	blockerGroup.steps = 0

	local blocker = newRect( blockerGroup, centerX, centerY, { size = 10000, fill = _K_, alpha = 0.1, touch = function() return true end } )
	transition.to( blocker, { alpha = 0.95, time = 100 } )
	local title = easyIFC:quickLabel( blockerGroup, "Generating", centerX, centerY - 50,
                                        settings.editPaneCommonTitleFont, 
                                        settings.editPaneCommonTitleFontSize, 
                                        settings.editPaneCommonTitleFontColor )

	local msg = easyIFC:quickLabel( blockerGroup, "", centerX, centerY + 50,
                                        settings.editPaneCommonTitleFont, 
                                        settings.editPaneCommonTitleFontSize/2, 
                                        settings.editPaneCommonTitleFontColor )

	function blockerGroup.onSetGenSteps( self, event )
		blockerGroup.steps = event.count
		ignore("onSetGenSteps", self )
	end;listen( "onSetGenSteps", blockerGroup )	
	
	function blockerGroup.onGenerateStep( self, event )
		blockerGroup.steps = blockerGroup.steps - 1
		if( blockerGroup.steps <= 0 ) then
			ignore("onGenerateStep", self )
			function self.onComplete( self )
				display.remove(self)
				generationEnabled 	= true
				post("onTextFieldVisiblity", { phase = "show" } ) -- hackery to re-show hidden text fields
			end
			transition.to( blockerGroup, { alpha = 0.1, delay = 500, time = 100, onComplete = self })
		end
		msg.text = event.details
	end;listen( "onGenerateStep", blockerGroup )



--[[
	--
	-- EFM Temporary Feedback
	--
	button.generating = true
	local indicator = newRect( group, button.x - button.width/2 - 10, button.y, { w = button.width + 20,  h = button.height, fill = _Y_, anchorX = 0 } )
	local frame = newRect( group, button.x - button.width/2 - 10, button.y, { w = button.width + 20,  h = button.height, fill = _T_, stroke = _B_, strokeWidth = 2, anchorX = 0  } )
	indicator.xScale = 0.05
	indicator.alpha = 0
	indicator.count = 0
	indicator.steps = 1
	function indicator.onGenerateStep( self, event ) 
		self.count = self.count + 1
		self.xScale = self.count/self.steps
		self.alpha = 1
		if( self.count >= self.steps ) then
			self:setFillColor(unpack(_G_))
			self.alpha = 1
			ignore( "onGenerateStep", indicator )
			if( onComplete ) then onComplete() end
			button.generating = false
		end
	end
	listen( "onGenerateStep", indicator )	
--]]	


	-- Generate 'tasks'
	--
	--local gamePath = RGFiles.desktop.getDesktopPath("EATProjects2/" .. util.cleanFileName( currentProject.name ) )	
	local gamePath = RGFiles.util.repairPath( settings.EATGenFolder .. "/" .. util.cleanFileName( currentProject.name ) )

	RGFiles.util.repairPath( gamePath .. "/" .. util.cleanFileName( currentProject.name ) )
	generatedData.gamePath = gamePath

	local tasks = {}
	
	-- EDO EFM for now NOT supporting deletions
	--[[
	if( projectSettings.cleanBuild ) then 
		genUtil.removeGameFolder( generatedData, currentProject, tasks )
	end
	--]]
	genUtil.createGameFolder( generatedData, currentProject, tasks )
	genUtil.createFolders( generatedData, currentProject, tasks )
	genUtil.cloneFolders( generatedData, currentProject, tasks )
	genUtil.cloneFiles( generatedData, currentProject, tasks )
	genUtil.saveContent( generatedData, currentProject, tasks )
	--EDO EAT genUtil.genIcons( generatedData, currentProject, tasks )

	--table.print_r(tasks)

	--
	-- Execute the tasks with delays between each step
	--
	----[[
--EFM	indicator.steps = #tasks

	post( "onSetGenSteps", { count = #tasks } )
	local stepDelay = (#tasks > 0 ) and round(6000/#tasks) or 500
	stepDelay = (stepDelay > 100) and stepDelay or 100 
	--print(stepDelay)
	stepDelay = 1500
	for i = 1, #tasks do
		local curTask = tasks[i]
		timer.performWithDelay( i * stepDelay, curTask )
	end
	--return generatedData
	--]]
	

	--[[


	-- ===================================
	-- Copy com/* to folder
	--
	local comPath = RGFiles.documents.getPath( "sources/com" )
	local dst = RGFiles.util.repairPath( gamePath .. "/com" )
	print( comPath )
	print( dst )
	RGFiles.util.mkFolder( dst  )
	RGFiles.util.cpFolder( comPath, dst )

	-- ===================================
	-- Generate config.lua
	--


	-- ===================================
	-- Generate build.settings
	--

	-- ===================================
	-- Generate 
	--
	--]]


end


return generator