-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- Template #2
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
-- 
-- =============================================================

--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

local sprite = require "sprite"

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------

-- Variables
local layers -- Local reference to display layers 

local rowsCols      = 16  
local numSprites    = rowsCols^2
local assumedFPS    = 30
local useOld        = false
local loops         = 10

local frames        = 8
local time          = 500
local timeTolerance = 100 --  +/- 100 ms

local transitionTime = 0

local uma
local spriteSet

local startTime = 0
local endTime   = 0
local totalTime = 0

local counts = {}
counts.old = {}
counts.new = {}

local expected = { }
expected.old = {}
expected.new = {}


local theSprites = {}
local eventCount = 0

local actualSpriteWidth  = 219
local actualSpriteHeight = 155
local targetSpriteWidth  = 60
local targetSpriteHeight = 40
local halfWidth           = targetSpriteWidth/2
local halfHeight         = targetSpriteHeight/2

local spriteScaleX = targetSpriteWidth/actualSpriteWidth
local spriteScaleY = targetSpriteHeight/actualSpriteHeight

local umaSheet
local spriteOptions

local createHorseSprite
local spriteCB

-- Local Function & Callback Declarations
local createCollisionCalculator
local createLayers
local addInterfaceElements
local verifyCounts
local initCounts
local initSprites
local placeSprites

local gameLogic = {}

-- =======================
-- ====================== Initialization
-- =======================
function gameLogic:createScene( screenGroup )

	-- 1. Set up any rendering layers we need
	createLayers( screenGroup )

	initCounts()

	initSprites()

	placeSprites()
	

	for i=1, #theSprites do
		theSprites[i]:play()
	end
end

-- =======================
-- ====================== Cleanup
-- =======================
function gameLogic:destroyScene( screenGroup )
	-- 1. Clear all references to objects we (may have) created in 'createScene()'	
	layers:destroy()
	layers = nil

	-- 2. Clean up gravity and physics debug
	physics.setDrawMode( "normal" )
	physics.setGravity(0,0)
	screenGroup.isVisible=false

--	ssk.gem:remove("myHorizSnapEvent", joystickListener)
end

createLayers = function( group )
	layers = ssk.display.quickLayers( group, 
		"background", 
		"content",
		"interfaces" )
end


spriteCB = function ( self, event )
	--print(display.fps)
	--print(event.phase)
	eventCount = eventCount + 1
	if(useOld) then
		--print(event.phase, event.target.currentFrame, eventCount)		
	else
		--print(event.phase, event.target.frame, eventCount)
	end

	if(useOld) then
		counts.old[event.phase] = counts.old[event.phase] + 1

		if(startTime == 0 and event.phase == "next") then
			startTime = system.getTimer()
		end

		if(event.phase == "end" and counts.old[event.phase] == expected.old[event.phase]) then
			endTime = system.getTimer()
			totalTime = endTime-startTime
			print("Last sprite done!")

			verifyCounts()
		end

	else
		counts.new[event.phase] = counts.new[event.phase] + 1

		if(startTime == 0 and event.phase == "began") then
			startTime = system.getTimer()
		end
		
		if(event.phase == "ended" and counts.new[event.phase] == expected.new[event.phase]) then
			endTime = system.getTimer()
			totalTime = endTime-startTime
			print("Last sprite done!" )

			verifyCounts()
		end
	end

	return true
end

