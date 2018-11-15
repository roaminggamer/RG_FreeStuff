
-- Credit: Derived from code found here: https://stackoverflow.com/questions/43928805/how-does-one-do-algebra-in-lua

-- ==
--    round(val, n) - Rounds a number to the nearest decimal places. (http://lua-users.org/wiki/FormattingNumbers)
--    val - The value to round.
--    n - Number of decimal places to round to.
-- ==
local function round(val, n)
   if (n) then
      return math.floor( (val * 10^n) + 0.5) / (10^n)
   else
      return math.floor(val+0.5)
   end
end


local solver = {}


local function solve( f, params )
   params = params or {}
	local eps = params.eps or 0.0000000001   -- precision
   local x_left =  params.x_left or eps
   local x_right =  params.x_right or 10000
   --
   local f_left, f_right = f(x_left), f(x_right)
   if( params.smart ) then
      if( not (x_left <= x_right and f_left * f_right <= 0) ) then
         return false, nil
      end
   else
      assert(x_left <= x_right and f_left * f_right <= 0, "Wrong diapazone")
   end
   
   while x_right - x_left > eps do
      local x_middle = (x_left + x_right) / 2
      local f_middle = f(x_middle)
      if f_middle * f_left > 0 then
         x_left, f_left = x_middle, f_middle
      else
         x_right, f_right = x_middle, f_middle
      end
   end
   if( params.smart ) then
      return true, round( (x_left + x_right) / 2, 4 )
   else
      return round( (x_left + x_right) / 2, 4 )
   end
end

function solver.solve( f, params )
   params = params or {}
   local fIn = f 
   -- Convert string to equation if needed
   if( type(f) == 'string' ) then
      fIn = f 
      f = "return function(x) return " .. f .. " end\n"
      f,x = loadstring(f)
      f = f()
      --
      local ret = solve( f, params )
      --
      if( params.debugEn ) then
         print( "for '" .. fIn .. "'  x == " .. ret )
      end
      return ret
   end
   return solve( f, params )
end

function solver.smartSolve( f, params )
   params = params or {}
   local fIn

   -- Convert string to equation if needed
   if( type(f) == 'string' ) then
      fIn = f 
      f = "return function(x) return " .. f .. " end\n"
      f,x = loadstring(f)
      f = f()
   end

   local maxIter = params.maxIter or 100
   local x_left, x_right = 1, 100
   for i = 1, maxIter do
      params.x_left = x_left
      params.x_right = x_right
      params.smart = true
      --
      local success, ret = solve( f, params )
      --
      if( success ) then
         if( params.debugEn ) then
            print( "for '" .. fIn .. "'  x == " .. ret )
         end
         return ret
      else
         x_left = (x_left == 1) and -1  or x_left * 10
         x_right = x_right * 10
      end

   end

   return nil   
end

return solver