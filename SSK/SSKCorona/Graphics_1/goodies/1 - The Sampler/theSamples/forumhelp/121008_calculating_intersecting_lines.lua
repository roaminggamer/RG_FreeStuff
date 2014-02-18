-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- Template #2
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
-- 
-- =============================================================

--local debugLevel = 2 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------

-- Variables
local myCC   -- Local reference to collisions Calculator
local layers -- Local reference to display layers 
local backImage
local thePlayer

-- Fake Screen Parameters (used to create visually uniform demos)
local screenWidth  = w
local screenHeight = h
local screenLeft   = centerX - screenWidth/2
local screenRight  = centerX + screenWidth/2
local screenTop    = centerY - screenHeight/2
local screenBot    = centerY + screenHeight/2

-- Local Function & Callback Declarations
local createCollisionCalculator
local createLayers
local addInterfaceElements

local currentExample = 1
local exampleSelector
local stepSelector

local exButton1
local stepButton1

local clearLabels
local ex_step = { {}, {}, {}, {}, {}, {} }

local anArrow1
local anArrow2
local anArrow3

local speedLabel1
local speedLabel2

local collisionLabel
local collisionPoint

local aCircle
local aPoint

local gameLogic = {}

-- =======================
-- ====================== Initialization
-- =======================
function gameLogic:createScene( screenGroup )

	-- 1. Create collisions calculator and set up collision matrix
	createCollisionCalculator()

	-- 2. Set up any rendering layers we need
	createLayers( screenGroup )

	-- 3. Add Interface Elements to this demo (buttons, etc.)
	addInterfaceElements()

	-- 4. Set up gravity and physics debug (if wanted)
	physics.setGravity(0,0)
	--physics.setDrawMode( "hybrid" )
	screenGroup.isVisible=true
	
	-- 5. Add demo/sample content
end

-- =======================
-- ====================== Cleanup
-- =======================
function gameLogic:destroyScene( screenGroup )
	-- 1. Clear all references to objects we (may have) created in 'createScene()'	

	layers:destroy()
	layers = nil
	myCC = nil
	thePlayer = nil

	-- 2. Clean up gravity and physics debug
	physics.setDrawMode( "normal" )
	physics.setGravity(0,0)
	screenGroup.isVisible=false

--	ssk.gem:remove("myHorizSnapEvent", joystickListener)
end


-- =======================
-- ====================== Local Function & Callback Definitions
-- =======================
createCollisionCalculator = function()
	--myCC = ssk.ccmgr:newCalculator()
	--myCC:addName("aSphere")
	--myCC:addName("aPoint")
	--myCC:dump()
end


createLayers = function( group )
	layers = ssk.display.quickLayers( group, 
		"background", 
		"content",
		"interfaces", 
			{ "exampleRadios", "stepRadios" } )
end

addInterfaceElements = function()
	-- Add background 
	--backImage = ssk.display.backImage( layers.background, "starBack_380_570.png") 

	-- Add Example Selection Radios and Text
	local tmpLabel
	local tmpButton
	local buttonTable = {}
	tmpLabel = ssk.labels:presetLabel( layers.interfaces, "default", "Example:", 0, 70, { fontSize = 16 }  )
	tmpLabel.x = tmpLabel.width / 2 + 10

	local buttonX = tmpLabel.x
	local buttonY = tmpLabel.y + 40
	for i = 1, 6 do
		tmpButton = ssk.buttons:presetRadio( layers.exampleRadios, "blueGreenGradient", 
		                                     buttonX, buttonY + (i-1) * 32, 60, 30, 
											i, exampleSelector )	
		buttonTable[i] = tmpButton
	end

	exButton1 = buttonTable[1]
	buttonTable = {}

	-- Add Example Step Radios and Text
	tmpLabel = ssk.labels:presetLabel( layers.interfaces, "default", "Step:", 0, 70, { fontSize = 16 }  )
	tmpLabel.x = w-tmpLabel.width - 10

	buttonX = tmpLabel.x
	buttonY = tmpLabel.y + 40
	for i = 1, 3 do
		tmpButton = ssk.buttons:presetRadio( layers.stepRadios, "blueGreenGradient", 
		                                     buttonX, buttonY + (i-1) * 42, 60, 40, 
											i, stepSelector )	
		buttonTable[i] = tmpButton
	end

	stepButton1 = buttonTable[1]
	buttonTable = {}
	
	
	exButton1:toggle()


