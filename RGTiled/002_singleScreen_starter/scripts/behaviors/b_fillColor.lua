-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local mod = {}

function mod.new( settings )	
	local behavior = {}
	behavior.ll = {} -- local listeners   obj:event() )   ==> ex: obj:addEventListener( "collision" )
	behavior.gl = {} -- global listeners  Runtime:event() ==> ex: Runtime:addEventListener( "enterFrame", obj )
	--
	local color = settings.color or {1,1,1,1} 
	-- Is color a string?  If so, assume it is a hex encoded string and 
	-- convert it.
	if( type(color) == "string" ) then
		color = hexcolor(color)
	end
	-- Ensure we have a four-value color coded
	for i = 1, 4 do
		color[i] = (color[i] ~= nil) and color[i] or 1
	end
	--
	function behavior.onCreate( self ) 
		self:setFillColor( unpack( color ) )
	end
	--
	function behavior.gl.enterFrame( self ) 
		--print( self.x, self.y )
	end
	--
	return behavior
end


return mod
