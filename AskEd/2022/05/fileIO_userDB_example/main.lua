io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- Require these just once in main.lua
require "scripts.extensions.string"
require "scripts.extensions.io"
require "scripts.extensions.table"
require "scripts.extensions.math"
require "scripts.extensions.display"

-- =====================================================
-- =====================================================

-- Dummy list of names to use in example to create new records.
local names = require "scripts.names"

-- Example user DB manager module
local example = require "scripts.example"

--
-- This example may not match your usage, but it will demonstrate
-- concepts you should be able to derive from.
--

print( " ******************* EXAMPLE STARTED RUNNING ")

-- 1 Initialize the local copy of the DB 
example.init() 


-- 2 Print record count
print("\nNumber of users records:" .. example.getRecordCount() )


-- 3 Dump list or users in DB
print( "\nRecords on load")
example.printUsers()


-- 4 Randomly add new record
local name = names[math.random(1,#names-1)] -- select random name
local id   = math.random(1,10) -- Generate random ID (small range to simplify finding randomly below)
local age  = math.random(20,80)
print( "\nAdding user ", name, id, age )
example.addUser( name, id, age )


-- 5 Randomly remove record by ID (may fail if no such record found)
local ID = math.random(1,10)
print( "\n Look for record with ID", ID )
local rec = example.getRecordByUserID( ID )
if( rec ) then
	print( "Removing record ", rec.name, rec.id, rec.age )
	example.removeRecordByReference( rec )
end


-- 6 Randomly remove record by INDEX (may fail if no such record found)
local index = math.random(2,5)
print( "\n Look for record with indx", index )
local rec = example.getRecordByIndex( index )
if( rec ) then
	print( "Removing record ", rec.name, rec.id, rec.age )
	example.removeRecordByReference( rec )
end


-- 7 Dump list or users in DB
print( "\nRecords after adding and (possibly) removing records.")
example.printUsers()



print( " ******************* EXAMPLE DONE RUNNING (restart to see new results) ")