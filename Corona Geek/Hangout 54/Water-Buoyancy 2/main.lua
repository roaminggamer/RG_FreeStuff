-- buoyancy sample
 
display.setStatusBar( display.HiddenStatusBar )
 
stage = display.getCurrentStage()
 
require("physics")
physics.start()
physics.setGravity(0,10)
physics.setDrawMode("hybrid")
 
-- Background and walls...
 
local left = display.newRect( -5, 0, 5, display.contentHeight )
local right = display.newRect( display.contentWidth, 0, 5, display.contentHeight )
local top = display.newRect( 0, -5, display.contentWidth, 5 )
local bottom = display.newRect( 0, display.contentHeight, display.contentWidth, 5 )
physics.addBody( left, "static" )
physics.addBody( right, "static" )
physics.addBody( top, "static" )
physics.addBody( bottom, "static" )
 
local bg = display.newRect( 0, display.contentCenterY, display.contentWidth, display.contentCenterY )
bg:setFillColor(0,0,255,100)
 
-- Creates water sensor...
 
local function newSensor(water,x,y)
        local sensor = display.newCircle( water, x, y, 5 )
        sensor:setFillColor(200,200,255)
        physics.addBody( sensor, "static", { isSensor=true, radius=5 } )
        
        local list = {}
        
        function sensor:collision(e)
                if (e.phase == "began") then
                        list[#list+1] = e.other
                elseif (e.phase == "ended") then
                        local index = table.indexOf(list,e.other)
                        table.remove(list,index)
                end
                return true
        end
        sensor:addEventListener("collision",sensor)
        
        function sensor:fire()
                sensor.alpha = .5
                for i=1, #list do
                        list[i]:applyForce( 0, -8, sensor.x, sensor.y ) -- default force applied is -8
                        sensor.alpha = 1
                end
        end
        
        return sensor
end
 
-- Keeps water sensors in front of boxes...
 
local objects = display.newGroup()
 
-- Create water sensors...
 
local water = display.newGroup()
for r=display.contentHeight/2, display.contentHeight, 30 do -- sensors spaced 30 pixels on the vertical
        for c=0, display.contentWidth, 30 do -- sensors spaced 30 pixels on the horizontal
                newSensor( water, c, r )
        end
end
 
-- Apply water effect...
 
local function fireWater()
        for i=1, water.numChildren do
                water[i]:fire()
        end
end
timer.performWithDelay(200,fireWater,0) -- force against the boxes applied 5 times a second
 
-- Create demo box...
 
local density = .1 -- boxes have very low density
local box = display.newRect( objects, 0, 0, 200, 100 )
box.x, box.y, box.rotation = display.contentCenterX, 100, 0
physics.addBody( box, "dynamic", { density=density } )
box.angularDamping = 1 -- stops the boxes from spinning wildly
box.linearDamping = .5 -- stops boxes from dropping or rising too quickly
 
-- Create boxes....
 
local function touch(e)
        if (e.phase == "began") then
                local box = display.newRect( objects, e.x, e.y, 1, 1 )
                stage:setFocus(box)
                box.hasFocus = true
                box:addEventListener("touch",touch)
                return true
        elseif (e.target.hasFocus) then
                if (e.phase == "moved") then
                        e.target.width = math.abs(e.x-e.xStart)
                        e.target.height = math.abs(e.y-e.yStart)
                        e.target.x = (e.x+e.xStart)/2
                        e.target.y = (e.y+e.yStart)/2
                else -- ended, cancelled
                        stage:setFocus(nil)
                        e.target.hasFocus = false
                        physics.addBody( e.target, "dynamic", { density=density } )
                        e.target.angularDamping = box.angularDamping -- stops the boxes from spinning wildly
                        e.target.linearDamping = box.linearDamping -- stops boxes from dropping or rising too quickly
                end
                return true
        end
        return false
end
Runtime:addEventListener("touch",touch)