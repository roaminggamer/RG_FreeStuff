-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"This is probably my favorite question of the month and I'm not alone", 
	"because it was asked in similar forms 3 times.",
	"",
	"Now, I could be wrong, but this seemed like a bunch of users taking a",
	"class and looking for someone else to do the work (or get them started)."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


-- Load SSK
--require "ssk.loadSSK"

-- Forward Declarations
-- SSK 
local angle2Vector      = ssk.math2d.angle2Vector
local vector2Angle      = ssk.math2d.vector2Angle
local scaleVec          = ssk.math2d.scale
local addVec            = ssk.math2d.add
local subVec            = ssk.math2d.sub
local normVec           = ssk.math2d.normalize
local getNormals        = ssk.math2d.normals
local vecLen            = ssk.math2d.length
local vecLen2           = ssk.math2d.length2
-- Lua and Corona 
local mAbs              = math.abs
local mRand             = math.random
local getInfo           = system.getInfo
local getTimer          = system.getTimer
local strMatch          = string.match
local strFormat         = string.format
--
-- A place to store our 'arrows'
local arrows = {}
local spawnTimer
local sceneChange
local spawnArrow

-- 
-- No, it doesn't really change scenes, but one could add scene changing 
-- to a function like this.  
sceneChange = function( self )
	if( self.removeSelf == nil ) then return end
	timer.cancel( spawnTimer )
	for k,v in pairs( arrows ) do
		display.remove(v)
	end
	arrows = {}
	spawnTimer = timer.performWithDelay( 150, spawnArrow, -1 )
end

--
-- Target
local tmp = display.newCircle( centerX, centerY, 20 )
tmp:setFillColor(1,0,1)

-- Spawn arrows off edge of screen and move to center
--
spawnArrow =  function()
	local buffer 	= 50
	local size 		= 40
	local x, y

	local from = math.random(1,4)

	if( from == 1 ) then
		-- left
		x = left - buffer
		y = math.random( top - buffer, bottom + buffer )

	elseif( from == 2 ) then
		-- right
		x = right + buffer
		y = math.random( top - buffer, bottom + buffer )

	elseif( from == 3 ) then
		-- top
		x = math.random( left - buffer, right + buffer )
		y = top - buffer

	else
		-- bottom
		x = math.random( left - buffer, right + buffer )
		y = bottom + buffer
	end

	local vec = subVec( x , y, centerX, centerY, true )
	local rotation = vector2Angle( vec )
	local len = vecLen(vec)
	local speed = math.random( 50, 200 )
	local time = 1000 * len / speed

	local tmp = display.newImageRect( "up.png", size, size )
	tmp.x = x
	tmp.y = y
	tmp.rotation = rotation
	tmp.onComplete = sceneChange
	transition.to( tmp, { x = centerX, y = centerY, time = time , onComplete = tmp } )

	arrows[tmp] = tmp
end

spawnTimer = timer.performWithDelay( 150, spawnArrow, -1 )

