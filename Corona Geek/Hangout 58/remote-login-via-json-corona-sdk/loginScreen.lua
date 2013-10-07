-- ----------------------------------------------------------------------------
-- INCLUDE REQUIRED LIBRARIES
-- ----------------------------------------------------------------------------
local mime = require("mime") -- for url encoding
local json = require("json") -- for handling json data
local widget = require("widget") -- for status label

-- ----------------------------------------------------------------------------
-- INITIALIZE VALUES
-- ----------------------------------------------------------------------------
local font = "HelveticaNeue" or system.nativeFont
local userid = nil
local password = nil
local URL = nil

-- ----------------------------------------------------------------------------
-- SET BACKGROUND
-- ----------------------------------------------------------------------------
local background = display.newRect(0, 0, _W, _H)
background:setFillColor(100,100,100);

-- ----------------------------------------------------------------------------
-- CREATE LOGIN SCREEN
-- ----------------------------------------------------------------------------
local loginScreen = display.newGroup()
loginScreen:insert(background)

-- ----------------------------------------------------------------------------
-- CREATE LABELS
-- ----------------------------------------------------------------------------
local labelHeadline = display.newText(loginScreen, " Member Login", 0, 0, font, 34)
labelHeadline:setReferencePoint(display.CenterLeftReferencePoint)
labelHeadline.x = _W * 0.5 - 140
labelHeadline.y = 70
loginScreen:insert(labelHeadline)

local labelUsername = display.newText(loginScreen, "Username", 0, 0, font, 18)
labelUsername:setReferencePoint(display.CenterLeftReferencePoint)
labelUsername:setTextColor(180, 180, 180)
labelUsername.x = _W * 0.5 - 128
labelUsername.y = 120
loginScreen:insert(labelUsername)

local labelPassword = display.newText(loginScreen, "Password", 0, 0, font, 18)
labelPassword:setReferencePoint(display.CenterLeftReferencePoint)
labelPassword:setTextColor(180, 180, 180)
labelPassword.x = _W * 0.5 - 128
labelPassword.y = 185
loginScreen:insert(labelPassword)

local labelReturnStatus = display.newText(loginScreen, "", 0, 0, font, 14)
labelReturnStatus:setReferencePoint(display.CenterLeftReferencePoint)
labelReturnStatus.x = _W * 0.5 - 5
labelReturnStatus.y = 310
loginScreen:insert(labelReturnStatus)

-- ----------------------------------------------------------------------------
-- CREATE USERNAME TEXT FIELD - ADD TO LOGIN FORM
-- ----------------------------------------------------------------------------
local frmUsername = native.newTextField(0, 0, _W*0.8, 30)
    frmUsername.inputType = "default"
    frmUsername.font = native.newFont(font, 18)
    frmUsername.hasBackground = true
    frmUsername.isEditable = true
    frmUsername.align = "left"
    frmUsername:setReferencePoint(display.TopCenterReferencePoint)
    frmUsername.x = _W * 0.5
    frmUsername.y = 135
    frmUsername.text = ''

-- add login form field to login screen
loginScreen:insert(frmUsername)

-- handle field events
function frmUsername:userInput(event)
    if(event.phase == "began") then
        -- you could implement tweening of object to get out of the way of the keyboard here
        print("Began frmUsername" .. ' ' .. event.target.text)
        event.target.text = ''
    elseif(event.phase == "editing") then
        -- fired with each new character
        print("Editing frmUsername" .. ' ' .. event.target.text)
    elseif(event.phase == "ended") then
        -- fired when the field looses focus as a result of some other object being interacted with
        print("Ended frmUsername" .. ' ' .. event.target.text)
    elseif(event.phase == "submitted") then
        -- you could implement tweening of objects to their original postion here
        print("Submitted frmUsername" .. ' ' .. event.target.text)        
    end
end
frmUsername:addEventListener("userInput",frmUsername)

-- ----------------------------------------------------------------------------
-- CREATE PASSWORD TEXT FIELD - ADD TO LOGIN FORM
-- ----------------------------------------------------------------------------
local frmPassword = native.newTextField(0, 0, _W * 0.8, 30)
    frmPassword.inputType = "default"
    frmPassword.font = native.newFont(font, 18)
    frmPassword.hasBackground = true
    frmPassword.isEditable = true
    frmPassword.isSecure = true
    frmPassword.align = "left"
    frmPassword:setReferencePoint(display.TopCenterReferencePoint)
    frmPassword.x = _W * 0.5
    frmPassword.y = 200
    frmPassword.text = ''

-- add login form field to login screen
loginScreen:insert(frmPassword)

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


-- ----------------------------------------------------------------------------
-- HANDLE JSON RETURN VALUES - DISPLAY IN STATUS LABEL
-- ----------------------------------------------------------------------------
local function loginCallback(event)
    
    -- print("inside loginCallback function")
    
    if ( event.isError ) then
        print( "Network error!");
    else
        print ( "RESPONSE: " .. event.response )
        local data = json.decode(event.response)
        
        -- do with data what you want...
        if data.result == 200 then
            -- player logged in okay
            print("Welcome back",data.firstname:gsub("^%l", string.upper))
            labelReturnStatus.text = "Welcome back "..data.firstname:gsub("^%l", string.upper)
            

            -- CHANGE SCENES OR DO SOMTHING ELSE HERE

        else
            -- prompt them to login again
            print("Please try again")
            labelReturnStatus.text = "Please try again"
            
        end
    end
    
    return true;
end

-- ----------------------------------------------------------------------------
-- MAKE KEYBOARD GO AWAY ON BACKGROUND TAP
-- ----------------------------------------------------------------------------
function background:tap(event)
    native.setKeyboardFocus(nil)
end
background:addEventListener("tap",background)

-- ----------------------------------------------------------------------------
-- HANDLE BUTTON PRESS
-- ----------------------------------------------------------------------------
local function btnOnPressHandler(event)    
    local userid = frmUsername.text
    local password = frmPassword.text 

    print(userid)
    print(password)
    
    -- stop if fields are blank
    if(userid == '' or password == '') then
        labelReturnStatus.text = 'A username or password is required.'
        return
    end   

    local URL = "http://opensourcemarketer.com/json.php?userid=" .. mime.b64(userid) .. "&password=" .. mime.b64(password);
    
    -- debug
    print(URL)
    
    -- call callback function
    network.request( URL, "GET", loginCallback )
end

-- handle onDrag
local function btnOnDragHandler(event)
    -- do something
end

-- handle onRelease
local function btnOnReleaseHandler(event)
    -- do something
end

-- create button
local btn = widget.newButton({
    id = "Login Button",
    left = 30,
    top = 250,
    label = "Login",
    width = 256,
    height = 36,
    font = font,
    fontsize = 18,
    labelColor = {
        default = {0,0,0},
        over = {255,255,255}
    },
    defaultColor = {201,107,61},
    overColor = {219,146,85},
    onPress = btnOnPressHandler,
    onDrag = btnOnDragHandler,
    onRelease = btnOnReleaseHandler
   })

-- add button to login screen
loginScreen:insert(btn)

-- ----------------------------------------------------------------------------
-- END OF LOGIN SCREEN
-- ----------------------------------------------------------------------------



