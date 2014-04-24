-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Labels Factory
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

-- External helper functions
local labels

if( not _G.ssk.labels ) then
	_G.ssk.labels = {}
	_G.ssk.labels.presetsCatalog = {}
end

labels = _G.ssk.labels

-- ==
--    ssk.labels:addPreset( presetName, params ) - Creates a label button preset (table containing visual options for label).
-- ==
function labels:addPreset( presetName, params )
	local entry = {}

	self.presetsCatalog[presetName] = entry

	entry.text           = fnn(params.text, "")
	entry.font           = fnn(params.font, native.systemFontBold)
	entry.fontSize       = fnn(params.fontSize, 20)
	entry.textColor          = fnn(params.textColor, {255,255,255,255})

	entry.emboss         = fnn(params.emboss, false)
	entry.embossTextColor     = fnn(params.embossTextColor, {255,255,255,255})
	entry.embossHighlightColor = fnn(params.embossHighlightColor, {255,255,255,255})
	entry.embossShadowColor    = fnn(params.embossShadowColor, {0,0,0,255})

	entry.referencePoint = fnn(params.referencePoint, display.CenterReferencePoint)
end

-- ==
--    ssk.labels:new( params, screenGroup ) - Core builder function for creating new labels.
-- ==
function labels:new( params, screenGroup )

	local screenGroup = screenGroup or display.currentStage

	local tmpParams = {}

	-- 1. Check for catalog entry option and apply FIRST 
	-- (allows us to override by passing params too)
	tmpParams.presetName     = params.presetName, nil 
	local presetCatalogEntry = self.presetsCatalog[tmpParams.presetName]
	if(presetCatalogEntry) then
		for k,v in pairs(presetCatalogEntry) do
			tmpParams[k] = v
		end
	end

	-- 2. Apply any passed params
	if(params) then
		for k,v in pairs(params) do
			tmpParams[k] = v
		end
	end

	-- 3. Ensure all 'required' values have something in them Snag Setting (assume all set)
	tmpParams.x              = fnn(tmpParams.x, display.contentWidth/2)
	tmpParams.y              = fnn(tmpParams.y, 0)
	tmpParams.embossTextColor     = fnn(tmpParams.embossTextColor, {255,255,255,255})
	tmpParams.embossHighlightColor = fnn(tmpParams.embossHighlightColor, {255,255,255,255})
	tmpParams.embossShadowColor    = fnn(tmpParams.embossShadowColor, {0,0,0,255})
	tmpParams.referencePoint = fnn(tmpParams.referencePoint, display.CenterReferencePoint)

	-- Create the label
	local labelInstance
	if(tmpParams.emboss) then
		labelInstance = display.newEmbossedText( tmpParams.text, 0, 0, tmpParams.font, tmpParams.fontSize, tmpParams.textColor )
	else
		labelInstance = display.newText( tmpParams.text, 0, 0, tmpParams.font, tmpParams.fontSize )
	end	

	-- 4. Store the params directly in the 
	for k,v in pairs(tmpParams) do
		labelInstance[k] = v
	end

	-- 5. Assign methods based on embossed or not
	if(labelInstance.emboss) then
		
		if(not labelInstance.setText) then
			function labelInstance:setText( text )
				self.label.text = text
				self.highlight.text = text
				self.shadow.text = text
				self.text = text
				return self.text
			end
		else
			labelInstance._old_setText = labelInstance.setText
			function labelInstance:setText( text )
				labelInstance:_old_setText( text )				
				self.text = text
				return self.text
			end
		end

		-- ==
		--    myLabel:setLabelTextColor( textColor ) - Changes the text color of the label (works for embossed and regular text).
		-- ==
		function labelInstance:setLabelTextColor( textColor )
			local label = self._label or self.label
			local r = textColor[1] or 255
			local g = textColor[2] or 255
			local b = textColor[3] or 255
			local a = textColor[4] or 255
			label:setTextColor(r,g,b,a)
		end

		-- ==
		--    myLabel:setHighlightTextColor( textColor ) - Changes the embossed text highlight color of the label.
		-- ==
		function labelInstance:setHighlightTextColor( textColor )
			local highlight = self._highlight or self.highlight
			local r = textColor[1] or 255
			local g = textColor[2] or 255
			local b = textColor[3] or 255
			local a = textColor[4] or 255
			highlight:setTextColor(r,g,b,a)
		end

		-- ==
		--    myLabel:setShadowTextColor( textColor ) - Changes the embossed text shadow color of the label.
		-- ==
		function labelInstance:setShadowTextColor( textColor )
			local shadow = self._shadow or self.shadow
			local r = textColor[1] or 255
			local g = textColor[2] or 255
			local b = textColor[3] or 255
			local a = textColor[4] or 255
			shadow:setTextColor(r,g,b,a)
		end

		-- ==
		--    myLabel:setTextColors( embossTextColor, embossHighlightColor, embossShadowColor ) - Changes text, highlight, and shadow colors for a embossed label.
		-- ==
		function labelInstance:setTextColors( embossTextColor, embossHighlightColor, embossShadowColor )
			self:setLabelTextColor(embossTextColor)
			self:setHighlightTextColor(embossHighlightColor)
			self:setShadowTextColor(embossShadowColor)
		end

		-- ==
		--    myLabel:getText( ) - Gets the label text.
		-- ==
		function labelInstance:getText()
			return self.text
		end

	else

		-- ==
		--    myLabel:setText( text ) - Changes the label text.
		-- ==
		function labelInstance:setText( text )
			self.text = text
			return self.text
		end

		function labelInstance:setLabelTextColor( textColor )
			print("warning: not embossed text" )
		end

		function labelInstance:setHighlightTextColor( textColor )
			print("warning: not embossed text" )
		end

		function labelInstance:setShadowTextColor( textColor )
			print("warning: not embossed text" )
		end

		function labelInstance:setTextColors( embossTextColor, embossHighlightColor, embossShadowColor )
			print("warning: not embossed text" )
		end

		-- ==
		--    funcname() - description
		-- ==
		function labelInstance:getText()
			return self.text
		end

	end	

	-- 6. Set textColor
	if(labelInstance.emboss) then
		if(labelInstance.textColor) then
			local r = fnn(labelInstance.textColor[1],  255)
			local g = fnn(labelInstance.textColor[2],  255)
			local b = fnn(labelInstance.textColor[3],  255)
			local a = fnn(labelInstance.textColor[4],  255)
			labelInstance:setTextColor(r,g,b,a)
		end

		if(labelInstance.embossTextColor) then
			labelInstance:setLabelTextColor(labelInstance.embossTextColor)
		end
		if(labelInstance.embossHighlightColor) then
			labelInstance:setHighlightTextColor(labelInstance.embossHighlightColor)
		end
		if(labelInstance.embossShadowColor) then
			labelInstance:setShadowTextColor(labelInstance.embossShadowColor)
		end
	else
		if(labelInstance.textColor) then
			local r = fnn(labelInstance.textColor[1],  255)
			local g = fnn(labelInstance.textColor[2],  255)
			local b = fnn(labelInstance.textColor[3],  255)
			local a = fnn(labelInstance.textColor[4],  255)
			labelInstance:setTextColor(r,g,b,a)
		end
	end

	-- 6. Set reference point and do final positioning
	labelInstance:setReferencePoint( labelInstance.referencePoint )
	labelInstance.x = tmpParams.x
	labelInstance.y = tmpParams.y

	if(screenGroup) then
		screenGroup:insert(labelInstance)
	end

	return labelInstance
