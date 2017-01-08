-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Eds Awesome Tool (a free SSK2 PRO co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
--   Last Updated: 06 JAN 2017
-- =============================================================
local RGFiles 	= ssk.files
local genUtil 	= require( "scripts.generation.genUtil" )
local pu 	  	= require( "scripts.generation.packageUtil" )


local curSettings
local curPlugins


local package = {}
function package.getVersion() return 1 end

function package.generate( generatedData, currentProject )
	local util = require "scripts.util"


	if( not currentProject ) then 
		curSettings = {}
		curPlugins = {}
	else
		--table.dump(curSettings,nil,"curSettings")
		curSettings = currentProject.settings
		curPlugins = currentProject.plugins
	end	


	-- EFM - Q: Put code here to force required plugins?

	local srcbase	= "documents" -- "resource" or "documents"
	--local content 	= "sources/templates/default/"
	local content 	= "sources/"
	local comSrc 	= "sources/com"


	-- 1. Specify any folders (directories) that should be created.
	--
	local createdScripts = false
	if( util.usingMonetizers(currentProject) or
	    util.usingAnalytics(currentProject) or 
	    util.usingAttribution(currentProject) or 
	    util.usingIAP(currentProject) or 
	    util.usingSocial(currentProject) or 
	    util.usingUtils(currentProject) ) then

		pu.createFolder( generatedData, "scripts")
		createdScripts = true
	end

	-- 2. Specify folders to clone
	--
	--pu.cloneFolder( generatedData, srcbase, content .. "defaultIcons_ios/" , "/"  )

	-- 3. Specify files to clone
	--
	--	pu.cloneFile( generatedData, srcbase, content .. "common/readMe.txt",  "readMe.txt" )

	if( currentProject.settings.provide_icons == "yes") then
		if( currentProject.settings.generate_ios == "true" ) then
			local imagesPath = RGFiles.documents.getPath( content .. "/targets/ios/icons" )
			local images =  RGFiles.util.getFilesInFolder(imagesPath)
			for i = 1, #images do
				pu.cloneFile( generatedData, srcbase, content .. "targets/ios/icons/" .. images[i],  images[i] )
			end
		end

		if( currentProject.settings.generate_android == "true" ) then
			local imagesPath = RGFiles.documents.getPath( content .. "/targets/android/icons" )
			local images =  RGFiles.util.getFilesInFolder(imagesPath)
			for i = 1, #images do
				pu.cloneFile( generatedData, srcbase, content .. "targets/android/icons/" .. images[i],  images[i] )
			end
		end

		if( currentProject.settings.generate_desktop_osx == "true" ) then
			local imagesPath = RGFiles.documents.getPath( content .. "/targets/desktop_osx" )
			local images =  RGFiles.util.getFilesInFolder(imagesPath)
			for i = 1, #images do
				pu.cloneFile( generatedData, srcbase, content .. "targets/desktop_osx/" .. images[i],  images[i] )
			end
		end
		
		if( currentProject.settings.generate_desktop_win32 == "true" ) then
			local imagesPath = RGFiles.documents.getPath( content .. "/targets/desktop_win32" )
			local images =  RGFiles.util.getFilesInFolder(imagesPath)
			for i = 1, #images do
				pu.cloneFile( generatedData, srcbase, content .. "targets/desktop_win32/" .. images[i],  images[i] )
			end
		end
	end

	if( currentProject.settings.provide_launch_images == "yes") then
		if( currentProject.settings.generate_android == "true" ) then
			local imagesPath = RGFiles.documents.getPath( content .. "/targets/android/banners" )
			local images =  RGFiles.util.getFilesInFolder(imagesPath)
			for i = 1, #images do
				pu.cloneFile( generatedData, srcbase, content .. "targets/android/banners/" .. images[i],  images[i] )
			end
		end

		if( currentProject.settings.generate_ios == "true" ) then
			if( currentProject.settings.orientation == "Portrait" ) then
				local imagesPath = RGFiles.documents.getPath( content .. "/targets/ios/launchPortrait" )
				local images =  RGFiles.util.getFilesInFolder(imagesPath)
				for i = 1, #images do
					pu.cloneFile( generatedData, srcbase, content .. "targets/ios/launchPortrait/" .. images[i],  images[i] )
				end
			else
				local imagesPath = RGFiles.documents.getPath( content .. "/targets/ios/launchLandscape" )
				local images =  RGFiles.util.getFilesInFolder(imagesPath)
				for i = 1, #images do
					pu.cloneFile( generatedData, srcbase, content .. "targets/ios/launchLandscape/" .. images[i],  images[i] )
				end
			end
		end
	end


	-- 4. Add specific generated content to generatedData table
	--
	local generate_config_lua  		=  require("scripts.generation.gen_config_lua").generate
	local generate_build_settings 	=  require("scripts.generation.gen_build_settings").generate

	pu.addGC( generatedData, generate_config_lua( "config.lua", currentProject ), "config.lua"  )
	pu.addGC( generatedData, generate_build_settings( "build.settings", currentProject ), "build.settings"  )

	local package_default_main = require "scripts.generation.packages.default_main"
	pu.addGC( generatedData, package_default_main.generate( "main.lua", currentProject ), "main.lua" )

	
	-- 5. Add special content from Frameworks, Ask Ed, etc.
	--
	
	local specialContent
	if( currentProject.projectType == "Frameworks" ) then

		local path
		local contentName 

		if( currentProject.projectSubtype == "Standard Composer Framework" ) then
			path = RGFiles.documents.getPath( "sources/StandardComposer.json" )					
			contentName = "StandardComposer"
		
		elseif( currentProject.projectSubtype  == "Improved Composer Framework" ) then
			path = RGFiles.documents.getPath( "sources/ImprovedComposer.json" )			
			contentName = "ImprovedComposer"
		end

		if( path ) then
			specialContent = RGFiles.util.loadTable( path )
			--table.dump( specialContent )
		end

		if( specialContent ) then
			local generator = require "scripts.generation.generator"
			generator.parseSpecial( generatedData, specialContent[contentName] )
			--table.dump( generatedData )
		end
	end

end


return package


