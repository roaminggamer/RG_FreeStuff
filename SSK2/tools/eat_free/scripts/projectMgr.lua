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
local util 		= require "scripts.util"
local settings 	= require "scripts.settings"

local allProjects = { projects = {} }

local projectMgr = {}
local currentProject

-- ==
-- Initialize manager and prepare to run
-- ==
function projectMgr.initialize( params )
	params = params or {}

	-- Load DB of all projects
	--allProjects = table.load( "projectDB.txt" ) or allProjects
	allProjects = RGFiles.util.loadTable( settings.EATDBPath  ) or allProjects

	if( #allProjects.projects == 0 ) then
		return
	end

	-- Load last?
	--projectMgr.load( allProjects.last )		
end

function projectMgr.purge()
	allProjects = { projects = {} }
	projectMgr.save()
end; listen( "onPurge", projectMgr.purge)


-- ==
-- Count current number of Worlds in Project
-- ==
function projectMgr.countProjects( )
	if( not allProjects ) then return 0 end
	if( not allProjects.projects ) then return 0 end
	local count = 0
	for k,v in pairs(allProjects.projects) do
		count = count + 1
	end
	return count
end


-- ==
-- Return reference to current project (if any)
-- ==
function projectMgr.addToMap( record )
	currentProject.map[#currentProject.map+1] = record.uid
end


-- ==
-- Create a UI record (or replace it if passed in)
-- ==
function projectMgr.newUI( uid, record )
	currentProject.uis[uid] = record or {}
end

-- ==
-- Create a World record (or replace it if passed in)
-- ==
function projectMgr.newWorld( uid, record )
	currentProject.worlds[uid] = record or {}
end

-- ==
-- Add a UI record or create a blank one if no record is passed
-- ==
function projectMgr.addToUI( ui_uid, uid )
	local ui = currentProject.uis[ui_uid]
	ui[#ui+1] = uid
end

-- ==
-- Add a World record or create a blank one if no record is passed
-- ==
function projectMgr.addToWorld( world_uid, uid )
	local world = currentProject.worlds[world_uid]
	world[#world+1] = uid
end


-- ==
-- Remove a object from the current project
-- ==
function projectMgr.deleteObject( uid )
	local removed = false
	local map = currentProject.map
	local found = false

	local count = 1
	while( not found and count <= #map ) do
		if( map[count] == uid ) then
			found = true
			table.remove( map, count )
		end
		count = count + 1
	end

	-- Found in a map entry, go purge all objects from that map entry's record too
	if( found ) then
		--print("Found map record ", uid)
		local record = currentProject.uis[uid] or  currentProject.worlds[uid]
		currentProject.uis[uid] = nil
		currentProject.worlds[uid] = nil
		for i = 1, #record do
			currentProject.records[record[i]] = nil
		end		
	end

	if( not found ) then
		for k, v in pairs(currentProject.uis) do
			local count = 1
			while( not found and count <= #v ) do
				if(v[count] == uid) then
					--print( "Found entity in ui")
					found = true
					table.remove( v, count )
				end
				count = count + 1
			end
		end
	end

	if( not found ) then
		for k, v in pairs(currentProject.worlds) do
			local count = 1
			while( not found and count <= #v ) do
				if(v[count] == uid) then
					--print( "Found entity in world")
					found = true
					table.remove( v, count )
				end
				count = count + 1
			end
		end
	end

	if( found ) then
		currentProject.records[uid] = nil
	end

	if( not found )	then print("deleteObject ", uid, " not found") end
end


-- ==
-- Get a record from this project by its uid
-- ==
function projectMgr.getRecord( uid )
	if( not currentProject.records[uid] ) then return nil end
	return currentProject.records[uid] 
end


-- ==
-- Get a specific UI by its uid
-- ==
function projectMgr.getUI( uid )
	if( not currentProject.uis[uid] ) then return {} end
	return currentProject.uis[uid]
end

-- ==
-- Get a specific World by its uid
-- ==
function projectMgr.getWorld( uid )
	if( not currentProject.worlds[uid] ) then return {} end
	return currentProject.worlds[uid]
end


-- ==
-- Return reference to current project (if any)
-- ==
function projectMgr.current()
	return currentProject 
end


-- ==
-- Return uid of last project
-- ==
function projectMgr.last()
	return allProjects.last or nil
end

-- ==
-- Clear current project
-- ==
function projectMgr.clear()
	currentProject = nil
end

-- ==
-- Clear current project
-- ==
function projectMgr.load( id )
	currentProject = nil
	local projects = allProjects.projects
	for i = 1, #projects do
		if( projects[i].id == id ) then
			--print("Found last project at index: ", i )
			currentProject = projects[i]			
		end
	end
	allProjects.last = id
	projectMgr.save()
end

-- ==
-- Save projects DB
-- ==
function projectMgr.save()	
	--table.save( allProjects, "projectDB.txt" )
	--if( settings.genPath ) then
		RGFiles.util.saveTable( allProjects, settings.EATDBPath  )
	--end
end


-- ==
-- Return table containing list of project names and uids
-- ==
function projectMgr.getProjectsList( )
	local projects = allProjects.projects
	local list = {}
	for i = 1, #projects do
		list[i] = { uid = projects[i].id, name = projects[i].name }

	end
	return list
end

-- ==
-- 
-- ==
function projectMgr.getCount()
	return #allProjects.projects 
end


-- ==
-- 
-- ==
function projectMgr.getUniqueName()
	local projectCount = #allProjects.projects + 1 
	local name = "Project #" .. projectCount

	-- Ensure a unique name
	local projects = allProjects.projects
	for i = 1, #projects do
		while( name == projects[i].name ) do
			projectCount = projectCount + 1
			name = "Project #" .. projectCount 
		end
	end
	return name
end


-- ==
-- 
-- ==
function projectMgr.deleteProject( uid )	
	--print(" Delete project ", uid)
	local projects = allProjects.projects
	local index 
	for i = 1, #projects do
		--print(" Looking ", i, projects[i].id, uid )
		if( projects[i].id == uid ) then
			--print( "found @ ", i)
			index = i
		end
	end
	if( index ) then 
		table.remove( projects, index )
		if( currentProject and currentProject.id == uid ) then
			currentProject = nil
			allProjects.last = nil
			if( #projects > 0 ) then
				allProjects.last = projects[1].id
			end
		end
		
		projectMgr.save()
		projectMgr.initialize()
		projectMgr.save()
	end
end

-- ==
-- Export A Project
-- ==
function projectMgr.export( uid )
	local projects = allProjects.projects 
	local toExport
	for i = 1, #projects do
		if( projects[i].id == uid ) then
			toExport = projects[i]
		end
	end
	table.dump(toExport)

	if( toExport ) then
		local fileName = util.cleanFileName(toExport.name) .. ".eat"
		RGFiles.util.mkFolder( settings.EATGenFolder )
		RGFiles.util.saveTable( toExport, settings.EATGenFolder .. "/" .. fileName )
		easyAlert("Success!", "Exported project to file: " ..  fileName, 
			      { { "OK" }, 
			        { "Open Folder", function() RGFiles.desktop.explore( settings.EATGenFolder ) end } } )
	end
end

-- ==
-- Generate Empty Project Record
-- ==
function projectMgr.emptyProject( name, projectType, projectSubtype )
	print("projectMgr.emptyProject() ", name, projectType, projectSubtype )
	local tmp =
		{ 
			id			= projectMgr.getUID( 8, false ), 
		 	uids 		= {},
		 	plugins		= {},
		 	settings	= require("scripts.defaultSettings").get(),
		 	projectType = projectType,
		 	projectSubtype = projectSubtype,
		 	name 		= name or projectMgr.getUniqueName(),
		 	summary 	= "Describe your game here.\n\nThis will help you later if you keep several projects stored in EAT."
		}	

	local projects = allProjects.projects
	projects[#projects+1] = tmp
	projectMgr.load( tmp.id )		

	return tmp
end

-- ==
-- Unique ID Generator
-- ==
local mRand = math.random
local keySrc = "abcdefghijklmnopqrstuvwxyaABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
--local keySrc = "abcdefghijklmnopqrstuvwxyaABCDEFGHIJKLMNOPQRSTUVWXYZ"
local keyTbl = {}
for i = 1, #keySrc do
  keyTbl[i] = keySrc:sub(i,i)
end
--table.dump(keyTbl)

projectMgr.getUID = function( rlen, verify )
	rlen = rlen or 20
	verify = fnn( verify, true )
	local tmp = ""
	local max = #keyTbl
	for i = 1, rlen do
		tmp = tmp .. keyTbl[mRand(1,max)]
	end

	if( verify ) then
		while( currentProject and currentProject.uids[tmp]  ) do
			print("duplicate UID")
			tmp = projectMgr.getUID(rlen,verify)
		end
		currentProject.uids[tmp] = tmp 
	end
	return tmp 
end


return projectMgr