-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- SSK Tester
-- =============================================================
-- This is a quick test of the current library.
--
-- Warning: Not all features are tested here!
-- =============================================================

local m2d = require "ssk.RGMath2D"



local obj1 = { x = 100, y = 200 }
local obj2 = { x = 150, y = 200 }


print(obj1.x, obj1.y)
print(obj2.x, obj2.y)

print( "\n add()------")
local obj3 = m2d.add( obj1, obj2 )
local x3,y3 = m2d.add( obj1, obj2, true)
print(obj3.x, obj3.y)
print(x3, y3)

print( "\n sub()------")
local obj3 = m2d.sub( obj1, obj2 )
local x3,y3 = m2d.sub( obj1, obj2, true)
print(obj3.x, obj3.y)
print(x3, y3)

print( "\n dot()------")
print( m2d.dot( obj1, obj2) )

print( "\n length()------")
print( m2d.length( obj1 ) )

print( "\n length2()------")
print( m2d.length2( obj1 ) )


print( "\n normalize()------")
local obj3 = m2d.normalize( obj1 )
local x3,y3 = m2d.normalize( obj1, true)
print(obj3.x, obj3.y)
print(x3, y3)


print( "\n normals()------")
local obj3, obj4 = m2d.normals( obj1 )
local x3,y3,x4,y4 = m2d.normals( obj1, true)
print(obj3.x, obj3.y, obj4.x, obj4.y)
print(x3, y3, x4, y4)


print( "\n vector2Angle()------")
local angle = m2d.vector2Angle( obj1 )
print( angle )


print( "\n angle2Vector()------")
local obj3 = m2d.angle2Vector( angle, true )
local x3,y3 = m2d.angle2Vector( angle )
print( obj3.x, obj3.y )
print( x3, y3 )

print( "\n tweenDist()------")
local dist = m2d.tweenDist( obj1, obj2)
print( dist )
