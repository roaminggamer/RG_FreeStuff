local public = {}

local mRand = math.random

public[1] = function( group )
   for i = 1, 10000 do
   	local x = mRand( left, right )
   	local y = mRand( top, bottom )
   	local tmp = display.newCircle( group, x, y, mRand( 4, 20 ) )
   	tmp:setFillColor( mRand(), mRand(), mRand() )
   end
end   

local count = 1
public[2] = function( group )
   count = count + 1
   for i = group.numChildren, count, -1 do
   	display.remove( group[i] )
   end
end   


public[3] = function( )
   local junk = {}
   for i = 1, 10000 do
   	junk[i] = i
   end
   table.save( junk, "junk.json" )
end   

public[4] = function( )
   local junk = table.load( "junk.json" )
end   




return public