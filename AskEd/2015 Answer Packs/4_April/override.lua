local override = {}

function override.doIt( extraPath )

	_G.sampleRoot = extraPath .. "/"

	-- ************************
	-- ************************ require()
	-- ************************
	local _G_require 			= _G.require
	local requireIgnoreList = {
		"ads", "analytics", "gameNetwork", "facebook", 	
		"composer", "crypto", "json", "lfs", "licensing",
		"media", "physics", "socket", "sprite", "sqlite3",
		"store", "storyboard",  "system", "widget",	
		"plugin", "CoronaProvider",
	}
	_G.require = function( path )
		local ignore = false
		for i = 1, #requireIgnoreList do
			ignore = ignore or (path:match( requireIgnoreList[i]) ~= nil)
		end

		if( ignore) then
			return _G_require( path )
		end

		return _G_require( extraPath:gsub("%/","%.") .. "." .. path )
	end

	-- ************************
	-- ************************ display.*
	-- ************************
	local display_newImage 		= _G.display.newImage
	local display_newImageRect 	= _G.display.newImageRect

	_G.display.newImage = function( ... )
		if( type(arg[1]) == "string" ) then 
			arg[1] = extraPath .. "/" .. arg[1]
		elseif( type(arg[2]) == "string" ) then 
			arg[2] = extraPath .. "/" .. arg[2]
		end
		return display_newImage( unpack(arg) )
	end

	_G.display.newImageRect = function( ... )
		if( type(arg[1]) == "string" ) then 
			arg[1] = extraPath .. "/" .. arg[1]
		elseif( type(arg[2]) == "string" ) then 
			arg[2] = extraPath .. "/" .. arg[2]
		end
		--table.print_r( arg )
		return display_newImageRect( unpack(arg) )
	end


	-- ************************
	-- ************************ graphics.*
	-- ************************
	local graphics_newImageSheet 	= _G.graphics.newImageSheet
	local graphics_newMask 			= _G.graphics.newMask
	local graphics_newOutline 		= _G.graphics.newOutline

	_G.graphics.newImageSheet = function( ... )
		if( type(arg[1]) == "string" ) then 
			arg[1] = extraPath .. "/" .. arg[1]
		end
		return graphics_newImageSheet( unpack(arg) )
	end

	_G.graphics.newMask = function( ... )
		if( type(arg[1]) == "string" ) then 
			arg[1] = extraPath .. "/" .. arg[1]
		end
		return graphics_newMask( unpack(arg) )
	end

	_G.graphics.newOutline = function( ... )
		if( type(arg[1]) == "string" ) then 
			arg[1] = extraPath .. "/" .. arg[1]
		end
		return graphics_newOutline( unpack(arg) )
	end

	-- ************************
	-- ************************ widget.*
	-- ************************
	local widget = require( "widget" )
	local widget_setTheme 		= widget.setTheme
	widget.setTheme = function( themeFile )
		if( type(arg[1]) == "string" ) then 
			arg[1] = extraPath .. "/" .. arg[1]
		end
		return widget_setTheme( themeFile )
	end

	-- ************************
	-- ************************ composer.*
	-- ************************
	local composer = require "composer"
	local composer_getScene		= composer.getScene
	composer.getScene = function( ... )
		if( type(arg[1]) == "string" ) then 
			arg[1] = extraPath:gsub("%/","%.") .. "." .. arg[1]
		end
		return composer_getScene( unpack(arg) )
	end

	local composer_gotoScene		= composer.gotoScene
	composer.gotoScene = function( ... )
		if( type(arg[1]) == "string" ) then 
			arg[1] = extraPath:gsub("%/","%.") .. "." .. arg[1]
		end
		return composer_gotoScene( unpack(arg) )
	end

	local composer_loadScene		= composer.loadScene
	composer.loadScene = function( ... )
		if( type(arg[1]) == "string" ) then 
			arg[1] = extraPath:gsub("%/","%.") .. "." .. arg[1]
		end
		return composer_loadScene( unpack(arg) )
	end

	local composer_removeScene		= composer.removeScene
	composer.removeScene = function( ... )
		if( type(arg[1]) == "string" ) then 
			arg[1] = extraPath:gsub("%/","%.") .. "." .. arg[1]
		end
		return composer_removeScene( unpack(arg) )
	end

	local composer_showOverlay		= composer.showOverlay
	composer.showOverlay = function( ... )
		if( type(arg[1]) == "string" ) then 
			arg[1] = extraPath:gsub("%/","%.") .. "." .. arg[1]
		end
		return composer_showOverlay( unpack(arg) )
	end


	-- ************************
	-- ************************ widget.*
	-- ************************
	local audio = _G.audio
	local audio_loadSound 		= audio.loadSound	
	audio.loadSound = function( ... )
		if( type(arg[1]) == "string" ) then 
			arg[1] = extraPath .. "/" .. arg[1]
		end
		return audio_loadSound( unpack(arg) )
	end

	local audio_loadStream	= audio.loadStream
	audio.loadStream = function( ... )
		if( type(arg[1]) == "string" ) then 
			arg[1] = extraPath .. "/" .. arg[1]
		end
		return audio_loadStream( unpack(arg) )
	end

end


return override