io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
--require "ssk2.loadSSK"
--_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================

-- =============================================================
-- Localizations
-- =============================================================
local getTimer = system.getTimer; local mRand = math.random; local mAbs = math.abs
-- NO SSK (-10 lines)
--local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
--local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
--local quickLayers = ssk.display.quickLayers
--local easyIFC = ssk.easyIFC;local persist = ssk.persist
--local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
--local normRot = math.normRot;local easyAlert = ssk.misc.easyAlert
--local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
--local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
--local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
--local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale
-- but then ...
-- NO SSK (+1 line)
local newImageRect = display.newImageRect;local newRect = display.newRect

-- NO SSK(+22 lines)
-- I simply refuse to use longhand Runtime:* calls
local isValid = function ( obj ) 
	return ( obj and obj.removeSelf and type(obj.removeSelf) == "function" )
end
local listen = function( name, listener ) 
	Runtime:addEventListener( name, listener ) 
end
local autoIgnore = function( name, obj ) 
   if( not isValid( obj ) ) then
      ignore( name, obj )
      obj[name] = nil
      return true
   end
   return false 
end
local post = function( name, params )
   params = params or {}
   local event = {}
   for k,v in pairs( params ) do event[k] = v end
   if( not event.time ) then event.time = getTimer() end
   event.name = name
   Runtime:dispatchEvent( event )
end

-- =============================================================
-- The Game (line count starts here)
-- =============================================================
local physics = require "physics"
physics.start()
physics.setGravity(0,20)
--physics.setDrawMode("hybrid")

-- NO SSK ( 8 additional lines )
local centerX  = display.contentCenterX
local centerY  = display.contentCenterY
local fullw  	= display.actualContentWidth
local fullh  	= display.actualContentHeight
local left   	= centerX - fullw/2
local right  	= centerX + fullw/2
local top    	= centerY - fullh/2
local bottom 	= centerY + fullh/2
--
local gameIsRunning = true
local horizSpeed    = 200
local jumpSpeed 	  = 650
local cameraOffset  = 25
local objects		  = {}
local pickupCount   = 0
local distance      = 0
--
-- SSK (1 line) local layers = ssk.display.quickLayers( sceneGroup,  "underlay",  "world", {  "background",  "content",  "foreground" }, "overlay" )
-- - versus - 
-- NO SSK equivalent ( 11 lines and a weird function )
function display.newGroup2( insertInto )
	local group = display.newGroup()
	if( insertInto ) then insertInto:insert( group ) end
	return group
end
local layers = display.newGroup2()
layers.underlay = display.newGroup2( layers )
layers.world = display.newGroup2( layers )
layers.background = display.newGroup2( layers.world )
layers.content = display.newGroup2( layers.world )
-- layers.foreground not used so skipped.
layers.overlay = display.newGroup2( layers )

--
-- SSK (1 line) ssk.easyInputs.twoTouch.create(layers.underlay, { debugEn = true, keyboardEn = true } )
-- - versus - 
-- NO SSK (*19 lines)
--
-- * It would cost another 20+ lines of code to add visual debug responses to the touch pads and keyboard support, but
-- I didn't want to do it ...
--
local function onTouch( self, event )
	event.name = self.eventName 
	Runtime:dispatchEvent( event ) 
	return false
end
local leftTouch = newImageRect( layers.underlay, "fillT.png", fullw/2, fullh )
leftTouch.anchorX = 0
leftTouch.x = left
leftTouch.y = centerY
leftTouch.eventName = "onTwoTouchLeft"
leftTouch.touch = onTouch
leftTouch:addEventListener("touch")
local rightTouch = newImageRect( layers.underlay, "fillT.png", fullw/2, fullh )
rightTouch.anchorX = 1
rightTouch.x = right
rightTouch.y = centerY
rightTouch.eventName = "onTwoTouchRight"
rightTouch.touch = onTouch
rightTouch:addEventListener("touch")
--
-- SSK (1 line) local player = newImageRect( layers.content, centerX, centerY + 100, "player.png", { w = 66, h = 92, fill = _W_, moveLeft = 0, moveRight = 0 }, { isFixedRotation = true, bounce = 0.1 } )
-- - versus - 
-- NO SSK (7 lines)
local player = newImageRect( layers.content, "player.png", 66, 92 )
player.x = centerX
player.y = centerY + 100
player.moveLeft = 0
player.moveRight = 0
physics.addBody( player, "dynamic", { bounce = 0.1 } )
player.isFixedRotation = true

--
-- SSK (1 line) local wrapProxy = newImageRect( layers.background, player.x, player.y, "fillT.png", { w = fullw + 60, h = fullh  } )
-- - versus - 
-- NO SSK (3 lines)
local wrapProxy = newImageRect( layers.background, "fillT.png", fullw + 60, fullh )
wrapProxy.x = player.x
wrapProxy.y = player.y

