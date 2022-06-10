-- =============================================================
local user_db_module = require "scripts.user_db_module"
local widget = require("widget") -- for status label

-- =============================================================
local sceneGroup = display.newGroup()

-- =============================================================
-- SET BACKGROUND
local background = display.newRect( sceneGroup, 420, 450, 500, 500)
background:setFillColor(100/255,100/255,100/255);

-- CREATE LABELS
local labelHeadline = display.newText( sceneGroup, "Remove User setting", 0, 0, font, 57)
labelHeadline.x = 375
labelHeadline.y = 60

local labelUsername = display.newText( sceneGroup, " enter your username", 0, 0, font, 36)
labelUsername:setTextColor( 0.5, 0.9, 0.5 )
labelUsername.x = 410 
labelUsername.y = 229

local labelPassword = display.newText( sceneGroup, " enter your password", 0, 0, font, 35)
labelPassword:setTextColor( 0.5, 0.5, 0.9)
labelPassword.x = 375
labelPassword.y = 470

local labelReturnStatus = display.newText( sceneGroup , "", 0, 0, font, 47)
labelReturnStatus.x = 400
labelReturnStatus.y = 740
labelReturnStatus:setFillColor( 1, 1, 1 )

local labelReturnStatus1 = display.newText( sceneGroup , "", 0, 0, font, 35)
labelReturnStatus1.x = 400
labelReturnStatus1.y = 900
labelReturnStatus1:setFillColor( 1, 1, 0 )

local labelReturnStatus2 = display.newText( sceneGroup , "", 0, 0, font, 35)
labelReturnStatus2.x = 400
labelReturnStatus2.y = 1000
labelReturnStatus2:setFillColor( 1, 0, 0 )


-- CREATE USERNAME TEXT FIELD - ADD TO LOGIN FORM
local frmUsernam = native.newTextField( 0, 0, 360, 100)
frmUsernam.inputType = "default"
frmUsernam.font = native.newFont(font, 50)
frmUsernam.isEditable = true
frmUsernam.align = "center"
frmUsernam.x = 415
frmUsernam.y = 335
-- frmUsernam.text = 'Response 1'
frmUsernam.text = ''
-- add login form field to login screen
sceneGroup:insert(frmUsernam)

-- handle field events
function frmUsernam:userInput(event)
   if(event.phase == "began") then
      -- you could implement tweening of object to get out of the way of the keyboard here
      print("Began frmUsername" .. ' ' .. event.target.text)
      event.target.text = ''
   elseif(event.phase == "editing") then
      -- fired with each new character
      print("Editing frmUsername before cleaning: " .. ' ' .. event.target.text)
      event.target.text = string.alphaNumericOnly(event.target.text)
      print("Editing frmUsername after cleaning : " .. ' ' .. event.target.text)
   elseif(event.phase == "ended") then
      -- fired when the field looses focus as a result of some other object being interacted with
      print("Ended frmUsername" .. ' ' .. event.target.text)
   elseif(event.phase == "submitted") then
      -- you could implement tweening of objects to their original postion here
      print("Submitted frmUsername" .. ' ' .. event.target.text)        
   end
end
frmUsernam:addEventListener("userInput",frmUsernam)

-- CREATE PASSWORD TEXT FIELD - ADD TO LOGIN FORM
local frmPassword = native.newTextField(0, 0, 360, 100)
frmPassword.inputType = "default"
frmPassword.font = native.newFont(font, 50)
frmPassword.isEditable = true
frmPassword.isSecure = false
frmPassword.align = "center"
frmPassword.x = 415
frmPassword.y = 565
-- frmPassword.text = 'Response 2'
frmPassword.text = ''
-- add login form field to login screen
sceneGroup:insert(frmPassword)

-- handle field events
function frmPassword:userInput(event)
   if(event.phase == "began") then
      -- you could implement tweening of object to get out of the way of the keyboard here
      print("Began Password" .. ' ' .. event.target.text)
      event.target.text = ''
   elseif(event.phase == "editing") then
      -- fired with each new character
      print("Editing Password" .. ' ' .. event.target.text)
   elseif(event.phase == "ended") then
      -- fired when the field looses focus as a result of some other object being interacted with
      print("Ended Password" .. ' ' .. event.target.text)
   elseif(event.phase == "submitted") then
      -- you could implement tweening of objects to their original postion here
      print("Submitted Password" .. ' ' .. event.target.text)        
   end
end
frmPassword:addEventListener("userInput",frmPassword) 

-- MAKE KEYBOARD GO AWAY ON BACKGROUND TAP
function background:tap(event)
   native.setKeyboardFocus(nil)
end
background:addEventListener("tap",background)

-- HANDLE BUTTON RELEASE
local function btnOnReleaseHandler(event)

   --
   -- A. Check that username conforms to rules and does not already exist
   -- 
   local userid = string.lower(frmUsernam.text)
   local userid_ok = false

   -- Rule A1 - Length >= 4
   if( string.len(userid) < 4 ) then       
      labelReturnStatus1.text = "invalid username (too short)!" 

   -- Rule A2 - Does not already exist
   --elseif( user_db_module.nameExists( userid ) ) then       
     -- labelReturnStatus1.text = "invalid username (already exists)!" 

   -- Clear warning label
   else
      labelReturnStatus1.text = ""
      labelReturnStatus2.text = ""
      userid_ok = true
   end

   -- Abort if user name not OK
   if( not userid_ok ) then return end

   --
   -- B. Check that username conforms to rules
   -- 
   local password = string.lower(frmPassword.text)

   -- Rule A1 - Length >= 4
   if( string.len(userid) < 4 ) then       
      labelReturnStatus1.text = "invalid password (too short)!" 
   else     
      local success, reason = user_db_module.removeRecordByNamePass( userid, password )
      if(  success ) then
         print( "User " .. userid .. " record successfully removed" )
      else
         print( "User " .. userid .. " record not removed.  Reason: " .. reason  )
      end
      labelReturnStatus1.text = userid
      labelReturnStatus2.text = reason

   end
end
-- HANDLE BUTTON RELEASE
local function btnOnReleaseHandler2(event)
   user_db_module.printUsers(i)
  end



-- create button
local btn = widget.newButton( {
   id = "Login Button",
   left = 410, 
   top = 770,  
   label ="Remove",
   defaultFile="image/button.png",
   overFile ="image/boulble.png",
   width = 200, 
   height = 100, 
   font = font, 
   fontSize = 53,
   labelColor = {  default = {0/255,0/255,1/255},
   over = {255/255,255/255,255/255} },
   defaultColor = {201/255,107/255,61/255}, 
   overColor = {219/255,146/255,85/255},
   -- onPress = btnOnPressHandler,
   -- onDrag = btnOnDragHandler,
   onRelease = btnOnReleaseHandler, 
   } )

-- add button to login screen
sceneGroup:insert(btn)


-- create button
local btn = widget.newButton( {
   id = "Login Button",
   left = 110, 
   top = 770,  
   label ="Dump DB",
   defaultFile="image/button.png",
   overFile ="image/boulble.png",
   width = 240, 
   height = 100, 
   font = font, 
   fontSize = 53,
   labelColor = {  default = {0/255,0/255,1/255},
   over = {255/255,255/255,255/255} },
   defaultColor = {201/255,107/255,61/255}, 
   overColor = {219/255,146/255,85/255},
   -- onPress = btnOnPressHandler,
   -- onDrag = btnOnDragHandler,
   onRelease = btnOnReleaseHandler2, 
   } )

-- add button to login screen
sceneGroup:insert(btn)

