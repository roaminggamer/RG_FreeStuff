--require("mobdebug").start() -- ZeroBrane Users
-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
display.setStatusBar(display.HiddenStatusBar)  
io.output():setvbuf("no") 

-- ==========================================================
-- === Naive Random Selection Approach
-- ==========================================================
local function naive()  
   
   local cards = { "jack.png", "king.png", "queen.png", "ace.png" }
   local selected = {}
  
   local group = display.newGroup()
   
   local function showCards( button )
      selected = {}
      display.remove(group)
      group = display.newGroup()

      local count = 0
      
      for i = 1, 4 do
         count = count + 1
         local file = cards[math.random( 1, #cards )] 
         
         while( selected[file] ) do
            count = count + 1
            file = cards[math.random( 1, #cards )] 
         end
         selected[file] = file


         local card = display.newImageRect( group, file, 140, 190 )
         card.x = button.x + 160 * i
         card.y = button.y
      end
      print("Count == ", count )
   end
      
   --
   -- Basic button to 'run' showCards() when touched.
   --   
   local button = display.newRect( 100, 100, 100, 100 )
   button:setFillColor( 1, 0, 0 )
   button.touch = function( self, event )
      if(event.phase == "ended") then
         showCards( event.target )
      end
      return true
   end
   button:addEventListener( "touch" )
end
naive()

-- ==========================================================
-- === Shuffle Bag Example 1
-- ==========================================================
local function bag1()  
   
   local shuffleBag = require "shuffleBag"
   
   local cards = shuffleBag.new( "jack.png", "king.png", "queen.png", "ace.png" )
   
   cards:shuffle()
   
   local group = display.newGroup()
   
   local function showCards( button )
      display.remove(group)
      group = display.newGroup()
      
      for i = 1, 4 do
         local file = cards:get()         
         local card = display.newImageRect( group, file, 140, 190 )
         card.x = button.x + 160 * i
         card.y = button.y
      end
   end
      
   --
   -- Basic button to 'run' showCards() when touched.
   --   
   local button = display.newRect( 100, 300, 100, 100 )
   button:setFillColor( 0, 1, 0 )
   button.touch = function( self, event )
      if(event.phase == "ended") then
         showCards( event.target )
      end
      return true
   end
   button:addEventListener( "touch" )
end
bag1()

-- ==========================================================
-- === Shuffle Bag Example 2 - Insert +  Auto Reshuffle
-- ==========================================================
local function bag2()  
   
   local shuffleBag = require "shuffleBag"
   
   local cards = shuffleBag.new()
   
   cards:insert( "jack.png" )
   cards:insert( "king.png" )
   cards:insert( "queen.png" )
   cards:insert( "ace.png" )
   
   cards:shuffle()

   local group = display.newGroup()
   
   local function showCards( button )
      display.remove(group)
      group = display.newGroup()
      
      for i = 1, 5 do
         local file = cards:get()         
         local card = display.newImageRect( group, file, 140, 190 )
         card.x = button.x + 160 * i
         card.y = button.y
      end
   end
      
   --
   -- Basic button to 'run' showCards() when touched.
   --   
   local button = display.newRect( 100, 500, 100, 100 )
   button:setFillColor( 0, 1, 1 )
   button.touch = function( self, event )
      if(event.phase == "ended") then
         showCards( event.target )
      end
      return true
   end
   button:addEventListener( "touch" )
end
bag2()