end	

exampleSelector = function( event )
	currentExample = tonumber(event.target:getText())
	--dprint(2, event.phase .. SPC .. "example: " .. currentExample )
	stepButton1:toggle()
end


stepSelector = function( event )
	local currentStep = tonumber( event.target:getText() )
	--dprint(2, event.phase .. SPC .. "step: " .. currentStep )

	if(event.phase == "ended") then
		local curCB = ex_step[currentExample][currentStep]
		curCB(currentExample)
	end
	return true	
end

clearLabels = function()
	if( anArrow1 and anArrow1.removeSelf ) then
		anArrow1:removeSelf()
		anArrow2:removeSelf()
		--anArrow3:removeSelf()
		aCircle:removeSelf()
		aPoint:removeSelf()
		speedLabel1:removeSelf()
		speedLabel2:removeSelf()

		if(collisionLabel) then
			dprint(2,"remove")
			collisionLabel:removeSelf()
			collisionLabel = nil

		end

		if(collisionPoint) then
			collisionPoint:removeSelf()
			collisionPoint = nil
		end
	end
end


---------------------- 1
---------------------- 1
---------------------- 1
ex_step[1][1] = function ()
	dprint(2,"Ex 1 Step 1" )

	clearLabels()

	local A_startX = centerX-75
	local A_startY = centerY+100
	local A_angle  = 25
	local A_radius = 20

	local B_startX = centerX+75
	local B_startY = centerY+100
	local B_angle  = -35
	local B_radius = 1

	anArrow1 = ssk.display.arrow2( layers.content, A_startX, A_startY, A_angle, 230, { color = _BLUE_ , width = 2} )
	aCircle  = ssk.display.circle( layers.content, A_startX, A_startY, { radius = A_radius, fill = _TRANSPARENT_, stroke = _WHITE_, strokeWidth = 1 } )
	aCircle.moveTime = 6
	aCircle.radius = A_radius

	anArrow2 = ssk.display.arrow2( layers.content, B_startX, B_startY, B_angle, 230, { color = _BLUE_ , width = 2} )
	aPoint   = ssk.display.circle( layers.content, B_startX, B_startY, { radius = B_radius, fill = _WHITE_, stroke = _WHITE_, strokeWidth = 1 } )
	aPoint.moveTime = 6
	aPoint.radius = B_radius

--	local nx,ny = ssk.math2d.angle2Vector( anArrow2.angle - 90)
--	nx,ny = ssk.math2d.scale(nx, ny, 15)
--	nx,ny = ssk.math2d.add( anArrow2.cx, anArrow2.cy, nx, ny)
--	anArrow3 = ssk.display.arrow( layers.content, anArrow2.cx, anArrow2.cy, nx, ny )

	local A_vLen = ssk.math2d.length(anArrow1.vx, anArrow1.vy)
	local A_pps  = A_vLen / aCircle.moveTime -- pixels / seconds
	aCircle.pps = round(A_pps,0)

	local B_vLen = ssk.math2d.length(anArrow2.vx, anArrow2.vy)
	local B_pps  = B_vLen / aPoint.moveTime -- pixels / seconds
	aPoint.pps = round(B_pps,0)

	speedLabel1 = ssk.labels:presetLabel( layers.interfaces, "default", "Circle speed: " .. aCircle.pps .. " pps", centerX - 75, h - 20, { fontSize = 14 }  )
	speedLabel2 = ssk.labels:presetLabel( layers.interfaces, "default", "Point speed: " .. aPoint.pps .. " pps", centerX + 75, h - 20, { fontSize = 14 }  )

	return true
