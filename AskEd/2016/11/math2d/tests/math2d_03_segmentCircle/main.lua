--------------------------------------------------------------------------------
-- Copyright (c) 2016 Roaming Gamer, LLC.
--
-- MIT Licensed
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy 
-- of this software and associated documentation files (the "Software"), to deal 
-- in the Software without restriction, including without limitation the rights 
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
-- copies of the Software, and to permit persons to whom the Software is furnished 
-- to do so, subject to the following conditions:
--  
-- The above copyright notice and this permission notice shall be included in all 
-- copies or substantial portions of the Software. 
--  
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL  
-- THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER  
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  
-- SOFTWARE.
--------------------------------------------------------------------------------

local math2d = require "plugin.math2d"

for k,v in pairs( math2d ) do
	print(k,v)
end

local x1,y1,x2,y2 = display.contentCenterX, display.contentCenterY+200, display.contentCenterX, display.contentCenterY-200
x1 = x1 - 150
x2 = x2
local line1 = display.newLine( x1,y1,x2,y2 )
line1.strokeWidth = 2
local p1 = { x = x1, y = y1 }
local p2 = { x = x2, y = y2 }

local circ = display.newCircle( display.contentCenterX, display.contentCenterY, 100 )
circ:setFillColor(0,0,0,0)
circ.strokeWidth = 2

local i1, i2 = math2d.segmentCircleIntersect( { x = p1.x, y = p1.y}, 
	                                              { x = p2.x, y = p2.y}, 
	                                              circ, 
	                                              100 )

if( i1 ) then
	local hit = display.newCircle( i1.x, i1.y, 10 )
	hit:setFillColor(0,1,0)
end

if( i2 ) then
	local hit = display.newCircle( i2.x, i2.y, 10 )
	hit:setFillColor(0,1,0)
end