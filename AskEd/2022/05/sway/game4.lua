-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local common 		= require "common"

local game = {}

-- Locals
local filter = { groupIndex = -1 }
local myTimer
local ballCount = 0

-- Forward Declarations
local showRules
local doGame


-- Useful Localizations
-- SSK
--
local newCircle 		= ssk.display.newCircle
local newRect 			= ssk.display.newRect
local newImageRect 		= ssk.display.newImageRect
local easyIFC   		= ssk.easyIFC
local easyFlyIn			= easyIFC.easyFlyIn
local isInBounds    	= ssk.easyIFC.isInBounds
local persist 			= ssk.persist
local isValid 			= display.isValid

local addVec			= ssk.math2d.add
local subVec			= ssk.math2d.sub
local lenVec			= ssk.math2d.length
local len2Vec			= ssk.math2d.length2
local normVec			= ssk.math2d.normalize
local vector2Angle		= ssk.math2d.vector2Angle
local angle2Vector		= ssk.math2d.angle2Vector
local scaleVec			= ssk.math2d.scale

-- Corona & Lua
--
local mAbs              = math.abs
local mRand             = math.random
local mSqrt             = math.sqrt
local getInfo           = system.getInfo
local getTimer          = system.getTimer
local strMatch          = string.match
local strFormat         = string.format
local pairs             = pairs

-- ===============================================
-- Helpers For This Game
-- ===============================================
local currentObjects 	= {}

