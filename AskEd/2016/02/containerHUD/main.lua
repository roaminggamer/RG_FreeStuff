-- =============================================================
-- Ask Ed 2016
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2016 (http://roaminggamer.com/)
-- =============================================================

local function newHUD( x, y, w, h )
	local hud = display.newGroup()
	local container = display.newContainer( hud, w, h )
	local bar = display.newImageRect( container, "bar.png", w, h )
	local overlay = display.newImageRect( hud, "overlay.png", w + 20, h + 10 )
	hud.x = x
	hud.y = y

	hud.percent = 100	

	function hud.setPercent( self, percent )
		self.percent = percent
		if( self.percent < 0 ) then
			self.percent = 0
		elseif( self.percent > 100 ) then
			self.percent = 100
		end

		local mult = (100-percent)/100
		local increment = (w/100)
		bar.x = -mult * w
	end

	function hud.getPercent( self, percent )
		return self.percent
	end
	return hud	
end

-- More likely what you want
local function newHUD2( x, y, w, h  )
	local hud = display.newGroup()
	local container = display.newContainer( hud, w, h )
	local bar = display.newImageRect( container, "bar.png", w, h )
	local overlay = display.newImageRect( hud, "overlay.png", w + 20, h + 10 )
	hud.x = x
	hud.y = y
	hud.percent = 100	

	function hud.setPercent( self, percent )
		self.percent = percent
		if( self.percent < 0 ) then
			self.percent = 0
		elseif( self.percent > 100 ) then
			self.percent = 100
		end
		
		local mult = (100-percent)/100
		local increment = (w/100)
		container.x = -mult * w
		bar.x =  -container.x
	end

	function hud.getPercent( self, percent )
		return self.percent
	end
	return hud	
end



local test1 = newHUD( display.contentCenterX, display.contentCenterY - 90, 400, 22 )
local test2 = newHUD2( display.contentCenterX, display.contentCenterY - 60, 400, 22 )

local test3 = newHUD( display.contentCenterX, display.contentCenterY - 30, 400, 22 )
local test4 = newHUD2( display.contentCenterX, display.contentCenterY, 400, 22 )

local test5 = newHUD( display.contentCenterX, display.contentCenterY + 30, 400, 22 )
local test6 = newHUD2( display.contentCenterX, display.contentCenterY + 60, 400, 22 )

local test7 = newHUD( display.contentCenterX, display.contentCenterY + 90, 400, 22 )
local test8 = newHUD2( display.contentCenterX, display.contentCenterY + 120, 400, 22 )

display.newLine( display.contentCenterX, 0, display.contentCenterX, display.contentHeight)
display.newLine( display.contentCenterX-100, 0, display.contentCenterX-100, display.contentHeight)
display.newLine( display.contentCenterX+100, 0, display.contentCenterX+100, display.contentHeight)

test1:setPercent( 75 )
test2:setPercent( 75 )

test3:setPercent( 25 )
test4:setPercent( 25 )
test4:setPercent( 100 )
test4:setPercent( 25 )

test5:setPercent( 150 )
test6:setPercent( 150 )


local up
local down
local percent = 100
local time = 30

up = function()
	percent = percent + 1
	if( percent >= 100 ) then
		timer.performWithDelay( time, down )
	else
		timer.performWithDelay( time, up )
	end
	print("up ", percent, system.getTimer())
end

down = function()
	percent = percent - 1
	if( percent > 0 ) then
		timer.performWithDelay( time, down )
	else
		timer.performWithDelay( time, up )
	end	
	print("down ", percent, system.getTimer())
end

local function enterFrame()
	test7:setPercent( percent )
	test8:setPercent( percent )
end
Runtime:addEventListener( "enterFrame", enterFrame )

down()