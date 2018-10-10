io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
ssk.meters.create_fps(true)
ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================
-- =====================================================
local mRand 			= math.random
local targetCount 	= 100
local killRadius  	= 50
local killRadius2  	= killRadius ^ 2
local genPerFrame 	= 100
local objects 			= {}

local useRealObjects = true

-- =====================================================
local layers = ssk.display.quickLayers( nil, "background", "content", "foreground" )
local back = ssk.display.newImageRect( layers.background, centerX, centerY, "protoBackX.png", 
	                                    { w = 720, h = 1386, rotation = 90 } )
local killCircle = ssk.display.newCircle( layers.background, centerX, centerY, 
	                                    { radius = killRadius, fill = _T_, stroke = _Y_, strokeWidth = 2 } )

local targetCountHUD = ssk.display.newRect( layers.foreground, left+150, bottom-50, 
													{ w = 280, h = 80, fill = _DARKERGREY_ } )
targetCountHUD.label = display.newText( layers.foreground, targetCount, targetCountHUD.x, targetCountHUD.y, nil, 30 )

local actualCountHUD = ssk.display.newRect( layers.foreground, right-150, bottom-50, 
													{ w = 280, h = 80, fill = _DARKERGREY_ } )
actualCountHUD.label = display.newText( layers.foreground, 0, actualCountHUD.x, actualCountHUD.y, nil, 30 )


-- Generate new objects and move to center
local function newObj()
	local x, y 
	local choice = mRand(1,4)
	
	if( choice == 1) then
	   x = left - 100
	   y = mRand(top, bottom)
	
	elseif( choice == 2) then
	   x = right + 100
	   y = mRand(top, bottom)
	
	elseif( choice == 3) then
	   x = mRand(left, right)
	   y = top - 100
	
	elseif( choice == 4) then
	   x = mRand(left, right)
	   y = bottom
	end		

	local obj

	-- Make a circle
	if( useRealObjects ) then
		obj = ssk.display.newCircle( layers.content, x, y, 			
													{ radius = mRand(5,10), fill = randomColor() } )

	-- make a table
	else 
		obj = { x = x, y = y }
	end

	transition.to(obj, { x = centerX, y = centerY, time = mRand(2000,3000) } )

	objects[obj] = obj

end


-- Use easy input to make it simple to increase/decrease target count
ssk.easyInputs.twoTouch.create( layers.background, { debugEn = true, keyboardEn = true } )
local function onTwoTouchLeft(event)
	if( event.phase ~= "ended" ) then return false end
	targetCount = targetCount - 100
	targetCount = (targetCount > 100) and targetCount or 100
	targetCountHUD.label.text = targetCount
	return false 
end; listen("onTwoTouchLeft", onTwoTouchLeft)

local function onTwoTouchRight(event)
	if( event.phase ~= "ended" ) then return false end
	targetCount = targetCount + 100		
	targetCountHUD.label.text = targetCount
	return false 
end; listen("onTwoTouchRight", onTwoTouchRight)



local function collisionScanner()
	local dx,dy
	for k,v in pairs(objects) do
		dx = v.x-centerX
		dy = v.y-centerY

		if( ( dx * dx + dy * dy ) <= killRadius2 ) then
			objects[v] = nil
			
			if( useRealObjects ) then
				display.remove( v )
			end
		end
	end

end

local function enterFrame()
	-- Scan for 'collisions' with circle at center once per frame
	collisionScanner()

	-- Generate new objects if needed
	local count = table.count( objects )

	actualCountHUD.label.text = count	

	if( count < targetCount ) then		
		
		-- Generate 'delta' or 'genPerFrame' number number of objects, whichever is less		
		local delta = targetCount-count			
		local toGen = (genPerFrame<delta) and genPerFrame or delta

		for i = 1, toGen do
			newObj()
		end
	end
end; listen("enterFrame", enterFrame)