end


-- ==
--    ssk.labels:presetLabel( group, presetName, text, x, y [, params ] ) - A label builder utilizing a preset to set the label's visual options.
-- ==
function labels:presetLabel( group, presetName, text, x, y, params  )
	local group = group or display.currentStage
	local presetName = presetName or "default"
		
	local tmpParams = params or {}
	tmpParams.presetName = presetName
	tmpParams.text = text
	tmpParams.x = x
	tmpParams.y = y
	
	local tmpLabel = self:new(tmpParams, group)
	return tmpLabel
end


-- ==
--    ssk.labels:quickLabel( group, text, x, y [, font [, fontSize [, textColor ] ] ] ) - An alternative label builder.  Only supports basic text options.
-- ==
function labels:quickLabel( group, text, x, y, font, fontSize, textColor )
	local group = group or display.currentStage
	local tmpParams = 
	{ 
		text = text,
		x = x,
		y = y,
		font = font or native.systemFont,
		fontSize = fontSize or 16,
		textColor  = textColor or _WHITE_
	}

	local tmpLabel = self:new(tmpParams, group)
	return tmpLabel
end

-- ==
--    ssk.labels:quickEmbossedLabel( group, text, x, y [, font [, fontSize [, embossTextColor [, embossHighlightColor [, embossShadowColor ] ] ] ] ] ) An alternative embossed label builder.  Only supports basic embossed options.
-- ==
function labels:quickEmbossedLabel( group, text, x, y, font, fontSize, embossTextColor, embossHighlightColor, embossShadowColor )
	local group = group or display.currentStage
	local tmpParams = 
	{ 
		text = text,
		x = x,
		y = y,
		font = font or native.systemFont,
		fontSize = fontSize or 16,
		embossTextColor  = embossTextColor or _BLACK_,
		embossHighlightColor  = embossHighlightColor or _LIGHTGREY_,
		embossShadowColor  = embossShadowColor or _TRANSPARENT_,
		emboss = true
	}

	local tmpLabel = self:new(tmpParams)
	group:insert(tmpLabel)
	return tmpLabel
end

