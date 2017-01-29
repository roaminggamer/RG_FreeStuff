-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
--  main.lua
-- =============================================================
-- Start (code/comments)
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
-- LOAD & INITIALIZE - SSK 2
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init()
_G.ssk.init( {} )

--
-- Super Basic Gold Miner
--
local hook
local background
local minRot = 110
local maxRot = 250
local rotRate = -60 -- degrees per second
local outSpeed = 300 -- pixels per second
local inSpeed = 300 -- pixels per second
local snapDist = 10

local lastT = system.getTimer()

local doNothing
local waitingToFire
local hookMovingOut
local retrievingHook

local objects = {}

doNothing =  function( self )
	lastT = system.getTimer()
end

waitingToFire = function( self, event )
	local curT = system.getTimer()
	local dt = curT - lastT
	lastT = curT
	self.rotation = self.rotation + rotRate * dt/1000 
	
	if( self.rotation < minRot )	 then
		rotRate = -rotRate
	elseif( self.rotation > maxRot ) then
		rotRate = -rotRate
	end
end

hookMovingOut = function( self )
	local curT = system.getTimer()
	local dt = curT - lastT
	lastT = curT

	local vec = ssk.math2d.angle2Vector( self.rotation, true )
	vec = ssk.math2d.scale(vec, outSpeed * dt/1000 )
	self.x = self.x + vec.x
	self.y = self.y + vec.y

	display.remove( self.line )

	self.line  = display.newLine( self.x, self.y, self.x0, self.y0)

	self:toFront()

	-- Hit Something?
	for k, v in pairs( objects ) do
		if( ssk.easyIFC.isInBounds( self, v ) ) then
			self.dragObj = v
			self.enterFrame = retrievingHook
			return
		end
	end

	-- Out Of Bounds
	if( not ssk.easyIFC.isInBounds( self, background ) ) then
		self.enterFrame = retrievingHook
	end


end

retrievingHook = function( self )

	local curT = system.getTimer()
	local dt = curT - lastT
	lastT = curT

	local vec = ssk.math2d.angle2Vector( self.rotation, true )
	vec = ssk.math2d.scale(vec, inSpeed * dt/1000 )
	self.x = self.x - vec.x
	self.y = self.y - vec.y

	display.remove( self.line )

	self.line  = display.newLine( self.x, self.y, self.x0, self.y0)

	-- Dragging something?
	if( self.dragObj ) then
		self.dragObj.x = self.dragObj.x - vec.x
		self.dragObj.y = self.dragObj.y - vec.y
	end

	-- Back Home?
	local vec = ssk.math2d.sub( self.x, self.y, self.x0, self.y0, true )
	local len = ssk.math2d.length( vec )
	if( len < snapDist ) then
		self.x = self.x0
		self.y = self.y0

		if( self.dragObj ) then
			objects[self.dragObj] = nil

			display.remove( self.dragObj )		
			self.dragObj = nil
		end

		display.remove( self.line )

		self.enterFrame = waitingToFire
	end

	self:toFront()
end

local function onTouch( self, event )
	if( event.phase ~= "ended" ) then return true end
	if( hook.enterFrame == waitingToFire ) then
		hook.enterFrame = hookMovingOut
	end
end

background = ssk.display.newRect( nil, centerX, centerY, 
	                                 	{ w = fullw, h = fullh, fill = hexcolor('#76472b'),
	                                 	  touch = onTouch })

local miner = ssk.display.newImageRect( nil, centerX, top + 80, "images/kenney3.png", { size = 100 } )


hook = ssk.display.newImageRect( nil, miner.x, miner.y + 50, "images/arrow.png", 
	 											{ rotation = 180, size = 30, enterFrame = doNothing } )
hook.x0 = hook.x
hook.y0 = hook.y

hook.enterFrame = waitingToFire



for i = 1, 9 do
	local obj = ssk.display.newImageRect( nil, 75 + (i-1) * 100, bottom - 100, "images/coin.png", 
		 											{ size = math.random( 50, 80 ) } )
	objects[obj] = obj
end