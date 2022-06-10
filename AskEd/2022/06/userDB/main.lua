io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- Require these just once in main.lua
require "extensions.string"
require "extensions.io"
require "extensions.table"
require "extensions.math"
require "extensions.display"
local user_db_module = require "user_db_module"
user_db_module.init() 
-- =====================================================
-- Example usage of functions in module.
-- =====================================================
-- 
print( " ******************* EXAMPLE STARTED RUNNING ")

--
print( "\n *******************  ")
print( "Users in DB " .. tostring( user_db_module.getRecordCount() ) )
user_db_module.printUsers() 

--
print( "\n *******************  ")
local success
local reason

success, reason = user_db_module.addUser( "Bob", "mypass123" )
print( success, reason )

success, reason = user_db_module.addUser( "Sue", "mypass456" )
print( success, reason )

success, reason  = user_db_module.addUser( "Bob", "mypass789" )
print( success, reason )

user_db_module.printUsers() 


--
print( "\n *******************  ")
local function test_find( name )
	local rec = user_db_module.getRecordByUserName( name )
	print("Try to get " .. name .. "'s record")
	if( rec ) then 
		print( "Found it: " )
		table.print_r( rec ) -- print_r() from extensions/table.lua
	else
		print( "Not found!" )
	end 
end

test_find( "Sue" )  -- This should produce a record
test_find( "Bill" ) -- There is no Bill

--
print( "\n *******************  ")
local function test_remove( name, pass )
	local success, reason = user_db_module.removeRecordByNamePass( name, pass )
	print( "Tried to remove user: " .. name .. " password: " .. pass )
	print( success, reason )
end

test_remove( "Bill", "funkyMonkey" )
test_remove( "Sue", "funkyMonkey" )
test_remove( "Sue", "mypass456" )
test_remove( "Sue", "mypass456" )
test_remove( "Bob", "mypass123" )

user_db_module.printUsers() 

