io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
-- =====================================================
-- YOUR CODE BELOW
-- =====================================================
local _R_ = { 1,0,0 }
local _G_ = { 0,1,0 }
local _B_ = { 0,0,1 }
local _Y_ = { 1,1,0 }
local _P_ = { 1,0,1 }

local common			= require "common"

local size = 80
local doRecalc_Test = false

common.captureBackButton()
common.easyAndroidUIVisibility("immersive")

local testGroup

local function renderTest()
   display.remove(testGroup)
   testGroup = display.newGroup()

	local back = display.newImageRect( testGroup,"protoBackX2.png", 720, 1386 )
	back.x = display.contentCenterX
	back.y = display.contentCenterY
	if( display.contentWidth > display.contentHeight ) then
		back.rotation = 90
	end


   timer.performWithDelay( 500, 
   	function()
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

local function onResize( event )
	common.easyAndroidUIVisibility("immersive")

	if( doRecalc_Test ) then
		common.calcHelpers()
		renderTest()
	end
end  
Runtime:addEventListener( "resize", onResize )


renderTest()
