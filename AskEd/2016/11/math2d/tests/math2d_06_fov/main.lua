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

local circ = display.newCircle( display.contentCenterX, display.contentCenterY - 100, 20 )
local rect = display.newRect( display.contentCenterX, display.contentCenterY, 40, 40  )

local angle = 0
local t = system.getTimer()
local speed = 45 -- degrees per second
local speed2 = -45 -- degrees per second
local fov = 120
local offsetAngle = 0

local rotateFOV = false

local function enterFrame()
		local curT = system.getTimer()
		local dt = curT - t
		t = curT

		-- Rotate Rectangle or FOV and redraw Lines	
		if( rotateFOV ) then
			offsetAngle = offsetAngle + speed2 * (dt/1000)
		else
			rect.rotation = rect.rotation + speed2 * (dt/1000)
		end
		
		display.remove( rect.line1 )
		display.remove( rect.line2 )
		display.remove( rect.line3 )
		local v = math2d.angle2Vector( rect.rotation - fov/2 + offsetAngle, true )
		v = math2d.scale( v, 300 )
		v.x = v.x + rect.x
		v.y = v.y + rect.y
		rect.line1 = display.newLine( rect.x, rect.y, v.x, v.y )
		rect.line1.strokeWidth = 2

		local v = math2d.angle2Vector( rect.rotation + fov/2 + offsetAngle, true )
		v = math2d.scale( v, 300 )
		v.x = v.x + rect.x
		v.y = v.y + rect.y
		rect.line2 = display.newLine( rect.x, rect.y, v.x, v.y )
		rect.line2.strokeWidth = 2

		local v = math2d.angle2Vector( rect.rotation + offsetAngle, true )
		v = math2d.scale( v, 300 )
		v.x = v.x + rect.x
		v.y = v.y + rect.y
		rect.line3 = display.newLine( rect.x, rect.y, v.x, v.y )
		rect.line3.strokeWidth = 2
		rect.line3:setStrokeColor(0,1,1)
		rect:toFront()

		-- Circle
		angle = angle + speed * (dt/1000)
		math2d.rotateAbout( circ, rect, angle, 150 )
		if( math2d.inFOV( circ, rect, fov, offsetAngle ) ) then
			circ:setFillColor(0,1,0) 
		else
			circ:setFillColor(1,0,0) 
		end
end
Runtime:addEventListener( "enterFrame" , enterFrame )