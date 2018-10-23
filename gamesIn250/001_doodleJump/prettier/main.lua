io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================

-- =============================================================
-- Localizations
-- =============================================================
local getTimer = system.getTimer; local mRand = math.random; local mAbs = math.abs
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers
local easyIFC = ssk.easyIFC;local persist = ssk.persist
local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
local normRot = math.normRot;local easyAlert = ssk.misc.easyAlert
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale

-- =============================================================
-- The Game (line count starts here)
-- =============================================================
local physics = require "physics"
physics.start()
physics.setGravity(0,20)
--physics.setDrawMode("hybrid")
--
local gameIsRunning = true
local horizSpeed    = 200
local jumpSpeed 	  = 650
local cameraOffset  = 25
local objects		  = {}
local pickupCount   = 0
local distance      = 0
--
local layers = ssk.display.quickLayers( sceneGroup,  "underlay",  "world", {  "background",  "content",  "foreground" }, "overlay" )
--
ssk.easyInputs.twoTouch.create(layers.underlay, { debugEn = true, keyboardEn = true } )
--
local player = newImageRect( layers.content, centerX, centerY + 100, "player.png", { w = 66, h = 92, fill = _W_, moveLeft = 0, moveRight = 0 }, { isFixedRotation = true, bounce = 0.1 } )
--
local wrapProxy = newImageRect( layers.background, player.x, player.y, "fillT.png", { w = fullw + 60, h = fullh  } )

--
local scoreBack = newRect( layers.overlay, centerX, top + 30, { w = 300, h = 60, fill = _DARKGREY_ } )
local scoreLabel = easyIFC:quickLabel( layers.overlay, 0, scoreBack.x, scoreBack.y, "Oxygen-Bold.ttf", 36, _Y_ )
function scoreLabel:update()
	self.text = pickupCount + distance
end
--
function player.preCollision( self, event )
	local contact 		= event.contact
	local other 		= event.other
	if( other.isDanger or other.isPickup ) then
		-- skip
	elseif( contact and contact.isEnabled ) then
		if( (self.y - other.y) > -(self.contentHeight/2 + other.contentHeight/2 - 1) ) then
			contact.isEnabled = false
			--other:setFillColor(unpack(_P_))
			--nextFrame( function() other:setFillColor(unpack(_G_)) end, 250 )
		end
	end	
	return false
end; player:addEventListener("preCollision")
--
function player.collision( self, event )
	local other 		= event.other
	if( event.phase == "began" ) then
		local vx, vy = self:getLinearVelocity()
		if( other.isDanger ) then
			gameIsRunning = false
			self:removeEventListener("preCollision")
			self:removeEventListener("collision")
			scoreLabel:setFillColor(1,0,0)
			nextFrame(
				function()
					self.isSensor = true
					self:applyAngularImpulse( mRand( -360, 360 ) )
				end )
		
		elseif( other.isPickup ) then
			pickupCount = pickupCount + 100
			scoreLabel:update()
			display.remove(other)
		
		elseif( other.isSpring and not other.open and vy > 0 ) then
			self:setLinearVelocity( vx, -jumpSpeed * 1.25 )
			other.open = true
			--transition.to( other, { yScale = 1, time = 100, delay = 1 } )
			nextFrame( function() other.fill = { type = "image", filename = "springboardUp.png" } end, 50 )
		
		elseif( other.isPlatform and vy > 0 ) then
			self:setLinearVelocity( vx, -jumpSpeed  )
		end
	end
	return false
end; player:addEventListener("collision")
--
local lastY
local lastX
local function createGameObject( x, y, objectType )
	x = x or lastX
	y = y or lastY
	if( not gameIsRunning ) then return nil end
	local obj
	if( objectType == "platform" ) then
		obj = newImageRect( layers.background, x, y, "platform.png",
			            { w = 210, h = 70, anchorY = 0, fill = _G_, isPlatform = true }, 
			            { bodyType = "static", bounce = 0 } )	
		lastX = x
		lastY = y

	elseif( objectType == "spring" ) then
		obj = newImageRect( layers.background, x + mRand(-40, 40), y, "springboardDown.png",
			            { size = 70, anchorY = 1, isSpring = true }, 
			            { bodyType = "static", bounce = 0, shape = {-35, 0, 35, 0, 35, 35, -35, 35 } } )
	
	elseif( objectType == "pickup" ) then
		obj = newImageRect( layers.background, x + mRand(-40, 40), y, "coinGold.png",
			            { size = 70, h = 70, anchorY = 1, isPickup = true }, 
			            { bodyType = "static", radius = 20, isSensor = true } )	
	
	elseif( objectType == "danger" ) then
		obj = newImageRect( layers.background, x + mRand(-40, 40), y, "spikes.png", 
			            { size = 70, anchorY = 1, isDanger = true }, 
			            { bodyType = "static", bounce = 0, isSensor = true, shape = {-35, 0, 35, 0, 35, 35, -35, 35 } } )
		
	end
	--
	function obj.finalize( self )
		objects[self] = nil
	end

end
local function levelGen( noItems )
	while lastY > (player.y - fullh * 0.75) do
		createGameObject( centerX + mRand( -200, 200 ) , lastY - mRand( 100, 300 ), "platform" )		

		-- Generate other item too?
		if( not noItems and mRand( 1, 100 ) > 20 ) then
			local items = { "danger", "pickup", "pickup", "spring", "spring", "spring"  }
			createGameObject( nil, nil, items[mRand(1,#items)] )
		end
	end
end
--
function player.enterFrame( self )	
	if( not autoIgnore( "enterFrame", self ) ) then 
		self.minY = self.minY or self.y
		self.lastY = self.lastY or self.y

		if( self.y < self.lastY ) then
			layers.world.y = layers.world.y + (self.lastY - self.y) 
			self.lastY = self.y
			levelGen()
		end

		local dist = round(self.minY - self.y)	
		if( dist > distance ) then 
			distance = dist 
			scoreLabel:update()
		end
		--
		wrapProxy.y = player.y
		ssk.actions.scene.rectWrap( self, wrapProxy )
		--
		local vx, vy = self:getLinearVelocity()
		vx = 0
		vx = vx - self.moveLeft * horizSpeed
		vx = vx + self.moveRight * horizSpeed
		self:setLinearVelocity( vx, vy )
	end
	return false
end; listen("enterFrame",player)
-- 
function player.onTwoTouchLeft( self, event )
	if( event.phase == "began" ) then
		self.moveLeft = 1
	elseif( event.phase == "ended" ) then
	self.moveLeft = 0
	end
end; listen( "onTwoTouchLeft", player )
--
function player.onTwoTouchRight( self, event )
	if( event.phase == "began" ) then
		self.moveRight = 1
	elseif( event.phase == "ended" ) then
	self.moveRight = 0
	end
end; listen( "onTwoTouchRight", player )
--
createGameObject( player.x, player.y + 100, "platform" )
levelGen(true)
