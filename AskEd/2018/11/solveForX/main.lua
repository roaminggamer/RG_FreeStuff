io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
local solver = require "solver"

-- Cool
local function my_func(x)
   return 200/(x+x^2+x^3+x^4+x^5) - 0.00001001
end
print( solver.solve( my_func )  )


-- Cooler
local x = solver.solve( "200/(x+x^2+x^3+x^4+x^5) - 0.00001001", {debugEn = true} )
local x = solver.smartSolve( "2 * x + 28", { debugEn = false } )

print("Solution : " .. tostring(x))

