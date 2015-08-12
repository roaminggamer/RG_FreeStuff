-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- HUDS Factory
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
-- Docs: https://github.com/roaminggamer/SSKCorona/wiki
-- =============================================================

local huds

if( not _G.ssk.huds ) then
	_G.ssk.huds = {}
end

huds = _G.ssk.huds

-- =================================================
--  Time HUD (w/ countdown, countup features)
-- =================================================
-- ==
--    ssk.huds:createTimeHUD( x, y, presetName, group [ , params ] ) - Creates a numeric time(r) hud formatted as HH:MM:SS.  It can be set manually to a fixed time and has a automatic countdown/up features. 
-- ==
function huds:createTimeHUD( x, y, presetName, group, params )
	local theHUD = ssk.labels:presetLabel( group, presetName, "0:00", x, y, params  )

	group:insert(theHUD)

	theHUD.curTime = 0
	theHUD.x, theHUD.y = x,y
	--theHUD.myx, theHUD.myy = x,y

	-- ==
	--    theHUD:get() - Gets the current number of seconds in the hud.
	-- ==
	function theHUD:get()
		return self.curTime
	end

	-- ==
	--    theHUD:set( seconds ) - Sets the current time for the hud.
	-- ==
	function theHUD:set( seconds )
		self.curTime = seconds
		self:setText( ssk.misc.convertSecondsToTimer( self.curTime ) )
		--self.x, self.y = self.myx, self.myy
	end

	-- ==
	--    theHUD:autoCount( maxTime, callback ) - Start the timer counting up from the current value to a maxTime.  Optionally calls a callback when maxTime is reached.
	-- ==
	function theHUD:autoCount( maxTime, callback)
		
		self.timer = function()
			self.curTime = self.curTime + 1
			self:setText( ssk.misc.convertSecondsToTimer( self.curTime ) )
			if( maxTime and ( self.curTime == maxTime ) )then
				if(callback) then
					callback( self )
				end
				timer.cancel(self.myTimer)
				self.myTimer = nil
				return
			end			
		end
		self.myTimer = timer.performWithDelay( 1000, self, 0 )
	end

	-- ==
	--    theHUD:autoCountDown( minTime, callback ) - Start the timer counting down from the current value to a minTime.  Optionally calls a callback when minTime is reached.
	-- ==
	function theHUD:autoCountDown( minTime, callback ) -- EFM swap order of args, make minTime optional
		
		self.timer = function()
			self.curTime = self.curTime - 1
			if(self.curTime >= 0) then
				self:setText( ssk.misc.convertSecondsToTimer( self.curTime ) )
			end

			if( minTime and ( self.curTime == minTime ) )then
				if(callback) then
					callback( self )
				end
				if(self.myTimer) then
					timer.cancel(self.myTimer)
					self.myTimer = nil
				end
				return
			end			
		end
		self.myTimer = timer.performWithDelay( 1000, self, 0 )
	end

	-- ==
	--    theHUD:stop() - Stops the current countup/countdown timer.
	-- ==
	function theHUD:stop()
		if( self.myTimer ) then
			timer.cancel(self.myTimer)
			self.myTimer = nil
		end
	end

	return theHUD
end


-- =================================================
--  Score HUD
-- =================================================
-- ==
--    ssk.huds:createNumericScoreHUD( x, y, digits, presetName, group [ , params ] ) - Creates a textual (numeric) score hud using an ssk.label with added functions. (Bug: Has a problem with digits ~= 0 and negative numbers. 10 NOV 2012)
-- ==
function huds:createNumericScoreHUD( x, y, digits, presetName, group, params)
	local theHUD = ssk.labels:presetLabel( group, presetName, string.lpad( "0", digits,'0'), x, y, params  )

	group:insert(theHUD)

	theHUD.curValue = 0
	theHUD.x, theHUD.y = x,y
	--theHUD.myx, theHUD.myy = x,y

	theHUD.digits = digits or 0

	-- ==
	--    theHUD:get() - Gets the currrent score on the hud.
	-- ==
	function theHUD:get()
		return self.curValue
	end


	-- ==
	--    theHUD:set( value ) - Set the current score.
	-- ==
	function theHUD:set( value )
		self.curValue = value
		if(self.digits) then
			self:setText( string.lpad( tostring(self.curValue) , self.digits,'0') )
		else
			self:setText( tostring(value) )
		end
	end

	-- ==
	--    theHUD:increment( value  ) - Adds value to the current score.
	-- ==
	function theHUD:increment( value )
		self.curValue = self.curValue + value
		if(self.digits) then
			self:setText( string.lpad( tostring(self.curValue) , self.digits,'0') )
		else
			self:setText( tostring(value) )
		end
	end

	return theHUD
