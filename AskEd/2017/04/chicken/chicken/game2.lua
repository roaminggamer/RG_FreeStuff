---REQUIRES
local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local physics = require "physics"

local lanes = {}
local laneID = 1

local scroll = 2 -- EFM

local RightSide  	-- EFM
local LeftSide 	-- EFM
local rightLabel  -- EFM
local leftLabel   -- EFM
local path1   		-- EFM
local path2  		-- EFM

----------------------
----------------------

function scene:destroy(  ) -- EFM
	RightSide = nil
	LeftSide = nil
	rightLabel = nil
	leftLabel = nil
	path1 = nil
	path2 = nil
end

---CREATE 
-- Initialize the scene here.
-- Example: add display objects to "sceneGroup", add touch listeners, etc.

function scene:create(  )
	local group = self.view

	local background 	= display.newGroup() -- EFM
	local road 		  	= display.newGroup() -- EFM
	local content 		= display.newGroup() -- EFM
	local interface  	= display.newGroup() -- EFM

	group:insert(background)
	group:insert(road)
	group:insert(content)
	group:insert(interface)
	



	---TAP BACKGROUND
	RightSide = display.newImageRect(background, "fillT.png", fullw/2, fullh ) -- EFM
	RightSide.anchorX  = 1 -- EFM
	RightSide.x        = right -- EFM
	RightSide.y        = centerY -- EFM
	
	function RightSide.tap( self, event ) -- EFM
		print("Tapped Right Side")
		if laneID < 3 then
			laneID = laneID + 1;
			transition.cancel(chick)
			local function onComplete()
				print( "At lane " .. laneID .. " to the right" )
			end
			transition.to( chick, { x = lanes[laneID].x, time = 50, onComplete = onComplete } )
			
		end
		return true
	end


	
	LeftSide = display.newImageRect(background, "fillT.png", fullw/2, fullh ) -- EFM
	LeftSide.anchorX  = 0 -- EFM
	LeftSide.x        = left -- EFM
	LeftSide.y        = centerY -- EFM
	LeftSide.name 		= "Left Side" -- EFM
	
	function LeftSide.tap( self, event ) -- EFM
		print("Tapped Left Side")
		if laneID > 1 then
			laneID = laneID - 1;
			transition.cancel(chick)
			local function onComplete()
				print( "At lane " .. laneID .. " to the left" )
			end
			transition.to( chick, { x = lanes[laneID].x, time = 50, onComplete = onComplete } )
			
		end
		return true
	end
	----------------------

	---TAP LABEL
	rightLabel = display.newText( { text = "", x = 0, y = 0 , fontSize = 50 } )
	interface:insert( rightLabel)
	rightLabel:setTextColor( 0 )
	rightLabel.x = 500
	rightLabel.y = centerY
		 
	leftLabel = display.newText( { text = "", x = 0, y = 0, fontSize = 50 } )
	interface:insert( leftLabel )
	leftLabel:setTextColor( 0 )
	leftLabel.x = 150
	leftLabel.y = centerY
	----------------------

	---PATHWAY (BACKGROUND)
	path1 = display.newImageRect( road, "road.png", fullw, fullh )
	path1.x = centerX
	path1.y = centerY

	path2 = display.newImageRect( road, "road.png", fullw, fullh )
	path2.x = centerX
	path2.y = centerY - fullh 
	----------------------

	---LANES
	for i = 1, 3 do -- loop 3 times to create 3 lanes for our game
	    laneimg = display.newImageRect( road, "lanesroad.png", 150, 1300 ) -- EFM
	    	lanes[i] = laneimg
	    	lanes[i].x = (display.contentCenterX - 140*2) + (i*140)
	    	lanes[i].y = display.contentCenterY
	    	lanes[i].id = i
	end
	----------------------

	---CHICK
	chick = display.newImageRect( content, "chick.png",100,100)
	chick.anchorY = 1
	chick.x = lanes[2].x
	chick.y = bottom
	physics.addBody( chick, "dynamic" ) 
	
	----------------------
	
end

----------------------


---BACKGROUND SCROLL
function pathScroll (self,event)
    path1.y = path1.y + scroll
    path2.y = path2.y + scroll

    if path1.y == fullh * 1.5 then
        path1.y = fullh * -.5
    end
 
    if path2.y == fullh * 1.5 then
        path2.y = fullh * -.5
    end
end
----------------------


-- EFM HAS TWO PHASES >>> "will" and "did"
---SHOW --that will show in scene
function scene:show (event)

	if( event.phase == "will" ) then
	
	elseif( event.phase == "did" ) then

		---FOR ROAD TO SCROLL
		path1.enterFrame = pathScroll
		Runtime:addEventListener("enterFrame", pathScroll)
		path2.enterFrame = pathScroll
		Runtime:addEventListener("enterFrame", pathScroll)
		----------------------

		---WHEN TAP TO RIGHT
		RightSide:addEventListener( "tap" )
		rightLabel.text = "right"
		----------------------

		---WHEN TAP TO LEFT
		LeftSide:addEventListener( "tap" )
		leftLabel.text = "left"
		----------------------
	end

end
----------------------

---HIDE 
function scene:hide (event)

	if( event.phase == "will" ) then

		Runtime:removeEventListener("enterFrame", pathScroll)
		Runtime:removeEventListener("enterFrame", pathScroll)
		
		RightSide:removeEventListener( "tap" )
		LeftSide:removeEventListener( "tap" )
	
	elseif( event.phase == "did" ) then

	end

end
----------------------

scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )
scene:addEventListener( "enter", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )


return scene
