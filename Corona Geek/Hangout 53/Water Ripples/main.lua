local screenW, screenH = display.contentWidth, display.contentHeight
local PI = 3.14159265
local GRAVITY = 9.8066
local surfaceLevel = screenH - 200
local surfaceLength = screenW
local lastTime = 0

-- Setup Physics
physics = require( "physics" )
physics.start()
--physics.setDrawMode("hybrid")

-- Setup tables
physicsObjectTable = {}; 	-- Contains all the physics object that need updated
u = {}   					-- height field
uNew = {}   				-- next height field
v = {}						-- velocity field
lines = {}					-- graphic lines

-- Changing below variables change the behaviour of the water
-- BEWARE! The surface will go unstable with the wrong values!
C = 0.99 -- Wave speed  
h = 2.0 / (surfaceLength-1)
hSq = h*h
dt = (C*h) -- dt must be less than h / c or c < h / dt or water is unstable
umax = 0.69 -- Clamp the height of the waves (choppiness of water)
rho = 2.0 -- density of water
mass = 0.004 -- mass of boxes

-- Initialise the arrays
for i=1, surfaceLength do
  lines[i] = nil
  u[i] = 0.0
  uNew[i] = 0.0
  v[i] = 0.0
end

function onRender(event)
	local timePassed = event.time - lastTime
	lastTime = lastTime + timePassed
	
	updateTimeLoop()
	average()
	
	-- update all the physics bodies, not very efficent!
	for i, body in ipairs(physicsObjectTable) do
		if(body.isBodyActive) then
      		updateBody(body)
      	end
    end
    
	drawWaterSurface()
	
	--oscillator(0,0.005,2) -- Uncomment for wave generator at water edge
end

-- Has the shape hit the water?
function checkBodyCollision(shape)
	index =  math.round(shape.x + shape.width/2)
	shapeBottom = shape.y + (0.5 * shape.height)
	waveBottom =  u[index]*10000
	if  shapeBottom + waveBottom > surfaceLevel then
		return true  -- shape is below the water surface
	else
		return false
	end 
end

-- Updates a shape making a ripple when the shape hits the water and updating the ripple afterwards
function updateBody(shape)
	-- upward velocity is sensitive to mass value so may want to clamp forces to stop jumping out of water
	-- Good values 0.01 or less!
	bodyXStart = math.round(shape.x - (shape.width/2))
	
	if(bodyXStart > surfaceLength - 100 or bodyXStart < 10) then
		return
	end
	
	-- Simulate size of the ripple based on the displacement from the water level
    -- Note this does not add how much of the object is below the surface level so body sinks
	if(shape.inWater) then	
		displacement = 0
		
		if(shape ~= nil and shape.width ~= nil) then
		
			for i=2,shape.width do
				displacement = displacement + u[bodyXStart+i] 
			end
		end
			
		forceUp = displacement * -1 * rho * GRAVITY
		forceDown = mass*GRAVITY
		
		if(forceUp > 0.1) then
			forceUp = 0.1
		end
		
		resultantForce = forceUp - forceDown
		bodyImpulse = -forceUp
		shape:applyLinearImpulse( 0, bodyImpulse, shape.x, shape.y) -- Apply force to body
		applyForce(shape,bodyXStart,shape.width,-resultantForce,1) -- Apply force to water surface	
	end
	
	if(shape.y > screenH+10000) then -- When to stop ripple
		shape.inWater = false
	elseif(shape.inWater ~= true) then 
		if(checkBodyCollision(shape)) then
			vx, vy = shape:getLinearVelocity()
			applyForce(shape,shape.x,shape.width,mass,vy) -- Impact force to simulate body hit water
			shape:applyLinearImpulse( 0, -3, shape.x, shape.y) -- Impact impulse to simulate body slow down
			shape.inWater = true
		end
		
	end
	
end

-- Calculate shape's momentum (f=vm) and apply the force to each column below it
-- This creates the inital ripple
function applyForce(shape,index,length,mass,vy)

	if(vy == nil or shape == nil or index == nil or length == nil) then
		return
	end
	
	columnForce = (vy * mass) / length
	
	if(shape.width ~= nil and shape.x ~= nil) then
		for i=2,shape.width do
			if(v[shape.x+i] ~= nil) then
				v[shape.x+i] = v[shape.x+i] - columnForce
			end
		end
	end 
end

function displayWater()
	for i=1,size do		
		if (lines[i] ~= nil) then
			lines[i]:removeSelf()
		end
		lines[i] = display.newLine(  i,250, i,y[i] )
	end
end

function drawWaterSurface()
	for i=1,surfaceLength do
		if (lines[i] ~= nil) then
			lines[i]:removeSelf() -- Not very efficient :-(
		end
		
		lines[i] = display.newLine(  i,surfaceLevel - (u[i]*10000), i,screenH) -- WTF BUG is reason not drawing 500 to 500 -- Corona can't draw straight lines
		lines[i]:setColor(100, 100, 200)
	end
end

local function onTouchScreen(event)
	index = math.round(event.x)
	y = calculateGaussian(40,-20)
	val = 0
	if(index > 40) then
		uMax = 0.3
		for i=1,40 do			
			if(y[i] < 0.7) then
				val = (uMax/0.7) * y[i] -- Two thirds
			else
				val = (uMax/0.3) * (1-y[i]) -- one third
			end 		
			u[index + i] = val			
		end
	end
end


xOsc= 0
function oscillator(index,amplitude,frequency)
	y = math.sin(xOsc*frequency ) * amplitude
	xOsc = xOsc + 0.05
	if(xOsc > 2*PI) then
		xOsc = 0
	end
	
	for i=1,20 do		
			u[index+i] = y 					
	end
end

function updateTimeLoop(time)	
	for i=2,surfaceLength-1 do		
		f = (C*C) * ((u[i-1] + u[i+1] - 2*u[i])/hSq) 
		v[i] = v[i] + f*dt
		
		if(v[i] >0.1) then
			v[i] = v[i] + (0.001* dt)
		end
		uNew[i] = u[i] + v[i] * dt
	end

	uNew[1] = 0
	uNew[surfaceLength] = 0
	
	for i=1,surfaceLength do
		u[i] = uNew[i]
	end
	clampU()
end

function clampU()
	for i=1,surfaceLength do
			
		if(u[i] < 0.7) then
			val = (umax/0.7) * u[i]
		else
			val = (umax/0.3) * (1-u[i])
		end 		
		u[i] = val		
	end
end

function calculateGaussian(size,sigma)
	y = {}
	for x=1,size do
		left = 1.0 / (sigma * math.sqrt(2.0*PI) )
		right =  math.exp(   (x*x*-1)/(2.0*sigma*sigma) )
		y[x] = (left * right)
	end
	return y
end

function average()
	for i=2,surfaceLength-1 do
		u[i] = (u[i-1] + u[i] + u[i+1]) / 3
	end
end

function dropBox()
	y = math.random( 600 )
	x= math.random( screenW -200) + 100 -- Constants here to drop away from edges
	body = display.newRect(x, surfaceLevel-y-50, 20, 20)
	physics.addBody( body, { density=1.0, friction=1.0} )
	body.inWater = false
	table.insert(physicsObjectTable,body)
end

Runtime:addEventListener("enterFrame", onRender)
Runtime:addEventListener("touch",onTouchScreen)
timer.performWithDelay( 1000, dropBox, 20 ) -- drop 20 boxes at one second intervals
