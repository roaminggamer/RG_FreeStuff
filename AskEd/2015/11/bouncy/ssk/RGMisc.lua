-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- 								License
-- =============================================================
--[[
	> SSK is free to use.
	> SSK is free to edit.
	> SSK is free to use in a free or commercial game.
	> SSK is free to use in a free or commercial non-game app.
	> SSK is free to use without crediting the author (credits are still appreciated).
	> SSK is free to use without crediting the project (credits are still appreciated).
	> SSK is NOT free to sell for anything.
	> SSK is NOT free to credit yourself with.
]]
-- =============================================================
local misc = {}
_G.ssk = _G.ssk or {}
_G.ssk.misc = misc

local socket		= require "socket"
local getTimer		= system.getTimer
local strGSub		= string.gsub
local strSub		= string.sub
local strFormat 	= string.format
local mFloor		= math.floor
local angle2Vector	= ssk.math2d.angle2Vector
local scaleVec		= ssk.math2d.scale

-- ==
--		noErrorAlerts(	) - Turns off those annoying error popups! :)
-- ==
function misc.noErrorAlerts()
	Runtime:hideErrorAlerts( )
end

misc.isConnectedToWWW = function( url )
	local url = url or "www.google.com" 
	local hostFound = true
	local con = socket.tcp()
	con:settimeout( 2 ) -- Timeout connection attempt after 2 seconds
						
	-- Check if socket connection is open
	if con:connect(url, 80) == nil then 
			hostFound = false
	end

	return hostFound
end

-- ==
--		func() - what it does
-- ==
function misc.secondsToTimer( seconds, version )	
	local seconds = seconds or 0
	version = version or 1

	if(version == 1) then
		seconds = tonumber(seconds)
		local minutes = math.floor(seconds/60)
		local remainingSeconds = seconds - (minutes * 60)

		local timerVal = "" 

		if(remainingSeconds < 10) then
			timerVal =	minutes .. ":" .. "0" .. remainingSeconds
		else
			timerVal = minutes .. ":"	.. remainingSeconds
		end

		return timerVal
	elseif( version == 2 ) then
		seconds = tonumber(seconds)
		local nHours = string.format("%02.f", mFloor(seconds/3600));
		local nMins = string.format("%02.f", mFloor(seconds/60 - (nHours*60)));
		local nSecs = string.format("%02.f", mFloor(seconds - nHours*3600 - nMins *60));
		return nHours..":"..nMins.."."..nSecs

	elseif( version == 3 ) then
		local nDays = 0
		seconds = tonumber(seconds)
		local nHours = string.format("%02.f", mFloor(seconds/3600));
		local nMins = string.format("%02.f", mFloor(seconds/60 - (nHours*60)));
		local nSecs = string.format("%02.f", mFloor(seconds - nHours*3600 - nMins *60));

		nHours = tonumber(nHours)
		nMins = tonumber(nMins)
		
		while (nHours >= 24) do
			nDays = nDays + 1
			nHours = nHours - 24
		end

		return nDays,nHours,nMins,nSecs 
	end
end

function misc.easyUnderline( obj, color, strokeWidth, extraWidth, yOffset )
		color = color or { 1,1,1,1 }
		strokeWidth = strokeWidth or 1
		extraWidth = extraWidth or 0
		yOffset = yOffset or 0
		local lineWidth = obj.contentWidth + extraWidth
		local x = obj.x - lineWidth/2
		local y = obj.y + obj.contentHeight/2 + strokeWidth + yOffset
		local line = display.newLine( obj.parent, x, y, x + lineWidth, y )
		line:setStrokeColor( unpack(color) )
		line.strokeWidth = strokeWidth
		return line
end