end

ex_step[1][2] = function(currentExample)

	local curSetup = ex_step[currentExample][1]
	curSetup()

	dprint(2,"Ex 1 Step 2" )

	-- Step 1 -> Set up varibles for calculations
	local Pa = { x = aCircle.x , y = aCircle.y }
	local Pb = { x = aPoint.x  , y = aPoint.y }

	dprint(2,"Pa = ", Pa.x, Pa.y)
	dprint(2,"Pb = ", Pb.x, Pb.y,NL)

	local Va = ssk.math2d.angle2Vector( anArrow1.angle, true )
	Va = ssk.math2d.scale(Va, aCircle.pps)
	Va.x = round(Va.x, 4)
	Va.y = round(Va.y, 4)
	dprint(2,"Va = ", Va.x, Va.y)

	local Vb = ssk.math2d.angle2Vector( anArrow2.angle, true )
	Vb = ssk.math2d.scale(Vb, aPoint.pps)
	Vb.x = round(Vb.x, 4)
	Vb.y = round(Vb.y, 4)

	dprint(2,"Vb = ", Vb.x, Vb.y,NL)
	
	local Ra = aCircle.radius
	local Rb = aPoint.radius

	dprint(2,"Ra = ", Ra)
	dprint(2,"Rb = ", Rb,NL)

    local Pab = ssk.math2d.sub(Pb, Pa)
	Pab.x = round(Pab.x, 4)
	Pab.y = round(Pab.y, 4)
	dprint(2,"Pab = ", Pab.x, Pab.y,NL)

	local Vab = ssk.math2d.sub(Vb, Va)
	Vab.x = round(Vab.x, 4)
	Vab.y = round(Vab.y, 4)
	dprint(2,"Vab = ", Vab.x, Vab.y,NL)


	-- Step 2 -> Set up functions for quadratic roots and discriminant
	local function root_a()
		return ssk.math2d.dot( Vab, Vab )
	end

	local function root_b()
		return 2 * ssk.math2d.dot( Pab, Vab )
	end

	local function root_c()
		local Pab = ssk.math2d.sub(Pb, Pa)
		local Rab2 = (Ra + Rb)

		Rab2 = Rab2 * Rab2
		dprint(2,"Rab2 = ", Rab2)

		return ssk.math2d.dot( Pab, Pab ) - Rab2
	end

	local function d_0_time(a,b)
		local t = -(b/ (2 * a))
		return t
	end

	local function d_positive_time(a,b,discrminant)
		local discrminant_square_root = math.sqrt(discrminant)
		local t0 = (-b - discrminant_square_root ) / (2 * a)
		local t1 = (-b + discrminant_square_root ) / (2 * a)
		dprint(2,"Dual intersection times: ", t0, t1)
		if(t0 < t1) then
			return t0
		end

		return t1
	end

	local function calcCollisionPoint( t )
		local startX, startY = aPoint.x, aPoint.y
		local dx,dy = ssk.math2d.angle2Vector( anArrow2.angle )
		dx,dy = ssk.math2d.scale( dx, dy, aPoint.pps * t )
		local colX, colY = ssk.math2d.add( startX, startY, dx, dy )
		return colX, colY
	end


	local function discriminant()
	    local a = root_a()
		local b = root_b()
		local c = root_c()
		dprint(2,"")

		dprint(2,"root_a = ", a)
		dprint(2,"root_b = ", b)
		dprint(2,"root_c = ", c, NL)

		local dVal = (b * b) - 4 * a * c
		
		local t = -1
		local colX = 0
		local colY = 0

		if(dVal == 0) then

			-- Check for special case of 2a == 0
			-- If this occurs no collsion actually occurs
			if( 2 * a == 0 ) then
				t = -1
				dVal = -1 -- Force to no-collision status
			else
				t = d_0_time( a, b )
			end

		elseif(dVal > 0) then
			t = d_positive_time( a, b, dVal )
								
		end

		t = round(t,2)

		if( t >= 0 ) then
			colX,colY = calcCollisionPoint( t )
		end

		return dVal,t,colX,colY
	end

	-- Step 4 -> Test discriminant and find collision time and point, then
	--           update labels
	local dVal,t,colX,colY = discriminant()
	if(dVal < 0) then
		dprint(2, dVal .. " => no intersection")
		collisionLabel = ssk.labels:presetLabel( layers.interfaces, "default", 
		                                      "No Intersection!", 
											  centerX, 20, { fontSize = 16, textColor = _RED_ }  )

	elseif(dVal == 0) then
		dprint(2, dVal .. " => single intersection @ " .. t .. " seconds")		
		collisionLabel = ssk.labels:presetLabel( layers.interfaces, "default", 
		                                      "Single Intersection @ " .. t .. " seconds", 
											  centerX, 20, { fontSize = 16, textColor = _GREEN_ }  )

		collisionPoint   = ssk.display.circle( layers.content, colX, colY, 
											 { radius = 4, fill = _RED_, 
											 stroke = _GREEN_, strokeWidth = 2 } )

	else
		dprint(2, dVal .. " => two intersections @ " .. t .. " seconds")		

		collisionLabel = ssk.labels:presetLabel( layers.interfaces, "default", 
		                                      "Dual Intersection, first at @ " .. t .. " seconds", 
											  centerX, 20, { fontSize = 16, textColor = _GREEN_ }  )

		collisionPoint   = ssk.display.circle( layers.content, colX, colY, 
											 { radius = 4, fill = _RED_, 
											 stroke = _GREEN_, strokeWidth = 2 } )
	end
	


