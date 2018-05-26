-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2018
-- =============================================================
-- 
-- =============================================================
-- 
-- =============================================================
local function isInBounds( obj, obj2 )
	if(not obj2) then return false end
	local bounds = obj2.contentBounds
	if( obj.x > bounds.xMax ) then return false end
	if( obj.x < bounds.xMin ) then return false end
	if( obj.y > bounds.yMax ) then return false end
	if( obj.y < bounds.yMin ) then return false end
	return true
end
local pushedColor = {0,1,0}
local toggledColor = {0,1,1}

local easyButton = {}

function easyButton.easyPush( object, callback, color )	
	color = color or pushedColor
	object.touch = function( self, event )
		local phase = event.phase
		local id 	= event.id
		if( phase == "began" ) then
			self.isFocus = true
			display.currentStage:setFocus( self, id )
			self:setFillColor(unpack(color))
		elseif( self.isFocus ) then
			if( isInBounds( event, self ) ) then
				self:setFillColor(unpack(color))
			else
				self:setFillColor(1,1,1)
			end
			if( event.phase == "ended" ) then
				self:setFillColor(1,1,1)
				self.isFocus = false
				display.currentStage:setFocus( self, nil )
				if( isInBounds( event, self ) ) then
					callback( )
				end
			end
		end
		return true
	end
	object:addEventListener( "touch" )
end


function easyButton.easyToggle( object, callback, color )	
	color = color or toggledColor
	object._toggled = false
	object.touch = function( self, event )
		local phase = event.phase
		local id 	= event.id
		if( phase == "began" ) then
			self.isFocus = true
			display.currentStage:setFocus( self, id )
			self:setFillColor(unpack(color))
		
		elseif( self.isFocus ) then
			if( not self._toggled ) then
				if( isInBounds( event, self ) ) then
					self:setFillColor(unpack(color))
				else
					self:setFillColor(1,1,1)
				end
			end

			if( event.phase == "ended" ) then
				self.isFocus = false
				display.currentStage:setFocus( self, nil )
				if( isInBounds( event, self ) ) then
					self._toggled = not self._toggled
					if( self._toggled ) then
						self:setFillColor(unpack(color))
						callback( true )
					else
						self:setFillColor(1,1,1)
						callback( false )
					end					
				end
			end
		end
		return true
	end
	object:addEventListener( "touch" )
end



return easyButton