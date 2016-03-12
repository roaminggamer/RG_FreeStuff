-- Copyright (C) 2013 Corona Inc. All Rights Reserved.
-- File: newSwitch unit test.

local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local isGraphicsV1 = ( 1 == display.getDefault( "graphicsCompatibility" ) )

--Forward reference for test function timer
local testTimer = nil

function scene:createScene( event )
	local group = self.view
	
	local xAnchor, yAnchor
	
	if not isGraphicsV1 then
		xAnchor = display.contentCenterX
		yAnchor = display.contentCenterY
	else
		xAnchor = 0
		yAnchor = 0
	end
	
	local fontColor = 0
	local background = display.newRect( xAnchor, yAnchor, display.contentWidth, display.contentHeight )
	
	if widget.USE_IOS_THEME then
		if isGraphicsV1 then background:setFillColor( 197, 204, 212, 255 )
		else background:setFillColor( 197/255, 204/255, 212/255, 1 ) end
	elseif widget.USE_ANDROID_HOLO_LIGHT_THEME then
		if isGraphicsV1 then background:setFillColor( 255, 255, 255, 255 )
		else background:setFillColor( 1, 1, 1, 1 ) end
	elseif widget.USE_ANDROID_HOLO_DARK_THEME then
		if isGraphicsV1 then background:setFillColor( 34, 34, 34, 255 )
		else background:setFillColor( 34/255, 34/255, 34/255, 1 ) end
		fontColor = 0.5
	else
		if isGraphicsV1 then background:setFillColor( 255, 255, 255, 255 )
		else background:setFillColor( 1, 1, 1, 1 ) end
	end
	group:insert( background )
	
	local backButtonPosition = 5
	local backButtonSize = 34
	local fontUsed = native.systemFont
	
	--Button to return to unit test listing
	local returnToListing = widget.newButton
	{
	    id = "returnToListing",
	    left = display.contentWidth * 0.5,
	    top = backButtonPosition,
	    label = "Exit",
	    width = 200, height = backButtonSize,
	    cornerRadius = 8,
	    onRelease = function() storyboard.gotoScene( "unitTestListing" ) end;
	}
	returnToListing.x = display.contentCenterX
	group:insert( returnToListing )
	
	----------------------------------------------------------------------------------------------------------------
	--										START OF UNIT TEST
	----------------------------------------------------------------------------------------------------------------
	
	--Toggle these defines to execute automated tests.
	local TEST_REMOVE_SWITCH = false
	local TEST_SET_STATE = false
	local TEST_DELAY = 1000
	
	local radioGroup = {}
	
	local function onRadioPress( event )
		local self = event.target

		-- Turn off other radio buttons in this set
		--[[
		for k, v in pairs( radioGroup ) do
			if radioGroup[k].id ~= self.id then
				radioGroup[k]:setState( { isOn = false } )
			end
		end
		--]]

		print( self.id, "is on?:", self.isOn )
	end
		
	local function onCheckBoxPress( event )
		local self = event.target
		
		print( self.id, "is on?:", self.isOn )
	end
	
	local function onOnOffPress( event )
		local self = event.target
		
		print( self.id, "is on?:", self.isOn )
		
		--display.remove( self )
	end
		
	
	local radioGroup = display.newGroup()
	
	-- Create a radio switch
	local radioButton = widget.newSwitch
	{
		left = 0,
		top = 120,
		style = "radio",
		id = "Radio button1",
		initialSwitchState = true,
		onPress = onRadioPress,
	}
	radioButton.x = display.contentCenterX
	radioGroup:insert( radioButton )
	
	-- Create a radio switch
	local radioButton2 = widget.newSwitch
	{
		left = 80,
		top = 120,
		style = "radio",
		id = "Radio button2",
		initialSwitchState = false,
		onPress = onRadioPress,
	}
	radioGroup:insert( radioButton2 )	
	
	-- Create a radio switch
	local radioButton3 = widget.newSwitch
	{
		left = 20,
		top = 120,
		style = "radio",
		id = "Radio button3",
		initialSwitchState = false,
		onPress = onRadioPress,
	}
	radioGroup:insert( radioButton3 )
	group:insert( radioGroup )
	
	--
	local radioButtonText1 = display.newText( "< Set 1", 0, 0, fontUsed, 18 )
	radioButtonText1.x = 70 + radioButton.x + radioButtonText1.contentWidth * 0.5
	radioButtonText1.y = radioButton.y - 2
	radioButtonText1:setFillColor( fontColor )
	group:insert( radioButtonText1 )
	
	---- other
	local otherRadioGroup = display.newGroup()
	
	-- Create a radio switch
	local radioButtonOther = widget.newSwitch
	{
		left = 20,
		top = 160,
		style = "radio",
		id = "Radio button4",
		initialSwitchState = false,
		onPress = onRadioPress,
	}
	otherRadioGroup:insert( radioButtonOther )
	
	-- Create a radio switch
	local radioButtonOther2 = widget.newSwitch
	{
		left = 80,
		top = 160,
		style = "radio",
		id = "Radio button4",
		initialSwitchState = false,
		onPress = onRadioPress,
	}
	otherRadioGroup:insert( radioButtonOther2 )
	group:insert( otherRadioGroup )
	
	--
	local radioButtonText2 = display.newText( "< Set 2", 0, 0, fontUsed, 18 )
	radioButtonText2.x = radioButtonText1.x
	radioButtonText2.y = radioButtonOther2.y - 2
	radioButtonText2:setFillColor( fontColor )
	group:insert( radioButtonText2 )
	
	
	-- Create a checkbox switch
	local checkboxButton = widget.newSwitch
	{
		left = 0,
		top = 200,
		style = "checkbox",
		id = "Checkbox button",
		onPress = onCheckBoxPress,
	}
	checkboxButton.x = display.contentCenterX
	group:insert( checkboxButton )
	
	local onOffSwitch = widget.newSwitch
	{
		left = 0,
		top = 300,
		style = "onOff",
		initialSwitchState = false,
		onRelease = onOnOffPress
	}
	onOffSwitch.x = display.contentCenterX
	group:insert( onOffSwitch )
	

	-- Skinned On-Off Switch
	--[[local onOffSwitchOptions = {
		frames =
		{
			{ x=0, y=0, width=160, height=44 },
			{ x=0, y=45, width=42, height=42 },
			{ x=44, y=45, width=42, height=42 },
			{ x=88, y=44, width=96, height=44 }
		},
		sheetContentWidth = 184,
		sheetContentHeight = 88
	}
	local onOffSwitchSheet = graphics.newImageSheet( "unitTestAssets/on-off-sheet.png", onOffSwitchOptions )

    local switch = widget.newSwitch {
		left = 100,
		top = 200,
		style = "onOff",
		sheet = onOffSwitchSheet,
		onOffMask = "unitTestAssets/switch-mask.png",

		onOffBackgroundFrame = 1,
		onOffBackgroundWidth = 160,
		onOffBackgroundHeight = 44,
			  
		onOffOverlayFrame = 4,
		onOffOverlayWidth = 96,
		onOffOverlayHeight = 44,
			  
		onOffHandleDefaultFrame = 2,
		onOffHandleOverFrame = 2,
	}--]]
	
	----------------------------------------------------------------------------------------------------------------
	--											TESTS
	----------------------------------------------------------------------------------------------------------------
	
	-- Test removing switch
	if TEST_REMOVE_SWITCH then
		timer.performWithDelay( 100, function()
			display.remove( radioButton )
			display.remove( checkboxButton )
			display.remove( onOffSwitch )
			
			TEST_DELAY = TEST_DELAY + TEST_DELAY
		end )
	end
	
	-- Test toggling the switch programatically
	if TEST_SET_STATE then
		timer.performWithDelay( 1000, function()
			onOffSwitch:setState( { isOn = false, isAnimated = true, onComplete = onOnOffPress } )
			checkboxButton:setState( { isOn = true, isAnimated = true, onComplete = onCheckBoxPress } )
		end)
	end

	
end

function scene:didExitScene( event )
	--Cancel test timer if active
	if testTimer ~= nil then
		timer.cancel( testTimer )
		testTimer = nil
	end
	
	storyboard.removeAll()
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "didExitScene", scene )

return scene
