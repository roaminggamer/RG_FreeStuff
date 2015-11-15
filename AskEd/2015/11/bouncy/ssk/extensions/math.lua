-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- Math Add-ons
-- =============================================================
-- 								License
-- =============================================================
--[[
	> SSK is free to use.
	> SSK is free to edit.
	> SSK is free to use in a free or commercial game.
	> SSK is free to use in a free or commercial non-game app.
	> SSK is free to use without crediting the author (credits are still appreciated).
	> SSK is free to use without crediting the project (credits are still appreciated).
	> SSK is NOT free to sell for anything.
	> SSK is NOT free to credit yourself with.
]]
-- =============================================================
local mDeg  = math.deg
local mRad  = math.rad
local mCos  = math.cos
local mSin  = math.sin
local mAcos = math.acos
local mAsin = math.asin
local mSqrt = math.sqrt
local mCeil = math.ceil
local mFloor = math.floor
local mAtan2 = math.atan2
local mPi = math.pi



--[[
h math.pointInRect
d Tests if a point is within the bounds of the specified rectangle.
s math.pointInRect( pointX, pointY, left, top, width, height )
s * pointX - x-position of point
s * pointY - y-position of point
s * left - Left-most x-position of rectangle.
s * top - Top-most y-position of rectangle.
s * width - Rectangle width.
s * height - Rectangle height.
r true' if point is within (or on edge) of rectangle, false otherwise.
e local pointA = { x=10, y=10 }
e local pointB = { x=10, y=11 }
e
e if( math.pointInRect( pointA.x, pointA.y, 0, 0, 10, 10 ) ) then
e    print("Point A is in the rectangle.")
e else 
e    print("Point A is not in the rectangle.")
e end
e
e if( math.pointInRect( pointB.x, pointB.y, 0, 0, 10, 10 ) ) then
e    print("Point B is in the rectangle.")
e else 
e    print("Point B is not in the rectangle.")
e end
e
d
d Prints:<br>
d Point A is in the rectangle.<br>
d Point B is not in the rectangle.<br>
--]]


-- from http://pastebin.com/3BwbxLjn (modified)
math.pointInRect = function( pointX, pointY, left, top, width, height )
	if( pointX >= left and pointX <= left + width and 
	    pointY >= top and pointY <= top + height ) then 
	   return true
	else
		return false
	end
end


-- ===============================================
-- ==          Caclulate Wrap Point
-- ===============================================
--[[
h ssk.components.EFM
d EFM
s ssk.components.EFM()
s * EFM - EFM
r None.
--]]

function math.calculateWrapPoint( objectToWrap, wrapRectangle )
	local right = wrapRectangle.x + wrapRectangle.contentWidth / 2
	local left  = wrapRectangle.x - wrapRectangle.contentWidth / 2

	local top = wrapRectangle.y - wrapRectangle.contentHeight / 2
	local bot  = wrapRectangle.y + wrapRectangle.contentHeight / 2

	if(objectToWrap.x >= right) then
		objectToWrap.x = left
	elseif(objectToWrap.x <= left) then 
		objectToWrap.x = right
	end

	if(objectToWrap.y >= bot) then
		objectToWrap.y = top
	elseif(objectToWrap.y <= top) then 
		objectToWrap.y = bot
	end
end




---============================================================
-- Calculate fibbonaci out to nth place (with caching for speedup)
-- http://en.literateprograms.org/Fibonacci_numbers_(Lua)
math.fibs={[0]=0, 1, 1} 
--[[
h math.fastfib
d Calculates the Fibbonaci sequence out to n places.
s fastfib( n )
s * n - Place to caclulate fibbonaci sequence to.
r A table containing all the elements of fibbonaci's sequence from 0 to the nth place.
--]]
function math.fastfib(n)
	for i=3,n do
		math.fibs[i]=math.fibs[i-1]+math.fibs[i-2]
	end
	return math.fibs[n]
end

---============================================================
-- Calculate Pascal's triangle to 'n' rows and return as a sequence
-- Modified: http://rosettacode.org/wiki/Pascal's_triangle#Lua
function math.PascalsTriangle_row(t)
  local ret = {}
  t[0], t[#t+1] = 0, 0
  for i = 1, #t do ret[i] = t[i-1] + t[i] end
  return ret
end

function math.PascalsTriangle(n)
  local t = {1}
  local full = nil

  for i = 1, n do
	if full then
		full = table.copy(full,t)
	else
		full = table.copy(t)
	end
    t = math.PascalsTriangle_row(t)
  end
  return full
end

function math.PascalsTriangle_lastRow(n)
  local t = {1}
  for i = 1, n do
    t = math.PascalsTriangle_row(t)
  end
  return t
end


-- Calculate the distance from one decimal lat-long position to another.
-- Distance is a multiple of R (either kilometers or miles)
-- More accurate for short distances than long.
function math.haversine_dist( lat1, lng1, lat2, lng2, R )

	--[[ haversine formula
	dlon = lon2 - lon1 
	dlat = lat2 - lat1 
	a = (sin(dlat/2))^2 + cos(lat1) * cos(lat2) * (sin(dlon/2))^2 
	c = 2 * atan2( sqrt(a), sqrt(1-a) ) 
	d = R * c (where R is the radius of the Earth;  radius of the Earth: 3961 miles and 6373 km) 
	--]]

	local R = R or 6373 -- Default radius of earth in km
	local dlng = mRad(lng2 - lng1)
	local dlat = mRad(lat2 - lat1)

	local lat1 = mRad(lat1)
	local lat2 = mRad(lat2)

	local a = (mSin(dlat/2))^2 + mCos(lat1) * mCos(lat2) * (mSin(dlng/2))^2 
	local c = 2 * mAtan2( mSqrt(a), mSqrt(1-a) ) 
	local d = R * c --(where R is the radius of the Earth)

	return d
end
--print(haversine_dist( lat1, lng1, lat2, lng2 ))


local mRand = math.random
local keySrc = "abcdefghijklmnopqrstuvwxyaABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
--local keySrc = "abcdefghijklmnopqrstuvwxyaABCDEFGHIJKLMNOPQRSTUVWXYZ"
local keyTbl = {}
for i = 1, #keySrc do
  keyTbl[i] = keySrc:sub(i,i)
end
--table.dump(keyTbl)

math.getUID = function( rlen )
  local tmp = ""
  local max = #keyTbl
  for i = 1, rlen do
    tmp = tmp .. keyTbl[mRand(1,max)]
  end
  return tmp
end

-- ==
--    Sergey Stuff - Nice bits from Sergey's code: https://gist.github.com/Lerg
-- ==
function math.clamp(value, low, high)
    if value < low then value = low
    elseif high and value > high then value = high end
    return value
end
function math.inBounds(value, low, high)
    if value >= low and value <= high then
        return true
    else
        return false
    end
end