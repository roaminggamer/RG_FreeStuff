-- =============================================================
-- Your Copyright Statement Goes Here
-- =============================================================
--  main.lua
-- =============================================================
-- https://gumroad.com/l/eatlean
-- =============================================================

-- Ensure messages are displayed immediately instead of buffering.
io.output():setvbuf("no")

-- Turn off the status bar on devices that supply one.
-- Most games and aps do this, so it is a defalt for EAT output.
display.setStatusBar(display.HiddenStatusBar)


local onTouch = function( self, event )
	if( event.phase == "began" ) then
		self:setFillColor(1,0,0)
	elseif( event.phase == "ended" ) then
		self:setFillColor(1,1,1)
	end
end

local cx = display.contentCenterX
local cy = display.contentCenterY
local mask = graphics.newMask( "grass_mask.png" )

local function addTouchToObject( obj )
	obj:setMask( mask )
	obj.maskScaleY = 150/142
	obj.maskScaleX = 180/174
	obj.touch = onTouch
	obj:addEventListener( "touch" )
	obj.isHitTestMasked = true
end

local function newTile( x, y )
	local tmp = display.newImageRect( "grass_tile.png", 180, 150 )
	tmp.x = x
	tmp.y = y
	addTouchToObject( tmp )
	return tmp
end



--- ==============================
local tmp = newTile( cx, cy - 150 )
local tmp = newTile( cx - 180/2, cy - 150/2 )
local tmp = newTile( cx + 180/2, cy - 150/2 )
local tmp = newTile( cx, cy )

