-- =============================================================
-- Example 'user db' management module.  Add and change functions as needed.
-- =============================================================
local m = {}


-- Called once on start up to load existing user DB if any exists
-- If file does not exist yet, DB == {} by end of function
function m.init()
   m._userDB = table.load("userDB.txt") or {}
end

-- Function demonstrating how to iterate over user DB list and do something with it. (In this case print it to the console.)
function m.printUsers()
   for i = 1, #m._userDB do
      print( "User #" .. i )
      print( " > Name: " .. m._userDB[i].name )
      print( " > Password: "   .. m._userDB[i].password )
   end
end

function m.getRecordCount( )
   return #m._userDB
end

function m.getRecordByIndex( index )
   if( m._userDB[index] ) then
      return m._userDB[index]
   else 
      print( "Warning: getByIndex(), invalid index " .. index )
      return nil
   end
end

function m.getRecordByUserID( name )
   for i = 1, #m._userDB do
      if( id == m._userDB[i].name ) then 
         return m._userDB[i]
      end
   end
   return nil
end

function m.nameExists( name )
   for i = 1, #m._userDB do
      if( name == m._userDB[i].name ) then 
         return true
      end
   end
   return false
end

-- Add new user and auto-save DB
function m.addUser( name, password )
   local record = { name = name, password = password }
   table.insert(m._userDB, record )
   table.save( m._userDB, "userDB.txt" )
end

-- Remove user record (by reference) and auto-save DB
function m.removeRecordByReference( rec )
   table.removeByRef( m._userDB, rec )
   table.save( m._userDB, "userDB.txt" )
end



return m
