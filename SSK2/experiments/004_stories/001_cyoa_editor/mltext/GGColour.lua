-- Project: GGColour
--
-- Date: October 17, 2012
--
-- File name: GGColour.lua
--
-- Author: Graham Ranson of Glitch Games - www.glitchgames.co.uk
--
-- Comments: 
-- 
--	    GGColour makes it very simple to used named or hex colours in your game or app. 
--		You can also create custom colour palettes that you can swap out whenever you want.
--
-- Copyright (C) 2012 Graham Ranson, Glitch Games Ltd.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this 
-- software and associated documentation files (the "Software"), to deal in the Software 
-- without restriction, including without limitation the rights to use, copy, modify, merge, 
-- publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons 
-- to whom the Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all copies or 
-- substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.
--
----------------------------------------------------------------------------------------------------

local GGColour = {}
local GGColour_mt = { __index = GGColour }

local lower = string.lower
local json = require( "json" ) 

--- Initiates a new GGColour object.
-- @return The new object.
function GGColour:new()
    
    local self = {}
    
    setmetatable( self, GGColour_mt )
    
    self.colours = {}
	self.palettes = {}

    return self
    
end

--- Gets all named colours in the system.
-- @return The colours.
function GGColour:getAvailableColours()
	return self.colours
end

--- Gets all palettes in the system.
-- @return The palettes.
function GGColour:getAvailablePalettes()
	return self.palettes
end

--- Adds a named colour to the main list of colours.
-- @param name The name of the new colour. Case-insensitive.
-- @param rgba A table containing the RGBA values.
function GGColour:addColour( name, rgba )
	self.colours[ lower( name ) ] = rgba
end

--- Adds a palette.
-- @param name The name of the new palette. Case-insensitive.
-- @param colours A table containing a list of named RGBA values.
function GGColour:addPalette( name, colours )
	self.palettes[ lower( name ) ] = colours
end

--- Gets a named palette.
-- @param name The name of the palette. Case-insensitive.
-- @return The palette. Nil if none found.
function GGColour:getPalette( name )
	return self.palettes[ lower( name ) ]
end

--- Removes a palette.
-- @param name The name the palette. Case-insensitive.
function GGColour:removePalette( name )
	self.palettes[ lower( name ) ] = nil
end

--- Gets a named colour.
-- @param name The name of the colour.
-- @param asTable Value indicating whether the colour should be returned as a table or individual components. Default is individual components.
-- @param paletteName The name of the colour palette to use. Optional and case-insensitive.
-- @return The found colour. Nil if none found.
function GGColour:fromName( name, asTable, paletteName )
	
	local colours = self:getAvailableColours()
	
	if paletteName then
		colours = self:getPalette( paletteName )
	end
	
	local colour
	if colours then
		colour = colours[ lower( name ) ]
	end
	
	if colour then
		if asTable then
			return colour
		else
			return colour[ 1 ], colour[ 2 ], colour[ 3 ], colour[ 4 ] or 1
		end
	end
	
end

--- Gets a colour from a passed in Hex string.
-- @param hex The hex string.
-- @param asTable Value indicating whether the colour should be returned as a table or individual components. Default is individual components.
-- @return The converted colour.
function GGColour:fromHex( hex, asTable )
	
	local colour = {}
	colour[ 1 ] = tonumber( string.sub( hex, 1, 2 ), 16 ) or 1
	colour[ 2 ] = tonumber( string.sub( hex, 3, 4 ), 16 ) or 1
	colour[ 3 ] = tonumber( string.sub( hex, 5, 6 ), 16 ) or 1
	colour[ 4 ] = tonumber( string.sub( hex, 7, 8 ), 16 ) or 1
	
	for i = 1, #colour, 1 do
		colour[ i ] = colour[ i ] / 255
	end

	if asTable then
		return colour
	else
		return colour[ 1 ], colour[ 2 ], colour[ 3 ], colour[ 4 ] or 1
	end
		
end

--- Load a set of colours from a file.
-- @param path The path to the file.
-- @param baseDir The base directory of the file. Optional, defaults to system.ResourceDirectory.
function GGColour:loadColours( path, baseDir )

	local path = system.pathForFile( path, baseDir or system.ResourceDirectory )

	if path then

		local file = io.open( path, "r" )
		
		if file then
			
			local data = file:read( "*a" ) or "{}"
			
			local colours = json.decode( data ) or {}

			for k, v in pairs( colours ) do
				self:addColour( k, v )
			end

			io.close( file )

		end
		
		file = nil

	end

end

--- Saves the current set of colours to a file.
-- @param path The path for the file.
function GGColour:saveColours( path )

	local path = system.pathForFile( path, system.DocumentsDirectory )
	local data = json.encode( self:getAvailableColours() or {} )
	local file = io.open( path, "w" )
	
	if file then
		file:write( data )
		io.close( file )
	end

	file = nil

end

--- Load a palette from a file.
-- @param name The name of the palette.
-- @param path The path to the file.
-- @param baseDir The base directory of the file. Optional, defaults to system.ResourceDirectory.
function GGColour:loadPalette( name, path, baseDir )

	local path = system.pathForFile( path, baseDir or system.ResourceDirectory )

	if path then

		local file = io.open( path, "r" )
		
		if file then
			
			local data = file:read( "*a" ) or "{}"
			
			local palette = json.decode( data ) or {}

			for k, v in pairs( palette ) do
				palette[ k ] = self:fromName( v, true )
			end

			self:addPalette( name, palette )

			io.close( file )

		end
		
		file = nil

	end

end

--- Destroys this GGColour object.
function GGColour:destroy()
	self.palettes = nil
	self.colours = nil
end

return GGColour