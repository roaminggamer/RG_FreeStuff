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

local observer = display.newImageRect( "arrow.png", 50, 50)
observer.x = display.contentCenterX
observer.y = display.contentCenterY


local circles = {}
circles[#circles+1] = display.newCircle( observer.x - 150, observer.y, 20 )
circles[#circles+1] = display.newCircle( observer.x + 150, observer.y, 20 )
circles[#circles+1] = display.newCircle( observer.x, observer.y - 150, 20 )
circles[#circles+1] = display.newCircle( observer.x, observer.y + 150, 20 )

local period = 2000

observer.rotation = -15
local function testInFBLR()
	observer.rotation = observer.rotation + 15

	for i = 1, #circles do
		local color = { 0,0,0 }
		
		local hit = false
		if( math2d.isToLeft( circles[i], observer ) ) then
			hit = true
			color[1] = 1
		end
		if( math2d.isToRight( circles[i], observer ) ) then
			hit = true
			color[2] = 1
		end
		if( math2d.isInFront( circles[i], observer ) ) then
			hit = true
			color[3] = 1
		end
		if( hit ) then
			circles[i]:setFillColor( unpack(color))
		else
			circles[i]:setFillColor( 0.25, 0.25, 0.25 )
		end
	end

	timer.performWithDelay( period, testInFBLR )
end
testInFBLR()
timer.performWithDelay( period, testInFBLR )