--
-- SSK (1 line) scoreBack = newRect( layers.overlay, centerX, top + 30, { w = 300, h = 60, fill = _DARKGREY_ } )
-- - versus - 
-- NO SSK (2 lines)
scoreBack = newRect( layers.overlay, centerX, top + 30, 300, 60 )
scoreBack:setFillColor( 0.125, 0.125, 0.125 )


-- SSK (1 line) local scoreLabel = easyIFC:quickLabel( layers.overlay, 0, scoreBack.x, scoreBack.y, "Oxygen-Bold.ttf", 36, _Y_ )
-- - versus - 
-- NO SSK (2 lines)
local scoreLabel = display.newText( layers.overlay, 0, scoreBack.x, scoreBack.y, "Oxygen-Bold.ttf", 36 )
scoreLabel:setFillColor(1,1,0)

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
			--nextFrame(
			timer.performWithDelay( 1,
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
			--nextFrame( function() other.fill = { type = "image", filename = "springboardUp.png" } end, 50 )
			timer.performWithDelay( 50,  function() other.fill = { type = "image", filename = "springboardUp.png" } end )
		
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
		-- SSK (1 line) obj = newImageRect( layers.background, x, y, "platform.png", { w = 210, h = 70, anchorY = 0, fill = _G_, isPlatform = true }, { bodyType = "static", bounce = 0 } )	
		-- - versus - 
		-- NO SSK (7 lines)
		obj = newImageRect( layers.background, "platform.png", 210, 70 )
		obj.x = x
		obj.y = y
		obj:setFillColor(0,1,0)
		obj.isPlatform = true
		obj.anchorY = 0
		physics.addBody( obj, "static", { bounce = 0 } )
		lastX = x
		lastY = y

	elseif( objectType == "spring" ) then
		-- SSK (1 line) obj = newImageRect( layers.background, x + mRand(-40, 40), y, "springboardDown.png", { size = 70, anchorY = 1, isSpring = true },  { bodyType = "static", bounce = 0, shape = {-35, 0, 35, 0, 35, 35, -35, 35 } } )
		-- - versus - 
		-- NO SSK (6 lines)
		obj = newImageRect( layers.background, "springboardDown.png", 70, 70 )
		obj.x = x + mRand(-40, 40)
		obj.y = y
		obj.isSpring = true
		obj.anchorY = 1
		physics.addBody( obj, "static", { bounce = 0, shape = {-35, 0, 35, 0, 35, 35, -35, 35 } } )
	
	elseif( objectType == "pickup" ) then
		-- SSK (1 line) obj = newImageRect( layers.background, x + mRand(-40, 40), y, "coinGold.png",  { size = 70, h = 70, anchorY = 1, isPickup = true },  { bodyType = "static", radius = 20, isSensor = true } )	
		-- - versus - 
		-- NO SSK (7 lines)
		obj = newImageRect( layers.background, "coinGold.png", 70, 70 )
		obj.x = x + mRand(-40, 40)
		obj.y = y
		obj.isPickup = true
		obj.anchorY = 1
		physics.addBody( obj, "static", { bounce = 0 } )
		obj.isSensor = true
	
	elseif( objectType == "danger" ) then
		-- SSK (1 line) obj = newImageRect( layers.background, x + mRand(-40, 40), y, "spikes.png",  { size = 70, anchorY = 1, isDanger = true },  { bodyType = "static", bounce = 0, isSensor = true, shape = {-35, 0, 35, 0, 35, 35, -35, 35 } } )
		-- - versus - 
		-- NO SSK (7 lines)
		obj = newImageRect( layers.background, "spikes.png", 70, 70 )
		obj.x = x + mRand(-40, 40)
		obj.y = y
		obj.isDanger = true
		obj.anchorY = 1
		physics.addBody( obj, "static", { bounce = 0, shape = {-35, 0, 35, 0, 35, 35, -35, 35 } } )
		obj.isSensor = true
		
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

		--local dist = round(self.minY - self.y)	
		local dist = math.round(self.minY - self.y)	-- same result for base case, but not same as SSK version
		if( dist > distance ) then 
			distance = dist 
			scoreLabel:update()
		end
		--
		wrapProxy.y = self.y
		-- SSK (1 line ) ssk.actions.scene.rectWrap( self, wrapProxy )
		-- versus
		-- NO SSK ( 14 lines )
		local right = wrapProxy.x + wrapProxy.contentWidth / 2
		local left  = wrapProxy.x - wrapProxy.contentWidth / 2
		local top = wrapProxy.y - wrapProxy.contentHeight / 2
		local bot  = wrapProxy.y + wrapProxy.contentHeight / 2
		if(self.x >= right) then
			self.x = left + self.x - right
		elseif(self.x <= left) then 
			self.x = right + self.x - left
		end
		if(self.y >= bot) then
			self.y = top + self.y - bot
		elseif(self.y <= top) then 
			self.y = bot + self.y - top
		end


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
