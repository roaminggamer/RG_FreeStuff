-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Roaming Gamer Button (Presets) Editor (a free SSK2 co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
--   Last Updated: 06 JAN 2017
-- =============================================================

local records = {}

records.all = table.load("allRecords.json") 

if( records.all == nil ) then 

	records.all = {}

	if( edoMode ) then

		for i = 1, 4 do 
			local cur = {}
			records.all[i] = cur

			local fakeID = math.getUID(4)

			local entries = {}
			cur.name = fakeID
			cur.id = math.getUID(20)
			cur.entries = entries
			
			for j = 1, math.random(10 * i, 40 * i ) do
				local rec = {}
				rec.name = math.getUID(4)
				rec.id = math.getUID(12)
				rec.isType = "buttonPreset"
				rec.definition = {}
				entries[j] = rec
			end
		end
	end
end

local function onRemoveRecord( event )
	table.dump(event)
	table.removeByRef( records.current, event.rec )
	post("onSave")
	post("onClearSelection")
end; listen("onRemoveRecord",onRemoveRecord)


local function onNewRecord( event )
	local entries = records.current

	if( event.rec ) then	
		rec = table.deepCopy( event.rec )
		rec.id = math.getUID(12)
		rec.name = rec.name .. math.getUID(2)
		entries[#entries+1] = rec
	else
		local rec = {}
		rec.name = math.getUID(4)
		rec.id = math.getUID(12)
		rec.isType = "buttonPreset"
		rec.definition = {}
		entries[#entries+1] = rec
	end

	local mainPane = require "scripts.mainPane"
	mainPane.redraw()
end; listen( "onNewRecord", onNewRecord)


local function onNewPresets()
	local cur = {}
	records.all[#records.all+1] = cur
	records.current = cur

	local entries = {}
	cur.name = "catalog" .. tostring(#records.all)
	cur.id = math.getUID(20)
	cur.entries = entries

	local leftPane = require "scripts.leftPane"
	leftPane.draw(true)	

	local mainPane = require "scripts.mainPane"
	mainPane.redraw()

	post("onSave")

end; listen( "onNewPresets", onNewPresets)


local lastSave
local function delayedSave()
	--print("SAVING", system.getTimer())
	table.save( records.all, "allRecords.json") 
	lastSave = nil
end
local function onSave()	
	if( lastSave == nil ) then
		lastSave = timer.performWithDelay(1,delayedSave)
	end	
end; listen( "onSave", onSave)

local function onSelectSet( event )
	local num = 1
	if( event and event.id ) then
		for i = 1, #records.all do
			if( records.all[i].id == event.id ) then
				num = i
			end
		end
	end

	if( records.all[num] ) then
		records.current = records.all[num].entries
	end
end; listen( "onSelectSet", onSelectSet)

listen( "onClearSelection", onSave)
listen( "onRefresh", onSave)
listen( "onSelectSet", onSave)


onSelectSet()
onSave()

return records