io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
-- =====================================================
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
--ssk.easyIFC.generateButtonPresets( nil, true )
-- =====================================================

-- =============================================================
-- Localizations
-- =============================================================
-- Commonly used Lua & Corona Functions
local getTimer = system.getTimer; local mRand = math.random
local mAbs = math.abs; local mFloor = math.floor; local mCeil = math.ceil
local strGSub = string.gsub; local strSub = string.sub
-- Common SSK Features
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers
local easyIFC = ssk.easyIFC;local persist = ssk.persist
local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
local normRot = math.normRot;local easyAlert = ssk.misc.easyAlert
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale
local RGTiled = ssk.tiled; local files = ssk.files
local factoryMgr = ssk.factoryMgr; local soundMgr = ssk.soundMgr
-- =====================================================
-- EXAMPLE BEGINS HERE
-- =====================================================
local group 
local beforeViewableContentHeight
local afterViewableContentHeight
local fixScale = 1
local fixOffset = 0
--
-- It is known, that opening a native dialog box in Android wil re-show the navigation bar if it was hidden.
--
-- This code provides a way to show a dialog and the dialog gives you the option to re-hide the nav bar so
-- we can investigate what happens with scaling.
--
local function reHide()
	print( "before rehide", display.actualContentHeight, display.viewableContentHeight, display.pixelHeight, display.safeActualContentHeight, group.yScale, display.contentScaleY, display.topStatusBarContentHeight  )
    ssk.android.easyAndroidUIVisibility()
    nextFrame( function() print( "after rehide", display.actualContentHeight, display.viewableContentHeight, display.pixelHeight, display.safeActualContentHeight, group.yScale, display.contentScaleY, display.topStatusBarContentHeight ) end, 1 )
end

local function openDialog( )
	print( "before show dialog", display.actualContentHeight, display.viewableContentHeight, display.pixelHeight, display.safeActualContentHeight, group.yScale, display.contentScaleY, display.topStatusBarContentHeight )
	easyAlert( "Roaming Gamer Says...", 
	            "Yo!  Navigation bar should be showing.  Want to re-hide it?",
	             { { "Yes!", reHide }, {"Never Mind", nil } } )
	nextFrame( function() print( "after show dialog", display.actualContentHeight, display.viewableContentHeight, display.pixelHeight, display.safeActualContentHeight, group.yScale, display.contentScaleY, display.topStatusBarContentHeight ) end, 1 )	
end

local function original()
	group = display.newGroup()
	ssk.android.easyAndroidUIVisibility()
	display.setDefault( "background", 1, 0, 1 )
	newRect( group, centerX, centerY, { w = fullw, h = fullh, fill = _K_, alpha = 0.95 })
	ssk.easyIFC:presetPush( group, "default", centerX, centerY, 200, 60, "Open Dialog", openDialog )
end


local function experiment1()
	beforeViewableContentHeight = display.pixelHeight
	print( "startup", display.actualContentHeight, display.viewableContentHeight, display.pixelHeight, display.safeActualContentHeight, display.contentScaleY, display.topStatusBarContentHeight  )
	group = display.newGroup()
	ssk.android.easyAndroidUIVisibility()
	nextFrame( 
		function()
			display.setDefault( "background", 1, 0, 1 )
			newRect( group, centerX, centerY, { w = fullw, h = fullh, fill = _K_, alpha = 0.95 })			
			ssk.easyIFC:presetPush( group, "default", centerX, centerY, 200, 60, "Open Dialog", openDialog )
			print( "done drawing", display.actualContentHeight, display.viewableContentHeight, display.pixelHeight, display.safeActualContentHeight, group.yScale, display.contentScaleY, display.topStatusBarContentHeight )
			afterViewableContentHeight = display.pixelHeight
			fixScale = afterViewableContentHeight/beforeViewableContentHeight
			fixOffset = afterViewableContentHeight - beforeViewableContentHeight
			print("Fix scale: ", fixScale)
			print("Fix offset: ", fixOffset)
			group:scale(fixScale,fixScale)
			group.y = -fixOffset
			print( "done fix scaling", display.actualContentHeight, display.viewableContentHeight, display.pixelHeight, display.safeActualContentHeight, group.yScale, display.contentScaleY, display.topStatusBarContentHeight )
		end, 1000 )
end


local function experiment2()
	beforeViewableContentHeight = display.safeActualContentHeight	
	print( "startup", display.actualContentHeight, display.viewableContentHeight, display.pixelHeight, display.safeActualContentHeight, display.contentScaleY, display.topStatusBarContentHeight  )
	group = display.newGroup()
	ssk.android.easyAndroidUIVisibility()
	nextFrame( 
		function()
			display.setDefault( "background", 1, 0, 1 )
			newRect( group, centerX, centerY, { w = fullw, h = fullh, fill = _K_, alpha = 0.95 })			
			ssk.easyIFC:presetPush( group, "default", centerX, centerY, 200, 60, "Open Dialog", openDialog )
			print( "done drawing", display.actualContentHeight, display.viewableContentHeight, display.pixelHeight, display.safeActualContentHeight, group.yScale, display.contentScaleY, display.topStatusBarContentHeight )
			afterViewableContentHeight = display.safeActualContentHeight
			fixScale = afterViewableContentHeight/beforeViewableContentHeight
			fixOffset = afterViewableContentHeight - beforeViewableContentHeight
			print("Fix scale: ", fixScale)
			print("Fix offset: ", fixOffset)
			group:scale(fixScale,fixScale)
			group.y = -fixOffset/2
			print( "done fix scaling", display.actualContentHeight, display.viewableContentHeight, display.pixelHeight, display.safeActualContentHeight, group.yScale, display.contentScaleY, display.topStatusBarContentHeight )
		end, 1000 )
