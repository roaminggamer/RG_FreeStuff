-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
-- Code To Create Example Buttons ++
-- =============================================================
local widget = require( "widget" )
widget.setTheme( "widget_theme_ios" )
--widget.setTheme( "widget_theme_android_holo_light" )
--widget.setTheme( "widget_theme_android_holo_dark" )
--
local cx,cy = display.contentCenterX, display.contentCenterY
local uw = display.actualContentWidth - display.contentWidth
local uh = display.actualContentHeight - display.contentHeight
local left = (uw == 0) and 0 or (0 - uw/2)
local right = left + display.actualContentWidth
local top = (uh == 0) and 0 or (0 - uh/2)
local bottom = top + display.actualContentHeight
--
local group 
--
local myModule
--
local bw = 200
local bh = 30
local bh2 = 80
local function makeButton( x, y, text, action )
	local button = display.newRect( x, y, bw, bh )
	button:setFillColor(1,1,1,0.1)
	button:setStrokeColor(1,1,1,0.5)
	button.strokeWidth = 2
	button.label = display.newText( text, x, y,  "Lato-Black.ttf", 16 )
	button.action = action or function() end
	function button.touch( self, event )
		if( event.phase == "ended" ) then 
			self:setStrokeColor(0.5,1,0.5,1)
			timer.performWithDelay( 60, 
				function() 
					self:setStrokeColor(1,1,1,0.5)
					self.action()
				end )		
		end
		return true
	end
	button:addEventListener("touch")
	return button
end
--
local function makeToggleButton( x, y, text1, text2, text3, offAction, onAction )
	local topLabel = display.newText( text1, x, y, "Lato-Black.ttf", 22 )
	
	-- Question: why is the logic opposite?  Bug in widget.*?
	local function listener( event )
		if( event.target.isOn ) then
			offAction()
		else
			onAction()
		end
	end

	-- Create a default on/off switch (using widget.setTheme)
	local button = widget.newSwitch 
	{
	    x = x,
	    y =  y,
	    onRelease = listener,
	}
	button.x = x
	button.y = topLabel.y + topLabel.contentHeight/2 + button.contentHeight/2

	local onLabel = display.newText( text2, button.x + button.contentWidth/2 + 10, button.y, "Lato-Black.ttf", 18 )
	onLabel.anchorX = 0
	onLabel:setTextColor(0,1,0)
	local offLabel = display.newText( text3, button.x - button.contentWidth/2 - 10, button.y, "Lato-Black.ttf", 18 )
	offLabel.anchorX = 1
	offLabel:setTextColor(1,0,0)

	return button
end
--
local function easyAlert( title, msg, buttons )
	buttons = buttons or { {"OK"} }
	local function onComplete( event )
		local action = event.action
		local index = event.index
		if( action == "clicked" ) then
			local func = buttons[index][2]
			if( func ) then func() end 
	    end
	end
	local names = {}
	for i = 1, #buttons do
		names[i] = buttons[i][1]
	end
	local alert = native.showAlert( title, msg, names, onComplete )
	return alert
end

-- =============================================================
--  Load patcher and start disabled, quiet, etc.
-- =============================================================
local patcher = require "plugin.patcher"
patcher.debug(false)
patcher.enabled(false)
patcher.caching(false)

-- =============================================================
--  Patcher Tests
-- =============================================================
local function createTestPatch()
	local patchedScript = 
		"local m = {}\n" ..
		"local cx,cy = display.contentCenterX, display.contentCenterY\n" ..
		"local mRand = math.random\n" ..
		"function m.run( group )\n" ..
		"	local tmp = display.newRect( group, cx + mRand(-200,200), cy + mRand(-20,80), 120, 120 )\n" ..
		"	tmp:setFillColor(1,mRand(),mRand())\n" ..
		"display.newText( group, 'patch v1 - scripts.myModule', cx, cy + 160,  'Lato-Black.ttf', 22 )\n" ..
		"end\n" ..
		"return m"
	patcher.mkFolder( "scripts" )
	patcher.write( patchedScript, "scripts.myModule" )
end

local function createTestPatch2()
	local patchedScript = 
		"local m = {}\n" ..
		"local cx,cy = display.contentCenterX, display.contentCenterY\n" ..
		"local mRand = math.random\n" ..
		"function m.run( group )\n" ..
		"	local tmp = display.newRect( group, cx + mRand(-200,200), cy + mRand(-20,80), 40, 40 )\n" ..
		"	tmp:setFillColor(1,mRand(),mRand())\n" ..
		"display.newText( group, 'patch v2 - scripts.myModule', cx, cy + 160,  'Lato-Black.ttf', 22 )\n" ..
		"end\n" ..
		"return m"
	patcher.mkFolder( "scripts" )
	patcher.write( patchedScript, "scripts.myModule" )
end

local function downloadPatch()
	patcher.mkFolder( "scripts" )
	local function onSuccess( event )
		easyAlert("Success", "Patch downloaded!" )
	end
	local function onFail( event )
		easyAlert("Failure", "Patch not downloaded?\n\nSee console" )
		for k,v in pairs(event) do
			print(k,v)
		end
	end
	local function onProgress( event )
		--for k,v in pairs(event) do
			--print(k,v)
		--end
	end

	local testPatch = "https://raw.githubusercontent.com/roaminggamer/RG_FreeStuff/master/myPluginSamples/patcher/myModule.lua"
	patcher.get( testPatch, "scripts.myModule", onSuccess, onFail, onProgress )
end

local function destroyPatch()
	patcher.remove( "scripts.myModule" )
end

local function loadMyModule()
	myModule = require "scripts.myModule"
end

local function testMyModule()
	if( not myModule ) then return end
	display.remove(group)
	group = display.newGroup()
	myModule.run( group )
end

local function printPatcherSettings()
	local settings = patcher.getSettings()

	print("=============================")
	for k,v in pairs(settings) do
		print(k,v)
	end
	print("=============================\n")
end


-- =============================================================
--  Create Buttons to Run Tests
-- =============================================================
local by = top + 20
local button = makeToggleButton( cx, by, "require() using", "patcher.require()", "_G.require()",
	               function() patcher.export() end,
	               function() patcher.reset() end )
by = by + bh2

local button = makeToggleButton( cx, by, "patcher.enabled()", "true", "false",
	               function() patcher.enabled(true) end,
	               function() patcher.enabled(false) end )
by = by + bh2

local button = makeToggleButton( cx, by, "patcher.debug()", "true", "false",
	               function() patcher.debug(true) end,
	               function() patcher.debug(false) end )
by = by + bh2

local button = makeToggleButton( cx, by, "patcher.caching()", "true", "false",
	               function() patcher.caching(true) end,
	               function() patcher.caching(false) end )
by = by + bh2

makeButton( cx, by, "Print Patcher Settings", printPatcherSettings )

by = bottom - 240
local bx = cx - 200
makeButton( bx, by, "Create Patch File v1", createTestPatch ); by = by + bh + 10
makeButton( bx, by, "Create Patch File v2", createTestPatch2 ); by = by + bh + 10
makeButton( bx, by, "Download Patch File v3", downloadPatch ); by = by + bh * 3

makeButton( bx, by, "Destroy Patch File", destroyPatch )

by = bottom - 240
local bx = cx + 200
makeButton( bx, by, "Dump Cache", function() patcher.dump() end); by = by + bh + 10
makeButton( bx, by, "Purge Cache", function() patcher.purge() end ); by = by + bh * 3

makeButton( bx, by, "Load Module", loadMyModule ); by = by + bh + 10
makeButton( bx, by, "Test Module", testMyModule ); by = by + bh * 3