end

ex_step[1][3] = function ()
	dprint(2,"Ex 1 Step 3" )
	local avx, avy = anArrow1.vx, anArrow1.vy
	local vLen = ssk.math2d.length(avx, avy)
	local A_endX = aCircle.x + avx
	local A_endY = aCircle.y + avy

	--aCircle.x = A_endX
	--aCircle.y = A_endY	
	ssk.action.moveToPoint( aCircle, A_endX, A_endY, aCircle.pps )


	local bvx, bvy = anArrow2.vx, anArrow2.vy
	local vLen = ssk.math2d.length(avx, avy)
	local B_endX = aPoint.x + bvx
	local B_endY = aPoint.y + bvy

	--aPoint.x = B_endX
	--aPoint.y = B_endY	
	ssk.action.moveToPoint( aPoint, B_endX, B_endY, aPoint.pps )
end


---------------------- 2
---------------------- 2
---------------------- 2
ex_step[2][1] = function ()
	dprint(2,"Ex 2 Step 1" )

	clearLabels()

	local A_startX = centerX-75
	local A_startY = centerY+100
	local A_angle  = 25
	local A_radius = 20

	local B_startX = centerX+75
	local B_startY = centerY+100
	local B_angle  = -35
	local B_radius = 1

	anArrow1 = ssk.display.arrow2( layers.content, A_startX, A_startY, A_angle, 230, { color = _BLUE_ , width = 2} )
	aCircle  = ssk.display.circle( layers.content, A_startX, A_startY, { radius = A_radius, fill = _TRANSPARENT_, stroke = _WHITE_, strokeWidth = 1 } )
	aCircle.moveTime = 4
	aCircle.radius = A_radius

	anArrow2 = ssk.display.arrow2( layers.content, B_startX, B_startY, B_angle, 230, { color = _BLUE_ , width = 2} )
	aPoint   = ssk.display.circle( layers.content, B_startX, B_startY, { radius = B_radius, fill = _WHITE_, stroke = _WHITE_, strokeWidth = 1 } )
	aPoint.moveTime = 2
	aPoint.radius = B_radius

