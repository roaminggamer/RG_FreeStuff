local math2d = require "RGMath2D"

local getTimer = system.getTimer

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local movePPS   = 50 -- Move at this many piexls-per-second
local rotateDPS = 90 -- Rotate at this many degrees-per-second

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
    vec = math2d.scale( vec, moveBy )

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
        if( x < centerX ) then
            self.dr = -1
        else
            self.dr = 1
        end
    end
end

local function makeCar( x, y )
    local car = display.newRect( 0, 0, 15, 24 )
    car:setFillColor( 1, 1, 0 )
    
    car.x = x    
    car.y = y

    car.dr = 0 

    car.enterFrame = carMover
    Runtime:addEventListener( "enterFrame", car );

    car.touch = onTouchSteer
    Runtime:addEventListener( "touch", car );

    return car
end


local myCar = makeCar( centerX, 440 )
