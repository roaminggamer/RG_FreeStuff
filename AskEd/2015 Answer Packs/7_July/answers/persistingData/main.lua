-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

--[[
		The user who posited this question wanted to keep 'persistent' data, even if the user re-installed the app.

		Fortunately, under both Android and iOS, data is in the documents folder is kept even if you install an app update.

		Unfortunately, if the user un-installs your app, this removes the documents folder so all data is lost.

		This answer will show how to store persistent data that will be retained as long as the user does not un-install the app.

		I may add a future answer showing how to persist data through un-intalls, but that is much more complex.

		Note: I used SSK to answer this question because SSK provides helper functions for loading and restoring tables, which I use
		for persisting data.
--]]



--
-- 1. Load SSK
--require "ssk.loadSSK"


-- 2. Forward declare out data 'container' and a table for storing objets
-- 
local myData
local myObjects = {}


--
-- 3. Draw two draggable objects
local tmp = display.newImageRect( "yellow_round.png", 80, 80 )
tmp.x = display.contentCenterX - 100
tmp.y = display.contentCenterY
tmp:setFillColor(1,0,0)
myObjects[#myObjects+1] = tmp

local tmp = display.newImageRect( "yellow_round.png", 80, 80 )
tmp.x = display.contentCenterX + 100
tmp.y = display.contentCenterY
tmp:setFillColor(0,1,0)
myObjects[#myObjects+1] = tmp


--
-- 4. Load the data, and if it exists, restore the last 'saved' position of the two objects
myData = table.load( "savedPositions.json" )


if( myData ) then 
	table.dump(myData)
	--
	-- The data was loaded, restore positions
	for i = 1, #myData do
		myObjects[i].x = myData[i].x
		myObjects[i].y = myData[i].y
	end
else
	--
	-- The data did not exist; Create blank table.
	myData = {}
	--
	-- Now, capture current positions and the save data.
	for i = 1, #myObjects do
		local tmp = {}
		myData[i] = tmp
		tmp.x = myObjects[i].x
		tmp.y = myObjects[i].y
	end
	table.save( myData, "savedPositions.json" )
end


-- 
-- 5. Define a touch listener that will save object positions each time they are moved
local function onTouch( self, event )
	if( event.phase == "moved" ) then
		--
		-- Move the object
		self.x = event.x
		self.y = event.y
	
	elseif( event.phase == "ended" ) then
		--
		-- Find this object's index
		local index = table.indexOf( myObjects, self )
		--
		-- Update the data table and save it.
		myData[index].x = myObjects[index].x
		myData[index].y = myObjects[index].y
		table.save( myData, "savedPositions.json" )
		end
	return true
end


-- 
-- 6. Attach the listener to our objects
for i = 1, #myObjects do
	myObjects[i].touch = onTouch
	myObjects[i]:addEventListener( "touch" )
end
		

--
-- 7. Instructions Label
local tmp = display.newText( "1. Drag Objects and re-run app.", 50, 10, native.systemFont, 22 )
tmp.anchorX = 0
local tmp = display.newText( "2. Notice the position is saved?", 50, 40, native.systemFont, 22 )
tmp.anchorX = 0