--	local nx,ny = ssk.math2d.angle2Vector( anArrow2.angle - 90)
--	nx,ny = ssk.math2d.scale(nx, ny, 15)
--	nx,ny = ssk.math2d.add( anArrow2.cx, anArrow2.cy, nx, ny)
--	anArrow3 = ssk.display.arrow( layers.content, anArrow2.cx, anArrow2.cy, nx, ny )

	local A_vLen = ssk.math2d.length(anArrow1.vx, anArrow1.vy)
	local A_pps  = A_vLen / aCircle.moveTime -- pixels / seconds
	aCircle.pps = round(A_pps,0)

	local B_vLen = ssk.math2d.length(anArrow2.vx, anArrow2.vy)
	local B_pps  = B_vLen / aPoint.moveTime -- pixels / seconds
	aPoint.pps = round(B_pps,0)

	speedLabel1 = ssk.labels:presetLabel( layers.interfaces, "default", "Circle speed: " .. aCircle.pps .. " pps", centerX - 75, h - 20, { fontSize = 14 }  )
	speedLabel2 = ssk.labels:presetLabel( layers.interfaces, "default", "Point speed: " .. aPoint.pps .. " pps", centerX + 75, h - 20, { fontSize = 14 }  )

	return true
end

ex_step[2][2] = ex_step[1][2]
ex_step[2][3] = ex_step[1][3]

---------------------- 3
---------------------- 3
---------------------- 3
ex_step[3][1] = function ()
	dprint(2,"Ex 3 Step 1" )

	clearLabels()

	local A_startX = centerX-5
	local A_startY = centerY+50
	local A_angle  = 0
	local A_radius = 20

	local B_startX = centerX+5
	local B_startY = centerY+100
	local B_angle  = 0
	local B_radius = 1

	anArrow1 = ssk.display.arrow2( layers.content, A_startX, A_startY, A_angle, 160, { color = _BLUE_ , width = 2} )
	aCircle  = ssk.display.circle( layers.content, A_startX, A_startY, { radius = A_radius, fill = _TRANSPARENT_, stroke = _WHITE_, strokeWidth = 1 } )
	aCircle.moveTime = 9
	aCircle.radius = A_radius

	anArrow2 = ssk.display.arrow2( layers.content, B_startX, B_startY, B_angle, 210, { color = _BLUE_ , width = 2} )
	aPoint   = ssk.display.circle( layers.content, B_startX, B_startY, { radius = B_radius, fill = _WHITE_, stroke = _WHITE_, strokeWidth = 1 } )
	aPoint.moveTime = 7
	aPoint.radius = B_radius

--	local nx,ny = ssk.math2d.angle2Vector( anArrow2.angle - 90)
--	nx,ny = ssk.math2d.scale(nx, ny, 15)
--	nx,ny = ssk.math2d.add( anArrow2.cx, anArrow2.cy, nx, ny)
--	anArrow3 = ssk.display.arrow( layers.content, anArrow2.cx, anArrow2.cy, nx, ny )

	local A_vLen = ssk.math2d.length(anArrow1.vx, anArrow1.vy)
	local A_pps  = A_vLen / aCircle.moveTime -- pixels / seconds
	aCircle.pps = round(A_pps,0)

	local B_vLen = ssk.math2d.length(anArrow2.vx, anArrow2.vy)
	local B_pps  = B_vLen / aPoint.moveTime -- pixels / seconds
	aPoint.pps = round(B_pps,0)

	speedLabel1 = ssk.labels:presetLabel( layers.interfaces, "default", "Circle speed: " .. aCircle.pps .. " pps", centerX - 75, h - 20, { fontSize = 14 }  )
	speedLabel2 = ssk.labels:presetLabel( layers.interfaces, "default", "Point speed: " .. aPoint.pps .. " pps", centerX + 75, h - 20, { fontSize = 14 }  )

	return true
end

ex_step[3][2] = ex_step[1][2]
ex_step[3][3] = ex_step[1][3]

