-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- main.lua
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init( )

local group = display.newGroup()


-- Standard lines
--
for i = 1, 10 do
	local tmp = display.newLine( group, 
											50, 100 + i * 10, 
		                        	100, 100 + i * 10 )
end

-- Standard Lines strokeWidth = 2
--
for i = 1, 10 do
	local tmp = display.newLine( group, 
											150, 100 + i * 10, 
		                        	200, 100 + i * 10 )
	tmp.strokeWidth = 2
end

-- Standard lines
--
for i = 1, 10 do
	local tmp = display.newLine( group, 
											250, 100 + i * 10, 
		                        	300, 100 + i * 10 )
	tmp.fill = { type = "image", filename = "fillW.png" }
end

-- Standard Lines strokeWidth = 2
--
for i = 1, 10 do
	local tmp = display.newLine( group, 
											350, 100 + i * 10, 
		                        	400, 100 + i * 10 )
	tmp.strokeWidth = 2
	tmp.fill = { type = "image", filename = "fillW.png" }
end


-- ImageRect Instead
--
function display.newHorizLine( x0, y0, x1, y1, thickness )
	thickness = thickness or 1
	local tmp = display.newImageRect( "fillW.png", math.abs(x1-x0), thickness )
	if( x0 < x1 ) then
		tmp.x = x0
		tmp.y = y0
		tmp.anchorX = 0
	else
		tmp.x = x1
		tmp.y = y0
		tmp.anchorX = 1
	end
	return tmp
end
for i = 1, 10 do
	local tmp = display.newHorizLine( 450, 100 + i * 10,  500, 100 + i * 10, 1 )
	group:insert(tmp)
	tmp:setFillColor(1,0,0)
end



transition.to( group, { y = 500, time = 10000 } )