end

-- =================================================
--  Horizonal Image Counter 
-- =================================================
-- ==
--    ssk.huds:createHorizImageCounter( group, x, y, imgSrc, imgW, imgH, maxValue, intialValue ) - Creates a horizontal graphical counter.  (Like a lives counter on old-school games.)
-- ==
function huds:createHorizImageCounter( group, x, y, imgSrc, imgW, imgH, maxValue, intialValue )
	
	local initialValue = initialValue or 0

	local theHUD = display.newGroup()
	group:insert(theHUD)

	--theHUD.myx, theHUD.myy = x,y
	theHUD.curValue = 0
	theHUD.maxValue = maxValue

	for i=1, maxValue do
		local img = display.newImageRect( theHUD, imgSrc, imgW, imgH )
		img.x = (i-1) * imgW
		img.y = 0
	end

	theHUD:setReferencePoint(display.CenterReferencePoint)
	theHUD.x, theHUD.y = x,y


	-- ==
	--    theHUD:set( value ) - Sets the number of currently visible elements in the hud up to the initially configured maxValue.
	-- ==
	function theHUD:set( value )
		self.curValue = value
		if(self.curValue < 0) then self.curValue = 0 end
		if(self.curValue > self.maxValue) then self.curValue = self.maxValue end

		for i=1, self.maxValue do
			if(i > self.curValue) then
				self[i].isVisible = false
			else
				self[i].isVisible = true
			end
		end

	end

	theHUD:set( intialValue )

	-- ==
	--    theHUD:get() - Gets the number of elements currently visible on this hud.
	-- ==
	function theHUD:get()
		return self.curValue
	end

	-- ==
	--    theHUD:increment( value ) - Add value visible elements to the hud, up to the initially configured maxValue.
	-- ==
	function theHUD:increment( value )
		self.curValue = self.curValue + value
		self:set( self.curValue )
	end

	return theHUD
end


