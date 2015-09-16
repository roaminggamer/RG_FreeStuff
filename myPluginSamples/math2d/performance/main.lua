-- 
-- Abstract: math2d Library Plugin Test Project
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2015 Corona Labs Inc. All Rights Reserved.
--
------------------------------------------------------------

local easyBench = require "RGEasyBench"
local measureTime = easyBench.measureTime

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


-- Test Addition
--
local innerIter 	= 10000
local outerIter 	= 100
local addVec 		= math2d.add
local addVecFast 	= math2d.fast.add

local function addObj()
	for i = 1, innerIter do
		addVec( circ, rect )
	end
end

local function addScalar()
	for i = 1, innerIter do
		addVec( x1,y1, x2, y2 )
	end
end

local function addFast()
	for i = 1, innerIter do
		addVecFast( x1,y1, x2, y2 )
	end
end

print("\n -------------------- Iterations = ",  innerIter * outerIter )
print("        Object Addition: ", measureTime( addObj, outerIter ) .. " ms" )
print("Scalar Encoded Addition: ", measureTime( addScalar, outerIter ) .. " ms" )
print("          Fast Addition: ", measureTime( addFast, outerIter ) .. " ms" )


-- Test Subtraction
--
local innerIter 	= 10000
local outerIter 	= 100
local subVec 		= math2d.sub
local subVecFast 	= math2d.fast.sub

local function subObj()
	for i = 1, innerIter do
		subVec( circ, rect )
	end
end

local function subScalar()
	for i = 1, innerIter do
		subVec( x1,y1, x2, y2 )
	end
end

local function subFast()
	for i = 1, innerIter do
		subVecFast( x1,y1, x2, y2 )
	end
end

print("\n -------------------- Iterations = ",  innerIter * outerIter )
print("        Object Subtraction: ", measureTime( subObj, outerIter ) .. " ms" )
print("Scalar Encoded Subtraction: ", measureTime( subScalar, outerIter ) .. " ms" )
print("          Fast Subtraction: ", measureTime( subFast, outerIter ) .. " ms" )


-- Test Length
--
local innerIter 	= 10000
local outerIter 	= 100
local lengthVec 		= math2d.length
local lengthVecFast 	= math2d.fast.length

local function lengthObj()
	for i = 1, innerIter do
		lengthVec( circ, rect )
	end
end

local function lengthScalar()
	for i = 1, innerIter do
		lengthVec( x1,y1, x2, y2 )
	end
end

local function lengthFast()
	for i = 1, innerIter do
		lengthVecFast( x1,y1, x2, y2 )
	end
end

print("\n -------------------- Iterations = ",  innerIter * outerIter )
print("        Object Length: ", measureTime( lengthObj, outerIter ) .. " ms" )
print("Scalar Encoded Length: ", measureTime( lengthScalar, outerIter ) .. " ms" )
print("          Fast Length: ", measureTime( lengthFast, outerIter ) .. " ms" )

-- Test Squared Length
--
local innerIter 	= 10000
local outerIter 	= 100
local length2Vec 		= math2d.length2
local length2VecFast 	= math2d.fast.length2

local function length2Obj()
	for i = 1, innerIter do
		length2Vec( circ, rect )
	end
end

local function length2Scalar()
	for i = 1, innerIter do
		length2Vec( x1,y1, x2, y2 )
	end
end

local function length2Fast()
	for i = 1, innerIter do
		length2VecFast( x1,y1, x2, y2 )
	end
end

print("\n -------------------- Iterations = ",  innerIter * outerIter )
print("        Object Squared : ", measureTime( length2Obj, outerIter ) .. " ms" )
print("Scalar Encoded Squared : ", measureTime( length2Scalar, outerIter ) .. " ms" )
print("          Fast Squared : ", measureTime( length2Fast, outerIter ) .. " ms" )