---------------------- 4
---------------------- 4
---------------------- 4
ex_step[4][1] = function ()
	dprint(2,"Ex 4 Step 1" )

	clearLabels()

	local A_startX = centerX-75
	local A_startY = centerY+100
	local A_angle  = 0
	local A_radius = 170

	local B_startX = centerX+75
	local B_startY = centerY+100
	local B_angle  = 0
	local B_radius = 1

	anArrow1 = ssk.display.arrow2( layers.content, A_startX, A_startY, A_angle, 210, { color = _BLUE_ , width = 2} )
	aCircle  = ssk.display.circle( layers.content, A_startX, A_startY, { radius = A_radius, fill = _TRANSPARENT_, stroke = _WHITE_, strokeWidth = 1 } )
	aCircle.moveTime = 3
	aCircle.radius = A_radius

	anArrow2 = ssk.display.arrow2( layers.content, B_startX, B_startY, B_angle, 210, { color = _BLUE_ , width = 2} )
	aPoint   = ssk.display.circle( layers.content, B_startX, B_startY, { radius = B_radius, fill = _WHITE_, stroke = _WHITE_, strokeWidth = 1 } )
	aPoint.moveTime = 3
	aPoint.radius = B_radius

--	local nx,ny = ssk.math2d.angle2Vector( anArrow2.angle - 90)
--	nx,ny = ssk.math2d.scale(nx, ny, 15)
--	nx,ny = ssk.math2d.add( anArrow2.cx, anArrow2.cy, nx, ny)
--	anArrow3 = ssk.display.arrow( layers.content, anArrow2.cx, anArrow2.cy, nx, ny )

	local A_vLen = ssk.math2d.length(anArrow1.vx, anArrow1.vy)
	local A_pps  = A_vLen / aCircle.moveTime -- pixels / seconds
	aCircle.pps = round(A_pps,0)

	local B_vLen = ssk.math2d.length(anArrow2.vx, anArrow2.vy)
	local B_pps  = B_vLen / aPoint.moveTime -- pixels / seconds
	aPoint.pps = round(B_pps,0)

	speedLabel1 = ssk.labels:presetLabel( layers.interfaces, "default", "Circle speed: " .. aCircle.pps .. " pps", centerX - 75, h - 20, { fontSize = 14 }  )
	speedLabel2 = ssk.labels:presetLabel( layers.interfaces, "default", "Point speed: " .. aPoint.pps .. " pps", centerX + 75, h - 20, { fontSize = 14 }  )

	return true
end

ex_step[4][2] = ex_step[1][2]
ex_step[4][3] = ex_step[1][3]


---------------------- 5
---------------------- 5
---------------------- 5
ex_step[5][1] = function ()
	dprint(2,"Ex 5 Step 1" )

	clearLabels()

	local A_startX = centerX-75
	local A_startY = centerY+100
	local A_angle  = 0
	local A_radius = 20

	local B_startX = centerX+75
	local B_startY = centerY+100
	local B_angle  = 0
	local B_radius = 1

	anArrow1 = ssk.display.arrow2( layers.content, A_startX, A_startY, A_angle, 210, { color = _BLUE_ , width = 2} )
	aCircle  = ssk.display.circle( layers.content, A_startX, A_startY, { radius = A_radius, fill = _TRANSPARENT_, stroke = _WHITE_, strokeWidth = 1 } )
	aCircle.moveTime = 3
	aCircle.radius = A_radius

	anArrow2 = ssk.display.arrow2( layers.content, B_startX, B_startY, B_angle, 210, { color = _BLUE_ , width = 2} )
	aPoint   = ssk.display.circle( layers.content, B_startX, B_startY, { radius = B_radius, fill = _WHITE_, stroke = _WHITE_, strokeWidth = 1 } )
	aPoint.moveTime = 3
	aPoint.radius = B_radius

