local messageQueue = require ( "messages" )
local myGroup=display.newGroup()
local bg = display.newImageRect(myGroup, "bg.jpg", display.contentWidth, display.contentHeight)
    bg.x, bg.y = display.contentWidth/2, display.contentHeight/2
    bg:toBack()

local mParams={ 
  fontSize = 46, 
  font="Raleway Bold",
  yPos=display.contentHeight/2,
  messageGroup = myGroup, 
  background = true,
  bgColour = {0,0,0,.6},
  bgWidth = display.contentWidth-100,
  bgBorderColour = {0,0,1},
  bgCornerRadius = 20,
  bgBorderWidth=10,
  textColour = {1,0,0},
}

messageQueue:init(mParams)

local function fooFunc()
  print("This has been called by the onComplete facility!")
end

messageQueue:addMessage("A MESSAGE",{time=1000, fadeIn=false, fadeOut=false, bg=true})
messageQueue:addMessage("NUMBER 2",{time=3000})
messageQueue:addMessage("AND A THIRD.",{time=5000, bg=false, onComplete=fooFunc })
messageQueue:addMessage("THE END!",{time=3000})