-- =================================================
--  Percentage Dial
-- =================================================
-- ==
--    ssk.huds:createHorizImageCounter( group, x, y, imgSrc, imgW, imgH, maxValue, intialValue ) - Creates a masked dial that can take the range [0,100] and display it graphically.
-- ==
function huds:createPercentageDial( group, x, y, params )
	local params = params or 
	{
		size        = 128,
		dialSrc     = _DARKGREY_,
		backSrc     = _BLACK_,
		maskPath    = imagesDir .. "interface/huds/dialMask1.png",
		maskW       = 128,
		maskH       = 128,
		overlayPath = nil,
		text        = true,
		textSize    = 24,
		textFont    = system.nativeFont,
		textColor   = _WHITE_,
		textSuffix  = "%",
		textPrefix  = "",
		percent     = 100,
	}

	local hud = display.newGroup()


	local size        = params.size or 128
	local dialSrc     = params.dialSrc or _DARKGREY_ 
	local backSrc     = params.backSrc or _BLACK_
	local maskPath    = params.maskPath or imagesDir .. "interface/huds/dialMask1.png"
	local maskW       = params.maskW or 128
	local maskH       = params.maskH or 128
	local text        = fnn(params.text, true)
	local textSize    = params.textSize or 10
	local textFont    = params.textFont or system.nativeFont
	local textColor   = params.textColor or _WHITE_
	local textSuffix  = params.textSuffix or "%"
	local textPrefix  = params.textPrefix or ""
	local percent     = params.percent or 100

	local dialGroup = display.newGroup()

	hud:insert(dialGroup)

	hud.mask = graphics.newMask( maskPath )

	if(hud.mask) then
		hud:setMask( hud.mask )
		hud.maskScaleX = size / maskW
		hud.maskScaleY = size / maskH

		hud.maskX = size/2
		hud.maskY = size/2
	end

	hud.leftBack    = display.newRect(dialGroup, 0,0,size/2,size)
	hud.leftBack:setReferencePoint( display.CenterRightReferencePoint )
	hud.leftBack.x = size/2
	hud.leftBack.y = size/2
	hud.leftBack:setFillColor( unpack(backSrc) )

	hud.leftDial    = display.newRect(dialGroup, 0,0,size/2,size)
	hud.leftDial:setReferencePoint( display.CenterRightReferencePoint )
	hud.leftDial.x = size/2
	hud.leftDial.y = size/2
	hud.leftDial:setFillColor( unpack(dialSrc) )

	hud.rightBack    = display.newRect(dialGroup, 0,0,size/2,size)
	hud.rightBack:setReferencePoint( display.CenterLeftReferencePoint )
	hud.rightBack.x = size/2
	hud.rightBack.y = size/2
	hud.rightBack:setFillColor( unpack(backSrc) )

	hud.rightDial    = display.newRect(dialGroup, 0,0,size/2,size)
	hud.rightDial:setReferencePoint( display.CenterLeftReferencePoint )
	hud.rightDial.x = size/2
	hud.rightDial.y = size/2
	hud.rightDial:setFillColor( unpack(dialSrc) )

	if(params.overlayPath) then
		hud.overlay    = display.newImageRect(hud, params.overlayPath, size,size)
		hud.overlay:setReferencePoint( display.CenterReferencePoint )
		hud.overlay.x = size/2
		hud.overlay.y = size/2
	end

	if(text) then
		hud.label  = display.newText( tostring(percent) .. "%", size/2, size/2, textFont, textSize )
		hud:insert(hud.label)
		hud.label:setTextColor( unpack( textColor ) )
		hud.label:setReferencePoint( display.CenterReferencePoint )
		hud.label.x = size/2
		hud.label.y = size/2

	end

	hud:setReferencePoint( display.CenterReferencePoint )
	hud.x,hud.y = x,y

	-- ==
	--    theHUD:getPercent() - Gets the current percent value of this hud.
	-- ==
	hud.getPercent = function( self )
		return self.percent
	end


	-- ==
	--    theHUD:setPercent( percent ) - Sets the hud to a specific percentage value.
	-- ==
	hud.setPercent = function( self, percent )
		local percent = percent
		if(percent < 0) then
			percent = 0
		elseif(percent > 100) then
			percent = 100
		end
		
		if( percent < 0 ) then
			self.rightDial.rotation = 0
			self.leftDial.rotation = 0
			self.rightDial.isVisible = true
		elseif( percent <  50 ) then
			self.rightDial.rotation = (percent/100 * 360)
			self.leftDial.rotation = 0
			self.rightDial.isVisible = true
		elseif( percent > 100 ) then
			self.rightDial.rotation = 180
			self.leftDial.rotation = 180
			self.rightDial.isVisible = false
		elseif( percent >= 50 ) then
			self.rightDial.rotation = 180
			self.leftDial.rotation = ((percent-50)/100 * 360)
			self.rightDial.isVisible = false
		end

		if(text) then
			self.label.text = textPrefix .. tostring(percent) .. textSuffix
			self.label:setReferencePoint( display.CenterReferencePoint )
			self.label.x = size/2
			self.label.y = size/2
		end

		self.percent = percent

	end

	--hud.percent = percent

	hud:setPercent( percent )

	group:insert( hud )

	return hud
end

