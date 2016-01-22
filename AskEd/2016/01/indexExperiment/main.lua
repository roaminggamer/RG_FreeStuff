-- =============================================================
-- Ask Ed 2016
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2016 (http://roaminggamer.com/)
-- =============================================================

local function test1( obj )
	return setmetatable(
		{ key1 = "value1", o = obj }, 
		{	
			__index = function( self , key ) 
				return rawget( self, key) or self.o[key] 
			end, -- Fallback lookup indexing 
			__newindex = function( self, key, value ) 
				if( rawget( self, key ) ) then
					rawset( self, key, value )
				else
					self.o[key] = value
				end
			end, -- Fallback lookup indexing 
		} )
end


local obj = display.newCircle( 100, 100, 10 )
local tmp = test1(obj)
print( tmp.key1, tmp.o.x, tmp.key2, tmp.o.x )

timer.performWithDelay( 500, function() tmp.x = 200 end )
transition.to( tmp, { x = 400, delay = 1000 } )

tmp.bob = 100
print( rawget( tmp, "bob"), tmp.bob )