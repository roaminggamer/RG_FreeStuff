-- Project: GGColour
--
-- Date: October 17, 2012
--
-- Version: 0.1
--
-- File name: GGColour.lua
--
-- Author: Graham Ranson of Glitch Games - www.glitchgames.co.uk
--
-- Update History:
--
-- 0.1 - Initial release
--
-- Comments: 
-- 
--	    GGColour makes it very simple to used named or hex colours in your game or app. 
--		You can also create custom colour palettes that you can swap out whenever you want
--		Colour values liberated from here - http://www.tayloredmktg.com/rgb/
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

--- Initiates a new GGColour object.
-- @return The new object.
function GGColour:new()
    
    local self = {}
    
    setmetatable( self, GGColour_mt )
    
    self.colours = {}
	self.palettes = {}
	
	-- Whites/Pastels --
	self:addColour( "Snow", { 255, 250, 250 } )
	self:addColour( "Snow2", { 238, 233, 233 } )
	self:addColour( "Snow3", { 205, 201, 201 } )
	self:addColour( "Snow4", { 139, 137, 137 } )
	self:addColour( "GhostWhite", { 248, 248, 255 } )
	self:addColour( "WhiteSmoke", { 245, 245, 245 } )
	self:addColour( "Gainsboro", { 220, 220, 220 } )
	self:addColour( "FloralWhite", { 255, 250, 240 } )
	self:addColour( "OldLace", { 253, 245, 230 } )
	self:addColour( "Linen", { 240, 240, 230 } )
	self:addColour( "AntiqueWhite", { 250, 235, 215 } )
	self:addColour( "AntiqueWhite2", { 238, 223, 204 } )
	self:addColour( "AntiqueWhite3", { 205, 192, 176 } )
	self:addColour( "AntiqueWhite4", { 139, 131, 120 } )
	self:addColour( "PapayaWhip", { 255, 239, 213 } )
	self:addColour( "BlanchedAlmond", { 255, 235, 205 } )
	self:addColour( "Bisque", { 255, 228, 196 } )
	self:addColour( "Bisque2", { 238, 213, 183 } )
	self:addColour( "Bisque3", { 205, 183, 158 } )
	self:addColour( "Bisque4", { 139, 125, 107 } )
	self:addColour( "PeachPuff", { 255, 218, 185 } )
	self:addColour( "PeachPuff2", { 238, 203, 173 } )
	self:addColour( "PeachPuff3", { 205, 175, 149 } )
	self:addColour( "PeachPuff4", { 139, 119, 101 } )
	self:addColour( "NavajoWhite", { 255, 222, 173 } )
	self:addColour( "Moccasin", { 255, 228, 181 } )
	self:addColour( "Cornsilk", { 255, 248, 220 } )
	self:addColour( "Cornsilk2", { 238, 232, 205 } )
	self:addColour( "Cornsilk3", { 205, 200, 177 } )
	self:addColour( "Cornsilk4", { 139, 136, 120 } )
	self:addColour( "Ivory", { 255, 255, 240 } )
	self:addColour( "Ivory2", { 238, 238, 224 } )
	self:addColour( "Ivory3", { 205, 205, 193 } )
	self:addColour( "Ivory4", { 139, 139, 131 } )
	self:addColour( "LemonChiffon", { 255, 250, 205 } )
	self:addColour( "Seashell", { 255, 245, 238 } )
	self:addColour( "Seashell2", { 238, 229, 222 } )
	self:addColour( "Seashell3", { 205, 197, 191 } )
	self:addColour( "Seashell4", { 139, 134, 130 } )
	self:addColour( "Honeydew", { 240, 255, 240 } )
	self:addColour( "Honeydew2", { 244, 238, 224 } )
	self:addColour( "Honeydew3", { 193, 205, 193 } )
	self:addColour( "Honeydew4", { 131, 139, 131 } )
	self:addColour( "MintCream", { 245, 255, 250 } )
	self:addColour( "Azure", { 240, 255, 255 } )
	self:addColour( "AliceBlue", { 240, 248, 255 } )
	self:addColour( "Lavender", { 230, 230, 250 } )
	self:addColour( "LavenderBlush", { 255, 240, 245 } )
	self:addColour( "MistyRose", { 255, 228, 225 } )
	self:addColour( "White", { 255, 255, 255 } )
	
	-- Greys --
	self:addColour( "Black", { 0, 0, 0 } )
	self:addColour( "DarkSlateGrey", { 49, 79, 79 } )
	self:addColour( "DimGrey", { 105, 105, 105 } )
	self:addColour( "SlateGrey", { 112, 138, 144 } )
	self:addColour( "LightSlateGrey", { 119, 136, 153 } )
	self:addColour( "Grey", { 190, 190, 190 } )
	self:addColour( "LightGrey", { 211, 211, 211 } )
	
	-- Blues --
	self:addColour( "MidnightBlue", { 25, 25, 112 } )
	self:addColour( "Navy", { 0, 0, 128 } )
	self:addColour( "CornflowerBlue", { 100, 149, 237 } )
	self:addColour( "DarkslateBlue", { 72, 61, 139 } )
	self:addColour( "SlateBlue", { 106, 90, 205 } )
	self:addColour( "MediumSlateBlue", { 123, 104, 238  } )
	self:addColour( "LightSlateBlue", { 132, 112, 255 } )
	self:addColour( "MediumBlue", { 0, 0, 205 } )
	self:addColour( "RoyalBlue", { 65, 105, 225 } )
	self:addColour( "Blue", { 0, 0, 255 } )
	self:addColour( "DodgerBlue", { 30, 144, 255 } )
	self:addColour( "DeepSkyBlue", { 0, 191, 255 } )
	self:addColour( "SkyBlue", { 135, 206, 250 } )
	self:addColour( "LightSkyBlue", { 135, 206, 250 } )
	self:addColour( "SteelBlue", { 70, 130, 180 } )
	self:addColour( "LightSteelBlue", { 176, 196, 222 } )
	self:addColour( "LightBlue", { 173, 216, 230 } )
	self:addColour( "PowderBlue", { 176, 224, 230 } )
	self:addColour( "PaleTurquoise", { 175, 238, 238 } )
	self:addColour( "DarkTurquoise", { 0, 206, 209 } )
	self:addColour( "MediumTurquoise", { 72, 209, 204 } )
	self:addColour( "Turquoise", { 64, 224, 208 } )
	self:addColour( "Cyan", { 0, 255, 255 } )
	self:addColour( "LightCyan", { 224, 255, 255 } )
	self:addColour( "CadetBlue", { 95, 158, 160 } )

	-- Greens --
	self:addColour( "MediumAquamarine", { 102, 205, 170 } )
	self:addColour( "Aquamarine", { 127, 255, 212 } )
	self:addColour( "DarkGreen", { 0, 100, 0 } )
	self:addColour( "DarkOliveGreen", { 85, 107, 47 } )
	self:addColour( "DarkSeaGreen", { 143, 188, 143 } )
	self:addColour( "SeaGreen", { 46, 139, 87 } )
	self:addColour( "MediumSeaGreen", { 60, 179, 113 } )
	self:addColour( "LightSeaGreen", { 32, 178, 170 } )
	self:addColour( "PaleGreen", { 152, 251, 152 } )
	self:addColour( "SpringGreen", { 0, 255, 127 } )
	self:addColour( "LawnGreen", { 124, 252, 0 } )
	self:addColour( "Chartreuse", { 127, 255, 0 } )
	self:addColour( "MediumSpringGreen", { 0, 250, 154 } )
	self:addColour( "GreenYellow", { 173, 255, 47 } )
	self:addColour( "LimeGreen", { 50, 205, 50 } )
	self:addColour( "YellowGreen", { 154, 205, 50 } )
	self:addColour( "ForestGreen", { 34, 139, 34 } )
	self:addColour( "OliveDrab", { 107, 142, 35 } )
	self:addColour( "DarkKhaki", { 189, 183, 107 } )
	self:addColour( "Khaki", { 240, 230, 140 } )
	
	-- Yellows --
	self:addColour( "PaleGoldenrod", { 238, 232, 170 } )
	self:addColour( "LightGoldenRodYellow", { 250, 250, 210 } )
	self:addColour( "LightYellow", { 255, 255, 224 } )
	self:addColour( "Yellow", { 255, 255, 0 } )
	self:addColour( "Gold", { 255, 215, 0 } )
	self:addColour( "LightGoldenrod", { 238, 221, 130	} )
	self:addColour( "Goldenrod", { 218, 165, 32 } )
	self:addColour( "DarkGoldenrod", { 184, 134, 11 } )
	
	-- Browns --
	self:addColour( "RosyBrown", { 188, 143, 143 } )	
	self:addColour( "IndianRed", { 205, 92, 92 } )	
	self:addColour( "SaddleBrown", { 139, 69, 19 } )	
	self:addColour( "Sienna", { 160, 82, 45 } )	
	self:addColour( "Peru", { 205, 133, 63 } )	
	self:addColour( "BurlyWood", { 222, 184, 135 } )	
	self:addColour( "Beige", { 245, 245, 220 } )	
	self:addColour( "Wheat", { 245, 222, 179 } )	
	self:addColour( "SandyBrown", { 244, 164, 96 } )	
	self:addColour( "Tan", { 210, 180, 140 } )	
	self:addColour( "Chocolate", { 210, 105, 30 } )	
	self:addColour( "Firebrick", { 178, 34, 34 } )	
	self:addColour( "Brown", { 165, 42, 42 } )	
	
	-- Oranges --	 
	self:addColour( "DarkSalmon", { 233, 150, 122 } )
    self:addColour( "Salmon", { 250, 128, 114 } )
    self:addColour( "LightSalmon", { 255, 160, 122 } )
    self:addColour( "Orange", { 255, 165, 0 } )
    self:addColour( "DarkOrange", { 255, 140, 0 } )
    self:addColour( "Coral", { 255, 127, 80 } )
    self:addColour( "LightCoral", { 240, 128, 128 } )
    self:addColour( "Tomato", { 255, 99, 71 } )
    self:addColour( "OrangeRed", { 255, 69, 0 } )
    self:addColour( "Red", { 255, 0, 0 } )
    
    -- Pinks/Violets --
    self:addColour( "HotPink", { 255, 105, 180 } )
    self:addColour( "DeepPink", { 255, 20, 147 } )
    self:addColour( "Pink", { 255, 192, 203 } )
    self:addColour( "LightPink", { 255, 182, 193 } )
    self:addColour( "PaleVioletRed", { 219, 112, 147 } )
    self:addColour( "Maroon", { 176, 48, 96 } )
    self:addColour( "MediumVioletRed", { 199, 21, 133 } )
    self:addColour( "VioletRed", { 208, 32, 144 } )
    self:addColour( "Violet", { 238, 130, 238 } )
    self:addColour( "Plum", { 221, 160, 221 } )
    self:addColour( "Orchid", { 218, 112, 214 } )
    self:addColour( "MediumOrchid", { 186, 85, 211 } )
    self:addColour( "DarkOrchid", { 153, 50, 204 } )
    self:addColour( "DarkViolet", { 148, 0, 211 } )
    self:addColour( "BlueViolet", { 138, 43, 226 } )
    self:addColour( "Purple", { 160, 32, 240 } )
    self:addColour( "MediumPurple", { 147, 112, 219 } )
    self:addColour( "Thistle", { 216, 191, 216 } )
    
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
			return colour[ 1 ], colour[ 2 ], colour[ 3 ], colour[ 4 ] or 255
		end
	end
	
end

--- Gets a colour from a passed in Hex string.
-- @param hex The hex string.
-- @param asTable Value indicating whether the colour should be returned as a table or individual components. Default is individual components.
-- @return The converted colour.
function GGColour:fromHex( hex, asTable )
	
	local colour = {}
	colour[ 1 ] = tonumber( string.sub( hex, 1, 2 ), 16 )
	colour[ 2 ] = tonumber( string.sub( hex, 3, 4 ), 16 )
	colour[ 3 ] = tonumber( string.sub( hex, 5, 6 ), 16 )
	colour[ 4 ] = tonumber( string.sub( hex, 7, 8 ), 16 )
	
	if asTable then
		return colour
	else
		return colour[ 1 ], colour[ 2 ], colour[ 3 ], colour[ 4 ] or 255
	end
		
end

--- Destroys this GGColour object.
function GGColour:destroy()
	self.palettes = nil
	self.colours = nil
end

return GGColour