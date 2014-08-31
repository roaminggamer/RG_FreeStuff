require "pushButtonClass"
require "toggleButtonClass"


local function myPushListener ( self, event )
	print( "Pressed button: ", self:getText() )
end

local function myToggleListener ( self, event )
	print( "Button: ", self:getText(), " is toggled? ", self:isSelected() )
end


local push1 = PushButton( display.currentStage, 100, 100, "Hello", myPushListener )

local push2 = PushButton( display.currentStage, 100, 150, "World", myPushListener, 
	                      { labelColor = {1,1,0}, labelSize = 18 } )


local toggle1 = ToggleButton( display.currentStage, 250, 100, "Toggle 1", myToggleListener )

local toggle2 = ToggleButton( display.currentStage, 250, 150, "Toggle 2", myToggleListener, 
	                      { labelColor = {0,1,1}, labelSize = 18 } )

local toggle3 = ToggleButton( display.currentStage, 250, 200, "Toggle 3", myToggleListener, 
	                      { labelColor = {0.8,0,0.8}, labelSize = 20 } )


toggle1:toggle()
toggle3:toggle( true )
