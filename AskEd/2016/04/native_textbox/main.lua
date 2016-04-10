


local function inputListener( self, event )
   print("TextBox 1 input listener event @ ", system.getTimer())
   for k,v in pairs(event) do
      print(k,v)
   end   
   print("-----------------------------------------------\n")

   self.began:setFillColor(1,1,1) 
   self.editing:setFillColor(1,1,1) 
   self.ended:setFillColor(1,1,1) 

   if(event.phase == "began" ) then 
      self.began:setFillColor(0,1,0) 
   elseif(event.phase == "editing" ) then 
      self.editing:setFillColor(0,1,0) 
   elseif(event.phase == "ended" ) then 
      self.ended:setFillColor(0,1,0) 
   end

end

local textBox = native.newTextBox( display.contentCenterX, display.contentCenterY - 90, 280, 100 )
textBox.text = "Text Box 1"
textBox.isEditable = true
textBox.userInput = inputListener
textBox:addEventListener( "userInput" )
textBox.font = native.newFont( native.systemFontBold, 18 )

textBox.began   = display.newCircle( display.contentCenterX - 100,  display.contentCenterY - 190, 10)
textBox.editing = display.newCircle( display.contentCenterX,  display.contentCenterY - 190, 10)
textBox.ended   = display.newCircle( display.contentCenterX + 100,  display.contentCenterY - 190, 10)
textBox.began.label = display.newText( "began 1", textBox.began.x, textBox.began.y + 30)
textBox.editing.label = display.newText( "editing 1", textBox.editing.x, textBox.editing.y + 30)
textBox.ended.label = display.newText( "ended 1", textBox.ended.x, textBox.ended.y + 30)



local function inputListener( self, event )
   print("TextBox 2 input listener event @ ", system.getTimer())
   for k,v in pairs(event) do
      print(k,v)
   end   
   print("-----------------------------------------------\n")

   self.began:setFillColor(1,1,1) 
   self.editing:setFillColor(1,1,1) 
   self.ended:setFillColor(1,1,1) 

   if(event.phase == "began" ) then 
      self.began:setFillColor(0,1,0) 
   elseif(event.phase == "editing" ) then 
      self.editing:setFillColor(0,1,0) 
   elseif(event.phase == "ended" ) then 
      self.ended:setFillColor(0,1,0) 
   end

end

local textBox = native.newTextBox( display.contentCenterX, display.contentCenterY + 100, 280, 100 )
textBox.text = "Text Box 2"
textBox.isEditable = true
textBox.userInput = inputListener
textBox:addEventListener( "userInput" )
textBox.font = native.newFont( native.systemFontBold, 18 )

textBox.began   = display.newCircle( display.contentCenterX - 100,  display.contentCenterY, 10)
textBox.editing = display.newCircle( display.contentCenterX,  display.contentCenterY, 10)
textBox.ended   = display.newCircle( display.contentCenterX + 100,  display.contentCenterY, 10)
textBox.began.label = display.newText( "began 2", textBox.began.x, textBox.began.y + 30)
textBox.editing.label = display.newText( "editing 2", textBox.editing.x, textBox.editing.y + 30)
textBox.ended.label = display.newText( "ended 2", textBox.ended.x, textBox.ended.y + 30)