createHorseSprite = function( x, y, oldSprites )

	local oldSprites = oldSprites or false
	local spriteInstance

	-- The following uses the old sprite API (the prepare() call is commented out below):
	if( oldSprites ) then
		spriteInstance = sprite.newSprite(spriteSet)
		spriteInstance:prepare("uma")

	else
		-- The new sprite API
		spriteInstance = display.newSprite( umaSheet, spriteOptions )
	end

	layers.content:insert(spriteInstance)

	spriteInstance:setReferencePoint(display.CenterReferencePoint)
	spriteInstance.x = x
	spriteInstance.y = y
	spriteInstance:scale(spriteScaleX, spriteScaleY)

	spriteInstance.sprite = spriteCB
	spriteInstance:addEventListener( "sprite", spriteInstance )
	--spriteInstance:play()

	theSprites[#theSprites+1] = spriteInstance

	return spriteInstance
end

verifyCounts = function()

	local retVal = true

	-- Verify counts for OLD style sprites
	if(useOld) then

		-- ==
		-- Callback Counts
		-- ==

		print("OLD - Callback counts; Expected vs received:")
		print("next:", expected.old.next, counts.old.next)
		print(" end:", expected.old["end"], counts.old["end"])

		if(	counts.old.next    == expected.old.next and
		    counts.old["end"]  == expected.old["end"]) then
		else
			retVal = false
			print("OLD - Callback counts DO NOT match!\n")
		end

		-- ==
		-- Timer Count
		-- ==
		local deltaTime = math.abs(totalTime - expected.old.time)
		print("Total time: " .. totalTime .. " ms" )
		print("Expected time: " .. round(expected.old.time,2) .. " ms" )

	
	-- Verify counts NEW style sprites
	else

		-- ==
		-- Callback Counts
		-- ==

		print("NEW - Callback counts; Expected vs received:")
		print("began:", expected.new.began, counts.new.began)
		print(" next:", expected.new.next, counts.new.next)
		print(" loop:", expected.new.loop, counts.new.loop)
		print("ended:", expected.new.ended, counts.new.ended)


		if(	counts.new.began  == expected.new.began and
			counts.new.ended  == expected.new.ended ) then
		else
			print("NEW - Callback counts DO NOT match!\n")
			retVal = false
		end

		-- ==
		-- Timer Count
		-- ==
		print("Total time: " .. totalTime .. " ms" )
		print("Expected time: " .. round(expected.new.time,2) .. " ms" )

		local deltaTime = math.abs(totalTime - expected.new.time)
		if( deltaTime <= timeTolerance ) then
		else
			print("Time NOT within tolerance",deltaTime, timeTolerance)
			retVal = false
		end
	end	
	return retVal
end

initCounts =  function()
	counts.old.next  = 0
	counts.old["end"]   = 0

	counts.new.began = 0
	counts.new.next  = 0
	counts.new.loop  = 0
	counts.new.ended = 0


	-- Expected OLD COUNTS
	expected.old.next   = numSprites * (loops * frames - 1)
	expected.old["end"] = numSprites
	expected.old.time   = loops * frames * 60 -- Bad perf, ends up being about 1 sprite-frame every other render-frame

	transitionTime = (0.9 * expected.old.time)/4

	-- Expected NEW COUNTS
	expected.new.began = numSprites
	expected.new.next  = numSprites * (((loops-1) * frames - 1) + frames - 2)

	if(loops == 1 ) then
		expected.new.next   = numSprites * (loops * frames - 2)

	elseif(loops == 2 ) then
		expected.new.next   = numSprites * (((loops-1) * frames - 2) + frames - 1 )

	else -- 3 or greater loops
		expected.new.next   = numSprites * (((loops-2) * frames - 2) + (2 * ( frames - 1 ) ) )
	end

	expected.new.loop  = numSprites * (loops-1)
	expected.new.ended = numSprites 
	expected.new.time   = loops * time

	transitionTime = (0.9 * expected.new.time)/4
end

initSprites = function()
	-- The following uses the old sprite API (the prepare() call is commented out below):
	uma = sprite.newSpriteSheetFromData( "theSamples/cbench/focused1/uma.png", require("theSamples.cbench.focused1.uma_old").getSpriteSheetData() )
	spriteSet = sprite.newSpriteSet(uma,1,frames)
	sprite.add(spriteSet,"uma",1,frames,time,loops)
	
	-- The following demonstrates using the new image sheet data format 
	-- where uma_old.lua has been migrated to the new format (uma.lua)
	local options =
	{
		frames = require("theSamples.cbench.focused1.uma").frames,
	}

	-- The new sprite API
	umaSheet = graphics.newImageSheet( "theSamples/cbench/focused1/uma.png", options )
	spriteOptions = { name="theSamples.cbench.focused1.uma", start=1, count=frames, time=time, loopCount = loops }
end

placeSprites = function()
	local x = halfWidth
	for i = 1, rowsCols do
		local y = halfHeight
		for j = 1, rowsCols do
			createHorseSprite(x, y, useOld)
			y = y + targetSpriteHeight
		end
		x = x + targetSpriteWidth
	end

	layers.content:setReferencePoint(display.TopLeftReferencePoint)
	layers.content.x = 0		
	layers.content.y = 0

	transition.to( layers.content, { xScale = w/layers.content.contentWidth, yScale = h/layers.content.contentHeight, time = transitionTime, delay = 0 } )
	transition.to( layers.content, { xScale = 2, yScale = 2, time = 2*transitionTime, delay = transitionTime+10 } )
	transition.to( layers.content, { xScale = 1, yScale = 1, time = transitionTime, delay = 3*transitionTime+30 } )
end




return gameLogic