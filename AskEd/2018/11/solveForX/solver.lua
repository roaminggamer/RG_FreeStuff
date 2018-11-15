
-- Credit: Derived from code found here: https://stackoverflow.com/questions/43928805/how-does-one-do-algebra-in-lua


local solver = {}


local function solve( f, params )
   params = params or {}
   print( f, params )
	local eps = params.eps or 0.0000000001   -- precision
   local x_left =  params.x_left or eps
   local x_right =  params.x_right or 10000
   --
   local f_left, f_right = f(x_left), f(x_right)
   assert(x_left <= x_right and f_left * f_right <= 0, "Wrong diapazone")
   while x_right - x_left > eps do
      local x_middle = (x_left + x_right) / 2
      local f_middle = f(x_middle)
      if f_middle * f_left > 0 then
         x_left, f_left = x_middle, f_middle
      else
         x_right, f_right = x_middle, f_middle
      end
   end
   return (x_left + x_right) / 2
end

function solver.solve( f, params )
   params = params or {}
   if( type(f) == 'string' ) then
      local fIn = f 
      f = "return function(x) return " .. f .. " end"
      print(f)
      local ret = solve( loadstring(f)(), params )
      if( params.debugEn ) then
         print( "for '" .. fIn .. "'  x == " .. ret )
      end
      return ret
   end
   return solve( f, params )
end

return solver