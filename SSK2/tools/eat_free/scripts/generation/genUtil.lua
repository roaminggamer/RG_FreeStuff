-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Eds Awesome Tool (a free SSK2 PRO co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
--   Last Updated: 06 JAN 2017
-- =============================================================

----------------------------------------------------------------------
--								LOCALS								              --
----------------------------------------------------------------------
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

-- Variables


-- Forward Declarations
local RGFiles = ssk.files


-- Uncomment following line to count currently decalred locals (can't have more than 200)
--ssk.misc.countLocals(1)
----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------
local util = {}
local private = {}
--[[
function util.getSettings()

	local settings = {}

	local tmp = {}
	settings.config_build = tmp

	local sources = { "resolution", "targets", "fps", "orientations" }

	for i = 1, #sources do
		--print( sources[i] )
		local src = require ( "pages." .. sources[i] )
		local tmp2 = table.deepCopy( src.targetTable )
		for k,v in pairs( tmp2 ) do
			tmp[k] = v
		end		
	end
	return settings
end
--]]

function util.indent( line, level, indentChar )
	indentChar = indentChar or "   "
	return string.rep( indentChar, level ) .. line
end

local currentContent

function util.resetContent()
	currentContent = nil
end

function util.getContent( )
	return currentContent 
end

function util.add( indent, line ) 
	currentContent = (currentContent == nil) and "" or (currentContent .. "\n")
	currentContent = currentContent .. util.indent( line, indent, "   "  )
end
function util.nl()
	util.add( 0, "" )
end
function util.cap( indent, skipNewLine, noComma )
	if( noComma ) then
		util.add( indent, "}" )
	else
		util.add( indent, "}," )
	end
	if( not skipNewLine ) then util.nl() end
end
function util.decimal_param( indent, pad, name, value )
	util.add( indent, string.format("%s = %d,", name:rpad(pad, " "), tonumber( value ) ) )
end
function util.float_param( indent, pad, name, value )
	util.add( indent, string.format("%s = %1.1f,", name:rpad(pad, " "), tonumber( value ) ) )
end
function util.string_param( indent, pad, name, value )
	util.add( indent, string.format("%s = \"%s\",", name:rpad(pad, " "), value ) )
end
function util.bool_param( indent, pad, name, value )
	util.add( indent, string.format("%s = %s,", name:rpad(pad, " "), tostring(value) ) )
end	

function util.string_table_param( indent, pad, name, values )
	local value = "{ "
	for k, v in pairs( values )do
		value = value .. '"' .. v .. '", '
	end
	value = value .. "}"
	util.add( indent, string.format("%s = %s,", name:rpad(pad, " "), value ) )
end

-- ========================================
-- Project Creation Tools
-- ========================================

function util.requirePlugin( plugins, name )
	local found = false
	for i = 1, #plugins do
		found = found or (plugins[i] == name )
	end
	if( not found ) then
		plugins[#plugins+1] = name
	end
end	


function util.getEmptyProjectData( )
	local generatedData = {}
	generatedData.folders = {}
	generatedData.folders_to_clone = {}
	generatedData.files_to_clone = {}
	generatedData.generatedContent = {}
	return generatedData
end	

function util.removeGameFolder( generatedData, currentProject, tasks )
	tasks[#tasks+1] =
		function()
			RGFiles.util.rmFolder( generatedData.gamePath )
			post("onGenerateStep", { details = "Remove folder: " .. tostring(generatedData.gamePath) } )
		end
end

function util.createGameFolder( generatedData, currentProject, tasks )
	tasks[#tasks+1] =
		function()
			RGFiles.util.mkFolder( generatedData.gamePath )
			post("onGenerateStep", { details = "Make folder: " .. tostring(generatedData.gamePath) } )
		end
end

function util.exploreGameFolder( generatedData )
	RGFiles.util.explore( generatedData.gamePath )
end

function util.createFolders( generatedData, currentProject, tasks )
	local steps = 0
	local saveRoot = generatedData.gamePath
	local foldersToCreate = {}
	--
	-- Build the paths
	--	
	local buildPaths
	buildPaths = function( folders, path )
		for k,v in pairs(folders) do
			steps = steps + 1
			foldersToCreate[#foldersToCreate+1] =  RGFiles.util.repairPath(  path .. "/" .. k )
			buildPaths( v, path .. "/" .. k )
		end
	end
	buildPaths( generatedData.folders, generatedData.gamePath )	

	--
	-- Sort them to ensure proper creation order
	--	
	table.sort( foldersToCreate )
	--table.dump( foldersToCreate, nil, "util.createFolders()")
	--
	-- Create the folders
	--
	for i = 1, #foldersToCreate do
		tasks[#tasks+1] =
			function()
				--print("util.createFolders() ", i, foldersToCreate[i] )
				RGFiles.util.mkFolder( foldersToCreate[i] )
				post("onGenerateStep", { details = "Make folder: " .. tostring(foldersToCreate[i]) } )
			end
	end
	--table.dump(tasks)

	return steps
end

function util.cloneFolders( generatedData, currentProject, tasks )
	local foldersToClone = generatedData.folders_to_clone

	for i = 1, #foldersToClone do
		local toClone = foldersToClone[i]
		--table.dump( toClone, nil, "util.cloneFolders()")	
		local srcbase = toClone.srcbase	
		local sourceRoot 
		if( srcbase == "documents" ) then
			sourceRoot = RGFiles.documents.getRoot( )
		else
			sourceRoot = RGFiles.resource.getRoot( )
		end

		local src = sourceRoot .. toClone.src
		local dst = generatedData.gamePath .. "/" .. toClone.dst

		src = RGFiles.util.repairPath( src )
		dst = RGFiles.util.repairPath( dst )

		tasks[#tasks+1] =
			function()
				--print("util.cloneFolders() ", i, src, dst )
				RGFiles.util.cpFolder( src, dst )
				post("onGenerateStep", { details = "Clone Folder: " .. tostring(toClone.src) } )
			end
	end
end

function util.cloneFiles( generatedData, currentProject, tasks )
	local filesToClone = generatedData.files_to_clone

	for i = 1, #filesToClone do
		local toClone = filesToClone[i]
		--table.dump( toClone, nil, "util.cloneFiles()")

		local srcbase = toClone.srcbase	
		local sourceRoot 
		if( srcbase == "documents" ) then
			sourceRoot = RGFiles.documents.getRoot( )
		else
			sourceRoot = RGFiles.resource.getRoot( )
		end

		local src = sourceRoot .. toClone.src
		local dst = generatedData.gamePath .. "/" .. toClone.dst
		
		src = RGFiles.util.repairPath( src )
		dst = RGFiles.util.repairPath( dst )

		tasks[#tasks+1] =
			function()
				--print("util.cloneFiles() ", i, src, dst )
				RGFiles.util.cpFile( src, dst )
				post("onGenerateStep", { details = "Clone File: " .. tostring(toClone.src) } )
			end
	end
end


function util.saveContent( generatedData, currentProject, tasks )
	--table.dump(generatedData)	
	--table.dump(generatedData.generatedContent[1])

	local saveRoot = generatedData.gamePath
	local generatedContent = generatedData.generatedContent

	for i = 1, #generatedContent do
		local path = RGFiles.util.repairPath( saveRoot .. "/" .. generatedContent[i].dst )
		tasks[#tasks+1] =
			function()
				--print("util.saveContent() ", i, " Writing generated content ==> " .. path )
				RGFiles.util.writeFile( generatedContent[i].content, path )
				post("onGenerateStep", { details = "Generate source code: " .. tostring(generatedContent[i].dst) } )
			end
	end
end

return util