function misc.quickLine( group, x, y, len, color, strokeWidth, yOffset )
		color = color or { 1,1,1,1 }
		strokeWidth = strokeWidth or 1
		extraWidth = extraWidth or 0
		yOffset = yOffset or 0
		local line = display.newLine( group, x, y + yOffset , x + len, y + yOffset )
		line:setStrokeColor( unpack(color) )
		line.strokeWidth = strokeWidth
		return line
end

misc.normRot = function( toNorm )
	if( type(toNorm) == "table" ) then
		while( toNorm.rotation >= 360 ) do toNorm.rotation = toNorm.rotation - 360 end		
		while( toNorm.rotation < 0 ) do toNorm.rotation = toNorm.rotation + 360 end
		return 
	else
		while( toNorm >= 360 ) do toNorm = toNorm - 360 end
		while( toNorm < 0 ) do toNorm = toNorm + 360 end
	end
	return toNorm
end


-- ==
--		pushDisplayDefault() / popDisplayDefault()- 
-- ==
local defaultValues = {}
function misc.pushDisplayDefault( defaultName, newValue )
	if( not defaultValues[defaultName] ) then defaultValues[defaultName] = {} end
	local values = defaultValues[defaultName]
	values[#values+1] = display.getDefault( defaultName )
	display.setDefault( defaultName, newValue )
end

function misc.popDisplayDefault( defaultName )
	if( not defaultValues[defaultName] ) then defaultValues[defaultName] = {} end
	local values = defaultValues[defaultName]
	if(#values == 0) then return end

	local tmp = values[#values]
	values[#values] = nil
	display.setDefault( defaultName, tmp )
end


misc.shortenString = function( text, maxLen, appendMe )
  if not text then return "" end
  --print( text, maxLen, appendMe )
  appendMe = appendMe or ""
  local outText = text
  if(outText:len() > maxLen) then
    outText = outText:sub(1,maxLen) .. appendMe
  end
  return outText
end


misc.fitText = function( obj, origText, maxWidth )
	origText = origText or ""
	local textLen = string.len( origText )
	while(obj.contentWidth > maxWidth and textLen > 1 ) do
			textLen = textLen - 1
			obj.text = misc.shortenString( origText, textLen, "..." )
			--if( textLen < 12 ) then
				-- return
			--end
	end	
end

misc.getImageSize = function ( path, basePath )
	basePath = basePath or system.ResourceDirectory
	local tmp = display.newImage( path, basePath, 10000,10000 )
	local sx = tmp.contentWidth
	local sy = tmp.contentHeight
	display.remove(tmp)
	return sx,sy
end


-- Rotate object about point
misc.rotateAbout = function( obj, x, y, params	)	
		
	x = x or display.contentCenterX
	y = y or display.contentCenterY
	params = params or {}
		
	local radius		= params.radius or 50
	obj._pathRot		= params.startA or 0
	local endA			= params.endA or (obj._pathRot + 360 )
	local time			= params.time or 1000
	local delay 		= params.delay or 0
	local myEasing		= params.myEasing or easing.linear
	local debugEn		= params.debugEn

	-- Start at right position
	local vx,vy = angle2Vector( obj._pathRot )
	vx,vy = scaleVec( vx, vy, radius )
	obj.x = x + vx 
	obj.y = y + vy

	-- remove 'enterFrame' listener when we finish the transition.
	obj.onComplete = function( self )
		if(params.onComplete) then 
			params.onComplete( obj )
		end
		Runtime:removeEventListener( "enterFrame", self )
	end

	-- Update position every frame
	obj.enterFrame = function ( self )
		local vx,vy = angle2Vector( self._pathRot )
		vx,vy = scaleVec( vx, vy, radius )
		self.x = x + vx 
		self.y = y + vy

		if( debugEn ) then
			local tmp = display.newCircle( self.parent, self.x, self.y, 1 )
			tmp:toBack()
		end
	end
	Runtime:addEventListener( "enterFrame", obj )

	-- Use transition to change the angle (gives us access to nice effects)
	transition.to( obj, { _pathRot = endA, delay = delay, time = time, transition = myEasing, onComplete = obj } )
end


-- Easy Mem/FPS Meter
--
misc.createEasyMeter = function( x , y, width, fontSize )
	x = x or centerX
	y = y or centerY
	width = width or 200
	fontSize = fontSize or 11
	local group = display.newGroup()	

	local hudFrame = display.newRect( group, x, y, width, 30)
	hudFrame:setFillColor(0.2,0.2,0.2)
	hudFrame:setStrokeColor(1,1,0)
	hudFrame.strokeWidth = 2

	local mMemLabel = display.newText( group, "", 40, hudFrame.y, native.systemFont, fontSize )
	mMemLabel:setFillColor(1,0.4,0)
	mMemLabel.anchorX = 1

	local tMemLabel = display.newText( group, "", 40, hudFrame.y, native.systemFont, fontSize )
	tMemLabel:setFillColor(0.2,1,0)
	tMemLabel.anchorX = 0

	hudFrame.touch = function( self, event )
		local target  = event.target
		local eventID = event.id

		if(event.phase == "began") then
			display.getCurrentStage():setFocus( target, eventID )
			target.isFocus = true
			target._x0 = target.x
			target._y0 = target.y

		elseif(target.isFocus) then
			local dx = event.x - event.xStart
			local dy = event.y - event.yStart
			target.x = target._x0 + dx
			target.y = target._y0 + dy

			if(event.phase == "ended" or event.phase == "cancelled") then
				display.getCurrentStage():setFocus( nil, eventID )
				target.isFocus = false
			end
		end
	end; hudFrame:addEventListener( "touch" )
	
	hudFrame.enterFrame = function( self )
		if( group.removeSelf == nil) then
			ignore( "enterFrame", hudFrame )
			return
		end
		-- Fill in current main memory usage
		collectgarbage("collect") -- Collect garbage every frame to get 'true' current memory usage
		local mmem = collectgarbage( "count" ) 
		mMemLabel.text = "M: " .. round(mmem/(1024),4) .. " MB"
		mMemLabel.x = hudFrame.x - 10
		mMemLabel.y = hudFrame.y

		-- Fill in current texture memory usage
		local tmem = system.getInfo( "textureMemoryUsed" )
		tMemLabel.text = "T: " .. round(tmem/(1024 * 1024),4) .. " MB"
		tMemLabel.x = hudFrame.x + 10
		tMemLabel.y = hudFrame.y
		group:toFront()
	end; listen( "enterFrame", hudFrame )
	return group
end

-- Easy Blur
--
misc.easyBlur = function( group, time, color )
	group = group or display.getCurrentStage()
	time = time or 0
	color = color or {0.5,0.5,0.5}
	local blur = display.captureScreen()
	blur.x, blur.y = centerX, centerY
	blur:setFillColor(unpack(color))
	blur.fill.effect = "filter.blur"
	blur.alpha = 0
	group:insert( blur )
	blur:addEventListener("touch", 
		function( event ) 
			if( event.phase == "ended" or event.phase == "cancelled" ) then
				transition.to( blur, { alpha = 0, time = time, onComplete = display.remove } )
			end
			return true 
		end )
	transition.to( blur, { alpha = 1, time = time } )
	return blur
end

-- Easy Shake
--
-- Derived from this: http://forums.coronalabs.com/topic/53736-simple-shake-easing-code-and-demo/
misc.easyShake = function( obj, amplitude, time )
	local shakeEasing = function(currentTime, duration, startValue, targetDelta)
		local shakeAmplitude = amplitude -- maximum shake in pixels, at start of shake
		local timeFactor = (duration-currentTime)/duration -- goes from 1 to 0 during the transition
		local scaledShake =( timeFactor*shakeAmplitude)+1 -- adding 1 prevents scaledShake from being less then 1 which would throw an error in the random code in the next line
		local randomShake = math.random(scaledShake)
		return startValue + randomShake - scaledShake*0.5 -- the last part detracts half the possible max shake value so the shake is "symmetrical" instead of always being added at the same side
	end -- shakeEasing
	if( not obj._shakeX0 ) then
		obj._shakeX0 = obj.x
		obj._shakeY0 = obj.y
	end
	local function onComplete(self)
		if( obj.removeSelf == nil ) then return end
		obj.x = obj._shakeX0
		obj.y = obj._shakeY0
	end
	transition.to(obj , {time = time, x = obj.x, y = obj.y, transition = shakeEasing, onComplete = onComplete } ) -- use the displayObjects current x and y as parameter
end

-- Easy alert popup
--
-- title - Name on popup.
-- msg - message in popup.
-- buttons - table of tables like this:
-- { { "button 1", opt_func1 }, { "button 2", opt_func2 }, ...}
--
misc.easyAlert = function( title, msg, buttons )

	local function onComplete( event )
		local action = event.action
		local index = event.index
		if( action == "clicked" ) then
			local func = buttons[index][2]
			if( func ) then func() end 
	    end
	    --native.cancelAlert()
	end

	local names = {}
	for i = 1, #buttons do
		names[i] = buttons[i][1]
	end
	--print( title, msg, names, onComplete )
	local alert = native.showAlert( title, msg, names, onComplete )
	return alert
end

-- Easy popup
--
-- title - Name on popup.
-- msg - message in popup.
-- buttons - table of tables like this:
-- { { "button 1", opt_func1 }, { "button 2", opt_func2 }, ...}
--
misc.easyPopup = function( title, msg, buttons, params )

	params = params or {}
	params.edgeOffset 		= params.edgeOffset or 20
	
	params.titleFont 		= params.titleFont or native.systemFontBold
	params.titleFontSize 	= params.titleFontSize or 20
	
	params.msgFont 			= params.msgFont or native.systemFont
	params.msgFontSize		= params.msgFontSize or 14

	params.buttonFont 		= params.buttonFont or native.systemFont
	params.buttonFontSize 	= params.buttonFontSize or 12

	local newImageRect	= ssk.display.imageRect
	local newRect		= ssk.display.rect
	local group = display.newGroup()
	local popup = display.newGroup()
	group:insert(popup)

	local function onTouch( self, event )
		local target  = event.target
		local eventID = event.id
		if(event.phase == "began") then
			display.getCurrentStage():setFocus( target, eventID )
			target.isFocus = true
			target:setFillColor(0,0,0,0.1)
		elseif(target.isFocus) then
			if(event.phase == "ended" or event.phase == "cancelled") then
				display.getCurrentStage():setFocus( nil, eventID )
				target.isFocus = false
				if(target.myCB) then target.myCB() end 
				ignore( "enterFrame", group )
				display.remove(group)
			end
		end
		return true
	end


	local blocker = newImageRect( group, centerX, centerY, "images/fillT.png", { w = fullw, h = fullh } )
	blocker.touch = function( self, event ) return true end
	blocker:addEventListener( "touch" )
	popup:toFront()

	-- Title
	local titleText = display.newText( popup, title, centerX, 0, params.titleFont, params.titleFontSize )
	titleText:setFillColor( 0, 0, 0 )
	titleText.anchorY = 0
	titleText.y = top + titleText.contentHeight/2

	-- Text Body
	local options = 
	{
	    parent 		= popup,
	    text 		= msg,
	    x 			= 0,
	    y 			= 0,
	    width 		= fullw - params.edgeOffset * 4,
	    --font = native.systemFontBold,
	    font 		= params.msgFont,
	    fontSize 	= params.msgFontSize,
	    align = "left"  --new alignment parameter
	}

	local textBody = display.newText( options )
	textBody:setFillColor( 0, 0, 0 )
	textBody.anchorX = 0
	textBody.anchorY = 0
	textBody.y = titleText.contentHeight + 40
	textBody.x = left + params.edgeOffset

	group.enterFrame = function( self )
		self:toFront()
	end; listen( "enterFrame", group )

	-- Buttons
	--
	local buttonsY = textBody.y + textBody.contentHeight + 40
	local buttonsText = {}
	local totalTextWidth = 0
	for i = 1, #buttons do
		local buttonText = display.newText( popup, buttons[i][1], left, buttonsY, params.buttonFont, params.buttonFontSize )
		buttonText:setFillColor( 0, 0, 0 )
		buttonText.anchorX = 0
		buttonsText[i] = buttonText
		totalTextWidth = totalTextWidth + buttonText.contentWidth
	end

	local ox = fullw - totalTextWidth - params.edgeOffset * 2
	ox = math.floor(ox / (#buttons + 1))
	ox = (ox<0) and 0 or ox
	local edgeBuffer = (ox > 20) and 20 or 0
	print(ox)
	local curX = left + ox
	for i = 1, #buttonsText do
		buttonsText[i].x = curX
		curX = curX + buttonsText[i].contentWidth + ox
		local button = newRect( popup, buttonsText[i].x + buttonsText[i].contentWidth/2, buttonsText[i].y, 
								{ w = buttonsText[i].contentWidth + 20, h = buttonsText[i].contentHeight + 10, 
								  stroke = _DARKERGREY_, strokeWidth = 2 } )
		buttonsText[i]:toFront()

		button.myCB = buttons[i][2]
		button.touch = onTouch
		button:addEventListener("touch")
	end

	-- BackRect
	--
	local backRect = newRect( popup, left, top, { w = fullw - params.edgeOffset * 2, h = popup.contentHeight + 30,
		                                     stroke = _DARKERGREY_, strokeWidth = 1, anchorX = 0, anchorY = 0 } )
	backRect:toBack()
	popup.anchorChildren = true
	popup.x = centerX
	popup.y = centerY

	return group
end


-- Rudimentary 'is valid format' e-mail check
--
misc.isValidEmail = function( val, debugEn )

	if( debugEn ) then
		print( val, string.len(val), string.match( val, "@" ), #val:split("@") )
	end
	if( not val or string.len(val) == 0 ) then return false end
	if( string.match( val, "@" ) == nil ) then return false end
	val = val:split("@") 
	if(#val<2) then return false end
	return true
end

-- temporarily block touches
--
misc.blockTouchesForDuration = function( duration, subtle )
	local blocker = newRect( nil, centerX, centerY, { w = fullw, h = fullh, fill = _K_, alpha = 0 , isHitTestable = true} )
	local upAlpha = 0.5
	if(subtle) then upAlpha = 0 end
	transition.to(blocker, { alpha = upAlpha, time = 350 } )
	--local loading = makeThrobber( display.currentStage, centerX, centerY )
	--if(subtle) then loading.isVisible = false end

	blocker.enterFrame = function( self )
		if( not self.toFront ) then
			ignore("enterFrame", self)
			return
		end
		self:toFront()
		loading:toFront()
	end
	blocker.touch = function() return true end
	blocker:addEventListener( "touch" )

	blocker.timer = function(self)
		if( not self.removeSelf ) then return end
		local function onComplete()
			if( not self.removeSelf ) then return end
			ignore("enterFrame", blocker)
			blocker:removeEventListener( "touch" )
			display.remove(blocker)
			display.remove(loading)
		end
		transition.to( blocker, { alpha = 0, time = 250, onComplete = onComplete } )		
	end
	timer.performWithDelay( duration, blocker )
end

-- 
--
misc.easyRemoteImage = function( curImg, fileName, imageURL, baseDirectory ) 
	--print(curImg, fileName, imageURL )
	--table.dump(curOrder)

	baseDirectory = baseDirectory or system.TemporaryDirectory

	if( string.match( imageURL, "http" ) == nil ) then
		imageURL =  "http:" .. imageURL
	end

	if( io.exists( fileName, baseDirectory ) ) then
		curImg.fill = { type = "image", baseDir = baseDirectory, filename = fileName }
		return
	end

	local function networkListener( event )
	    if ( event.isError ) then
	        --print( "Network error - download failed" )
	    elseif ( event.phase == "began" ) then
	        --print( "Progress Phase: began" )
	    elseif ( event.phase == "ended" ) then
	        --print( "Displaying response image file" )
	        curImg.fill = { type = "image", baseDir = event.response.baseDirectory, filename = event.response.filename }
	    end
	end

	local params = {}
	params.progress = false

	network.download(
	    imageURL,
	    "GET",
	    networkListener,
	    params,
	    fileName,
	    baseDirectory
	)
end

-- ========================================================================
function misc.oleft( obj ) 
	if( obj.anchorX == 0 ) then
		return obj.x
	elseif( obj.anchorX == 1 ) then
		return obj.x - obj.contentWidth
	end
	return obj.x - obj.contentWidth/2
end

function misc.oright( obj ) 
	if( obj.anchorX == 1 ) then
		return obj.x
	elseif( obj.anchorX == 0 ) then
		return obj.x + obj.contentWidth
	end
	return obj.x + obj.contentWidth/2
end

function misc.ohcenter( obj ) 
	if( obj.anchorX == 1 ) then
		return obj.x - obj.contentWidth/2
	elseif( obj.anchorX == 0 ) then
		return obj.x + obj.contentWidth/2
	end
	return obj.x 
end

function misc.obottom( obj ) 
	if( obj.anchorY == 0 ) then
		return obj.y + obj.contentHeight
	elseif( obj.anchorY == 1 ) then
		return obj.y
	end
	return obj.y + obj.contentHeight/2
end

function misc.otop( obj ) 
	if( obj.anchorY == 0 ) then
		return obj.y 
	elseif( obj.anchorY == 1 ) then
		return obj.y - obj.contentHeight
	end
	return obj.y - obj.contentHeight/2
end

function misc.ovcenter( obj ) 
	if( obj.anchorY == 0 ) then
		return obj.y + obj.contentHeight/2
	elseif( obj.anchorY == 1 ) then
		return obj.y - obj.contentHeight/2
	end
	return obj.y
end
function misc.protoDim( group, obj, fontSize, color  )
	fontSize = fontSize or 12
	color = color or _P_

	local cw = obj.contentWidth
	local ch = obj.contentHeight
	local cr = misc.oright(obj) 
	local cb = misc.oright(obj)
	--local tmp = easyIFC:quickLabel( group, "< " .. cw .. ", " .. ch .. " >", cw/2-5, ch/2-5, gameFont, fontSize, color )
	--local tmp = easyIFC:quickLabel( group, "< " .. cw .. ", " .. ch .. " >", cr, cb, openSans, gameFont, color )
	local tmp = easyIFC:quickLabel( group, "< " .. cw .. ", " .. ch .. " >", obj.x + cw/2-5, obj.y + ch/2-5, gameFont, fontSize, color )
	tmp.anchorX = 1
	tmp.anchorY = 1
	--if( obj.anchorY == 0 ) then tmp.x = tmp.x + ch/2 end
	nextFrame( function() tmp:toFront() end, 500 )
end

function misc.aboveY( obj, params )
	if skip(obj) then return end 
	local x,y = obj.parent:localToContent( obj.x, obj.y )
	if( y < params.y ) then 
		post(params.eventName, { y = y } )
		--print("POSTING", params.eventName)
	end
end

function misc.belowY( obj, params )
	if( not isValid( obj ) ) then return end
	local x,y = obj.parent:localToContent( obj.x, obj.y )
	if( y > params.y ) then 
		post(params.eventName, { y = y } )
		--print("POSTING", params.eventName)
	end
end



-- ========================================================================

return misc