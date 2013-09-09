-------------------------------------------------------------------------------------------------------
--------------------------------  *** WATER BUOYANCY EXAMPLE ***  -------------------------------------
-------------------------------------------------------------------------------------------------------

-- By iNSERT.CODE - http://insertco.de/
-- Version: 1.0
-- 
-- Sample code is MIT licensed

-- Thanks to anyone who has had input in this code on the Corona SDK Forums
-- Particularly 'horacebury'

-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------


-- HIDE STATUS BAR

display.setStatusBar(display.HiddenStatusBar)


-- INIT PHYSICS
local physics = require("physics")
physics.start()
physics.setGravity( 0, 100 )
physics.setDrawMode( "hybrid" ) 
local gx, gy = physics.getGravity()
 
 
-- FORWARD REFS

local _W = display.contentWidth
local _H = display.contentHeight

local ground, ceiling, leftWall, rightWall

local liquidLevel


-------------------------------------------------------------------------------------------------------
-----------------------------------------  *** SETTINGS ***  ------------------------------------------
-------------------------------------------------------------------------------------------------------


local liquidDensity = 1.0 	-- Sets the desnity of the liquid (e.g. 1.0 default = water, 2.5 = oil etc)

local numberOfBoxes = 5		-- Sets the number of boxes

local boxSize = 80 			-- Sets the size of the boxes


-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------

 
 
-- CREATE SCREEN BOUNDARY
 
ground = display.newRect(0,0,_W,20)
ground.x = _W * 0.5; ground.y = _H + (ground.height * 0.5)
 
ceiling = display.newRect(0,0,_W,20);
ceiling.x = _W * 0.5; ceiling.y = 0 - (ceiling.height * 0.5)
 
leftWall = display.newRect(0,0,10,_H)
leftWall.x = 0 - (leftWall.width * 0.5); leftWall.y = _H * 0.5
 
rightWall = display.newRect(0,0,10,_H)
rightWall.x = _W + (rightWall.width * 0.5); rightWall.y = _H * 0.5
 
physics.addBody(ground, "static", {friction = 0.1})
physics.addBody(ceiling, "static", {friction = 0.1})
physics.addBody(leftWall, "static", {friction = 0.1})
physics.addBody(rightWall, "static", {friction = 0.1})
 
 
-- CREATE 'BOXES' DISPLAY GROUP & BOXES
 
-- A display group we can loop through -
-- works just like a table, but allows us to perform other display functions upon the boxes as well.
-- Be sure to use boxes.numChildren instead of #boxes when getting the number of boxes in the group,
-- but otherwise it works just like a table (which is really just an array)

local boxes = display.newGroup()
 

-- It adds that box to the 'boxes' display group

local function addBox()
	
        local box = display.newRect( boxes, 0, 0, boxSize, boxSize)
        
        box.x = math.random(50, _W - 50); box.y = math.random(50, _W / 3)
        box.area = box.height * box.width
        box.density = 3.0
        box.mass = box.area * box.density
        
        box:setFillColor( math.random(0,255), math.random(0,255), math.random(0,255) )
        
        physics.addBody( box, { density=3.0, friction=0.5 } )
    
end

 
 
-- CREATE SET NUMBER OF BOXES (DEFINED IN SETTINGS ABOVE)

for i=1, numberOfBoxes do
        addBox()
end
 
 
-- CREATE LIQUID
 
local liquid = display.newRect(0, 0, _W, _H * 0.5)
 
liquid:setFillColor(0, 102, 255)
liquid.alpha = 0.3
liquid:setReferencePoint(display.TopCenterReferencePoint)
liquid.x = _W * 0.5
liquid.y = _H * 0.5
 
 
-- TOUCH TO DRAG FUNCTION
                
local function dragBody(e)
        local body = e.target
        local phase = e.phase
        local stage = display.getCurrentStage()
        
        if(phase == "began") then
                stage:setFocus(body, e.id)
                body.isFocus = true
                body.tempJoint = physics.newJoint("touch", body, e.x, e.y)
        elseif(phase == "moved") then
                if(body.tempJoint ~= nil) then
                        body.tempJoint:setTarget(e.x, e.y)
                end
        elseif(phase == "ended" or phase == "cancelled") then
                if(body.tempJoint ~= nil) then
                        stage:setFocus(body, nil)
                        body.isFocus = false
                        body.tempJoint:removeSelf()
                        body.tempJoint = nil
                end
        end
 
        return true
end
 

-- LOOP TO MAKE ALL BOXES DRAGGABLE

for i=1, boxes.numChildren do
        boxes[i]:addEventListener("touch", dragBody)
end
 
 
-- FLOAT/BUOYANCY FUNCTION
 
local function float()
        for i=1, boxes.numChildren do -- LOOP TO APPLY FORCES TO EACH BOX INDIVIDUALLY
                
				-- get the box from the display group
                local box = boxes[i]
                
                -- apply forces to box
                if (box.y + (box.height * 0.5)) >= liquid.y then
                        
						local submergedPercent = math.floor (100 - (((liquid.y - box.y + (box.height * 0.5)) / box.height) * 100))
                        
						if submergedPercent > 100 then
                                submergedPercent = 100
                        end
                        
                        if submergedPercent > 1 then
                                
								local buoyancyForce = (box.mass * gy)
                                box:applyForce( 0, buoyancyForce * -0.002, box.x, box.y )
                                
								box.linearDamping = 10 -- 4 * liquidDensity
								box.angularDamping = 0 -- 5 * liquidDensity
                        else
                                box.linearDamping = 0
                                box.angularDamping = 0
                        end     
                end     
        end     
end
 
Runtime:addEventListener( "enterFrame", float )