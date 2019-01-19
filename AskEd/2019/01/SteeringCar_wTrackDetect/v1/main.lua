local math2d = require "RGMath2D"

local getTimer = system.getTimer

local cx     = display.contentCenterX
local cy     = display.contentCenterY
local fullw  = display.actualContentWidth
local fullh  = display.actualContentHeight
local left   = cx - fullw/2
local right  = cx + fullw/2
local top    = cy - fullh/2
local bottom = cy + fullh/2

local carW  = 12
local carH  = 20
local aheadOffset = 2

local movePPS   = 75 -- Move at this many piexls-per-second
local rotateDPS = 90 -- Rotate at this many degrees-per-second
local speedMultiplier = 1

local carMover = function( self, event )

    if( self.lastTime == nil ) then
        self.lastTime = getTimer()
        return
    end

    local curTime   = getTimer()
    local dt        = curTime - self.lastTime 
    self.lastTime = curTime

    dt = dt/1000

    local rotateBy  = dt * rotateDPS * self.dr
    local moveBy    = dt * movePPS

    self.rotation = self.rotation + rotateBy
    if(self.rotation > 360) then self.rotation = self.rotation - 360 end
    if(self.rotation < 0) then self.rotation = self.rotation + 360 end

    local vec = math2d.angle2Vector( self.rotation, true )
    vec = math2d.scale( vec, moveBy * speedMultiplier )

    self.x = self.x + vec.x
    self.y = self.y + vec.y
end

local function onTouchSteer( self, event )
    local phase = event.phase
    local x = event.x
    local y = event.y

    if( phase == "ended" ) then
        self.dr = 0
    else
        if( x < cx ) then
            self.dr = -1
        else
            self.dr = 1
        end
    end
end


local function makeCar( x, y )
    local car = display.newRect( 0, 0, carW, carH )
    car:setFillColor( 0.2, 0.2, 0.2 )
    car.strokeWidth = 2
    
    car.x = x    
    car.y = y

    car.dr = 0 

    car.enterFrame = carMover
    Runtime:addEventListener( "enterFrame", car );

    car.touch = onTouchSteer
    Runtime:addEventListener( "touch", car );

    -- Car Track Sampling Code
    local onColorSampleEvent
    onColorSampleEvent = function ( event )
        local r,g,b = event.r, event.g, event.b
        local colorString = tostring(r)..tostring(g)..tostring(b)

        --print( "Sampling result, at position: " .. event.x .. " " .. event.y .. " The color is: " .. r .. " " .. g .. " " .. b .. " " .. event.a )

        --car:setFillColor( r,g,b )
        timer.performWithDelay( 1, function() car:sampleAheadOfCar() end )

        if( colorString == "010" ) then
            speedMultiplier = 2
        elseif( colorString == "110" ) then
            speedMultiplier = 0.5
        elseif( colorString == "100" ) then
            speedMultiplier = 0.25
        else
            speedMultiplier = 1
        end

    end
    function car.sampleAheadOfCar( self )
        local vec = math2d.angle2Vector( self.rotation, true )
        vec = math2d.scale( vec, carH/2 + aheadOffset )
        display.colorSample( car.x + vec.x, car.y + vec.y, onColorSampleEvent ) 
    end
    car:sampleAheadOfCar() 

    return car
end


-- Create some blocks to slow/speed car
local block = display.newRect( cx, cy + 100, 200, 80 )
block:setFillColor(1,1,0)

local block = display.newRect( cx, cy, 200, 80 )
block:setFillColor(0,1,0)

local block = display.newRect( cx, cy - 100, 200, 80 )
block:setFillColor(1,0,0)




local myCar = makeCar( cx, 440 )