-- =================================================
--  Percentage Bar
-- =================================================
-- ==
--    ssk.huds:createPercentageBar( group, x, y, params ) - Creates a masked horizontal bar that can take the range [0,100] and display it graphically.
-- ==
function huds:createPercentageBar( group, x, y, params )
	local params = params or 
	{
		w            = 128,
		h            = 32,
		barSrc     = _DARKGREY_,
		backSrc    = _BLACK_,
		maskPath     = imagesDir .. "interface/huds/barMask1.png",
		maskW       = 256,
		maskH       = 64,
		overlayPath  = nil,
		text         = true,
		textSize     = 24,
		textFont     = system.nativeFont,
		textColor    = _WHITE_,
		textSuffix   = "%",
		textPrefix   = "",
		textRotation = 0,
		textXScale   = 1,
		percent      = 100,
	}

	local hud = display.newGroup()


	local width        = params.w or 128
	local height       = params.h or 32
	local barSrc       = params.barSrc or _DARKGREY_ 
	local backSrc      = params.backSrc or _BLACK_
	local maskPath     = params.maskPath or imagesDir .. "interface/huds/barMask1.png"
	local maskW       = params.maskW or 256
	local maskH       = params.maskH or 64
	local overlayPath  = params.overlayPath or nil
	local text         = fnn(params.text, true)
	local textSize     = params.textSize or 10
	local textFont     = params.textFont or system.nativeFont
	local textColor    = params.textColor or _WHITE_
	local textSuffix   = params.textSuffix or "%"
	local textPrefix   = params.textPrefix or ""
	local textRotation = params.textRotation or 0
	local textXScale   = params.textXScale or 1
	local percent      = params.percent or 100
		
	local barGroup = display.newGroup()

	hud:insert(barGroup)

	hud.mask = graphics.newMask( maskPath )
	hud:setMask( hud.mask )
	hud.maskScaleX = width / maskW
	hud.maskScaleY = height/ maskH

	hud.spacer    = display.newRect(barGroup, 0,0,3*width,2*height)
	hud.spacer:setReferencePoint( display.CenterReferencePoint )
	hud.spacer.x = 0
	hud.spacer.y = 0
	hud.spacer:setFillColor( unpack(_TRANSPARENT_) )

	hud.backBar    = display.newRect(barGroup, 0,0,width,height)
	hud.backBar:setReferencePoint( display.CenterReferencePoint )
	hud.backBar:setFillColor( unpack(backSrc) )
	hud.backBar.x = 0		
	hud.backBar.y = 0

	hud.frontBar = display.newRect(barGroup, 0,0,width,height)
	hud.frontBar:setReferencePoint( display.CenterReferencePoint )
	hud.frontBar:setFillColor( unpack(barSrc) )
	hud.frontBar.x = -width
	hud.frontBar.y = 0


	if(overlayPath) then
		hud.overlay    = display.newImageRect(hud, params.overlayPath, width,height)
		hud.overlay:setReferencePoint( display.CenterReferencePoint )
		hud.overlay.x = 0
		hud.overlay.y = 0
	end

	if(text) then
		hud.label  = display.newText( tostring(percent) .. "%", width/2, height/2, textFont, textSize )
		hud:insert(hud.label)
		hud.label:setTextColor( unpack( textColor ) )
		hud.label:setReferencePoint( display.CenterReferencePoint )
		hud.label.x = 0
		hud.label.y = 0
		hud.label.rotation = textRotation
		hud.label.xScale = textXScale
	end

	hud:setReferencePoint( display.CenterReferencePoint )
	hud.x,hud.y = x,y

	-- ==
	--    theHUD:getPercent() - Gets the current percent value of this hud.
	-- ==
	hud.getPercent = function( self )
		return self.percent
	end
	
	-- ==
	--    theHUD:setPercent( percent ) - Sets the hud to a specific percentage value.
	-- ==
	hud.setPercent = function( self, percent )
		local percent = percent
		if(percent < 0) then
			percent = 0
		elseif(percent > 100) then
			percent = 100
		end

		self.frontBar.x = percent/100 * self.frontBar.width * -1

		if(text) then
			self.label.text = textPrefix .. tostring(percent) .. textSuffix
			self.label:setReferencePoint( display.CenterReferencePoint )
			self.label.x = 0
			self.label.y = 0
			hud.label.rotation = textRotation
			hud.label.xScale = textXScale

		end

		self.percent = percent

	end

	--hud.percent = percent

	hud:setPercent( percent )

	group:insert( hud )

	return hud
