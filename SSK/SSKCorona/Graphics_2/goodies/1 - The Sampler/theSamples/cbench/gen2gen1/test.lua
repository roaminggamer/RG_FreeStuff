-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- Template #3 - For Benchmarks
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

local debugLevel = 2 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print


----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
local storyboard = require( "storyboard" )
local sprite = require "sprite"

-- Variables
local layers -- Local reference to display layers 

local startingFPS = display.fps
local avgFPS      = display.fps

local oldDuration = 0
local newDuration = 0

local oldAvgFPS = 0
local newAvgFPS = 0


local rowsCols      = 40  
local numSprites    = rowsCols^2
local assumedFPS    = 30
local useOld        = true
local allowExit     = false
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

local results


local theSprites = {}
local eventCount = 0
local oldEventCount = 0
local newEventCount = 0

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

local function fpsListener( event )
	avgFPS = avgFPS + display.fps
	avgFPS = avgFPS /2
	print(avgFPS)
end

local gameLogic = {}

local startTime
local endTime

local oneTimePrep -- preTest for all tests
local oneTimeGather -- postTest for all tests; includes cleanup work

local preTest -- preTest for single theBenchmark
local benchClosure
local theBenchmark -- run single theBenchmark (pass ops_per_iter)
local postTest -- postTest results for theBenchmark and return durationMS for the single theBenchmark
local accumulate -- takes table from iterate and calculates final result; updates messages etc.

-- =======================
-- ====================== Initialization
-- =======================
function gameLogic:createScene( screenGroup )
	-- 1. Set up any rendering layers we need
	createLayers( screenGroup )

	-- 2. Run the theBenchmark
	oneTimePrep()
	results = {}
	results.iterations = 1
	results.numOps = 1
	preTest()
	--Runtime:addEventListener("enterFrame", fpsListener)
	theBenchmark( 1 )
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

	-- 3. EFM - add code to catch cancelled tests here


end

-- =======================
-- ====================== Local Function & Callback Definitions
-- =======================
createLayers = function( group )
	layers = ssk.display.quickLayers( group, 
		"background", 
		"content",
		"interfaces" )
end


oneTimePrep = function()
	theSprites = {}
	initCounts()
	initSprites()
	placeSprites()
end

preTest = function()
	startTime = system.getTimer()
end

postTest = function()
	endTime = system.getTimer()
	return endTime-startTime
end

oneTimeGather = function()
	theSprites = nil
end


accumulate = function( results )
	local totalDurationMS = 0
	local totalOperations = results.iterations * results.numOps
	
	for i = 1, #results do
		totalDurationMS = totalDurationMS + results[i]
	end

	if( totalDurationMS > 0) then
		local OPS = round( (totalOperations / totalDurationMS) * 1000, 2 )

		local suffix = ""

		if(OPS > 1000000000) then
			OPS = round(OPS/1000000000,2)
			suffix = " G"
		elseif(OPS > 1000000) then
			OPS = round(OPS/1000000,2)
			suffix = " M"
		elseif(OPS > 1000) then
			OPS = round(OPS/1000,2)
			suffix = " K"
		end

		_G.lastResultMessage = totalOperations .. " operations @ " .. OPS .. suffix .. " ops/s"
	else
		_G.lastResultMessage = totalOperations .. SPC .. " operations in less than 1 ms" 
	end

	dprint(2, _G.lastResultMessage)

	return OPS	
end

theBenchmark = function( numOps )
	for i=1, #theSprites do
		--print(theSprites[i], #theSprites)
		theSprites[i]:play()
	end
	transition.to( layers.content, { xScale = w/layers.content.contentWidth, yScale = h/layers.content.contentHeight, time = transitionTime, delay = 0 } )
	transition.to( layers.content, { xScale = 2, yScale = 2, time = 2*transitionTime, delay = transitionTime+10 } )
	transition.to( layers.content, { xScale = 1, yScale = 1, time = transitionTime, delay = 3*transitionTime+30 } )
end

spriteCB = function ( self, event )
	--print(display.fps)
	--print(event.phase)
	if(useOld) then
		--print(event.phase, event.target.currentFrame, eventCount)		
	else
		--print(event.phase, event.target.frame, eventCount)
	end

	eventCount = eventCount + 1

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

--EFM G2	spriteInstance:setReferencePoint(display.CenterReferencePoint)
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

	_G.lastResultMessage = ""

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
			_G.lastResultMessage = "Event Counts Match; "
		else
			retVal = false
			print("OLD - Callback counts DO NOT match!\n")
			_G.lastResultMessage = "Event Counts DO NOT Match; "
		end

		-- ==
		-- Timer Count
		-- ==
		local deltaTime = math.abs(totalTime - expected.old.time)
		print("Total time: " .. totalTime .. " ms" )
		print("Expected time: " .. round(expected.old.time,2) .. " ms" )

		_G.lastResultMessage = _G.lastResultMessage .." Duration not tested"

	
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
			_G.lastResultMessage = "Event Counts Match; "
		else
			print("NEW - Callback counts DO NOT match!\n")
			retVal = false
			_G.lastResultMessage = "Event Counts DO NOT Match; "
		end

		-- ==
		-- Timer Count
		-- ==
		print("Total time: " .. totalTime .. " ms" )
		print("Expected time: " .. round(expected.new.time,2) .. " ms" )

		local deltaTime = math.abs(totalTime - expected.new.time)
		if( deltaTime <= timeTolerance ) then
			_G.lastResultMessage = _G.lastResultMessage .." Duration within tolerance"
		else
			print("Time NOT within tolerance",deltaTime, timeTolerance)
			retVal = false
			_G.lastResultMessage = _G.lastResultMessage .." Duration NOT within tolerance"
		end
	end	

	if(retVal) then
		_G.lastResultMessage = "PASS - " .. _G.lastResultMessage
	else
		_G.lastResultMessage = "FAIL - " .. _G.lastResultMessage
	end

	while #theSprites > 1 do
		theSprites[#theSprites]:removeSelf()
		theSprites[#theSprites] = nil
	end

	theSprites = nil

	local durationMS = postTest()

	if(useOld == true) then
		oldDuration = durationMS	
		oldEventCount = eventCount	
		oldAvgFPS = avgFPS
	else
		newDuration = durationMS
		newEventCount = eventCount
		newAvgFPS = avgFPS
	end

	oneTimeGather()

	--_G.lastResultMessage = totalOperations .. " operations @ " .. OPS .. suffix .. " ops/s"

	if(allowExit) then

		local oldOPS = round(1000 * oldEventCount / oldDuration,0)
		local newOPS = round(1000 * newEventCount / newDuration,0)
		local vs = round(newOPS/oldOPS,2)

		_G.lastResultMessage = rowsCols^2 .. " Sprites => " .. newOPS .. " sprites/s vs. " .. oldOPS .. " sprites/s (" .. vs .. "x)"

		--Runtime:removeEventListener("enterFrame", fpsListener)
		print(oldAvgFPS, newAvgFPS)

		timer.performWithDelay( 34, function() storyboard.gotoScene( "s_MainMenu" , "slideRight", 400  )	end )
	else
		avgFPS = startingFPS
		eventCount = 0
		useOld  = false
		allowExit = true
		oneTimePrep()
		results = {}
		results.iterations = 1
		results.numOps = 1
		preTest()
		theBenchmark( 1 )
	end

	return retVal
end

initCounts =  function()
	eventCount = 0

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

--EFM G2	layers.content:setReferencePoint(display.TopLeftReferencePoint)
	layers.content.x = 0		
	layers.content.y = 0
end





return gameLogic