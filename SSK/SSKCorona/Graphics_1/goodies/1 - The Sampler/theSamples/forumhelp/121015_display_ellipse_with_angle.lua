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

--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
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

local createEllipse

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
	createEllipse( centerX, centerY-20, 150, 50, 0 )
	createEllipse( centerX, centerY+20, 150, 50, 45 )

	--local obj = table.remove( layers.content,2)
    --table.insert( layers.content,3,obj)

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
	myCC = ssk.ccmgr:newCalculator()
	myCC:addName("player")
	myCC:addName("wrapTrigger")
	myCC:collidesWith("player", "wrapTrigger")
	myCC:dump()
end


createLayers = function( group )
	layers = ssk.display.quickLayers( group, 
		"background", 
		"scrollers", 
			{ "scroll3", "scroll2", "scroll1" },
		"content",
		"interfaces" )
end

addInterfaceElements = function()
	-- Add background 
	backImage = ssk.display.backImage( layers.background, "starBack_380_570.png") 
end	

createEllipse = function ( x, y, w, h, angle )
	
	local function newArc(group, x,y,w,h,s,e,rot) -- modification of original code by: rmbsoft (Corona Forums Member)
		local theArc = display.newGroup()

		local xc,yc,xt,yt,cos,sin = 0,0,0,0,math.cos,math.sin --w/2,h/2,0,0,math.cos,math.sin
		s,e = s or 0, e or 360
		s,e = math.rad(s),math.rad(e)
		w,h = w/2,h/2
		local l = display.newLine(0,0,0,0)
		if(rot == 0) then
			l:setColor(255, 0, 0)
		else
			l:setColor(0, 255, 0)
		end
		l.width = 4
                
		theArc:insert( l )
		
		for t=s,e,0.02 do 
			local cx,cy = xc + w*cos(t), yc - h*sin(t)
			l:append(cx,cy) 
		end

		group:insert( theArc )

		-- Center, Rotate, then translate		
		theArc.x,theArc.y = 0,0
		theArc.rotation = rot
		theArc.x,theArc.y = x,y
			
		return theArc
	end
        
	local function newEllipse(group, x, y, w, h, rot) -- modification of original code by: rmbsoft (Corona Forums Member)
		return newArc(group, x, y, w, h, nil, nil, rot)
	end

	local theEllipse = newEllipse(layers.content, x,y,w,h,angle)

	return theEllipse
end

createSky = function ( x, y, width, height  )
	local sky  = ssk.display.imageRect( layers.background, x, y, imagesDir .. "starBack_320_240.png",
		{ w = width, h = height, myName = "theSky" } )
	return sky
end


return gameLogic