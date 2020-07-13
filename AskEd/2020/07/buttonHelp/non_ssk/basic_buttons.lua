--
-- Super basic two-image button helpers
--

local public = {}


--
-- Create Push-Button
--
function public.newPush( group, x, y, w, h, img1, img2, userListener )
	local button = display.newGroup()
	button.x = x
	button.y = y
	group:insert(button)

	button._unselImage = display.newImageRect( button, img2, w, h )
	button._selImage = display.newImageRect( button, img1, w, h )
	button._selImage.isVisible = false

	button._selected = false

	function button.updateImage( self )
		self._selImage.isVisible = self._selected
		self._unselImage.isVisible = not self._selected
	end

	function button.pressed( self )
		return self._selected
	end

	function button.touch( self, event )
		if( event.phase == "began" ) then
			self._selected =  true
			self:updateImage()
			display.getCurrentStage():setFocus( self, event.id )
      		self.isFocus = true

		elseif( self.isFocus ) then
			if( event.phase == "ended" ) then
				self._selected =  false
				self:updateImage()
				self.isFocus = false
				display.getCurrentStage():setFocus( self, nil )
				if ( userListener ) then
					userListener( event )
				end
			end

			return true
		end
		return false
	end
	button:addEventListener("touch")
	return button
end


--
-- Create Toggle-Button
--
function public.newToggle( group, x, y, w, h, img1, img2, userListener )
	local button = public.newPush( group, x, y, w, h, img1, img2, userListener )

	-- override touch listener added when creating button
	function button.touch( self, event )
		if( event.phase == "began" ) then
			self._selected = not self._selected
			self:updateImage()
			
			if ( userListener ) then
				userListener( event )
			end

			return true
		end
		return false
	end
	return button
end


--
-- Create Radio-Button
--
function public.newRadio( group, x, y, w, h, img1, img2, userListener )
	local button = public.newPush( group, x, y, w, h, img1, img2, userListener )
	button._isRadio = true

	-- override 'updateImage'  added when creating button 
	function button.updateImage( self )
		for i = 1, group.numChildren do
			local cur = group[i]			
			if(cur._isRadio) then				
				cur._selected = (cur == self)
				cur._selImage.isVisible = cur._selected
				cur._unselImage.isVisible = not cur._selected
			end
		end
	end
	
	-- override touch listener added when creating button
	function button.touch( self, event )
		if( event.phase == "began" ) then
			self:updateImage()			
			if ( userListener ) then
				userListener( event )
			end
			return true
		end
		return false
	end

	function button.toggle( self, skip_listener )
		self:updateImage()
		if( not skip_listener and userListener ) then
			self:userListener()
		end
	end
	return button
end


return public