-- Project: GGChart
--
-- Date: November 16, 2012
--
-- Version: 0.1
--
-- File name: GGChart.lua
--
-- Author: Graham Ranson of Glitch Games - www.glitchgames.co.uk
--
-- Update History:
--
-- 0.1 - Initial release
--
-- Comments: 
-- 
--		GGChart allows for easy creation of Google Image Charts for your Corona apps. 
--		The Google Image Chart API was deprecated in April 2012 however it should still
--		work. Info is here - https://developers.google.com/chart/image/
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

local GGChart = {}
local GGCharts_mt = { __index = GGChart }

local http = require( "socket.http" )
local ltn12 = require( "ltn12" )

local googleUrl = "http://chart.apis.google.com/chart?"

--- Initiates a new GGChart object.
-- @return The new object.
function GGChart:new( params )
    
    local self = {}
    
    setmetatable( self, GGCharts_mt )
    
    if params then
    	if params.type == "qr" then		
			self:newQR(params)
		elseif params.type == "pie" then		
			self:newPie(params)	
		elseif params.type == "line" then		
			self:newLine(params)	
		end
    end
    
    return self
    
end

--- Creates a new line chart. Called internally.
-- @param params The chart params.
function GGChart:newLine( params )

	if not params then
		params = {}
	end

	self.mode = params.mode or "standard"

	if self.mode == "standard" then
		self.type = "lc"
	elseif self.mode == "spark" then
		self.type = "ls"
	elseif self.mode == "xy" then
		self.type = "lxy"
	end	

	self.title = params.title or ""
	self.titleColour = params.titleColour or "000000"
	self.titleFontSize = params.titleFontSize or 11.5
	self.data = params.data or ""
	self.width = params.width or 200
	self.height = params.height or self.width
	self.legend = params.legend or ""
	self.legendPosition = params.legendPosition or "r"
	self.legendSize = params.legendSize
	self.labels = params.labels or ""
	self.margins = params.margins or { 0, 0, 0, 0 }
	self.x = params.x or 0
	self.y = params.y or 0
	self.scale = params.scale or { 0, 100 }
	self.dataColours = params.dataColours or "0000FF"
	self.dataStyle = params.dataStyle or ""

	self.axis = params.axis or ""
	self.axisLabels = params.axisLabels or ""
	self.axisLabelPositions = params.axisLabelPositions or ""

	self.transparency = params.transparency or "a,s,000000" 
	self.background = params.background or "bg,s,FFFFFF"

	self.url = googleUrl .. "chf=" .. self:encodeString( self.transparency .. "|" .. self.background ) 
	self.url = self.url .. "&chs=" .. self.width .. "x" .. self.height
	self.url = self.url .. "&cht=" .. self.type 
	self.url = self.url .. "&chco=" .. self:encodeString( self.dataColours ) 
	self.url = self.url .. "&chd=" .. self:encodeString( self.data) 
	self.url = self.url .. "&chdl=" .. self:encodeString( self.legend) 
	self.url = self.url .. "&chdlp=" .. self.legendPosition
	self.url = self.url .. "&chls=" .. self:encodeString( self.dataStyle )
	self.url = self.url .. "&chts=" .. self:encodeString( self.titleColour .. "," .. self.titleFontSize )  
	self.url = self.url .. "&chma=" .. self:encodeString( self.margins[ 1 ] .. "," .. self.margins[ 2 ] .. "," .. self.margins[ 3 ] .. "," .. self.margins[ 4 ] ) 
	self.url = self.url .. "&chtt=" .. self:encodeString( self.title ) 
   
   	if self.axisLabels ~= "" then
   		
   		self.url = self.url .. "&chxt=" .. self.axis
   		self.url = self.url .. "&chxl=" .. encodeString(self.axisLabels) 
   		self.url = self.url .. "&chxp="  .. encodeString(self.axisLabelPositions)
   	
   	else
 
		if self.legendSize then
			self.url = self.url .. "&chl=" .. self:encodeString( self.labels .. "|" .. self.legendSize[ 1 ] .. "," .. self.legendSize[ 2 ] )
		else
			self.url = self.url .. "&chl=" .. self:encodeString( self.labels )
		end
   	
   	end

	self:downloadChart()

end

--- Creates a new QR code. Called internally.
-- @param params The chart params.
function GGChart:newQR( params )

	if not params then
		params = {}
	end

	self.type = "qr"
	self.width = params.width or 200
	self.height = params.height or self.width
	self.data = self:encodeString( params.data or "" )
	self.encoding = params.encoding or "UTF-8"
	self.errorCorrectionLevel = params.errorCorrectionLevel or "L"
	self.margin = params.margin or 4
	self.x = params.x or 0
	self.y = params.y or 0

	self.transparency = params.transparency or "a,s,000000" 
	self.background = params.background or "bg,s,FFFFFF"

	self.url = googleUrl .. "chf=" .. self:encodeString( self.transparency .. "|" .. self.background ) 
	self.url = self.url .. "&chs=" .. self.width .. "x" .. self.height 
	self.url = self.url .. "&cht=" .. self.type 
	self.url = self.url .. "&chld=" .. self:encodeString( self.errorCorrectionLevel .. "|" .. self.margin ) 
	self.url = self.url .. "&chl=" .. self.data 
	self.url = self.url .. "&choe=" .. self.encoding

	self:downloadChart()

