io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
-- =====================================================
-- TESTING CODE
-- =====================================================
local common			= require "common"
--
local testGroup
local size  = 80
local _R_   = { 1,0,0 }
local _G_   = { 0,1,0 }
local _B_   = { 0,0,1 }
local _Y_   = { 1,1,0 }
local _P_   = { 1,0,1 }
--
local redrawDelay		= 1000
local doRecalc_Test  = false
local immersiveMode  = "immersiveSticky" -- immersive immersiveSticky


-- ==
--    Applies selected immersive settings
-- ==
local function doImmersiveMode()
	common.easyAndroidUIVisibility(immersiveMode)
end


-- ==
--    A test so we can see something; Draws back, horiz/vert lines, and blocks in corners.
-- ==
local function renderTest()
   timer.performWithDelay( redrawDelay, 
  		function()

		   display.remove(testGroup)
		   testGroup = display.newGroup()

			local back = display.newImageRect( testGroup,"protoBackX2.png", 720, 1386 )
			back.x = display.contentCenterX
			back.y = display.contentCenterY
			if( display.contentWidth > display.contentHeight ) then
				back.rotation = 90
			end
			local tmp = display.newLine( testGroup, common.centerX, common.top, common.centerX, common.bottom )
			tmp.strokeWidth = 2
			tmp:setStrokeColor(math.random(),math.random(),math.random())
			local tmp = display.newLine( testGroup, common.left, common.centerY, common.right, common.centerY )
			tmp.strokeWidth = 2
			tmp:setStrokeColor(math.random(),math.random(),math.random())
			local ul = display.newRect( testGroup, common.left, common.top, size, size )
			ul.anchorX = 0
			ul.anchorY = 0
			ul:setFillColor( unpack( _R_ ) )

			local ur = display.newRect( testGroup, common.right, common.top, size, size )
			ur.anchorX = 1
			ur.anchorY = 0
			ur:setFillColor( unpack( _G_ ) )
			local lr = display.newRect( testGroup, common.right, common.bottom, size, size )
			lr.anchorX = 1
			lr.anchorY = 1
			lr:setFillColor( unpack( _B_ ) )
			local ll = display.newRect( testGroup, common.left, common.bottom, size, size )
			ll.anchorX = 0
			ll.anchorY = 1
			ll:setFillColor( unpack( _Y_ ) )
			local c = display.newRect( testGroup, common.centerX, common.centerY, size, size )
			c:setFillColor( unpack( _P_ ) )
		end )
end

-- ==
--    Catch resize event and optional re-draw test content
-- ==
local function onResize( event )
	if( doRecalc_Test ) then
		common.calcHelpers()
		renderTest()
	end
end  
Runtime:addEventListener( "resize", onResize )


-- Catch application resume and:
-- 
-- 1. Re-apply immersive mode.
-- 2. Optionally re-draw content
--
local function onSystem( event )
	print(event.type)
	if( event.type == "applicationResume" ) then
		doImmersiveMode()

		onResize()

	end
end  
Runtime:addEventListener( "system", onSystem )


-- =====================================================
-- DO TEST
-- =====================================================

-- Apply immersive mode for first time
doImmersiveMode()

-- Catch back button and if user decides to 'stay', 
-- 
-- 1. Re-apply immersive mode.
-- 2. Optionally re-draw content
--

common.captureBackButton( function() doImmersiveMode();onResize(); end  )

-- Draw test content
renderTest()
