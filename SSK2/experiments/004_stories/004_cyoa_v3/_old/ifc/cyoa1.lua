-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
--
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local screenGroup
local layers 

-- Callbacks/Functions
local onBack

-- Forward Declarations
local imageRect 		= ssk.display.imageRect
local easyIFC			= ssk.easyIFC
local tern 				= _G.ternary
local mRand 			= math.random

local getTimer 			= system.getTimer
local sysGetInfo		= system.getInfo
local strMatch 			= string.match
local strFormat 		= string.format

----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------
local maxW = w - 30
local curY = 0
local ySep = 5
local text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry.  Lorem Ipsum is simply dummy text of the printing and typesetting industry."

local rooms = {}

rooms['start'] = { title = 'Beach', description = "You are standing on a beach.\n\nA rocky trail leads north towards some cliffs.  To the west you see a shack.", exits = { { 'north', 'room1' }, { 'west', 'room2'} } }
rooms['room1'] = { title = 'Cliffs', description = "A small clearing rests at the base of impassible cliffs.\n\nA rocky trail leads south towards the ocean.  A grassy path leads uphill to the west.", exits = { { 'south', 'start' }, { 'west', 'room3'} } }
rooms['room2'] = { title = 'Shack', description = "A small shack with a single door and a window sits all alone on the edge of the island. The door is closed.\n\nTrails lead north and east.", exits = { { 'east', 'start' }, { 'north', 'room3'}, { 'door', 'shackdoor' }, { 'window', 'shackwindow' } } }
rooms['room3'] = { title = 'Hilltop', description = "You stand atop a low hill.\n\nTo the east you see a grassy clearing.  To the south is a shack.  A loose and rutted trail leads south east.", exits = { { 'east', 'room1' }, { 'south', 'room2'}, {"south east", 'start'} } }
rooms['shackdoor'] = { title = 'Door', description = "You open the door, and see a crossbow resting on a table and facing the door.\n\nYou also see a string, attaching the the crossbow's trigger to the doorknob . . .  Twang!  Oomph!\n\nYou died.", exits = {} }
rooms['shackwindow'] = { title = 'Dirty Window', description = "The window is too dirty to see through.\n\nIf you could break the window, you would be able to look inside.\n\nOh well, there is always the door.", exits = { { 'east', 'start' }, { 'north', 'room3'}, { 'door', 'shackdoor' }, { 'window', 'shackwindow' } } }


colors = { _WHITE_, }

local nextSection


nextSection = function( group, roomName, color )
	local color = color or _WHITE_

	print( group, roomName, color )

	local curRoom = rooms[roomName]	

	local tmp = display.newText( group, curRoom.title, 0, 0, maxW, 0, gameFont, 26 )
	tmp.anchorX = 0
	tmp.anchorY = 0
	local height = tmp.contentHeight
	tmp.x = 15		
	tmp.y = curY 
	curY = tmp.y + ySep + height
	tmp:setFillColor( unpack( color ) )

	if( not curRoom.visited or true) then 
		curRoom.visited = true

		local tmp = display.newText( group, curRoom.description, 0, 0, maxW, 0, gameFont, 22 )
		tmp.anchorX = 0
		tmp.anchorY = 0
		local height = tmp.contentHeight
		tmp.x = 15		
		tmp.y = curY 
		curY = tmp.y + ySep + height
		tmp:setFillColor( unpack( color ) )
	end

	local function onChoice( self, event )
		if(event.phase == "ended") then
			nextSection( group, self.toRoom, self.color )

			local maxY 	= group.contentHeight - h
			print(maxY, group.contentHeight, h, group.y )
			if(group.contentHeight > h ) then
				transition.to( group, { y = -maxY, time = 150, easing = transition.outCirc } )
			end

		end
	end

	local choiceX = 0
	local exits = curRoom.exits

	local colors = { _GREEN_, _CYAN_, _BRIGHTORANGE_, _YELLOW_, _PINK_ }


	for i = 1, #exits do
		local label  = display.newText( group, exits[i][1] , 0, 0, gameFont, 16 )
		local button = display.newRect( group, 0, 0, label.contentWidth + 30, 40 )	

		button.x = choiceX + button.contentWidth/2 + 10
		label.x  = button.x
		button.y = curY + button.contentHeight/2 + ySep
		label.y  = button.y
		label:toFront()
		label:setFillColor(0,0,0)
		button:setFillColor( unpack( colors[i] ) )
		button.color  = colors[i]
		button.toRoom = exits[i][2]

		button.touch = onChoice
		button:addEventListener( "touch" )

		if( i == #exits ) then
			curY = button.y + ySep + button.contentHeight
		end

		choiceX = choiceX + button.contentWidth + 10
	end

end


----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	screenGroup = self.view
	
	-- Create some rendering layers
	layers = ssk.display.quickLayers( screenGroup, "underlay", "background", "content", "buttons", "overlay" )
	local content = layers.content

	local backImage = imageRect( layers.underlay, centerX, centerY, 
	           "images/interface/protoBack.png", 
	           { w = 380, h = 570, rotation = tern( isLandscape, 90, 0 ) } )

	--content.x = centerX
	--content.y = 0

	nextSection( layers.content, 'start' )

	--print(content.x, content.y, round(content.contentWidth), round(content.contentHeight) )

	local function scroller( self, event )
		if( event.phase == "began" ) then
			content.x0 = content.x
			content.y0 = content.y

		elseif(event.phase == "moved") then
			local dx = event.x - event.xStart
			local dy = event.y - event.yStart

			print(dx,dy,content.y)

			content.y = content.y0 + dy 

			local maxY = content.contentHeight - h

			if(content.y < -maxY) then content.y = -maxY end
			if(content.y > 0) then content.y = 0 end

		end

		return true
	end
	backImage.touch = scroller
	backImage:addEventListener( "touch" )	

end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:show( event )
	screenGroup 	= self.view
	local willDid 	= event.phase
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:hide( event )
	screenGroup 	= self.view
	local willDid 	= event.phase
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	screenGroup = self.view

	display.remove(layers)
	layers = nil

	screenGroup = nil
end


----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
onBack = function ( event ) 
	local options =
	{
		effect = "fade",
		time = 200,
		params =
		{
			logicSource = nil
		}
	}
	composer.gotoScene( "ifc.mainMenu", options  )	

	return true
end


---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
---------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------

return scene
