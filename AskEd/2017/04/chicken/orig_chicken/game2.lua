---REQUIRES
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local physics = require "physics"
physics.start()
physics.setGravity(0,0)
local lanes = {}
local laneID = 1

scroll = 2

	---SIZE PHONE DECLARATION

	local screenW = display.contentWidth --640
	local screenH = display.contentHeight --1136
	local halfX = display.contentWidth * 0.5 --half width 320
	local halfY = display.contentHeight * 0.5 --half height 568

	----------------------
----------------------

---WHEN TAP CHICK MOVE
local function tapListener( event )
 	local object = event.target
	   if object.name == "Right Side" then
	   	print( object.name.." TAPPED!" )
	   		if laneID < 3 then
	   		laneID = laneID + 1;
	   		transition.to(chick, {x=lanes[laneID].x,time=50})
	   		print( "At lane "..laneID.." to the right")
	   		end
	   	return true
	   end

	   if object.name == "Left Side" then
	   	print( object.name.." TAPPED!" )
		   	if laneID > 1 then
		  	laneID = laneID - 1;
		   	transition.to(chick, {x=lanes[laneID].x,time=50})
		   	print( "At lane "..laneID.." to the left")
	   		end
    	return true
    	end
end
	----------------------

---CREATE 
-- Initialize the scene here.
-- Example: add display objects to "sceneGroup", add touch listeners, etc.

function scene:create(  )
	local group = self.view

	---TAP BACKGROUND
	RightSide = display.newRect(group, 500,halfY, halfX+50, screenH + 100 )
	RightSide.alpha = 0.1
	RightSide.name = "Right Side"

	LeftSide = display.newRect(group, 140, halfY,halfX+50, screenH + 100)
	LeftSide.alpha = 0.1
	LeftSide.name = "Left Side"
	----------------------

	---TAP LABEL
	rightLabel = display.newText({ text = "", x = 0, y = 0 , fontSize = 50 } )
	rightLabel:setTextColor( 0 ) ; rightLabel.x = 500 ;rightLabel.y = halfY
	 
	leftLabel = display.newText({ text = "", x = 0, y = 0, fontSize = 50 } )
	leftLabel:setTextColor( 0 ) ; leftLabel.x = 150 ; leftLabel.y = halfY
	----------------------

	---PATHWAY (BACKGROUND)
	path1 = display.newImageRect(group, "road.png",screenW,screenH)
    path1.x = halfX
    path1.y = halfY

	path2 = display.newImageRect(group, "road.png",screenW,screenH)
    path2.x = halfX
    path2.y = halfY - screenH 
	----------------------

	---LANES
	for i=1,3 do -- loop 3 times to create 3 lanes for our game
		--myGroup=display.newGroup()
	    laneimg = display.newImageRect("lanesroad.png", 150, 1300)
	    	lanes[i] = laneimg
	    	lanes[i].x = (display.contentCenterX - 140*2) + (i*140)
	    	lanes[i].y = display.contentCenterY
	    	lanes[i].id = i
	end
	----------------------

	---CHICK
   	chick = display.newImageRect("chick.png",100,100)
    chick.anchorY = 1
    chick.x = lanes[2].x
    chick.y = 1000
    physics.addBody(chick) 
	chick.bodyType = "dynamic"
	
	----------------------

	

path1:toBack();
path2:toBack();
--group:insert( RightSide )
--group:insert( LeftSide )
group:insert( rightLabel )
group:insert( leftLabel )
group:insert( laneimg)
group:insert( chick )

end

----------------------


---BACKGROUND SCROLL
function pathScroll (self,event)
    path1.y = path1.y + scroll
    path2.y = path2.y + scroll

    if path1.y == screenH * 1.5 then
        path1.y = screenH * -.5
    end
 
    if path2.y == screenH * 1.5 then
        path2.y = screenH * -.5
    end
end
----------------------


---SHOW --that will show in scene
function scene:show (event)

---FOR ROAD TO SCROLL
path1.enterFrame = pathScroll
Runtime:addEventListener("enterFrame", pathScroll)
path2.enterFrame = pathScroll
Runtime:addEventListener("enterFrame", pathScroll)
----------------------

---WHEN TAP TO RIGHT
RightSide:addEventListener( "tap", tapListener )
rightLabel.text = "right"
----------------------

---WHEN TAP TO LEFT
LeftSide:addEventListener( "tap", tapListener )
leftLabel.text = "left"
----------------------

end
----------------------

---HIDE 
function scene:hide (event)



end
----------------------

scene:addEventListener( "create", scene )
scene:addEventListener( "enter", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )


return scene