end

--- Creates a new pie chart. Called internally.
-- @param params The chart params.
function GGChart:newPie( params )

	if not params then
		params = {}
	end

	self.mode = params.mode or "2d"

	if self.mode == "2d" then
		self.type = "p"
	elseif self.mode == "3d" then
		self.type = "p3"
	elseif self.mode == "concentric" then
		self.type = "pc"
	end	

	self.title = params.title or ""
	self.titleColour = params.titleColour or "000000"
	self.titleFontSize = params.titleFontSize or 11.5
	self.data = params.data or ""
	self.width = params.width or 200
	self.height = params.height or self.width
	self.legend = params.legend or ""
	self.legendPosition = params.legendPosition or "r"
	self.legendSize = params.legendSize
	self.labels = params.labels or ""
	self.radians = params.radians or 1
	self.margins = params.margins or { 0, 0, 0, 0 }
	self.x = params.x or 0
	self.y = params.y or 0
	self.scale = params.scale or { 0, 100 }
	self.dataColours = params.dataColours or "0000FF"

	self.transparency = params.transparency or "a,s,000000" 
	self.background = params.background or "bg,s,FFFFFF"

	self.url = googleUrl .. "chf=" .. self:encodeString( self.transparency .. "|" .. self.background ) 
	self.url = self.url .. "&chs=" .. self.width .. "x" .. self.height
	self.url = self.url .. "&cht=" .. self.type 
	self.url = self.url .. "&chco=" .. self:encodeString( self.dataColours ) 
	self.url = self.url .. "&chds=" .. self:encodeString( self.scale[ 1 ] .. "," .. self.scale[ 2 ] ) 
	self.url = self.url .. "&chd=" .. self:encodeString( self.data ) 
	self.url = self.url .. "&chdl=" .. self:encodeString( self.legend ) 
	self.url = self.url .. "&chdlp=" .. self.legendPosition
	self.url = self.url .. "&chp=" .. self.radians 
	self.url = self.url .. "&chtt=" .. self:encodeString( self.title ) 
	self.url = self.url .. "&chts=" .. self:encodeString( self.titleColour .. "," .. self.titleFontSize ) 
	self.url = self.url .. "&chma=" .. self:encodeString( self.margins[ 1 ] .. "," .. self.margins[ 2 ] .. "," .. self.margins[ 3 ] .. "," .. self.margins[ 4 ] ) 

	if self.legendSize then
		self.url = self.url .. "&chl=" .. self:encodeString( self.labels .. "|" .. self.legendSize[ 1 ] .. "," .. self.legendSize[ 2 ] )
	else
		self.url = self.url .. "&chl=" .. self:encodeString( self.labels )
	end

	self:downloadChart()
	
end

--- Url encodes a string. Called internally.
-- @param str The string to encode.
-- @return The encoded string.
function GGChart:encodeString( str )

	if str then
		str = string.gsub( str, "\n", "\r\n" )
		str = string.gsub( str, "([^%w ])", function (c) return string.format( "%%%02X", string.byte( c ) ) end )
		str = string.gsub( str, " ", "+" )
	end
	
  	return str	
  	
end

--- Downloads this GGChart object. Called internally.
function GGChart:downloadChart()

	local networkListener = function( event )

        if ( event.isError ) then
    		print ( "GGChart Error - Download failed." )
        else
            
        end

	end

	if self.url and self.type then	 

		local download = function()

			local time = os.time()

			self.filename = "chart_" .. self.type .. "_" .. time .. ".png"
			self.path = system.pathForFile( self.filename , system.DocumentsDirectory )

			local file = io.open( self.path, "w+b" ) 

			-- Request remote file and save data to local file
			http.request
			{
				url = self.url, 
				sink = ltn12.sink.file( file ),
			}

			native.setActivityIndicator( false )	

			self.image = display.newImage( self.filename, system.DocumentsDirectory, self.x or 0, self.y or 0 )

		end

		local showActivityIndicator = function()
			native.setActivityIndicator( true )
			timer.performWithDelay(1, download(), 1 )
		end

		showActivityIndicator()
		
	end

end

--- Destroys this GGChart object.
function GGChart:destroy()
	
	display.remove( self.image )
	self.image = nil
	
	-- EFM Modified original destroy code because it was failing.
	-- The file was probably still marked as in use when the remove was attempted.
	local filename = self.filename
	timer.performWithDelay(100, function ()
		print("Removing ", filename )
	
		if filename then
			local result =
				os.remove( system.pathForFile( filename, system.DocumentsDirectory ) )
			if( result ) then
				print("Destroyed file:", filename )
			else
				print("WARNING! Failed to destroy file:", filename )
			end
		end

	end 
	)

	
end

return GGChart