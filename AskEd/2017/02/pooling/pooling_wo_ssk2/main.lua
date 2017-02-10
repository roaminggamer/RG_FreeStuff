-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
--  main.lua
-- =============================================================
-- Start (code/comments)
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)


local function runTest( usePooling, usePhysics )
	local pool = {}
	local objects = {}
	local countProxy = { count = 100, trueCount = 100 }

	local group = display.newGroup()

	local left = display.contentCenterX - display.actualContentWidth/2
	local right = left + display.actualContentWidth
	local top = display.contentCenterY - display.actualContentHeight/2
	local bottom = top + display.actualContentHeight

	local physics
	if( usePhysics ) then
		physics = require "physics"
		physics.start()
		physics.setGravity(0,0)
	end

	local function destroyObjects()
		if( usePooling ) then
			for i = 1, #objects do
				local obj = objects[i]
				-- just hide it for this example;  you would do more in a real pooling algorithm
				-- I simply want to demonstrate, even with the cheapest
				obj.alpha = 0 
				pool[#pool+1] = obj
			end
			objects = {}
		else
			for i = 1, #objects do
				display.remove(objects[i])
			end
			objects = {}

		end
	end


	local function createObject()
		local x = math.random( left + 150, right - 150 )
		local y = math.random( top + 150, bottom - 150)

		local obj

		-- Not pooling, or no more objects in 'pool'
		if( not usePooling or #pool == 0 ) then
			obj = display.newCircle( group, x, y, math.random(10,20))
			obj:setFillColor( math.random(), math.random(), math.random() )

			if( usePhysics ) then
				physics.addBody( obj )
				obj.isSensor = true -- Avoid cost of 'responses' to make this example 'cheaper'
			end

		else
			obj = pool[#pool]
			obj.alpha = 1
			obj.x = x
			obj.y = y
			pool[#pool] = nil
		end

		objects[#objects+1] = obj
	end

	local countLabel = display.newText( "starting", display.contentCenterX, top + 30, native.systemFont, 40 )


	transition.to( countProxy, { count = 10000, delay = 1000, time = 60000 } )


	local function enterFrame()
		countProxy.trueCount = math.floor(countProxy.count)
		destroyObjects()
		for i = 1, countProxy.trueCount do
			createObject()
		end

		countLabel.text = countProxy.trueCount
	end; Runtime:addEventListener("enterFrame",enterFrame)


end




local function noPool_noPhysics()
	runTest( false, false )
end
local function noPool_plusPhysics()
	runTest( false, true )
end

local function Pool_noPhysics()
	runTest( true, false )
end
local function Pool_plusPhysics()
	runTest( true, true )
end


noPool_noPhysics()
--noPool_plusPhysics()
--Pool_noPhysics()
--Pool_plusPhysics()