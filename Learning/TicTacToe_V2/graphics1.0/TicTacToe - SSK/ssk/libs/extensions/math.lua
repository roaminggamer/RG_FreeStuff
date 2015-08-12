-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Math Add-ons
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
--
-- =============================================================



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
	local right = wrapRectangle.x + wrapRectangle.width / 2
	local left  = wrapRectangle.x - wrapRectangle.width / 2

	local top = wrapRectangle.y - wrapRectangle.height / 2
	local bot  = wrapRectangle.y + wrapRectangle.height / 2

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