local maxIter = 150
local function getSafeXY( params  )
	params = params or {}
	local minX 				= params.minX or left + 100
	local maxX 				= params.maxX or right - 100
	local minY 				= params.minY or top + 200
	local maxY 				= params.maxY or bottom - 200
	local offset        	= 8
	local safeRadius    	= params.safeRadius or 100
	local safeRadius2 		= safeRadius * safeRadius
    
    local tx = mRand( minX, maxX )
    local ty = mRand( minY, maxY)

    local iter = 0
    local isSafe = false    

    while( isSafe == false ) do
        iter = iter + 1
        if( iter > maxIter ) then
            print("Failed Iter Test")
            return nil, nil
        end

        isSafe = true        
        for i = 1, #currentObjects do        	
            local obj = currentObjects[i]
            --print("EDO", #currentObjects, i, tx, ty, obj.x, obj.y )
            local vec = subVec( tx, ty, obj.x, obj.y, true )
            local len2 = len2Vec( vec )
            if( len2 < safeRadius2 ) then
                isSafe = false
                tx = mRand( minX, maxX )
                ty = mRand( minY, maxY )
            end
        end        
    end

    return tx, ty
end

-- ===============================================
-- Standard Game Functions
-- ===============================================
showRules = function( startDelay )
	local tmp = easyIFC:quickLabel( common.layers.content, "Count All Circles", centerX, centerY - 80, gameFont, 60  )
	local function onComplete()
		display.remove(tmp)
		timer.performWithDelay( startDelay, doGame  )
	end

	easyFlyIn( tmp, { delay = 1000, sox = fullw, time = 1000 } )
	transition.to( tmp, { alpha = 0, delay = 3000, time = 500, onComplete = onComplete } )
end

doGame = function( )

	ballCount = 0

	local difficultyMods = {
	 { 3, 5, 1000, 3000 },
	 { 5, 7, 800, 2000 },
	 { 8, 10, 750, 1000 },
	 { 5, 10, 500, 750 },

	}
	local difficultySettings = difficultyMods[common.currentDifficulty]

	local ground = newRect( common.layers.content, centerX, centerY, 
							{ fill = _T_, w = 10000, h = 10000 },
							{ bodyType = "static", filter = filter } )

	local currentForce = 0
	local function setNewForce()
		currentForce = mRand( -100, 100 )
	end
	myTimer = timer.performWithDelay( 150, setNewForce, -1 )



	local function drawFlower( petalCount, x, y )
		local group = display.newGroup()
		common.layers.content:insert( group )
		--currentObjects[#currentObjects+1] = group
		--group.x = x
		--group.y = y

		local flower = newImageRect( group, x, y, "images/circle2.png", 
									{ size = 50, fill = hexcolor("#543a01") },
									{ bodyType = "dynamic", filter = filter } )
		currentObjects[#currentObjects+1] = flower
		flower.petals = {}

		timer.performWithDelay( 1500, 
			function()
				if( flower and flower.applyLinearImpulse )  then
					flower:applyLinearImpulse( 100, 0, flower.x, flower.y ) 
				end
			end )

		-- flower.doFly = function()
		-- 	display.remove(ground)
		-- 	if( flower and flower.applyLinearImpulse )  then
		-- 		flower:applyLinearImpulse( mRand(2500, 3500), 0, flower.x, flower.y ) 
		-- 	end
		-- end
		-- listen("doFly", flower)

		flower.enterFrame = function( self )
			self:applyForce( currentForce, 0, flower.x, flower.y )
		end
		listen("enterFrame", flower)
		local sliceDeg = 360 / petalCount

		for i = 1, petalCount do
			local angle = i * sliceDeg + sliceDeg/2
			local scale = 5
			local petal = newImageRect( group, x, y, "images/petal.png", 
								{ w = 213/scale, h = 300/scale, rotation = angle, angularDamping = 1 },
								{ bodyType = "dynamic", filter = filter } )
			flower.petals[#flower.petals+1] = petal
			local vec = angle2Vector( angle, true )
			vec = scaleVec( vec, 35 )
			petal.x = flower.x + vec.x
			petal.y = flower.y + vec.y
			petal:toBack()
			--transition.to( tmp, { x = vec.x, y = vec.y, delay = delay1, time = time1 })
			--transition.to( tmp, { x = 0, y = 0, delay = delay2, time = time2 })

			local paint1 = { type = "gradient", color1 = hexcolor("#c59801"), color2 = hexcolor("#ecde01"), direction = "up" }
			local paint2 = { type = "image", filename =  "images/petal.png" }
			local paint = { type = "composite", paint1 =  paint2, paint2 = paint1 }
			petal.fill = paint
			petal.fill.effect = "composite.multiply"

			petal.myJoint = physics.newJoint( "weld", flower, petal, flower.x, flower.y )
			--petal.myJoint.dampingRatio = 0
			petal.myJoint.frequency = 20

		end

		local stemGreen = { 0,0.3,0 }

		local stem = newRect( group, x, y, 
							{ anchorY = 0, w = 15, h = fullh, fill = stemGreen, stroke = _K_, strokeWidth = 2 },
							{ bodyType = "dynamic", filter = filter } )

		stem.fill = { type = "gradient", color1 = { 0,0.7,0,1 }, color2 = { 0,0.3,0,1 }, direction = "right" }


		stem.myJoint = physics.newJoint( "weld", flower, stem, flower.x, flower.y )

		stem.myJoint2 = physics.newJoint( "pivot", stem, ground, stem.x, stem.y + stem.contentHeight )
		
		stem.myJoint2.isLimitEnabled = true
		stem.myJoint2:setRotationLimits( -5, 5 )

		stem:toBack()

		local numLeaves = 2-- mRand( 2, 5 )
		local curY 		= y + mRand(100, 175)
		local incrY 	= mRand( 0, 10 )
		local isLeft 	= mRand( 1, 100) > 50
		for i = 1, numLeaves do
			local leaf
			if( isLeft ) then
				local scale = 5
				leaf = newImageRect( group, x-213/7, curY, "images/petal.png", 
							{ w = 213/scale, h = 300/scale, rotation = mRand( -130, -60), fill = stemGreen },
							{ bodyType = "dynamic", filter = filter } )
				local paint1 = { type = "gradient", color1 = { 0,0.7,0,1 }, color2 = { 0,0.3,0,1 }, direction = "up" }
				local paint2 = { type = "image", filename =  "images/petal.png" }
				local paint = { type = "composite", paint1 =  paint2, paint2 = paint1 }
				leaf.fill = paint
				leaf.fill.effect = "composite.multiply"
				leaf.myJoint = physics.newJoint( "weld", stem, leaf, leaf.x, leaf.y )
				--leaf.myJoint.dampingRatio = 0
				leaf.myJoint.frequency = 20
			else
				local scale = 5
				leaf = newImageRect( group, x+213/7, curY, "images/petal.png", 
							{ w = 213/scale, h = 300/scale, rotation = mRand( 60, 130), fill = stemGreen },
							{ bodyType = "dynamic", filter = filter } )
				local paint1 = { type = "gradient", color1 = { 0,0.7,0,1 }, color2 = { 0,0.3,0,1 }, direction = "up" }
				local paint2 = { type = "image", filename =  "images/petal.png" }
				local paint = { type = "composite", paint1 =  paint2, paint2 = paint1 }
				leaf.fill = paint
				leaf.fill.effect = "composite.multiply"
				leaf.myJoint = physics.newJoint( "weld", leaf, stem, leaf.x, leaf.y )
				--leaf.myJoint.dampingRatio = 0
				leaf.myJoint.frequency = 20
			end
			isLeft = not isLeft

			curY = curY + incrY
			leaf:toBack()
		end
		group:toFront()
	end


	local incr = 275
	local minY = top + 100
	local maxY = minY + incr
	for i = 1, mRand(difficultySettings[1],difficultySettings[2]) do
		local tx, ty = getSafeXY( { minY = minY, maxY = maxY } )
		--local tx, ty = getSafeXY()
		if( tx ) then
			local petalCount = mRand(5,6)
			if( petalCount == 6 ) then
				ballCount = ballCount + 1
			end
			drawFlower( petalCount, tx, ty )
		end
		if( i == 4 ) then
			minY = minY + incr
			maxY = maxY + incr
		elseif( i == 8 ) then
			minY = minY + incr
			maxY = maxY + incr
		end
	end

	-- timer.performWithDelay( difficultySettings[4] + ballCount *  difficultySettings[3], 
	-- 	function()
	-- 		post("doFly")
	-- 	end )


	-- timer.performWithDelay( difficultySettings[4] + ballCount *  difficultySettings[3] + 500, 
	-- 	function() 
	-- 		timer.cancel(myTimer)
	-- 		myTimer = nil
	-- 		for k,v in pairs( currentObjects ) do
	-- 			display.remove(v)
	-- 		end
	-- 		local allChoices = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }
	-- 		table.remove( allChoices, ballCount + 1 )
	-- 		table.dump( allChoices )
	-- 		table.shuffle( allChoices )
	-- 		local answers = {} 
	-- 		answers[#answers+1] = allChoices[1]
	-- 		answers[#answers+1] = allChoices[2]
	-- 		answers[#answers+1] = allChoices[3]
	-- 		answers[#answers+1] = ballCount
	-- 		timer.performWithDelay( 1000, function() common.doBallCount( answers, ballCount ) end )
	-- 		print(ballCount)
	-- 		currentObjects = {}
	-- 	end )
	--transition.to( group, { rotation = 360 * 2, delay = delay1, time = time1, transition = easing.outCirc })
	--transition.to( group, { rotation = 0, delay = delay2, time = time2, transition = easing.outCirc, onComplete = onComplete })

	common.layers.content.y = fullh
	transition.to( common.layers.content, { y = 0, delay = 500, time = 500, transition = easing.outCirc })
end

-- ===============================================
-- Exposed Game
-- ===============================================
function game.run( startDelay )
	startDelay = startDelay or 0
	--showRules( common.doCountDown )
	--showRules( startDelay )
	doGame()
end




return game