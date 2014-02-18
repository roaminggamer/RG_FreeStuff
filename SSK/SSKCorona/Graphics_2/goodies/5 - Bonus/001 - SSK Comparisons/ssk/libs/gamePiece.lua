-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Image Sheets Manager - For use with new sprites functionality
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

local touch

local gamepiece

if( not _G.ssk.gamepiece ) then
	_G.ssk.gamepiece = {}
end

gamepiece = _G.ssk.gamepiece

-------------------------------------------------
-- BUILDER FUNCTIONS
-------------------------------------------------
function gamepiece:addPreset( presetName, params )	
	return
end

-- ==
--    func() - what it does
-- ==
function gamepiece:new( group, x, y, params )	
	local group = group or display.currentStage
	local thePiece = display.newGroup()

	local params = params or {}

	--table.dump(params)

	-- visual Params
	if( params.imagePaths ) then  -- Allow pieces with using images to have nil width/height
		print("In imagepaths")
		thePiece.w             = params.w or params.size
		thePiece.h             = params.h or params.size
	else
		print("Not in imagepaths")

		thePiece.w             = params.w or params.size or 40
		thePiece.h             = params.h or params.size or 40
	end
	thePiece.baseEn        = params.baseEn
	thePiece.imagePaths    = params.imagePaths
	thePiece.spriteSheet   = params.spriteSheet
	thePiece.sequenceData  = params.sequenceData
	thePiece.maskImage     = params.maskImage
	thePiece.maskWidth     = params.maskWidth or params.w or params.size or 40
	thePiece.maskHeight    = params.maskHeight or params.h or params.size or 40
	if(thePiece.w) then
		thePiece._maskScaleX   = params.maskXScale or thePiece.w/thePiece.maskWidth -- Can't set early, so precalculate and use later
	else
		thePiece._maskScaleX   = params.maskXScale or 1
	end
	if(thePiece.h) then
		thePiece._maskScaleY   = params.maskYScale or thePiece.h/thePiece.maskHeight -- Can't set early, so precalculate and use later
	else
		thePiece._maskScaleY   = params.maskYScale or 1
	end
	

	-- callback Params
	thePiece.onBegan     = params.onBegan
	thePiece.onMoved     = params.onMoved
	thePiece.onEnded     = params.onEnded

	-- interactive Params
	thePiece.dragEnabled = params.dragEnabled

	-- Base Piece
	if(thePiece.baseEn) then
		local base = display.newRect( thePiece, 0, 0, thePiece.w, thePiece.h )
		thePiece.base = base
	end

	-- (Loose) Images
	if(thePiece.imagePaths) then
		local imagePaths = thePiece.imagePaths
		local images = {}
		thePiece.images = images
		
		for k,v in pairs(imagePaths) do
			-- If the height or width is not specified, use newImage() instead.
			if( thePiece.w == nil or thePiece.h == nil ) then
				images[k] = display.newImage( thePiece, imagePaths[k] )
			else
				images[k] = display.newImageRect( thePiece, imagePaths[k], thePiece.w, thePiece.h )
			end

--EFM G2			images[k]:setReferencePoint( display.CenterReferencePoint )				
			images[k].x = images[k].contentWidth/2
			images[k].y = images[k].contentHeight/2
			images[k].isVisible = false
		end
	end
	
	-- Sprite
	if(thePiece.spriteSheet and thePiece.sequenceData) then
		local spriteSheet  = thePiece.spriteSheet
		local sequenceData = thePiece.sequenceData
		local aSprite = display.newSprite( spriteSheet, sequenceData )
		aSprite.xScale = thePiece.w/aSprite.contentWidth
		aSprite.yScale = thePiece.h/aSprite.contentHeight
		thePiece:insert(aSprite)
--EFM G2		aSprite:setReferencePoint( display.CenterReferencePoint )				
		aSprite.x = thePiece.w/2
		aSprite.y = thePiece.h/2
		thePiece.sprite = aSprite
		thePiece.sprite.isVisible = false
	end

	-- Mask
	if(thePiece.maskImage and thePiece.maskWidth and thePiece.maskHeight) then
		local mask = graphics.newMask( thePiece.maskImage )
		thePiece:setMask( mask )
		thePiece.mask = mask
		thePiece.maskScaleX = thePiece._maskScaleX 
		thePiece.maskScaleY = thePiece._maskScaleY
		thePiece.maskX = thePiece.w/2
		thePiece.maskY = thePiece.h/2
	end

	-- Attach touch listener to this piece
	if( thePiece.onBegan or thePiece.onMoved or thePiece.onEnded ) then
		thePiece.touch = touch
		thePiece:addEventListener( "touch" , thePiece)
	end

	-------------------------------------------------
	-- METHODS
	-------------------------------------------------
	-- Base Methods
	-- ==
	--    func() - what it does
	-- ==
	function thePiece:getBase()
		if(not self.base) then return nil end
		return self.base
	end

	-- Loose Image Methods
	-- ==
	--    func() - what it does
	-- ==
	function thePiece:getImages()
		if(not self.images) then return nil end
		return self.images
	end

	-- ==
	--    func() - what it does
	-- ==
	function thePiece:showImage( imgIndex )
	
		if(not self.images) then return false end
		if( not self.images[imgIndex]) then return false end
		for k,v in pairs(self.images) do
			v.isVisible = false
		end
		self.images[imgIndex].isVisible = true
		return true
	end

	-- ==
	--    func() - what it does
	-- ==
	function thePiece:showImages( )
		if(not self.images) then return false end
		for k,v in pairs(self.images) do
			v.isVisible = true
		end
		return true
	end

	-- ==
	--    func() - what it does
	-- ==
	function thePiece:hideImages( )
		if(not self.images) then return false end
		for k,v in pairs(self.images) do
			v.isVisible = false
		end
		return true
	end

	group:insert( thePiece )
--EFM G2	thePiece:setReferencePoint( display.CenterReferencePoint )
	thePiece.x = x or params.x or centerX
	thePiece.y = y or params.y or centerY
	return thePiece
end



-------------------------------------------------
-- TOUCH FUNCTION
-------------------------------------------------
touch = function( self, event )	
	local phase  = event.phase
	local id     = event.id

	local target = self.base or self

	if(phase == "began") then
		display.getCurrentStage():setFocus( target, id )
		target.isFocus = true

		if(self.onBegan) then
			self:onBegan( event )
		end

	elseif(target.isFocus) then

		local bounds = target.stageBounds
		local x,y = event.x, event.y
		local isWithinBounds = 
			bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y

		if(isWithinBounds) then

			if(phase == "moved") then

				if(self.dragEnabled) then
					self.x = event.x
					self.y = event.y
					self:toFront()
				end

				if(self.onMoved) then
					self:onMoved( event )
				end

			elseif(phase == "ended" or phase == "cancelled") then
				display.getCurrentStage():setFocus( target , nil )
				target.isFocus = false

				if(self.onEnded) then
					self:onEnded( event )
				end
			end

		else
			display.getCurrentStage():setFocus( target , nil )
			target.isFocus = false

			if(self.onEnded) then
				self:onEnded( event )
			end

		end

	elseif(phase == "moved") then
		display.getCurrentStage():setFocus( target, id )
		target.isFocus = true

		if(self.onBegan) then
			self:onBegan( event )
		end

		if(self.dragEnabled) then
			self.x = event.x
			self.y = event.y
			self:toFront()
		end


	else
		print("ERROR: gamepieces: onTouch() should never get here! phase == ", phase )
	end

	--print(target, phase, event.x, event.y, event.id, target.x, target.y, event.time)


	return true
end
