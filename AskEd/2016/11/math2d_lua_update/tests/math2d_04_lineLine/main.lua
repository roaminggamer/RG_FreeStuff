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
local math2d = require "math2d"


local x1,y1,x2,y2 = display.contentCenterX, display.contentCenterY-200, display.contentCenterX, display.contentCenterY+200
local line1 = display.newLine( x1,y1,x2,y2 )
line1.strokeWidth = 2
local x3,y3,x4,y4 = display.contentCenterX-200, display.contentCenterY, display.contentCenterX + 200, display.contentCenterY
local line2 = display.newLine( x3,y3,x4,y4 )
line2.strokeWidth = 2

local period = 60
local deltaAngle = 5
local startAngle = 0
local endAngle = 360
local angle = startAngle
local marker


local function testLineIntersect()
	angle = angle + deltaAngle
	display.remove(line2)
	display.remove(marker)

	--print(angle)
	if( angle > endAngle ) then 		
		return
	end
	local vec = math2d.angle2Vector( angle, true )
	vec = math2d.scale( vec, 250 )
	vec.x = vec.x + x3
	vec.y = vec.y + y3
	line2 = display.newLine( x3, y3, vec.x, vec.y )
	line2.strokeWidth = 2
	local intersect = math2d.lineLineIntersect( x3,y3,vec.x,vec.y, x1,y1,x2,y2 )
	if( intersect ) then 
		marker = display.newCircle( intersect.x, intersect.y, 10, true, true )
		marker:setFillColor(0,1,0)
	end

	timer.performWithDelay( period, testLineIntersect )
end
timer.performWithDelay( period, testLineIntersect )