--	local nx,ny = ssk.math2d.angle2Vector( anArrow2.angle - 90)
--	nx,ny = ssk.math2d.scale(nx, ny, 15)
--	nx,ny = ssk.math2d.add( anArrow2.cx, anArrow2.cy, nx, ny)
--	anArrow3 = ssk.display.arrow( layers.content, anArrow2.cx, anArrow2.cy, nx, ny )

	local A_vLen = ssk.math2d.length(anArrow1.vx, anArrow1.vy)
	local A_pps  = A_vLen / aCircle.moveTime -- pixels / seconds
	aCircle.pps = round(A_pps,0)

	local B_vLen = ssk.math2d.length(anArrow2.vx, anArrow2.vy)
	local B_pps  = B_vLen / aPoint.moveTime -- pixels / seconds
	aPoint.pps = round(B_pps,0)

	speedLabel1 = ssk.labels:presetLabel( layers.interfaces, "default", "Circle speed: " .. aCircle.pps .. " pps", centerX - 75, h - 20, { fontSize = 14 }  )
	speedLabel2 = ssk.labels:presetLabel( layers.interfaces, "default", "Point speed: " .. aPoint.pps .. " pps", centerX + 75, h - 20, { fontSize = 14 }  )

	return true
end

ex_step[5][2] = ex_step[1][2]
ex_step[5][3] = ex_step[1][3]

---------------------- 6
---------------------- 6
---------------------- 6
ex_step[6][1] = function ()
	dprint(2,"Ex 5 Step 1" )

	clearLabels()

	local A_startX = centerX-75
	local A_startY = centerY+100
	local A_angle  = 0
	local A_radius = 20

	local B_startX = centerX+75
	local B_startY = centerY+100
	local B_angle  = 0
	local B_radius = 1

	anArrow1 = ssk.display.arrow2( layers.content, A_startX, A_startY, A_angle, 210, { color = _BLUE_ , width = 2} )
	aCircle  = ssk.display.circle( layers.content, A_startX, A_startY, { radius = A_radius, fill = _TRANSPARENT_, stroke = _WHITE_, strokeWidth = 1 } )
	aCircle.moveTime = 4
	aCircle.radius = A_radius

	anArrow2 = ssk.display.arrow2( layers.content, B_startX, B_startY, B_angle, 210, { color = _BLUE_ , width = 2} )
	aPoint   = ssk.display.circle( layers.content, B_startX, B_startY, { radius = B_radius, fill = _WHITE_, stroke = _WHITE_, strokeWidth = 1 } )
	aPoint.moveTime = 1
	aPoint.radius = B_radius

--	local nx,ny = ssk.math2d.angle2Vector( anArrow2.angle - 90)
--	nx,ny = ssk.math2d.scale(nx, ny, 15)
--	nx,ny = ssk.math2d.add( anArrow2.cx, anArrow2.cy, nx, ny)
--	anArrow3 = ssk.display.arrow( layers.content, anArrow2.cx, anArrow2.cy, nx, ny )

	local A_vLen = ssk.math2d.length(anArrow1.vx, anArrow1.vy)
	local A_pps  = A_vLen / aCircle.moveTime -- pixels / seconds
	aCircle.pps = round(A_pps,0)

	local B_vLen = ssk.math2d.length(anArrow2.vx, anArrow2.vy)
	local B_pps  = B_vLen / aPoint.moveTime -- pixels / seconds
	aPoint.pps = round(B_pps,0)

	speedLabel1 = ssk.labels:presetLabel( layers.interfaces, "default", "Circle speed: " .. aCircle.pps .. " pps", centerX - 75, h - 20, { fontSize = 14 }  )
	speedLabel2 = ssk.labels:presetLabel( layers.interfaces, "default", "Point speed: " .. aPoint.pps .. " pps", centerX + 75, h - 20, { fontSize = 14 }  )

	return true
end

ex_step[6][2] = ex_step[1][2]
ex_step[6][3] = ex_step[1][3]


return gameLogic