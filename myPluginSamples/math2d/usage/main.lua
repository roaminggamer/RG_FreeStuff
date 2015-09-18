-- 
-- Abstract: math2d Library Plugin Test Project
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2015 Corona Labs Inc. All Rights Reserved.
--
------------------------------------------------------------

-- Load plugin library
local math2d = require "plugin.math2d"


-- Set up some scalars to play with during out exploration of the math2d plugin.
--
local x1,y1 = 10,10
local x2,y2 = 15,-10

-- Create some objects to play with during out exploration of the math2d plugin.
--
local circ = display.newCircle( 100, 100, 30 )
local rect = display.newRect( 150, 250, 60, 60 )
rect.rotation = 15

--
-- Vector Addition (Scalars)
--
local vx,vy = math2d.add( x1, y1, x2, y2 )        -- Return two numbers
local vec   = math2d.add( x1, y1, x2, y2, true )  -- Return a table
print("\nVector Addition (Scalars)")
print("Results: ", vx, vy ) 
print("Results: ", vec.x, vec.y ) 

--
-- Vector Addition (Objects)
--
local vx,vy = math2d.add( circ, rect, true )  -- Return two numbers
local vec   = math2d.add( circ, rect )  -- Return a table
print("\nVector Addition (Objects)")
print("Results: ", vx, vy ) 
print("Results: ", vec.x, vec.y ) 

--
-- Vector Subtraction (Scalars)
--
local vx,vy = math2d.sub( x1, y1, x2, y2 )        -- Return two numbers
local vec   = math2d.sub( x1, y1, x2, y2, true )  -- Return a table
print("\nVector Subtraction (Scalars)")
print("Results: ", vx, vy ) 
print("Results: ", vec.x, vec.y ) 

--
-- Vector Subtraction (Objects)
--
local vx,vy = math2d.sub( circ, rect, true )  -- Return two numbers
local vec   = math2d.sub( circ, rect )  -- Return a table
print("\nVector Subtraction (Objects)")
print("Results: ", vx, vy ) 
print("Results: ", vec.x, vec.y )

--
-- Dot Product (Scalars)
--
print("\nDot (inner) Product (Scalars)")
print("Result: ", math2d.dot( x1, y1, x2, y2 ) )

--
-- Dot Product (Objects)
--
print("\nDot (inner) Product (Objects)")
print("Result: ", math2d.dot( circ, rect ) )

--
-- Cross Product (Scalars)
--
print("\nCross (vector) Product (Scalars)")
print("Result: ", math2d.cross( x1, y1, x2, y2 ) )

--
-- Cross Product (Objects)
--
print("\nCross (vector) Product (Objects)")
print("Result: ", math2d.cross( circ, rect ) )

--
-- Vector Normalize (Scalars)
--
local vx,vy = math2d.sub( x1, y1, x2, y2 ) -- Return two numbers
vx, vy = math2d.normalize(vx, vy)
print("\nVector Normalize (Scalars)")
print("Results: ", vx, vy ) 

--
-- Vector Normalize (Objects)
--
local vec   = math2d.sub( circ, rect ) -- Return a table
vec = math2d.normalize(vec) 
print("\nVector Normalize (Objects)")
print("Results: ", vec.x, vec.y )

--
-- Vector Length (Scalars)
--
local vx,vy = math2d.sub( x1, y1, x2, y2 ) -- Return two numbers
print("\nVector Length (Scalars)")
print("Result: ", math2d.length(vx, vy) ) 

--
-- Vector Length (Objects)
--
local vec   = math2d.sub( circ, rect ) -- Return a table
print("\nVector Length (Objects)")
print("Result: ", math2d.length(vec) )

--
-- Vector Square Length (Scalars)
--
local vx,vy = math2d.sub( x1, y1, x2, y2 ) -- Return two numbers
print("\nVector Square Length (Scalars)")
print("Result: ", math2d.length2(vx, vy) ) 

--
-- Vector Square Length (Objects)
--
local vec   = math2d.sub( circ, rect ) -- Return a table
print("\nVector Square Length (Objects)")
print("Result: ", math2d.length2(vec) )

--
-- Vector To Angle (Scalars)
--
local vx,vy = math2d.sub( x1, y1, x2, y2 ) -- Return two numbers
print("\nVector To Angle (Scalars)")
print("Result: ", math2d.vector2Angle(vx, vy) ) 

--
-- Vector To Angle of Object
--
local vec   = math2d.sub( circ, rect ) -- Return a table
print("\nVector To Angle (Objects)")
print("Result: ", math2d.vector2Angle(vec) )

--
-- Angle To Vector - Produce Scalars
--
local angle = 135
local vx,vy = math2d.angle2Vector( angle )        -- Return two numbers
print("\nAngle To Vector (Scalars)")
print("The vector: < " .. vx .. ", " .. vy .. " > " )  -- Print the numbers

--
-- Angle To Vector - Produce Object
--
local vec   = math2d.angle2Vector( angle, true )  -- Return a table
print("\nAngle To Vector (Object)")
print("The vector: < " .. vec.x .. ", " .. vec.y .. " > " ) -- Print the table fields


--
-- Screen To Cartesian (Scalars)
-- Cartesian To Screen (Scalars)
--
print("\nScreen -> Cartesian -> Screen DEMO (Scalars)")
local vx,vy = math2d.sub( x1, y1, x2, y2 ) -- Return two numbers
print("   Screen: ", vx, vy ) 
vx,vy = math2d.screen2Cartesian(vx,vy)
print("Cartesian: ", vx, vy ) 
vx,vy = math2d.cartesian2Screen(vx,vy)
print("   Screen: ", vx, vy ) 

--
-- Screen To Cartesian (Object)
-- Cartesian To Screen (Object)
--
print("\nScreen -> Cartesian -> Screen DEMO (Object)")
local vec   = math2d.sub( circ, rect ) -- Return a table
print("   Screen: ", vec.x, vec.y )
vec = math2d.screen2Cartesian(vec)
print("Cartesian: ", vec.x, vec.y )
vec = math2d.cartesian2Screen(vec)
print("   Screen: ", vec.x, vec.y )
-------------------------------------------------------------------------------
-- END
-------------------------------------------------------------------------------