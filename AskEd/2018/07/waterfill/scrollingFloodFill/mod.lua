
local mod = {}

function mod.create( group, x, y, params  )
	local water = display.newGroup()

	group:insert(water)
	group.x = x
	group.y = y

	local img = display.newRect( water, 0, 0, params.width, params.height)
	img.anchorX = 0
	img.anchorY = 0

	display.setDefault( "textureWrapX", "repeat" )
	display.setDefault( "textureWrapY", "repeat" )

	img.fill = { type = "image", filename = params.image }
	img.fill.scaleX = params.baseWidth/params.width
	img.fill.scaleY = params.baseHeight/params.height

	display.setDefault( "textureWrapX", "clampToEdge" )
	display.setDefault( "textureWrapY", "clampToEdge" )

	img.texOffsetX 	= 0
	img.texOffsetY 	= 0
	img.lastT    	= system.getTimer()
	img.rateX			= params.rateX
	img.rateY			= params.rateY

	function img.enterFrame( self )
		-- stop if not valid/deleted
		if( not self.removeSelf or type(self.removeSelf) ~= "function" ) then
			Runtime:removeEventListener( "enterFrame", self )
			return
		end

		local curT 	= system.getTimer()
		local dt 	= curT - self.lastT
		self.lastT 	= curT

		local dOffsetX = dt * self.rateX / 1000
		local dOffsetY = dt * self.rateY / 1000
		
		self.texOffsetX = self.texOffsetX + dOffsetX
		self.texOffsetY = self.texOffsetY + dOffsetY

		--
		-- Keep values in bounds [-1, 1]
		--
		if( dOffsetX >= 0 ) then
			while(self.texOffsetX > 1) do
				self.texOffsetX = self.texOffsetX - 2
			end
		else
			while(self.texOffsetX < -1) do
				self.texOffsetX = self.texOffsetX + 2
			end
		end
		if( dOffsetY >= 0 ) then
			while(self.texOffsetY > 1) do
				self.texOffsetY = self.texOffsetY - 2
			end
		else
			while(self.texOffsetY < -1) do
				self.texOffsetY = self.texOffsetY + 2
			end
		end	

		self.fill.x = self.texOffsetX
		self.fill.y = self.texOffsetY
	end
	Runtime:addEventListener( "enterFrame", img )

	function water.getRates( self )
		return img.rateX, img.rateY
	end

	function water.setRateX( self, newRate )
		img.rateX = newRate
	end

	function water.setRateY( self, newRate )
		img.rateY = newRate
	end

	return water
end

return mod