
require "ssk2.loadSSK"
_G.ssk.init()
_G.ssk.init( { launchArgs           = ..., 
               enableAutoListeners  = true,
               exportCore           = true,
               exportColors         = true,
               exportSystem         = true,
               exportSystem         = true,
               debugLevel           = 0 } )

local getTimer = system.getTimer


local display_newRect = display.newRect
local addEventListener

local function my_addEventListener( ... )
   local passedListener = (arg[3] ~=nil and type(arg[3]) == "function")
   local hasOwnTouch = (arg[1].touch ~= nil)
   print("In my addEventListener ", arg[1].myName, hasOwnTouch, passedListener )
   
   local isTouch = arg[2] == "touch"
   
   if( not isTouch ) then
      addEventListener(unpack( arg ))
      return
   end
   
      
   -- 1
   if( hasOwnTouch and passedListener ) then      
      local listener = arg[3]
      local function customListener( event )
         if( event.phase == "ended" ) then
            table.dump( debug.getinfo(1, "S") )

            print("In custom listener 1")
         end
         listener(event)
      end      
      addEventListener( arg[1], "touch", customListener )       
      --addEventListener( arg[1], "touch", arg[3] ) -- correct
   
   -- 2
   elseif( not hasOwnTouch and passedListener ) then
      local listener = arg[3]
      local function customListener( event )
         if( event.phase == "ended" ) then
            print("In custom listener 2")
         end
         listener(event)
      end      
      addEventListener( arg[1], "touch", customListener )       
      --addEventListener( unpack( arg ))
   
   -- 3
   else
      local listener = arg[1].touch
      arg[1].touch = function( self, event )
         if( event.phase == "ended" ) then
            print("In custom listener 3")
         end
         listener(self, event)
      end 
      
      addEventListener( arg[1], "touch" )
      --addEventListener( unpack( arg ))
   end   
end


display.newRect = function( ... )
   local obj = display_newRect( unpack(arg) )
   addEventListener = addEventListener or obj.addEventListener   
   obj.addEventListener = my_addEventListener
	return obj
end


local function onTouch( self, event )
   if( event.phase == "ended") then
      print("onTouch() " .. tostring(self.myName) .. " @ " .. getTimer() )
   end
end

local function onTouch2( event )
   if( event.phase == "ended") then
      print("onTouch2() " .. tostring(event.target.myName) .. " @ " .. getTimer() )
   end
end


local a = display.newRect( 100, 100, 150, 150 )
a.myName = "a"
a.touch = onTouch
a:addEventListener( "touch" )

local b = display.newRect( 300, 100, 150, 150 )
b.myName = "b"
b:addEventListener( "touch", onTouch2 )

local c = display.newRect( 500, 100, 150, 150 )
c.myName = "c"
c.touch = onTouch
c.addEventListener( c, "touch", onTouch2 )