end


-- =================================================
--  Percentage Bar
-- =================================================
function huds:createPercentageImageBar( group, x, y, params )
	local params = params or 
	{
		w            = 128,
		h            = 32,
		barSrc     = _DARKGREY_,
		maskPath     = imagesDir .. "interface/huds/barMask1.png",
		maskW       = 256,
		maskH       = 64,
		underlayPath  = nil,
		overlayPath  = nil,
		text         = true,
		textSize     = 24,
		textFont     = system.nativeFont,
		textColor    = _WHITE_,
		textSuffix   = "%",
		textPrefix   = "",
		textRotation = 0,
		textXScale   = 1,
		percent      = 100,
	}

	local hud = display.newGroup()


	local width        = params.w or 128
	local height       = params.h or 32
	local barSrc       = params.barSrc or _DARKGREY_ 
	local maskPath     = params.maskPath or imagesDir .. "interface/huds/barMask1.png"
	local maskW       = params.maskW or 256
	local maskH       = params.maskH or 64
	local underlayPath  = params.underlayPath or nil
	local overlayPath  = params.overlayPath or nil
	local text         = fnn(params.text, true)
	local textSize     = params.textSize or 10
	local textFont     = params.textFont or system.nativeFont
	local textColor    = params.textColor or _WHITE_
	local textSuffix   = params.textSuffix or "%"
	local textPrefix   = params.textPrefix or ""
	local textRotation = params.textRotation or 0
	local textXScale   = params.textXScale or 1
	local percent      = params.percent or 100
		
	if(underlayPath) then
		hud.underlay    = display.newImageRect(hud, underlayPath, width,height)
		hud.underlay:setReferencePoint( display.CenterReferencePoint )
		hud.underlay.x = 0
		hud.underlay.y = 0
	end

	hud.imageBar = display.newImageRect(hud, barSrc, width, height)
	hud.imageBar:setReferencePoint( display.CenterReferencePoint )
	hud.imageBar.x = -width
	hud.imageBar.y = 0


	local mask = graphics.newMask( maskPath )
	hud.imageBar:setMask( mask )
	hud.imageBar.maskScaleX = 1--width / maskW
	hud.imageBar.maskScaleY = 1--height/ maskH

	if(overlayPath) then
		hud.overlay    = display.newImageRect(hud, overlayPath, width,height)
		hud.overlay:setReferencePoint( display.CenterReferencePoint )
		hud.overlay.x = 0
		hud.overlay.y = 0
	end

	if(text) then
		hud.label  = display.newText( tostring(percent) .. "%", width/2, height/2, textFont, textSize )
		hud:insert(hud.label)
		hud.label:setTextColor( unpack( textColor ) )
		hud.label:setReferencePoint( display.CenterReferencePoint )
		hud.label.x = 0
		hud.label.y = 0
		hud.label.rotation = textRotation
		hud.label.xScale = textXScale
	end

	hud:setReferencePoint( display.CenterReferencePoint )
	hud.x,hud.y = x,y

	hud.getPercent = function( self )
		return self.percent
	end
	
	hud.setPercent = function( self, percent )
		local percent = percent
		if(percent < 0) then
			percent = 0
		elseif(percent > 100) then
			percent = 100
		end

		hud.imageBar.maskX = percent/100 * self.imageBar.width * -1
		--self.imageBar.x = percent/100 * self.imageBar.width * -1

		if(text) then
			self.label.text = textPrefix .. tostring(percent) .. textSuffix
			self.label:setReferencePoint( display.CenterReferencePoint )
			self.label.x = 0
			self.label.y = 0
			hud.label.rotation = textRotation
			hud.label.xScale = textXScale

		end

		self.percent = percent

	end

	--hud.percent = percent

	hud:setPercent( percent )

	group:insert( hud )

	return hud
end