end


local function experiment3()
	fixScale = nil
	beforeViewableContentHeight = display.safeActualContentHeight	
	print( "startup", display.actualContentHeight, display.viewableContentHeight, display.pixelHeight, display.safeActualContentHeight, display.contentScaleY, display.topStatusBarContentHeight  )

	local function onResize( event )
	    print('resized!',event)
	    if( fixScale ) then
			group:scale(fixScale,fixScale)
			group.y = -fixOffset/2
			print( "done fix scaling", display.actualContentHeight, display.viewableContentHeight, display.pixelHeight, display.safeActualContentHeight, group.yScale, display.contentScaleY, display.topStatusBarContentHeight )
	    else
			afterViewableContentHeight = display.safeActualContentHeight
			fixScale = afterViewableContentHeight/beforeViewableContentHeight
			fixOffset = afterViewableContentHeight - beforeViewableContentHeight
			print("Fix scale: ", fixScale)
			print("Fix offset: ", fixOffset)
			group:scale(fixScale,fixScale)
			group.y = -fixOffset/2
			print( "done first fix scaling", display.actualContentHeight, display.viewableContentHeight, display.pixelHeight, display.safeActualContentHeight, group.yScale, display.contentScaleY, display.topStatusBarContentHeight )
	    end
	end	 
	Runtime:addEventListener( "resize", onResize )	
	
	group = display.newGroup()
	ssk.android.easyAndroidUIVisibility()
	display.setDefault( "background", 1, 0, 1 )
	newRect( group, centerX, centerY, { w = fullw, h = fullh, fill = _K_, alpha = 0.95 })			
	ssk.easyIFC:presetPush( group, "default", centerX, centerY, 200, 60, "Open Dialog", openDialog )
	print( "done drawing", display.actualContentHeight, display.viewableContentHeight, display.pixelHeight, display.safeActualContentHeight, group.yScale, display.contentScaleY, display.topStatusBarContentHeight )
end



local function experiment4()
	local currentStage = display.getCurrentStage()
	fixScale = nil
	beforeViewableContentHeight = display.safeActualContentHeight	
	print( "startup", display.actualContentHeight, display.viewableContentHeight, display.pixelHeight, display.safeActualContentHeight, display.contentScaleY, display.topStatusBarContentHeight  )

	local function onResize( event )
	    print('resized!',event)
	    if( fixScale ) then
			currentStage:scale(fixScale,fixScale)
			currentStage.y = -fixOffset/2
			print( "done fix scaling", display.actualContentHeight, display.viewableContentHeight, display.pixelHeight, display.safeActualContentHeight, group.yScale, display.contentScaleY, display.topStatusBarContentHeight )
	    else
			afterViewableContentHeight = display.safeActualContentHeight
			fixScale = afterViewableContentHeight/beforeViewableContentHeight
			fixOffset = afterViewableContentHeight - beforeViewableContentHeight
			print("Fix scale: ", fixScale)
			print("Fix offset: ", fixOffset)
			currentStage:scale(fixScale,fixScale)
			currentStage.y = -fixOffset/2
			print( "done first fix scaling", display.actualContentHeight, display.viewableContentHeight, display.pixelHeight, display.safeActualContentHeight, group.yScale, display.contentScaleY, display.topStatusBarContentHeight )
	    end
	end	 
	Runtime:addEventListener( "resize", onResize )	
	
	group = display.newGroup()
	ssk.android.easyAndroidUIVisibility()
	display.setDefault( "background", 1, 0, 1 )
	newRect( group, centerX, centerY, { w = fullw, h = fullh, fill = _K_, alpha = 0.95 })			
	ssk.easyIFC:presetPush( group, "default", centerX, centerY, 200, 60, "Open Dialog", openDialog )
	print( "done drawing", display.actualContentHeight, display.viewableContentHeight, display.pixelHeight, display.safeActualContentHeight, group.yScale, display.contentScaleY, display.topStatusBarContentHeight )
end

local function androidShrinkageFix()
	local beforeViewableContentHeight
	local afterViewableContentHeight
	local fixScale = 1
	local fixOffset = 0
	local currentStage = display.getCurrentStage()
	fixScale = nil
	beforeViewableContentHeight = display.safeActualContentHeight	
	local function onResize( event )
	    print('resized!',event)
	    if( fixScale ) then
			currentStage:scale(fixScale,fixScale)
			currentStage.y = -fixOffset/2
	    else
			afterViewableContentHeight = display.safeActualContentHeight
			fixScale = afterViewableContentHeight/beforeViewableContentHeight
			fixOffset = afterViewableContentHeight - beforeViewableContentHeight
			currentStage:scale(fixScale,fixScale)
			currentStage.y = -fixOffset/2
	    end
	end	 
	Runtime:addEventListener( "resize", onResize )	
end


-- experiment4()

androidShrinkageFix()
original()